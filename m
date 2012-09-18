From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 47671] New: infiniband/hw/nes/nes_verbs.c:3008: possible
 missing break ?
Date: Tue, 18 Sep 2012 19:59:09 +0000 (UTC)
Message-ID: <bug-47671-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=47671

           Summary: infiniband/hw/nes/nes_verbs.c:3008: possible missing
                    break ?
           Product: Drivers
           Version: 2.5
    Kernel Version: 3.6-rc6
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
linux kernel version 3.6-rc6.

It said

[linux-3.6-rc6/drivers/infiniband/hw/nes/nes_verbs.c:3008]: (warning) Redundant
assignment of "next_iwarp_state" in switch

The source code is

                    switch (nesqp->hw_iwarp_state) {
                        case NES_AEQE_IWARP_STATE_CLOSING:
                            next_iwarp_state = NES_CQP_QP_IWARP_STATE_CLOSING;
                        case NES_AEQE_IWARP_STATE_TERMINATE:

That looks like a possible missing break after the first case.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
