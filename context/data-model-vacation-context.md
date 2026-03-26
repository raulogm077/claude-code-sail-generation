# Vacation Management (VM) — Appian Record Type Context Reference

This document is used by the `sail-dynamic-converter` agent to convert the vacation management mockup into functional SAIL code. It defines all record types, fields, and relationships needed for the conversion.

> ⚠️ All UUIDs below are **placeholders**. After creating the record types in Appian, replace them using Ctrl+Space autocomplete in the Interface Designer.

<available_record_types><vm_employee><vm_team><vm_request><vm_ref_leave_type><vm_ref_request_status>

---

### VM Employee

**Record Type**: `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee'`

**Description**: Empleado perteneciente a un equipo. Almacena datos personales, información laboral y saldos de vacaciones/enfermedad.

**Fields**:

| Field Name | Data Type | Field Reference |
|---|---|---|
| id | Integer | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000001}id'` |
| firstName | Text | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000002}firstName'` |
| lastName | Text | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000003}lastName'` |
| email | Text | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000004}email'` |
| jobTitle | Text | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000005}jobTitle'` |
| department | Text | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000006}department'` |
| teamId | Integer | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000007}teamId'` |
| managerId | User | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000008}managerId'` |
| appianUserId | User | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000009}appianUserId'` |
| vacationBalance | Integer | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000010}vacationBalance'` |
| sickBalance | Integer | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000011}sickBalance'` |
| isActive | Boolean | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000012}isActive'` |
| createdBy | User | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000013}createdBy'` |
| createdOn | Datetime | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000014}createdOn'` |
| modifiedBy | User | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000015}modifiedBy'` |
| modifiedOn | Datetime | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.fields.{f001e001-0000-0000-0000-000000000016}modifiedOn'` |

**Relationships**:

| Relationship Name | Type | Relationship Reference |
|---|---|---|
| team | many-to-one | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.relationships.{rel001e001-0000-0000-0000-000000000001}team'` |
| requests | one-to-many | `'recordType!{a1b2c3d4-0001-0001-0001-000000000001}VM Employee.relationships.{rel001e001-0000-0000-0000-000000000002}requests'` |

---

### VM Team

**Record Type**: `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team'`

**Description**: Equipo o departamento de la organización. Contiene múltiples empleados y tiene un manager asignado.

**Fields**:

| Field Name | Data Type | Field Reference |
|---|---|---|
| id | Integer | `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team.fields.{f002t001-0000-0000-0000-000000000001}id'` |
| name | Text | `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team.fields.{f002t001-0000-0000-0000-000000000002}name'` |
| description | Text | `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team.fields.{f002t001-0000-0000-0000-000000000003}description'` |
| managerId | User | `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team.fields.{f002t001-0000-0000-0000-000000000004}managerId'` |
| isActive | Boolean | `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team.fields.{f002t001-0000-0000-0000-000000000005}isActive'` |
| createdBy | User | `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team.fields.{f002t001-0000-0000-0000-000000000006}createdBy'` |
| createdOn | Datetime | `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team.fields.{f002t001-0000-0000-0000-000000000007}createdOn'` |

**Relationships**:

| Relationship Name | Type | Relationship Reference |
|---|---|---|
| employees | one-to-many | `'recordType!{a1b2c3d4-0002-0001-0001-000000000002}VM Team.relationships.{rel002t001-0000-0000-0000-000000000001}employees'` |

---

### VM Request

**Record Type**: `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request'`

**Description**: Solicitud de ausencia enviada por un empleado. Almacena el período solicitado, tipo de ausencia, estado actual e información de aprobación.

**Fields**:

| Field Name | Data Type | Field Reference |
|---|---|---|
| id | Integer | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000001}id'` |
| employeeId | Integer | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000002}employeeId'` |
| leaveTypeId | Integer | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000003}leaveTypeId'` |
| statusId | Integer | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000004}statusId'` |
| startDate | Date | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000005}startDate'` |
| endDate | Date | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000006}endDate'` |
| totalDays | Integer | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000007}totalDays'` |
| reason | Text | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000008}reason'` |
| approvedBy | User | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000009}approvedBy'` |
| approvalDate | Datetime | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000010}approvalDate'` |
| approvalNotes | Text | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000011}approvalNotes'` |
| isActive | Boolean | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000012}isActive'` |
| createdBy | User | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000013}createdBy'` |
| createdOn | Datetime | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000014}createdOn'` |
| modifiedBy | User | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000015}modifiedBy'` |
| modifiedOn | Datetime | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.fields.{f003r001-0000-0000-0000-000000000016}modifiedOn'` |

**Relationships**:

| Relationship Name | Type | Relationship Reference |
|---|---|---|
| employee | many-to-one | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.relationships.{rel003r001-0000-0000-0000-000000000001}employee'` |
| leaveType | many-to-one | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.relationships.{rel003r001-0000-0000-0000-000000000002}leaveType'` |
| status | many-to-one | `'recordType!{a1b2c3d4-0003-0001-0001-000000000003}VM Request.relationships.{rel003r001-0000-0000-0000-000000000003}status'` |

---

### VM Ref Leave Type

**Record Type**: `'recordType!{a1b2c3d4-0004-0001-0001-000000000004}VM Ref Leave Type'`

**Description**: Tabla de referencia para tipos de ausencia.

**Fields**:

| Field Name | Data Type | Field Reference |
|---|---|---|
| id | Integer | `'recordType!{a1b2c3d4-0004-0001-0001-000000000004}VM Ref Leave Type.fields.{f004l001-0000-0000-0000-000000000001}id'` |
| value | Text | `'recordType!{a1b2c3d4-0004-0001-0001-000000000004}VM Ref Leave Type.fields.{f004l001-0000-0000-0000-000000000002}value'` |
| allowanceDays | Integer | `'recordType!{a1b2c3d4-0004-0001-0001-000000000004}VM Ref Leave Type.fields.{f004l001-0000-0000-0000-000000000003}allowanceDays'` |
| requiresApproval | Boolean | `'recordType!{a1b2c3d4-0004-0001-0001-000000000004}VM Ref Leave Type.fields.{f004l001-0000-0000-0000-000000000004}requiresApproval'` |
| sortOrder | Integer | `'recordType!{a1b2c3d4-0004-0001-0001-000000000004}VM Ref Leave Type.fields.{f004l001-0000-0000-0000-000000000005}sortOrder'` |

**Relationships**:

| Relationship Name | Type | Relationship Reference |
|---|---|---|
| requests | one-to-many | `'recordType!{a1b2c3d4-0004-0001-0001-000000000004}VM Ref Leave Type.relationships.{rel004l001-0000-0000-0000-000000000001}requests'` |

---

### VM Ref Request Status

**Record Type**: `'recordType!{a1b2c3d4-0005-0001-0001-000000000005}VM Ref Request Status'`

**Description**: Tabla de referencia para estados de solicitud: Pendiente, Aprobada, Rechazada, Cancelada.

**Fields**:

| Field Name | Data Type | Field Reference |
|---|---|---|
| id | Integer | `'recordType!{a1b2c3d4-0005-0001-0001-000000000005}VM Ref Request Status.fields.{f005s001-0000-0000-0000-000000000001}id'` |
| value | Text | `'recordType!{a1b2c3d4-0005-0001-0001-000000000005}VM Ref Request Status.fields.{f005s001-0000-0000-0000-000000000002}value'` |
| sortOrder | Integer | `'recordType!{a1b2c3d4-0005-0001-0001-000000000005}VM Ref Request Status.fields.{f005s001-0000-0000-0000-000000000003}sortOrder'` |

**Relationships**:

| Relationship Name | Type | Relationship Reference |
|---|---|---|
| requests | one-to-many | `'recordType!{a1b2c3d4-0005-0001-0001-000000000005}VM Ref Request Status.relationships.{rel005s001-0000-0000-0000-000000000001}requests'` |

</vm_ref_request_status></vm_ref_leave_type></vm_request></vm_team></vm_employee></available_record_types>
