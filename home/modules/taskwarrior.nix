{ config, pkgs, ... }:
{
  programs.taskwarrior = {
    package = pkgs.emptyDirectory;
    enable = true;
    #colorTheme = "dark-blue-256";
    dataLocation = "${config.home.homeDirectory}/.task";
    config = {
      news.version = "3.4.0";
      urgency = {
        project.coefficient = 0;
        annotations.coefficient = 0;
        age.coefficient = 1; # Lower age
        uda.priority.H.coefficient = 8; # Raise high priority
        uda.priority.L.coefficient = -1; # Low priority actually lowers priority
        active.coefficient = 1; # Lower active
        blocking.coefficient = 3.0; # Lower blocking
        due.coefficient = 14.0; # Raise due
      };

      default.command = "j";

      # Custom Jacob report
      report.j = {
        description = "Jacob task view";
        columns = "id,due,due.relative,description";
        labels = "ID,Due Date,Due,Description";
        sort = "urgency-,tags+"; # Sort by urgency and then group tags together, and block the column
        filter = "+PENDING and (due.before:+12d or +proj or priority:M or priority:H or +next or +ACTIVE)";
        dateformat = "A, D b"; # Display date as abbreviated day name
      };

      report.w = {
        description = "Tasks due before Monday";
        columns = "id,tags,due,description,urgency";
        labels = "ID,Tag,Due,Description,urg";
        sort = "urgency-,tags+"; # Sort by urgency and then group tags together, and block the column
        filter = "+PENDING and due.before:monday"; # Show pending tasks due between now and Monday
        dateformat = "A"; # Display date as abbreviated day name
      };

      # Sort by which will show up, default behavior is due+,wait+,entry+
      report.waiting.sort = "wait + ,due + ,entry +";

      # Modify list report
      report.list.dateformat = "D b, a";

      # Visual
      column.padding = 3;
      color.due = "white";
      color.overdue = "color9";
      color.uda.priority.H = "color5";
      color.uda.priority.L = "color250";
      color.uda.priority.M = "color250";
      color.until = "white";

      # Something is due soon if it is due in <5 days
      due = 5;
    };
  };
}
