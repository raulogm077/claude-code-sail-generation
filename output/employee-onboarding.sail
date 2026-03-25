a!localVariables(
  /* TODO-CONVERTER: Transform to ri!isUpdate */
  local!isUpdate: false(),
  /* TODO-CONVERTER: Transform to ri!cancel */
  local!cancel: false(),

  /* ── Paso 1: Información Personal ── */
  local!firstName: "Juan",
  local!lastName: "Pérez",
  local!birthDate: date(1990, 5, 15),
  local!gender: "Masculino",
  local!nationalId: "12345678",
  local!phone: "555-0100",
  local!personalEmail: "juan.perez@email.com",
  local!address: "Av. Reforma 123",
  local!city: "Ciudad de México",
  local!state: "CDMX",
  local!zipCode: "06600",
  local!emergencyContactName: "María Pérez",
  local!emergencyContactPhone: "555-0199",
  local!emergencyContactRelation: "Esposa",

  /* ── Paso 2: Información del Puesto ── */
  local!jobTitle: "Analista de Seguridad",
  local!department: "Operaciones",
  local!managerName: "Carlos López",
  local!startDate: date(2025, 4, 1),
  local!contractType: "Indefinido",
  local!workLocation: "Oficina Central",
  local!salary: "45000",

  /* ── Paso 3: Historial de Empleo ── */
  local!employmentHistory: {
    a!map(
      id: 1,
      employerName: "Construcciones ABC S.A.",
      jobTitle: "Auxiliar de Seguridad",
      city: "Guadalajara",
      state: "JAL",
      startDate: date(2018, 3, 1),
      endDate: date(2021, 12, 31),
      contactPerson: "Roberto Díaz",
      contactPhone: "333-1234",
      safetyPercentage: 85,
      overallJobDuties: "Supervisión de obra, reportes de incidentes",
      safetyResponsibilities: "Implementación de protocolos de seguridad"
    ),
    a!map(
      id: 2,
      employerName: "Infraestructura XYZ",
      jobTitle: "Técnico de Seguridad",
      city: "Monterrey",
      state: "NL",
      startDate: date(2022, 1, 15),
      endDate: date(2024, 11, 30),
      contactPerson: "Laura Soto",
      contactPhone: "818-5678",
      safetyPercentage: 92,
      overallJobDuties: "Inspección de equipos y capacitación al personal",
      safetyResponsibilities: "Auditorías internas de seguridad"
    )
  },

  /* ── Paso 4: Educación y Certificaciones ── */
  local!education: {
    a!map(
      id: 1,
      type: "Educación",
      institutionName: "UNAM",
      degreeLevel: "Licenciatura",
      degreeMajor: "Ingeniería Industrial",
      graduationDate: date(2017, 6, 30),
      certificationName: null
    ),
    a!map(
      id: 2,
      type: "Certificación",
      institutionName: "Instituto Mexicano de Seguridad",
      degreeLevel: null,
      degreeMajor: null,
      graduationDate: date(2020, 9, 15),
      certificationName: "Técnico en Seguridad e Higiene Industrial"
    )
  },

  /* ── Paso 5: Documentos y Acuerdos ── */
  local!acceptCodeOfConduct: false(),
  local!acceptPrivacyPolicy: false(),
  local!acceptSafetyPolicy: false(),
  local!acceptDataPolicy: false(),

  /* ── Control de UI ── */
  local!selectedEmploymentHistoryId: null,
  local!selectedEducationId: null,

  a!wizardLayout(
    titleBar: a!headerTemplateFull(
      title: "Registro de Nuevo Empleado",
      secondaryText: "Complete todos los pasos para finalizar el proceso de incorporación",
      backgroundColor: "#1A3A5C"
    ),
    isTitleBarFixed: false(),
    style: "DOT_VERTICAL",
    contentsWidth: "WIDE",
    steps: {

      /* ══════════════════════════════════════════════
         PASO 1 – Información Personal
      ══════════════════════════════════════════════ */
      a!wizardStep(
        label: "Información Personal",
        instructions: "Ingrese los datos personales del nuevo empleado",
        disableNextButton: or(
          a!isNullOrEmpty(local!firstName),
          a!isNullOrEmpty(local!lastName),
          a!isNullOrEmpty(local!nationalId),
          a!isNullOrEmpty(local!personalEmail)
        ),
        contents: {
          a!sectionLayout(
            label: "Datos Personales",
            labelColor: "STANDARD",
            contents: {
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Nombre(s)",
                        labelPosition: "ABOVE",
                        value: local!firstName,
                        saveInto: local!firstName,
                        required: true(),
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Apellidos",
                        labelPosition: "ABOVE",
                        value: local!lastName,
                        saveInto: local!lastName,
                        required: true(),
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!dateField(
                        label: "Fecha de Nacimiento",
                        labelPosition: "ABOVE",
                        value: local!birthDate,
                        saveInto: local!birthDate,
                        validations: {}
                      )
                    }
                  )
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!dropdownField(
                        label: "Género",
                        labelPosition: "ABOVE",
                        placeholder: "Seleccionar...",
                        choiceLabels: {"Masculino", "Femenino", "No binario", "Prefiero no decir"},
                        choiceValues: {"Masculino", "Femenino", "No binario", "Prefiero no decir"},
                        value: local!gender,
                        saveInto: local!gender,
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "CURP / ID Nacional",
                        labelPosition: "ABOVE",
                        value: local!nationalId,
                        saveInto: local!nationalId,
                        required: true(),
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Correo Electrónico Personal",
                        labelPosition: "ABOVE",
                        value: local!personalEmail,
                        saveInto: local!personalEmail,
                        required: true(),
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  )
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Teléfono",
                        labelPosition: "ABOVE",
                        value: local!phone,
                        saveInto: local!phone,
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {}
                  )
                }
              )
            }
          ),
          a!sectionLayout(
            label: "Dirección",
            labelColor: "STANDARD",
            contents: {
              a!textField(
                label: "Calle y Número",
                labelPosition: "ABOVE",
                value: local!address,
                saveInto: local!address,
                refreshAfter: "UNFOCUS",
                validations: {}
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Ciudad",
                        labelPosition: "ABOVE",
                        value: local!city,
                        saveInto: local!city,
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Estado",
                        labelPosition: "ABOVE",
                        value: local!state,
                        saveInto: local!state,
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Código Postal",
                        labelPosition: "ABOVE",
                        value: local!zipCode,
                        saveInto: local!zipCode,
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  )
                }
              )
            }
          ),
          a!sectionLayout(
            label: "Contacto de Emergencia",
            labelColor: "STANDARD",
            contents: {
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Nombre Completo",
                        labelPosition: "ABOVE",
                        value: local!emergencyContactName,
                        saveInto: local!emergencyContactName,
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Teléfono",
                        labelPosition: "ABOVE",
                        value: local!emergencyContactPhone,
                        saveInto: local!emergencyContactPhone,
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!dropdownField(
                        label: "Relación",
                        labelPosition: "ABOVE",
                        placeholder: "Seleccionar...",
                        choiceLabels: {"Cónyuge", "Padre/Madre", "Hijo/Hija", "Hermano/Hermana", "Otro"},
                        choiceValues: {"Cónyuge", "Padre/Madre", "Hijo/Hija", "Hermano/Hermana", "Otro"},
                        value: local!emergencyContactRelation,
                        saveInto: local!emergencyContactRelation,
                        validations: {}
                      )
                    }
                  )
                }
              )
            }
          )
        }
      ),

      /* ══════════════════════════════════════════════
         PASO 2 – Información del Puesto
      ══════════════════════════════════════════════ */
      a!wizardStep(
        label: "Información del Puesto",
        instructions: "Defina el cargo, área y condiciones laborales",
        disableNextButton: or(
          a!isNullOrEmpty(local!jobTitle),
          a!isNullOrEmpty(local!department),
          a!isNullOrEmpty(local!startDate)
        ),
        contents: {
          a!sectionLayout(
            label: "Datos del Puesto",
            labelColor: "STANDARD",
            contents: {
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Título del Puesto",
                        labelPosition: "ABOVE",
                        value: local!jobTitle,
                        saveInto: local!jobTitle,
                        required: true(),
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!dropdownField(
                        label: "Departamento",
                        labelPosition: "ABOVE",
                        placeholder: "Seleccionar...",
                        choiceLabels: {
                          "Operaciones",
                          "Seguridad Industrial",
                          "Recursos Humanos",
                          "Tecnología",
                          "Finanzas",
                          "Administración"
                        },
                        choiceValues: {
                          "Operaciones",
                          "Seguridad Industrial",
                          "Recursos Humanos",
                          "Tecnología",
                          "Finanzas",
                          "Administración"
                        },
                        value: local!department,
                        saveInto: local!department,
                        required: true(),
                        validations: {}
                      )
                    }
                  )
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Gerente / Supervisor Directo",
                        labelPosition: "ABOVE",
                        value: local!managerName,
                        saveInto: local!managerName,
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!dateField(
                        label: "Fecha de Inicio",
                        labelPosition: "ABOVE",
                        value: local!startDate,
                        saveInto: local!startDate,
                        required: true(),
                        validations: {}
                      )
                    }
                  )
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!dropdownField(
                        label: "Tipo de Contrato",
                        labelPosition: "ABOVE",
                        placeholder: "Seleccionar...",
                        choiceLabels: {"Indefinido", "Tiempo Determinado", "Por Proyecto", "Tiempo Parcial"},
                        choiceValues: {"Indefinido", "Tiempo Determinado", "Por Proyecto", "Tiempo Parcial"},
                        value: local!contractType,
                        saveInto: local!contractType,
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!dropdownField(
                        label: "Lugar de Trabajo",
                        labelPosition: "ABOVE",
                        placeholder: "Seleccionar...",
                        choiceLabels: {"Oficina Central", "Planta Norte", "Planta Sur", "Remoto", "Híbrido"},
                        choiceValues: {"Oficina Central", "Planta Norte", "Planta Sur", "Remoto", "Híbrido"},
                        value: local!workLocation,
                        saveInto: local!workLocation,
                        validations: {}
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!textField(
                        label: "Salario Mensual (MXN)",
                        labelPosition: "ABOVE",
                        value: local!salary,
                        saveInto: local!salary,
                        refreshAfter: "UNFOCUS",
                        validations: {}
                      )
                    }
                  )
                }
              )
            }
          )
        }
      ),

      /* ══════════════════════════════════════════════
         PASO 3 – Historial de Empleo
      ══════════════════════════════════════════════ */
      a!wizardStep(
        label: "Historial de Empleo",
        instructions: "Registre los empleos anteriores del candidato",
        contents: {
          a!sectionLayout(
            label: "Empleos Anteriores",
            labelColor: "STANDARD",
            contents: {
              a!gridLayout(
                headerCells: {
                  a!gridLayoutHeaderCell(label: "Empleador"),
                  a!gridLayoutHeaderCell(label: "Puesto"),
                  a!gridLayoutHeaderCell(label: "Ciudad / Estado"),
                  a!gridLayoutHeaderCell(label: "Período"),
                  a!gridLayoutHeaderCell(label: "% Seguridad", align: "CENTER"),
                  a!gridLayoutHeaderCell(label: "Acciones", align: "CENTER")
                },
                columnConfigs: {
                  a!gridLayoutColumnConfig(width: "AUTO"),
                  a!gridLayoutColumnConfig(width: "AUTO"),
                  a!gridLayoutColumnConfig(width: "AUTO"),
                  a!gridLayoutColumnConfig(width: "AUTO"),
                  a!gridLayoutColumnConfig(width: "NARROW"),
                  a!gridLayoutColumnConfig(width: "NARROW")
                },
                rows: a!forEach(
                  items: local!employmentHistory,
                  expression: a!gridRowLayout(
                    id: fv!item.id,
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: fv!item.employerName,
                            style: "STRONG"
                          )
                        }
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: fv!item.jobTitle
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: fv!item.city & ", " & fv!item.state
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          text(fv!item.startDate, "MMM yyyy"),
                          " – ",
                          if(
                            a!isNullOrEmpty(fv!item.endDate),
                            "Presente",
                            text(fv!item.endDate, "MMM yyyy")
                          )
                        }
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: fv!item.safetyPercentage & "%",
                            /* TODO: Extract to expression rule - repeated logic for safety color
                             * Used in: Safety column, Summary step, KPI display
                             * Logic: if >= 90 green, >= 70 yellow, else red */
                            color: if(
                              fv!item.safetyPercentage >= 90,
                              "POSITIVE",
                              if(
                                fv!item.safetyPercentage >= 70,
                                "#F5A623",
                                "NEGATIVE"
                              )
                            ),
                            style: "STRONG"
                          )
                        },
                        align: "CENTER"
                      ),
                      a!buttonArrayLayout(
                        buttons: {
                          a!buttonWidget(
                            label: "Editar",
                            saveInto: a!save(local!selectedEmploymentHistoryId, fv!item.id),
                            style: "GHOST",
                            color: "ACCENT",
                            size: "SMALL"
                          )
                        },
                        align: "CENTER"
                      )
                    }
                  )
                ),
                rowHeader: 1
              ),
              a!buttonArrayLayout(
                buttons: {
                  /* TODO: Implement add employment history dialog */
                  a!buttonWidget(
                    label: "Agregar Empleo",
                    style: "OUTLINE",
                    color: "ACCENT",
                    icon: "plus"
                  )
                },
                align: "START",
                marginAbove: "STANDARD"
              )
            }
          )
        }
      ),

      /* ══════════════════════════════════════════════
         PASO 4 – Educación y Certificaciones
      ══════════════════════════════════════════════ */
      a!wizardStep(
        label: "Educación y Certificaciones",
        instructions: "Capture la formación académica y certificaciones profesionales",
        contents: {
          a!sectionLayout(
            label: "Formación Académica y Certificaciones",
            labelColor: "STANDARD",
            contents: {
              a!gridLayout(
                headerCells: {
                  a!gridLayoutHeaderCell(label: "Tipo"),
                  a!gridLayoutHeaderCell(label: "Institución"),
                  a!gridLayoutHeaderCell(label: "Grado / Certificación"),
                  a!gridLayoutHeaderCell(label: "Área / Especialidad"),
                  a!gridLayoutHeaderCell(label: "Fecha"),
                  a!gridLayoutHeaderCell(label: "Acciones", align: "CENTER")
                },
                columnConfigs: {
                  a!gridLayoutColumnConfig(width: "NARROW"),
                  a!gridLayoutColumnConfig(width: "AUTO"),
                  a!gridLayoutColumnConfig(width: "AUTO"),
                  a!gridLayoutColumnConfig(width: "AUTO"),
                  a!gridLayoutColumnConfig(width: "NARROW"),
                  a!gridLayoutColumnConfig(width: "NARROW")
                },
                rows: a!forEach(
                  items: local!education,
                  expression: a!gridRowLayout(
                    id: fv!item.id,
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: fv!item.type,
                            color: if(
                              fv!item.type = "Educación",
                              "#1A3A5C",
                              "#2E7D32"
                            ),
                            style: "STRONG"
                          )
                        }
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: fv!item.institutionName
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: if(
                          fv!item.type = "Educación",
                          a!defaultValue(fv!item.degreeLevel, "—"),
                          a!defaultValue(fv!item.certificationName, "—")
                        )
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!defaultValue(fv!item.degreeMajor, "—")
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: if(
                          a!isNullOrEmpty(fv!item.graduationDate),
                          "—",
                          text(fv!item.graduationDate, "MMM yyyy")
                        )
                      ),
                      a!buttonArrayLayout(
                        buttons: {
                          a!buttonWidget(
                            label: "Editar",
                            saveInto: a!save(local!selectedEducationId, fv!item.id),
                            style: "GHOST",
                            color: "ACCENT",
                            size: "SMALL"
                          )
                        },
                        align: "CENTER"
                      )
                    }
                  )
                ),
                rowHeader: 1
              ),
              a!buttonArrayLayout(
                buttons: {
                  /* TODO: Implement add education/certification dialog */
                  a!buttonWidget(
                    label: "Agregar Educación / Certificación",
                    style: "OUTLINE",
                    color: "ACCENT",
                    icon: "plus"
                  )
                },
                align: "START",
                marginAbove: "STANDARD"
              )
            }
          )
        }
      ),

      /* ══════════════════════════════════════════════
         PASO 5 – Documentos y Acuerdos
      ══════════════════════════════════════════════ */
      a!wizardStep(
        label: "Documentos y Acuerdos",
        instructions: "El empleado debe aceptar las políticas de la empresa y firmar los documentos requeridos",
        disableNextButton: not(
          and(
            local!acceptCodeOfConduct,
            local!acceptPrivacyPolicy,
            local!acceptSafetyPolicy,
            local!acceptDataPolicy
          )
        ),
        contents: {
          a!sectionLayout(
            label: "Políticas y Acuerdos",
            labelColor: "STANDARD",
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: "Por favor lea y acepte las siguientes políticas de la empresa antes de continuar.",
                    style: "EMPHASIS"
                  )
                },
                marginBelow: "STANDARD"
              ),
              a!cardLayout(
                contents: {
                  a!checkboxField(
                    label: "Código de Conducta",
                    labelPosition: "COLLAPSED",
                    choiceLabels: {"He leído y acepto el Código de Conducta de la empresa"},
                    choiceValues: {true()},
                    value: if(local!acceptCodeOfConduct, {true()}, {}),
                    saveInto: {
                      a!save(
                        local!acceptCodeOfConduct,
                        not(a!isNullOrEmpty(save!value))
                      )
                    },
                    validations: {}
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "El código de conducta establece los estándares de comportamiento esperados de todos los colaboradores.",
                        color: "SECONDARY",
                        size: "SMALL"
                      )
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!checkboxField(
                    label: "Política de Privacidad",
                    labelPosition: "COLLAPSED",
                    choiceLabels: {"He leído y acepto la Política de Privacidad y Protección de Datos"},
                    choiceValues: {true()},
                    value: if(local!acceptPrivacyPolicy, {true()}, {}),
                    saveInto: {
                      a!save(
                        local!acceptPrivacyPolicy,
                        not(a!isNullOrEmpty(save!value))
                      )
                    },
                    validations: {}
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Describe cómo la empresa recopila, usa y protege la información personal de los empleados.",
                        color: "SECONDARY",
                        size: "SMALL"
                      )
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!checkboxField(
                    label: "Política de Seguridad e Higiene",
                    labelPosition: "COLLAPSED",
                    choiceLabels: {"He leído y acepto el Reglamento de Seguridad e Higiene Industrial"},
                    choiceValues: {true()},
                    value: if(local!acceptSafetyPolicy, {true()}, {}),
                    saveInto: {
                      a!save(
                        local!acceptSafetyPolicy,
                        not(a!isNullOrEmpty(save!value))
                      )
                    },
                    validations: {}
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Normas y procedimientos de seguridad que todo colaborador debe conocer y cumplir en sus actividades diarias.",
                        color: "SECONDARY",
                        size: "SMALL"
                      )
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!checkboxField(
                    label: "Política de Uso de Datos",
                    labelPosition: "COLLAPSED",
                    choiceLabels: {"He leído y acepto la Política de Uso Aceptable de Sistemas y Datos"},
                    choiceValues: {true()},
                    value: if(local!acceptDataPolicy, {true()}, {}),
                    saveInto: {
                      a!save(
                        local!acceptDataPolicy,
                        not(a!isNullOrEmpty(save!value))
                      )
                    },
                    validations: {}
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Regula el uso correcto de los sistemas de información, equipos y activos tecnológicos de la empresa.",
                        color: "SECONDARY",
                        size: "SMALL"
                      )
                    }
                  )
                },
                style: "STANDARD",
                padding: "STANDARD"
              )
            }
          ),
          a!sectionLayout(
            label: "Documentos Requeridos",
            labelColor: "STANDARD",
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: "Los siguientes documentos deberán ser entregados al área de Recursos Humanos en los primeros 3 días hábiles:",
                    style: "EMPHASIS"
                  )
                },
                marginBelow: "STANDARD"
              ),
              a!cardLayout(
                contents: {
                  /* TODO: Implement document upload with a!fileUploadField when integrating with record */
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(text: "• ", style: "STRONG"),
                      "Identificación oficial vigente (INE / Pasaporte)",
                      char(10),
                      a!richTextItem(text: "• ", style: "STRONG"),
                      "CURP",
                      char(10),
                      a!richTextItem(text: "• ", style: "STRONG"),
                      "Comprobante de domicilio (máx. 3 meses)",
                      char(10),
                      a!richTextItem(text: "• ", style: "STRONG"),
                      "RFC con homoclave",
                      char(10),
                      a!richTextItem(text: "• ", style: "STRONG"),
                      "Número de Seguro Social (NSS)",
                      char(10),
                      a!richTextItem(text: "• ", style: "STRONG"),
                      "Últimos certificados de estudios",
                      char(10),
                      a!richTextItem(text: "• ", style: "STRONG"),
                      "Cartas de recomendación (mínimo 2)"
                    }
                  )
                },
                style: "INFO",
                padding: "STANDARD"
              )
            }
          )
        }
      ),

      /* ══════════════════════════════════════════════
         PASO 6 – Revisión y Confirmación
      ══════════════════════════════════════════════ */
      a!wizardStep(
        label: "Revisión y Confirmación",
        instructions: "Verifique la información antes de enviar el registro",
        contents: {
          a!sectionLayout(
            label: "Resumen del Registro",
            labelColor: "STANDARD",
            contents: {
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: "Información Personal",
                                style: "STRONG",
                                size: "MEDIUM_PLUS"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(text: "Nombre: ", style: "STRONG"),
                              local!firstName & " " & local!lastName,
                              char(10),
                              a!richTextItem(text: "ID Nacional: ", style: "STRONG"),
                              local!nationalId,
                              char(10),
                              a!richTextItem(text: "Correo: ", style: "STRONG"),
                              local!personalEmail,
                              char(10),
                              a!richTextItem(text: "Teléfono: ", style: "STRONG"),
                              a!defaultValue(local!phone, "—"),
                              char(10),
                              a!richTextItem(text: "Ciudad: ", style: "STRONG"),
                              a!defaultValue(local!city, "—") & ", " & a!defaultValue(local!state, "—")
                            }
                          )
                        },
                        style: "STANDARD",
                        padding: "STANDARD"
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: "Información del Puesto",
                                style: "STRONG",
                                size: "MEDIUM_PLUS"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(text: "Puesto: ", style: "STRONG"),
                              a!defaultValue(local!jobTitle, "—"),
                              char(10),
                              a!richTextItem(text: "Departamento: ", style: "STRONG"),
                              a!defaultValue(local!department, "—"),
                              char(10),
                              a!richTextItem(text: "Supervisor: ", style: "STRONG"),
                              a!defaultValue(local!managerName, "—"),
                              char(10),
                              a!richTextItem(text: "Fecha de inicio: ", style: "STRONG"),
                              if(
                                a!isNullOrEmpty(local!startDate),
                                "—",
                                text(local!startDate, "dd/MM/yyyy")
                              ),
                              char(10),
                              a!richTextItem(text: "Contrato: ", style: "STRONG"),
                              a!defaultValue(local!contractType, "—"),
                              char(10),
                              a!richTextItem(text: "Lugar de trabajo: ", style: "STRONG"),
                              a!defaultValue(local!workLocation, "—")
                            }
                          )
                        },
                        style: "STANDARD",
                        padding: "STANDARD"
                      )
                    }
                  )
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: "Historial Laboral",
                                style: "STRONG",
                                size: "MEDIUM_PLUS"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: length(local!employmentHistory) & " empleos registrados",
                                color: if(
                                  a!isNullOrEmpty(local!employmentHistory),
                                  "NEGATIVE",
                                  "POSITIVE"
                                )
                              )
                            }
                          )
                        },
                        style: "STANDARD",
                        padding: "STANDARD"
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: "Educación y Certificaciones",
                                style: "STRONG",
                                size: "MEDIUM_PLUS"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: length(local!education) & " registros de formación",
                                color: if(
                                  a!isNullOrEmpty(local!education),
                                  "NEGATIVE",
                                  "POSITIVE"
                                )
                              )
                            }
                          )
                        },
                        style: "STANDARD",
                        padding: "STANDARD"
                      )
                    }
                  ),
                  a!columnLayout(
                    width: "AUTO",
                    contents: {
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: "Políticas Aceptadas",
                                style: "STRONG",
                                size: "MEDIUM_PLUS"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: if(
                                  and(
                                    local!acceptCodeOfConduct,
                                    local!acceptPrivacyPolicy,
                                    local!acceptSafetyPolicy,
                                    local!acceptDataPolicy
                                  ),
                                  "Todas las políticas aceptadas",
                                  "Políticas pendientes de aceptar"
                                ),
                                color: if(
                                  and(
                                    local!acceptCodeOfConduct,
                                    local!acceptPrivacyPolicy,
                                    local!acceptSafetyPolicy,
                                    local!acceptDataPolicy
                                  ),
                                  "POSITIVE",
                                  "NEGATIVE"
                                )
                              )
                            }
                          )
                        },
                        style: "STANDARD",
                        padding: "STANDARD"
                      )
                    }
                  )
                },
                marginAbove: "STANDARD"
              ),
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "info-circle", color: "ACCENT"),
                      " ",
                      a!richTextItem(
                        text: "Al enviar este formulario, se creará el expediente del empleado y se notificará al área de Recursos Humanos para continuar con el proceso de incorporación.",
                        style: "EMPHASIS"
                      )
                    }
                  )
                },
                style: "INFO",
                padding: "STANDARD",
                marginAbove: "STANDARD"
              )
            }
          )
        }
      )
    },
    primaryButtons: {
      /* TODO-CONVERTER: Set all form fields to corresponding record type fields */
      /* TODO: Configure process model to send onboarding notification email to HR */
      a!buttonWidget(
        label: "Registrar Empleado",
        submit: true(),
        style: "SOLID",
        color: "ACCENT",
        loadingIndicator: true(),
        showWhen: fv!isLastStep
      )
    },
    secondaryButtons: {
      /* TODO-CONVERTER: Set local!cancel to true, transform to ri!cancel */
      a!buttonWidget(
        label: "Cancelar",
        value: true(),
        saveInto: a!save(local!cancel, true()),
        style: "LINK",
        validate: false()
      )
    }
  )
)
