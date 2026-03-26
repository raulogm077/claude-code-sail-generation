/* ==========================================================================
 * ORQUESTADOR DE AGENTES - NUEVA EJECUCION
 * ==========================================================================
 * Purpose: Form to launch a new agent orchestration. Users define the job
 *   name, objective, context, select agents, define execution order,
 *   set priority, and enable human review checkpoints.
 *
 * REQUIREMENT: Allow selection of orchestration flow type and agents.
 * REQUIREMENT: Support ordering of agents and marking human review steps.
 * REQUIREMENT: Show clear summary of what will execute before launch.
 * ========================================================================== */

a!localVariables(
  local!isUpdate: false(),
  local!cancel: false(),

  /* Form fields */
  local!jobName,
  local!description,
  local!functionalContext,
  local!project,
  local!orchestrationType,
  local!priority: "Media",
  local!observations,
  local!requireGlobalHumanReview: false(),

  /* Agent selection */
  local!availableAgents: {
    a!map(id: 1, name: "Agente Extractor", specialty: "Extraccion de datos", icon: "download", color: "#3B82F6"),
    a!map(id: 2, name: "Agente Clasificador", specialty: "Clasificacion documental", icon: "tags", color: "#8B5CF6"),
    a!map(id: 3, name: "Agente Revisor", specialty: "Revision de calidad", icon: "check-double", color: "#059669"),
    a!map(id: 4, name: "Agente Generador", specialty: "Generacion de documentos", icon: "file-text", color: "#F59E0B"),
    a!map(id: 5, name: "Agente Validador", specialty: "Validacion normativa", icon: "shield", color: "#DC2626"),
    a!map(id: 6, name: "Agente Resumidor", specialty: "Resumen y sintesis", icon: "compress", color: "#EC4899")
  },
  local!selectedAgentIds: tointeger({}),

  /* Ordered pipeline - agents added in order with human review flag */
  local!pipeline: {
    a!map(order: 1, agentId: 1, agentName: "Agente Extractor", humanReview: false()),
    a!map(order: 2, agentId: 3, agentName: "Agente Revisor", humanReview: true()),
    a!map(order: 3, agentId: 4, agentName: "Agente Generador", humanReview: false())
  },

  a!formLayout(
    titleBar: a!headerTemplateFull(
      title: if(a!defaultValue(local!isUpdate, false()), "Editar Ejecucion", "Nueva Ejecucion"),
      secondaryText: "Configure los parametros de la orquestacion",
      backgroundColor: "#1C2C44"
    ),
    contents: {
      a!columnsLayout(
        columns: {
          /* ====== LEFT COLUMN - Form fields ====== */
          a!columnLayout(
            contents: {
              /* --- Basic Information --- */
              a!sectionLayout(
                label: "Informacion General",
                labelColor: "STANDARD",
                contents: {
                  a!textField(
                    label: "Nombre del Trabajo",
                    labelPosition: "ABOVE",
                    placeholder: "Ej: Analisis Contractual Q1 2026",
                    value: local!jobName,
                    saveInto: local!jobName,
                    required: true(),
                    validations: if(
                      a!isNotNullOrEmpty(local!jobName),
                      if(len(local!jobName) < 5, "El nombre debe tener al menos 5 caracteres", null),
                      null
                    )
                  ),
                  a!paragraphField(
                    label: "Descripcion / Objetivo",
                    labelPosition: "ABOVE",
                    placeholder: "Describa el objetivo de esta ejecucion...",
                    value: local!description,
                    saveInto: local!description,
                    required: true(),
                    height: "SHORT"
                  ),
                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        contents: {
                          a!dropdownField(
                            label: "Proyecto Asociado",
                            labelPosition: "ABOVE",
                            placeholder: "Seleccione un proyecto",
                            choiceLabels: {"Proyecto Alpha", "Proyecto Beta", "Proyecto Gamma", "Proyecto Delta"},
                            choiceValues: {"alpha", "beta", "gamma", "delta"},
                            value: local!project,
                            saveInto: local!project,
                            required: true()
                          )
                        }
                      ),
                      a!columnLayout(
                        contents: {
                          a!dropdownField(
                            label: "Tipo de Orquestacion",
                            labelPosition: "ABOVE",
                            placeholder: "Seleccione un flujo",
                            choiceLabels: {
                              "Secuencial - Agentes en orden",
                              "Paralelo - Agentes simultaneos",
                              "Condicional - Segun resultado previo",
                              "Mixto - Combinacion de flujos"
                            },
                            choiceValues: {"sequential", "parallel", "conditional", "mixed"},
                            value: local!orchestrationType,
                            saveInto: local!orchestrationType,
                            required: true()
                          )
                        }
                      )
                    }
                  ),
                  a!paragraphField(
                    label: "Contexto Funcional",
                    labelPosition: "ABOVE",
                    placeholder: "Proporcione contexto adicional para los agentes...",
                    value: local!functionalContext,
                    saveInto: local!functionalContext,
                    height: "SHORT"
                  ),
                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        contents: {
                          a!radioButtonField(
                            label: "Prioridad",
                            labelPosition: "ABOVE",
                            choiceLabels: {"Alta", "Media", "Baja"},
                            choiceValues: {"Alta", "Media", "Baja"},
                            value: local!priority,
                            saveInto: local!priority,
                            choiceLayout: "COMPACT"
                          )
                        }
                      ),
                      a!columnLayout(
                        contents: {
                          a!paragraphField(
                            label: "Observaciones Adicionales",
                            labelPosition: "ABOVE",
                            placeholder: "Notas o instrucciones especiales...",
                            value: local!observations,
                            saveInto: local!observations,
                            height: "SHORT"
                          )
                        }
                      )
                    }
                  )
                }
              )
            },
            width: "AUTO"
          ),

          /* ====== RIGHT COLUMN - Agent Pipeline ====== */
          a!columnLayout(
            contents: {
              a!sectionLayout(
                label: "Pipeline de Agentes",
                labelColor: "STANDARD",
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: a!richTextItem(
                      text: "Defina el orden de ejecucion y los puntos de revision humana.",
                      color: "#6B7280",
                      size: "SMALL"
                    ),
                    marginBelow: "STANDARD"
                  ),

                  /* Pipeline ordered list */
                  a!forEach(
                    items: local!pipeline,
                    expression: a!cardLayout(
                      contents: {
                        a!sideBySideLayout(
                          items: {
                            a!sideBySideItem(
                              item: a!stampField(
                                text: text(fv!item.order, "0"),
                                backgroundColor: "#1C2C44",
                                contentColor: "#FFFFFF",
                                size: "TINY",
                                shape: "ROUNDED",
                                labelPosition: "COLLAPSED"
                              ),
                              width: "MINIMIZE"
                            ),
                            a!sideBySideItem(
                              item: a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                value: {
                                  a!richTextItem(
                                    text: fv!item.agentName,
                                    style: "STRONG",
                                    size: "STANDARD"
                                  ),
                                  if(
                                    fv!item.humanReview,
                                    {
                                      char(10),
                                      a!richTextIcon(icon: "user-check", color: "#F59E0B", size: "SMALL"),
                                      " ",
                                      a!richTextItem(
                                        text: "Revision humana requerida",
                                        color: "#F59E0B",
                                        size: "SMALL",
                                        style: "STRONG"
                                      )
                                    },
                                    {}
                                  )
                                }
                              ),
                              width: "AUTO"
                            ),
                            a!sideBySideItem(
                              item: a!buttonArrayLayout(
                                buttons: {
                                  a!buttonWidget(
                                    label: "Mover",
                                    icon: "arrows-v",
                                    style: "GHOST",
                                    size: "SMALL",
                                    saveInto: {}
                                  ),
                                  a!buttonWidget(
                                    label: "Quitar",
                                    icon: "times",
                                    style: "GHOST",
                                    size: "SMALL",
                                    color: "NEGATIVE",
                                    saveInto: {}
                                  )
                                },
                                marginBelow: "NONE"
                              ),
                              width: "MINIMIZE"
                            )
                          },
                          alignVertical: "MIDDLE",
                          spacing: "STANDARD"
                        )
                      },
                      style: "NONE",
                      shape: "ROUNDED",
                      padding: "STANDARD",
                      showBorder: true,
                      marginBelow: "LESS"
                    )
                  ),

                  /* Add agent button */
                  a!buttonArrayLayout(
                    buttons: a!buttonWidget(
                      label: "Agregar Agente al Pipeline",
                      icon: "plus",
                      style: "OUTLINE",
                      color: "ACCENT",
                      saveInto: {}
                    ),
                    align: "CENTER",
                    marginBelow: "STANDARD"
                  ),

                  /* Available agents catalog */
                  a!sectionLayout(
                    label: "Agentes Disponibles",
                    labelColor: "STANDARD",
                    contents: {
                      a!forEach(
                        items: local!availableAgents,
                        expression: a!sideBySideLayout(
                          items: {
                            a!sideBySideItem(
                              item: a!stampField(
                                icon: fv!item.icon,
                                backgroundColor: fv!item.color,
                                contentColor: "#FFFFFF",
                                size: "TINY",
                                shape: "SEMI_ROUNDED",
                                labelPosition: "COLLAPSED"
                              ),
                              width: "MINIMIZE"
                            ),
                            a!sideBySideItem(
                              item: a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                value: {
                                  a!richTextItem(
                                    text: fv!item.name,
                                    style: "STRONG",
                                    size: "STANDARD"
                                  ),
                                  char(10),
                                  a!richTextItem(
                                    text: fv!item.specialty,
                                    color: "#6B7280",
                                    size: "SMALL"
                                  )
                                }
                              ),
                              width: "AUTO"
                            ),
                            a!sideBySideItem(
                              item: a!buttonArrayLayout(
                                buttons: a!buttonWidget(
                                  label: "Agregar",
                                  icon: "plus",
                                  style: "GHOST",
                                  size: "SMALL",
                                  saveInto: {}
                                ),
                                marginBelow: "NONE"
                              ),
                              width: "MINIMIZE"
                            )
                          },
                          alignVertical: "MIDDLE",
                          spacing: "STANDARD",
                          marginBelow: if(fv!isLast, "NONE", "LESS")
                        )
                      )
                    }
                  )
                }
              )
            },
            width: "MEDIUM_PLUS"
          )
        },
        spacing: "STANDARD"
      )
    },
    buttons: a!buttonLayout(
      primaryButtons: {
        /* TODO-CONVERTER: Set all form fields to corresponding record type fields */
        a!buttonWidget(
          label: "Lanzar Ejecucion",
          icon: "rocket",
          submit: true(),
          style: "SOLID",
          color: "ACCENT",
          loadingIndicator: true()
        )
      },
      secondaryButtons: {
        a!buttonWidget(
          label: "Guardar Borrador",
          icon: "save",
          style: "OUTLINE",
          saveInto: {}
        ),
        /* TODO-CONVERTER: Set local!cancel to true, transform to ri!cancel */
        a!buttonWidget(
          label: "Cancelar",
          style: "LINK",
          saveInto: a!save(local!cancel, true()),
          validate: false()
        )
      }
    ),
    backgroundColor: "#F5F6F8"
  )
)