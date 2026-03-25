a!localVariables(
  /* === DATOS DEL CASO === */
  local!nombreCaso: "",
  local!descripcionBreve: "",
  local!documentoAdjunto: {},

  /* === ESTADO DEL ANÁLISIS === */
  local!analizando: false,
  local!planGenerado: false,

  /* === AGENTES DISPONIBLES === */
  local!agentesDisponibles: {
    a!map(
      id: 1,
      nombre: "sail-schema-validator",
      descripcion: "Valida funciones SAIL, parámetros y valores enumerados contra el esquema oficial de la API",
      icono: "check-circle",
      colorFondo: "#EDE9FE",
      colorTexto: "#6B21A8"
    ),
    a!map(
      id: 2,
      nombre: "sail-icon-validator",
      descripcion: "Verifica que todos los iconos de rich text sean alias válidos en el sistema Appian",
      icono: "image",
      colorFondo: "#DBEAFE",
      colorTexto: "#1D4ED8"
    ),
    a!map(
      id: 3,
      nombre: "sail-code-reviewer",
      descripcion: "Valida la estructura del código SAIL, reglas de sintaxis y patrones arquitectónicos",
      icono: "code",
      colorFondo: "#D1FAE5",
      colorTexto: "#065F46"
    ),
    a!map(
      id: 4,
      nombre: "sail-validation-implementer",
      descripcion: "Implementa validaciones de reglas de negocio identificadas en los requerimientos",
      icono: "shield",
      colorFondo: "#FEE2E2",
      colorTexto: "#991B1B"
    ),
    a!map(
      id: 5,
      nombre: "sail-interface-splitter",
      descripcion: "Refactoriza interfaces monolíticas en componentes SAIL reutilizables",
      icono: "columns",
      colorFondo: "#FEF9C3",
      colorTexto: "#92400E"
    ),
    a!map(
      id: 6,
      nombre: "sail-dynamic-converter",
      descripcion: "Transforma mockups estáticos en interfaces dinámicas conectadas a registros de Appian",
      icono: "refresh",
      colorFondo: "#E0F2FE",
      colorTexto: "#0369A1"
    )
  },

  /* === PLAN DE TRABAJO (muestra de datos generados por el agente) === */
  local!planDeTrabajo: {
    a!map(
      paso: 1,
      titulo: "Generación del Mockup SAIL",
      descripcion: "Crear el mockup estático de la interfaz basado en los requisitos del documento adjunto",
      agente: "sail-dynamic-converter",
      duracionMin: 30,
      dependencias: "Ninguna",
      prioridad: "ALTA",
      estado: "PENDIENTE"
    ),
    a!map(
      paso: 2,
      titulo: "Validación de Esquema API",
      descripcion: "Verificar que todas las funciones y parámetros SAIL generados sean válidos según el esquema oficial",
      agente: "sail-schema-validator",
      duracionMin: 10,
      dependencias: "Paso 1",
      prioridad: "ALTA",
      estado: "PENDIENTE"
    ),
    a!map(
      paso: 3,
      titulo: "Validación de Iconos",
      descripcion: "Comprobar que todos los nombres de iconos usados en la interfaz existen como alias válidos",
      agente: "sail-icon-validator",
      duracionMin: 5,
      dependencias: "Paso 1",
      prioridad: "MEDIA",
      estado: "PENDIENTE"
    ),
    a!map(
      paso: 4,
      titulo: "Revisión Estructural del Código",
      descripcion: "Validar el anidamiento, la jerarquía de layouts y los patrones arquitectónicos del código SAIL",
      agente: "sail-code-reviewer",
      duracionMin: 20,
      dependencias: "Pasos 2 y 3",
      prioridad: "ALTA",
      estado: "PENDIENTE"
    ),
    a!map(
      paso: 5,
      titulo: "Implementación de Validaciones de Negocio",
      descripcion: "Agregar las reglas de validación identificadas en el documento: campos requeridos, formatos y lógica condicional",
      agente: "sail-validation-implementer",
      duracionMin: 25,
      dependencias: "Paso 4",
      prioridad: "ALTA",
      estado: "PENDIENTE"
    ),
    a!map(
      paso: 6,
      titulo: "Conversión a Interfaz Dinámica",
      descripcion: "Conectar la interfaz a los registros de Appian, reemplazar datos locales con queries a!recordData()",
      agente: "sail-dynamic-converter",
      duracionMin: 35,
      dependencias: "Paso 5",
      prioridad: "ALTA",
      estado: "PENDIENTE"
    )
  },

  a!headerContentLayout(
    header: {
      a!cardLayout(
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "robot", size: "LARGE", color: "#6B21A8"),
                      a!richTextItem(
                        text: "  Orquestador de Agentes",
                        size: "LARGE",
                        style: "STRONG"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Adjunta un documento con la descripción de la funcionalidad. El agente orquestador leerá el documento, creará un plan de trabajo paso a paso e identificará qué agentes deben intervenir y en qué orden.",
                        color: "SECONDARY"
                      )
                    }
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!stampField(
                    labelPosition: "COLLAPSED",
                    value: if(local!planGenerado, "Plan generado", "Sin plan"),
                    backgroundColor: if(local!planGenerado, "#D1FAE5", "#F3F4F6"),
                    contentColor: if(local!planGenerado, "#065F46", "#6B7280"),
                    size: "LARGE"
                  )
                },
                width: "MEDIUM_SMALL"
              )
            }
          )
        },
        style: "STANDARD",
        padding: "STANDARD"
      )
    },
    contents: {
      a!columnsLayout(
        columns: {

          /* =====================================================
             PANEL IZQUIERDO: Datos del caso y agentes
             ===================================================== */
          a!columnLayout(
            contents: {

              /* Sección: Crear caso */
              a!sectionLayout(
                label: "Nuevo caso de orquestación",
                labelIcon: "plus-circle",
                contents: {
                  a!textField(
                    label: "Nombre del caso",
                    labelPosition: "ABOVE",
                    placeholder: "Ej: Módulo de gestión de empleados",
                    value: local!nombreCaso,
                    saveInto: local!nombreCaso,
                    required: true,
                    requiredMessage: "Ingresa un nombre para el caso"
                  ),
                  a!textField(
                    label: "Descripción breve",
                    labelPosition: "ABOVE",
                    placeholder: "Describe brevemente la funcionalidad que quieres implementar...",
                    value: local!descripcionBreve,
                    saveInto: local!descripcionBreve,
                    inputPurpose: "PARAGRAPH"
                  ),
                  a!fileUploadField(
                    label: "Documento de requisitos",
                    labelPosition: "ABOVE",
                    helpTooltip: "Adjunta el documento que describe la funcionalidad. El agente lo leerá para generar el plan de trabajo.",
                    target: a!documentUploadTarget(
                      folder: 12345
                    ),
                    value: local!documentoAdjunto,
                    saveInto: local!documentoAdjunto,
                    maxSelections: 1
                  ),
                  a!buttonArrayLayout(
                    buttons: {
                      a!buttonWidget(
                        label: if(
                          local!analizando,
                          "Analizando documento...",
                          "Analizar y generar plan"
                        ),
                        icon: if(local!analizando, "refresh", "brain"),
                        style: "PRIMARY",
                        disabled: or(
                          local!analizando,
                          local!nombreCaso = "",
                          isnull(local!nombreCaso),
                          count(local!documentoAdjunto) = 0
                        ),
                        saveInto: {
                          a!save(local!analizando, true),
                          a!save(local!planGenerado, true),
                          a!save(local!analizando, false)
                        }
                      )
                    },
                    align: "FILL"
                  )
                }
              ),

              /* Sección: Agentes disponibles */
              a!sectionLayout(
                label: "Agentes disponibles",
                labelIcon: "list",
                contents: {
                  a!forEach(
                    items: local!agentesDisponibles,
                    expression: a!cardLayout(
                      contents: {
                        a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextIcon(
                              icon: fv!item.icono,
                              color: fv!item.colorTexto
                            ),
                            a!richTextItem(
                              text: "  " & fv!item.nombre,
                              style: "STRONG",
                              color: fv!item.colorTexto
                            )
                          }
                        ),
                        a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextItem(
                              text: fv!item.descripcion,
                              color: "SECONDARY",
                              size: "SMALL"
                            )
                          }
                        )
                      },
                      style: "STANDARD",
                      marginBelow: "STANDARD"
                    )
                  )
                }
              )
            },
            width: "MEDIUM_SMALL"
          ),

          /* =====================================================
             PANEL DERECHO: Plan de trabajo
             ===================================================== */
          a!columnLayout(
            contents: {
              a!sectionLayout(
                label: if(
                  local!planGenerado,
                  "Plan de trabajo — " & count(local!planDeTrabajo) & " pasos identificados",
                  "Plan de trabajo"
                ),
                labelIcon: "list-ol",
                contents: {

                  /* Estado vacío: sin plan generado */
                  a!cardLayout(
                    showWhen: not(local!planGenerado),
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        align: "CENTER",
                        value: {
                          a!richTextIcon(icon: "file-text-o", size: "LARGE", color: "#D1D5DB"),
                          a!richTextItem(
                            text: char(10) & char(10) & "El plan de trabajo aparecerá aquí",
                            style: "STRONG",
                            color: "SECONDARY"
                          ),
                          a!richTextItem(
                            text: char(10) & char(10) & "Adjunta un documento y haz clic en «Analizar y generar plan» para que el agente orquestador cree el plan de trabajo con los agentes asignados.",
                            color: "SECONDARY"
                          )
                        }
                      )
                    },
                    style: "NONE",
                    padding: "EVEN_MORE"
                  ),

                  /* Pasos del plan */
                  a!cardLayout(
                    showWhen: local!planGenerado,
                    contents: {
                      a!forEach(
                        items: local!planDeTrabajo,
                        expression: a!cardLayout(
                          contents: {
                            a!columnsLayout(
                              columns: {

                                /* Número de paso */
                                a!columnLayout(
                                  contents: {
                                    a!stampField(
                                      labelPosition: "COLLAPSED",
                                      value: "Paso " & fv!item.paso,
                                      backgroundColor: "#EDE9FE",
                                      contentColor: "#6B21A8",
                                      size: "STANDARD"
                                    )
                                  },
                                  width: "MEDIUM_SMALL"
                                ),

                                /* Título, descripción y agente */
                                a!columnLayout(
                                  contents: {
                                    a!richTextDisplayField(
                                      labelPosition: "COLLAPSED",
                                      value: {
                                        a!richTextItem(
                                          text: fv!item.titulo,
                                          style: "STRONG"
                                        )
                                      }
                                    ),
                                    a!richTextDisplayField(
                                      labelPosition: "COLLAPSED",
                                      value: {
                                        a!richTextItem(
                                          text: fv!item.descripcion,
                                          color: "SECONDARY",
                                          size: "SMALL"
                                        )
                                      }
                                    ),
                                    a!richTextDisplayField(
                                      labelPosition: "COLLAPSED",
                                      value: {
                                        a!richTextIcon(icon: "robot", color: "#6B21A8"),
                                        a!richTextItem(
                                          text: "  " & fv!item.agente,
                                          style: "STRONG",
                                          color: "#6B21A8",
                                          size: "SMALL"
                                        ),
                                        a!richTextItem(
                                          text: "   |   Depende de: " & fv!item.dependencias,
                                          color: "SECONDARY",
                                          size: "SMALL"
                                        )
                                      }
                                    )
                                  },
                                  width: "AUTO"
                                ),

                                /* Duración, prioridad y estado */
                                a!columnLayout(
                                  contents: {
                                    a!stampField(
                                      labelPosition: "COLLAPSED",
                                      value: fv!item.prioridad,
                                      backgroundColor: if(
                                        fv!item.prioridad = "ALTA",
                                        "#FEE2E2",
                                        "#FEF9C3"
                                      ),
                                      contentColor: if(
                                        fv!item.prioridad = "ALTA",
                                        "#991B1B",
                                        "#92400E"
                                      ),
                                      size: "SMALL"
                                    ),
                                    a!stampField(
                                      labelPosition: "COLLAPSED",
                                      value: fv!item.estado,
                                      backgroundColor: "#F3F4F6",
                                      contentColor: "#6B7280",
                                      size: "SMALL"
                                    ),
                                    a!richTextDisplayField(
                                      labelPosition: "COLLAPSED",
                                      value: {
                                        a!richTextIcon(icon: "clock-o", color: "#6B7280"),
                                        a!richTextItem(
                                          text: "  " & fv!item.duracionMin & " min",
                                          color: "SECONDARY",
                                          size: "SMALL"
                                        )
                                      }
                                    )
                                  },
                                  width: "MEDIUM_SMALL"
                                )
                              )
                            }
                          },
                          style: "STANDARD",
                          marginBelow: "STANDARD"
                        )
                      )
                    },
                    style: "NONE",
                    padding: "NONE"
                  ),

                  /* Resumen del plan */
                  a!sectionLayout(
                    showWhen: local!planGenerado,
                    label: "Resumen de ejecución",
                    labelIcon: "bar-chart",
                    contents: {
                      a!columnsLayout(
                        columns: {
                          a!columnLayout(
                            contents: {
                              a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                align: "CENTER",
                                value: {
                                  a!richTextItem(
                                    text: text(count(local!planDeTrabajo)),
                                    size: "LARGE",
                                    style: "STRONG",
                                    color: "#6B21A8"
                                  ),
                                  a!richTextItem(
                                    text: char(10) & "Pasos totales",
                                    color: "SECONDARY"
                                  )
                                }
                              )
                            },
                            width: "AUTO"
                          ),
                          a!columnLayout(
                            contents: {
                              a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                align: "CENTER",
                                value: {
                                  a!richTextItem(
                                    text: text(count(local!agentesDisponibles)),
                                    size: "LARGE",
                                    style: "STRONG",
                                    color: "#6B21A8"
                                  ),
                                  a!richTextItem(
                                    text: char(10) & "Agentes disponibles",
                                    color: "SECONDARY"
                                  )
                                }
                              )
                            },
                            width: "AUTO"
                          ),
                          a!columnLayout(
                            contents: {
                              a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                align: "CENTER",
                                value: {
                                  a!richTextItem(
                                    text: "125",
                                    size: "LARGE",
                                    style: "STRONG",
                                    color: "#6B21A8"
                                  ),
                                  a!richTextItem(
                                    text: char(10) & "Minutos estimados",
                                    color: "SECONDARY"
                                  )
                                }
                              )
                            },
                            width: "AUTO"
                          )
                        }
                      )
                    }
                  )
                }
              )
            },
            width: "AUTO"
          )
        )
      )
    }
  )
)
