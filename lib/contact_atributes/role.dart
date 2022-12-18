enum Role {
  unknown,
  admin,
  approver,
  preparer,
  viewer,
  employee,
}

extension RoleExtention on Role {
  String getDisplayName() => name.substring(0, 1).toUpperCase() + name.substring(1, name.length);
}

Role getRoleInstanceByString(String role) {
  switch (role) {
    case 'Admin':
      return Role.admin;
    case 'Approver':
      return Role.approver;
    case 'Preparer':
      return Role.preparer;
    case 'Viewer':
      return Role.viewer;
    case 'Employee':
      return Role.employee;
  }
  return Role.unknown;
}
