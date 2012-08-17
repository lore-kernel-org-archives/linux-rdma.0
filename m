From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 46051] New: mthca/mthca_cmd.c:1362: suspicious call to
 MTHCA_PUT
Date: Fri, 17 Aug 2012 08:47:42 +0000 (UTC)
Message-ID: <bug-46051-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=46051

           Summary: mthca/mthca_cmd.c:1362: suspicious call to MTHCA_PUT
           Product: Drivers
           Version: 2.5
    Kernel Version: 3.6-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
        AssignedTo: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
        ReportedBy: dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org
        Regression: No


I just ran the static analyser cppcheck over the source code of the
linux kernel version 3.6-rc2.

It said

[linux-3.6-rc2/drivers/infiniband/hw/mthca/mthca_cmd.c:1362]: (warning) Using
sizeof with a numeric constant as function argument might not be what you
intended.

The source code is

        MTHCA_PUT(inbox, 0x1, INIT_HCA_FLAGS1_OFFSET);

The 2nd parameter to the macro looks suspicious.
All the other calls to MTHCA_PUT do not have a value.

Suggest code rework.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
