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
        age.coefficient = 0; # Disable age as a factor
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
        columns = "id,due,tags,due.relative,description";
        labels = "ID,Due Date,Tags,Due,Description";
        sort = "urgency-,tags+"; # Sort by urgency and then group tags together, and block the column
        filter = "+PENDING and (due.before:+12d or priority:M or priority:H or +next or +ACTIVE or (due.before:+16d and +proj))";
        dateformat = "a D";
      };

      report.w = {
        description = "Tasks due before Monday";
        columns = "id,tags,due,description,urgency";
        labels = "ID,Tag,Due,Description,urg";
        sort = "urgency-,tags+"; # Sort by urgency and then group tags together, and block the column
        filter = "+PENDING and due.before:monday"; # Show pending tasks due between now and Monday
        dateformat = "A"; # Display date as full day name
      };

      # Sort by which will show up, default behavior is due+,wait+,entry+
      report.waiting.sort = "wait + ,due + ,entry +";

      # Modify list report
      report.list.dateformat = "D b, a";

      # Visual
      column.padding = 4;
      color.due = "gray22";
      color.overdue = "rgb421";
      color.calendar.today = "green";
      # make tagged and untagged the same color
      color.tagged = "gray15";
      color.tag.proj = "rgb315";
      color.tag.none = "gray15";
      color.uda.priority.H = "on red";
      color.uda.priority.M = "gray15";
      color.uda.priority.L = "gray15";

      # school keywords
      color.keyword.paper = "rgb434";
      color.keyword.Paper = "rgb434";
      color.keyword.response = "rgb434";
      color.keyword.Response = "rgb434";

      # move overdue to take precedence over tag
      rule.precedence.color = "deleted,completed,overdue,active,keyword.,tag.,project.,scheduled,due.today,due,blocked,blocking,recurring,tagged,uda.";

      # color.until = "white";

      # Something is due soon if it is due in <5 days
      due = 5;
    };
  };
}
