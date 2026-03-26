/*
  ============================================================
  VACATION MANAGEMENT — STATIC MOCKUP (Phase 1)
  ============================================================
  Interface:  Gestión de Vacaciones del Equipo
  Purpose:    Manager view for approving/rejecting team time-off
              requests, viewing team calendar, and managing
              employee leave balances.
  Phase:      MOCKUP — all data is hardcoded via local! variables
              and a!map() structures. No ri!, recordtype!, or
              a!queryRecordType() references.
  Outputs to: /output/vacation-management.sail
  Next step:  Run sail-dynamic-converter agent to produce
              /output/vacation-management-functional.sail
  ============================================================
*/
a!localVariables(

  /* --------------------------------------------------------
     KPI COUNTERS
  -------------------------------------------------------- */
  local!kpiDaysAvailable: 117,
  local!kpiDaysUsed: 8,
  local!kpiPending: 3,
  local!kpiAbsentToday: 2,

  /* --------------------------------------------------------
     TAB NAVIGATION
  -------------------------------------------------------- */
  local!selectedTab: 1,

  /* --------------------------------------------------------
     TAB 1 — REQUESTS DATA
     Status colors: POSITIVE (green), NEGATIVE (red), #F7A928 (amber)
  -------------------------------------------------------- */
  local!requests: {
    a!map(
      id: 1,
      employeeName: "María Martínez",
      type: "Vacaciones",
      startDate: "15/03/2026",
      endDate: "22/03/2026",
      days: 6,
      status: "Aprobada",
      statusColor: "POSITIVE"
    ),
    a!map(
      id: 2,
      employeeName: "Carlos López",
      type: "Enfermedad",
      startDate: "25/03/2026",
      endDate: "26/03/2026",
      days: 2,
      status: "Pendiente",
      statusColor: "#F7A928"
    ),
    a!map(
      id: 3,
      employeeName: "Ana García",
      type: "Personal",
      startDate: "01/04/2026",
      endDate: "03/04/2026",
      days: 3,
      status: "Pendiente",
      statusColor: "#F7A928"
    ),
    a!map(
      id: 4,
      employeeName: "Pedro Sánchez",
      type: "Vacaciones",
      startDate: "10/04/2026",
      endDate: "17/04/2026",
      days: 6,
      status: "Rechazada",
      statusColor: "NEGATIVE"
    ),
    a!map(
      id: 5,
      employeeName: "Laura Fernández",
      type: "Maternidad/Paternidad",
      startDate: "01/05/2026",
      endDate: "01/08/2026",
      days: 92,
      status: "Aprobada",
      statusColor: "POSITIVE"
    )
  },

  /* --------------------------------------------------------
     TAB 2 — CALENDAR DATA (weekly view, March 2026)
     VAC = Vacaciones · ENF = Enfermedad · PER = Personal
  -------------------------------------------------------- */
  local!calendarData: {
    a!map(employee: "Ana García",     s1: "",    s2: "",    s3: "VAC", s4: ""),
    a!map(employee: "Carlos López",   s1: "",    s2: "ENF", s3: "",    s4: ""),
    a!map(employee: "María Martínez", s1: "VAC", s2: "VAC", s3: "",    s4: ""),
    a!map(employee: "Pedro Sánchez",  s1: "",    s2: "",    s3: "",    s4: ""),
    a!map(employee: "Laura Fernández",s1: "",    s2: "",    s3: "",    s4: "")
  },

  /* --------------------------------------------------------
     TAB 3 — TEAM MEMBERS DATA
  -------------------------------------------------------- */
  local!teamMembers: {
    a!map(id: 1, firstName: "Ana",    lastName: "García",    jobTitle: "Desarrolladora", vacationBalance: 22, sickBalance: 10, status: "Activa"),
    a!map(id: 2, firstName: "Carlos", lastName: "López",     jobTitle: "Analista",       vacationBalance: 15, sickBalance: 8,  status: "Activa"),
    a!map(id: 3, firstName: "María",  lastName: "Martínez",  jobTitle: "Diseñadora",     vacationBalance: 18, sickBalance: 12, status: "Ausente"),
    a!map(id: 4, firstName: "Pedro",  lastName: "Sánchez",   jobTitle: "QA Engineer",    vacationBalance: 20, sickBalance: 10, status: "Activa"),
    a!map(id: 5, firstName: "Laura",  lastName: "Fernández", jobTitle: "Tech Lead",      vacationBalance: 12, sickBalance: 6,  status: "Activa")
  },

  /* --------------------------------------------------------
     UI STATE
  -------------------------------------------------------- */
  local!showNewRequestForm: false(),
  local!selectedRequestId: null,
  local!newRequest: a!map(
    employeeId: null,
    typeId:     null,
    startDate:  null,
    endDate:    null,
    reason:     ""
  ),

  value: a!headerContentLayout(
    backgroundColor: "#F5F6F8",
    contentsPadding: "MORE",

    /* ======================================================
       HEADER — Title bar with team name and primary action
    ====================================================== */
    header: a!cardLayout(
      style: "NONE",
      padding: "STANDARD",
      contents: {
        a!columnsLayout(
          columns: {
            a!columnLayout(width: "AUTO", contents: {}),
            a!columnLayout(
              width: "WIDE_PLUS",
              contents: {
                a!sideBySideLayout(
                  alignVertical: "MIDDLE",
                  items: {
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: "Gestión de Vacaciones",
                            size: "LARGE",
                            style: "STRONG"
                          ),
                          a!richTextItem(
                            text: char(10) & "Equipo de Tecnología  ·  Marzo 2026",
                            size: "SMALL",
                            color: "SECONDARY"
                          )
                        }
                      )
                    ),
                    a!sideBySideItem(
                      width: "MINIMIZE",
                      item: a!buttonWidget(
                        label: "+ Nueva Solicitud",
                        style: "PRIMARY",
                        saveInto: {
                          a!save(local!showNewRequestForm, true()),
                          a!save(local!newRequest, a!map(
                            employeeId: null,
                            typeId:     null,
                            startDate:  null,
                            endDate:    null,
                            reason:     ""
                          ))
                        }
                      )
                    )
                  }
                )
              }
            ),
            a!columnLayout(width: "AUTO", contents: {})
          }
        )
      }
    ),

    /* ======================================================
       MAIN CONTENT
    ====================================================== */
    contents: {
      a!columnsLayout(
        columns: {
          a!columnLayout(width: "AUTO", contents: {}),
          a!columnLayout(
            width: "WIDE_PLUS",
            contents: {

              /* --------------------------------------------
                 KPI CARDS
              -------------------------------------------- */
              a!cardGroupLayout(
                cardWidth: "MEDIUM",
                spacing: "SPARSE",
                cards: {

                  /* KPI 1 — Días disponibles */
                  a!cardLayout(
                    style: "NONE",
                    padding: "STANDARD",
                    contents: {
                      a!sideBySideLayout(
                        alignVertical: "MIDDLE",
                        items: {
                          a!sideBySideItem(
                            width: "MINIMIZE",
                            item: a!stampField(
                              labelPosition: "COLLAPSED",
                              icon: "calendar",
                              backgroundColor: "ACCENT",
                              contentColor: "WHITE",
                              size: "MEDIUM",
                              shape: "ROUNDED"
                            )
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: text(local!kpiDaysAvailable),
                                  size: "LARGE",
                                  style: "STRONG"
                                ),
                                a!richTextItem(
                                  text: char(10) & "Días disponibles equipo",
                                  size: "SMALL",
                                  color: "SECONDARY"
                                )
                              }
                            )
                          )
                        }
                      )
                    }
                  ),

                  /* KPI 2 — Días consumidos */
                  a!cardLayout(
                    style: "NONE",
                    padding: "STANDARD",
                    contents: {
                      a!sideBySideLayout(
                        alignVertical: "MIDDLE",
                        items: {
                          a!sideBySideItem(
                            width: "MINIMIZE",
                            item: a!stampField(
                              labelPosition: "COLLAPSED",
                              icon: "check",
                              backgroundColor: "POSITIVE",
                              contentColor: "WHITE",
                              size: "MEDIUM",
                              shape: "ROUNDED"
                            )
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: text(local!kpiDaysUsed),
                                  size: "LARGE",
                                  style: "STRONG"
                                ),
                                a!richTextItem(
                                  text: char(10) & "Días consumidos (mes)",
                                  size: "SMALL",
                                  color: "SECONDARY"
                                )
                              }
                            )
                          )
                        }
                      )
                    }
                  ),

                  /* KPI 3 — Pendientes */
                  a!cardLayout(
                    style: "NONE",
                    padding: "STANDARD",
                    contents: {
                      a!sideBySideLayout(
                        alignVertical: "MIDDLE",
                        items: {
                          a!sideBySideItem(
                            width: "MINIMIZE",
                            item: a!stampField(
                              labelPosition: "COLLAPSED",
                              icon: "clock",
                              backgroundColor: "#F7A928",
                              contentColor: "WHITE",
                              size: "MEDIUM",
                              shape: "ROUNDED"
                            )
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: text(local!kpiPending),
                                  size: "LARGE",
                                  style: "STRONG"
                                ),
                                a!richTextItem(
                                  text: char(10) & "Pendientes de aprobación",
                                  size: "SMALL",
                                  color: "SECONDARY"
                                )
                              }
                            )
                          )
                        }
                      )
                    }
                  ),

                  /* KPI 4 — Ausentes hoy */
                  a!cardLayout(
                    style: "NONE",
                    padding: "STANDARD",
                    contents: {
                      a!sideBySideLayout(
                        alignVertical: "MIDDLE",
                        items: {
                          a!sideBySideItem(
                            width: "MINIMIZE",
                            item: a!stampField(
                              labelPosition: "COLLAPSED",
                              icon: "user",
                              backgroundColor: "NEGATIVE",
                              contentColor: "WHITE",
                              size: "MEDIUM",
                              shape: "ROUNDED"
                            )
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: text(local!kpiAbsentToday),
                                  size: "LARGE",
                                  style: "STRONG"
                                ),
                                a!richTextItem(
                                  text: char(10) & "Ausentes hoy",
                                  size: "SMALL",
                                  color: "SECONDARY"
                                )
                              }
                            )
                          )
                        }
                      )
                    }
                  )

                }
              ),

              /* --------------------------------------------
                 TAB BAR
                 Rule: each tab column is MINIMIZE width;
                 trailing AUTO column fills remaining space
                 and satisfies the "at least one AUTO" rule.
              -------------------------------------------- */
              a!columnsLayout(
                columns: {

                  /* Tab 1 */
                  a!columnLayout(
                    width: "MINIMIZE",
                    contents: {
                      a!cardLayout(
                        style: "NONE",
                        padding: "STANDARD",
                        decorativeBarPosition: "BOTTOM",
                        decorativeBarColor: if(local!selectedTab = 1, "ACCENT", "NONE"),
                        link: a!dynamicLink(value: 1, saveInto: local!selectedTab),
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            align: "CENTER",
                            value: {
                              a!richTextItem(
                                text: "Solicitudes",
                                style: if(local!selectedTab = 1, "STRONG", "PLAIN"),
                                color: if(local!selectedTab = 1, "ACCENT", "SECONDARY")
                              )
                            }
                          )
                        }
                      )
                    }
                  ),

                  /* Tab 2 */
                  a!columnLayout(
                    width: "MINIMIZE",
                    contents: {
                      a!cardLayout(
                        style: "NONE",
                        padding: "STANDARD",
                        decorativeBarPosition: "BOTTOM",
                        decorativeBarColor: if(local!selectedTab = 2, "ACCENT", "NONE"),
                        link: a!dynamicLink(value: 2, saveInto: local!selectedTab),
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            align: "CENTER",
                            value: {
                              a!richTextItem(
                                text: "Calendario",
                                style: if(local!selectedTab = 2, "STRONG", "PLAIN"),
                                color: if(local!selectedTab = 2, "ACCENT", "SECONDARY")
                              )
                            }
                          )
                        }
                      )
                    }
                  ),

                  /* Tab 3 */
                  a!columnLayout(
                    width: "MINIMIZE",
                    contents: {
                      a!cardLayout(
                        style: "NONE",
                        padding: "STANDARD",
                        decorativeBarPosition: "BOTTOM",
                        decorativeBarColor: if(local!selectedTab = 3, "ACCENT", "NONE"),
                        link: a!dynamicLink(value: 3, saveInto: local!selectedTab),
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            align: "CENTER",
                            value: {
                              a!richTextItem(
                                text: "Mi Equipo",
                                style: if(local!selectedTab = 3, "STRONG", "PLAIN"),
                                color: if(local!selectedTab = 3, "ACCENT", "SECONDARY")
                              )
                            }
                          )
                        }
                      )
                    }
                  ),

                  /* Filler column — required AUTO column */
                  a!columnLayout(width: "AUTO", contents: {})

                }
              ),

              /* ============================================
                 TAB 1 — SOLICITUDES
              ============================================ */
              a!sectionLayout(
                showWhen: local!selectedTab = 1,
                label: "Solicitudes del Equipo",
                labelColor: "STANDARD",
                contents: {
                  a!gridField(
                    labelPosition: "COLLAPSED",
                    /* TODO [functional]: Replace with a!recordData(
                         recordType: 'recordType!{...}VM Request',
                         filters: a!queryLogicalExpression(
                           operator: "AND",
                           filters: {
                             a!queryFilter(field: '...isActive', operator: "=", value: true()),
                             a!queryFilter(field: '...employee.fields.teamId', operator: "=", value: ri!teamId, applyWhen: a!isNotNullOrEmpty(ri!teamId))
                           }
                         )
                       ) */
                    data: local!requests,
                    columns: {
                      a!gridTextColumn(
                        label: "Empleado",
                        sortField: "employeeName",
                        value: fv!row.employeeName
                      ),
                      a!gridTextColumn(
                        label: "Tipo",
                        sortField: "type",
                        value: fv!row.type
                      ),
                      a!gridTextColumn(
                        label: "Fecha inicio",
                        sortField: "startDate",
                        value: fv!row.startDate
                      ),
                      a!gridTextColumn(
                        label: "Fecha fin",
                        sortField: "endDate",
                        value: fv!row.endDate
                      ),
                      a!gridTextColumn(
                        label: "Días",
                        sortField: "days",
                        value: fv!row.days,
                        align: "CENTER"
                      ),
                      a!gridColumn(
                        label: "Estado",
                        sortField: "status",
                        value: a!tagField(
                          labelPosition: "COLLAPSED",
                          tags: {
                            a!tagItem(
                              label: fv!row.status,
                              backgroundColor: fv!row.statusColor
                            )
                          }
                        )
                      ),
                      a!gridColumn(
                        label: "Acciones",
                        value: a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          /* TODO [functional]: wire Aprobar/Rechazar to process models */
                          value: if(
                            fv!row.status = "Pendiente",
                            {
                              a!richTextItem(
                                text: "Aprobar",
                                link: a!dynamicLink(
                                  value: fv!row.id,
                                  saveInto: local!selectedRequestId
                                ),
                                color: "POSITIVE"
                              ),
                              a!richTextItem(text: "  |  ", color: "SECONDARY"),
                              a!richTextItem(
                                text: "Rechazar",
                                link: a!dynamicLink(
                                  value: fv!row.id,
                                  saveInto: local!selectedRequestId
                                ),
                                color: "NEGATIVE"
                              )
                            },
                            a!richTextItem(text: "—", color: "SECONDARY")
                          )
                        )
                      )
                    },
                    rowHeader: 1,
                    pagingInfo: a!pagingInfo(
                      startIndex: 1,
                      batchSize: 10,
                      sort: a!sortInfo(
                        field: "startDate",
                        ascending: false()
                      )
                    )
                  )
                }
              ),

              /* ============================================
                 TAB 2 — CALENDARIO
              ============================================ */
              a!sectionLayout(
                showWhen: local!selectedTab = 2,
                label: "Calendario del Equipo — Marzo 2026",
                labelColor: "STANDARD",
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "VAC = Vacaciones  ·  ENF = Enfermedad  ·  PER = Personal",
                        color: "SECONDARY",
                        size: "SMALL"
                      )
                    }
                  ),
                  a!gridField(
                    labelPosition: "COLLAPSED",
                    /* TODO [functional]: Replace with computed calendar query
                       that aggregates VM Request records by employee and week */
                    data: local!calendarData,
                    columns: {
                      a!gridTextColumn(
                        label: "Empleado",
                        sortField: "employee",
                        value: fv!row.employee
                      ),
                      a!gridTextColumn(
                        label: "10-14 Mar",
                        sortField: "s1",
                        value: fv!row.s1,
                        align: "CENTER"
                      ),
                      a!gridTextColumn(
                        label: "17-21 Mar",
                        sortField: "s2",
                        value: fv!row.s2,
                        align: "CENTER"
                      ),
                      a!gridTextColumn(
                        label: "24-28 Mar",
                        sortField: "s3",
                        value: fv!row.s3,
                        align: "CENTER"
                      ),
                      a!gridTextColumn(
                        label: "31 Mar-4 Abr",
                        sortField: "s4",
                        value: fv!row.s4,
                        align: "CENTER"
                      )
                    },
                    pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 10)
                  )
                }
              ),

              /* ============================================
                 TAB 3 — MI EQUIPO
              ============================================ */
              a!sectionLayout(
                showWhen: local!selectedTab = 3,
                label: "Miembros del Equipo",
                labelColor: "STANDARD",
                contents: {
                  a!gridField(
                    labelPosition: "COLLAPSED",
                    /* TODO [functional]: Replace with a!recordData(
                         recordType: 'recordType!{...}VM Employee',
                         filters: a!queryFilter(
                           field: '...teamId', operator: "=",
                           value: ri!teamId, applyWhen: a!isNotNullOrEmpty(ri!teamId)
                         )
                       ) */
                    data: local!teamMembers,
                    columns: {
                      a!gridTextColumn(
                        label: "Nombre",
                        sortField: "firstName",
                        value: fv!row.firstName & " " & fv!row.lastName
                      ),
                      a!gridTextColumn(
                        label: "Cargo",
                        sortField: "jobTitle",
                        value: fv!row.jobTitle
                      ),
                      a!gridTextColumn(
                        label: "Saldo Vacaciones",
                        sortField: "vacationBalance",
                        value: text(fv!row.vacationBalance) & " días",
                        align: "CENTER"
                      ),
                      a!gridTextColumn(
                        label: "Saldo Enfermedad",
                        sortField: "sickBalance",
                        value: text(fv!row.sickBalance) & " días",
                        align: "CENTER"
                      ),
                      a!gridColumn(
                        label: "Estado",
                        sortField: "status",
                        value: a!tagField(
                          labelPosition: "COLLAPSED",
                          tags: {
                            a!tagItem(
                              label: fv!row.status,
                              backgroundColor: if(
                                fv!row.status = "Ausente",
                                "NEGATIVE",
                                "POSITIVE"
                              )
                            )
                          }
                        )
                      )
                    },
                    pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 10)
                  )
                }
              ),

              /* ============================================
                 FORMULARIO — NUEVA SOLICITUD
                 Shown/hidden via local!showNewRequestForm
              ============================================ */
              a!sectionLayout(
                showWhen: local!showNewRequestForm,
                label: "Nueva Solicitud de Ausencia",
                labelColor: "ACCENT",
                contents: {

                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        width: "AUTO",
                        contents: {
                          a!dropdownField(
                            label: "Empleado",
                            labelPosition: "ABOVE",
                            placeholder: "Selecciona un empleado...",
                            /* TODO [functional]: Replace with a!queryRecordType() on VM Employee */
                            choiceLabels: {
                              "Ana García",
                              "Carlos López",
                              "María Martínez",
                              "Pedro Sánchez",
                              "Laura Fernández"
                            },
                            choiceValues: {1, 2, 3, 4, 5},
                            value: local!newRequest.employeeId,
                            saveInto: local!newRequest.employeeId,
                            required: true()
                          ),
                          a!dropdownField(
                            label: "Tipo de ausencia",
                            labelPosition: "ABOVE",
                            placeholder: "Selecciona el tipo...",
                            /* TODO [functional]: Replace with a!queryRecordType() on VM Ref Leave Type */
                            choiceLabels: {
                              "Vacaciones",
                              "Enfermedad",
                              "Personal",
                              "Maternidad/Paternidad",
                              "Otros"
                            },
                            choiceValues: {1, 2, 3, 4, 5},
                            value: local!newRequest.typeId,
                            saveInto: local!newRequest.typeId,
                            required: true()
                          )
                        }
                      ),
                      a!columnLayout(
                        width: "AUTO",
                        contents: {
                          a!dateField(
                            label: "Fecha de inicio",
                            labelPosition: "ABOVE",
                            value: local!newRequest.startDate,
                            saveInto: local!newRequest.startDate,
                            required: true()
                          ),
                          a!dateField(
                            label: "Fecha de fin",
                            labelPosition: "ABOVE",
                            value: local!newRequest.endDate,
                            saveInto: local!newRequest.endDate,
                            required: true()
                          )
                        }
                      )
                    }
                  ),

                  a!paragraphField(
                    label: "Motivo",
                    labelPosition: "ABOVE",
                    placeholder: "Describe el motivo de la solicitud...",
                    value: local!newRequest.reason,
                    saveInto: local!newRequest.reason,
                    height: "SHORT"
                  ),

                  a!sideBySideLayout(
                    items: {
                      a!sideBySideItem(
                        width: "MINIMIZE",
                        item: a!buttonWidget(
                          label: "Enviar solicitud",
                          style: "PRIMARY",
                          /* TODO [functional]: Replace saveInto with a!startProcess()
                             or a!writeRecords() to create the VM Request record */
                          saveInto: {
                            a!save(
                              local!requests,
                              {
                                local!requests,
                                a!map(
                                  id: count(local!requests) + 1,
                                  employeeName: index(
                                    {"Ana García","Carlos López","María Martínez","Pedro Sánchez","Laura Fernández"},
                                    local!newRequest.employeeId,
                                    ""
                                  ),
                                  type: index(
                                    {"Vacaciones","Enfermedad","Personal","Maternidad/Paternidad","Otros"},
                                    local!newRequest.typeId,
                                    ""
                                  ),
                                  startDate: text(local!newRequest.startDate, "dd/MM/yyyy"),
                                  endDate:   text(local!newRequest.endDate,   "dd/MM/yyyy"),
                                  days:      0,
                                  status:    "Pendiente",
                                  statusColor: "#F7A928"
                                )
                              }
                            ),
                            a!save(local!showNewRequestForm, false()),
                            a!save(local!selectedTab, 1)
                          }
                        )
                      ),
                      a!sideBySideItem(
                        width: "MINIMIZE",
                        item: a!buttonWidget(
                          label: "Cancelar",
                          style: "SECONDARY",
                          saveInto: {
                            a!save(local!showNewRequestForm, false())
                          }
                        )
                      )
                    }
                  )

                }
              )
              /* END main content items */

            }
          ),
          a!columnLayout(width: "AUTO", contents: {})
        }
      )
    }
    /* END a!headerContentLayout */
  )
  /* END a!localVariables */
)
