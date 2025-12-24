# Project Context for Claude

This file contains important business context about the office attendance tracker project.

## Project Purpose

This application tracks which days the user physically attends the office vs. working remotely. The company mandates a minimum number of office days within rolling attendance windows.

**Current Requirement**: Attend at least 20 days per attendance window (as of 2025)

## Data Models - Business Purpose

### Attendance
Records a single day of office attendance.

### AttendanceWindow
Defines a tracking period with an associated attendance requirement.

**Business Context**:
- Duration: Typically 3 months (~90 days)
- Overlap: New windows created every month to implement rolling requirement
- Multiple overlapping windows are normal and expected
- Current requirement: 20 days per window (can theoretically vary per window)
- Requirement changes: Company evaluates in-office requirements yearly; changes implemented via new windows in the new year

### ExclusionPeriod
Company-defined date ranges when office attendance tracking does not apply.

**Purpose**: Represents periods when the office is closed or attendance is not required/counted

**Examples**:
- Winter holidays / year-end shutdown
- Company-wide events (conferences, all-hands meetings)
- Summer shutdowns
- Office maintenance/renovation periods

**NOT for**:
- Individual sick days
- Personal PTO (may be supported in the future)

## Business Rules

### Rolling Windows
The "rolling" attendance requirement is implemented via overlapping attendance windows:
- Windows are typically 3 months long
- A new window is created every month
- This creates a 2-month overlap between consecutive windows
- At any given time, multiple windows may be "active"

### Exclusion Periods
- Can span multiple attendance windows
- Attendance CAN be logged during exclusion periods (user came in anyway)
- Exclusion period days should NOT count toward attendance requirements

### Counting Attendance
When calculating if attendance requirements are met:

1. **Filter out weekends**: Saturday and Sunday don't count toward the requirement
2. **Filter out exclusion periods**: Days within exclusion period ranges don't count
3. **Allow attendance during exclusions**: Users can log attendance during exclusions, but it won't count toward metrics

## Typical Usage Patterns

**Office Attendance**:
- Primary days: Tuesday, Wednesday, Thursday
- Occasional: Monday (when other days are missed)
- Rare: Weekends (for special circumstances)

**Exclusion Periods**:
- Winter holidays (December/January)
- Company-wide events (conferences, all-hands)
- Quarterly or annual planning sessions
