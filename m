From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 15095] New: ib_srp module removal triggers circular locking
 complaint
Date: Wed, 20 Jan 2010 19:06:59 GMT
Message-ID: <bug-15095-11804@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15095

           Summary: ib_srp module removal triggers circular locking
                    complaint
           Product: Drivers
           Version: 2.5
    Kernel Version: 2.6.33-rc3 (infiniband.git tree, for-next branch, last
                    commit dates from Thu Jan 14 12:23:37 2010 -0800)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
        AssignedTo: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
        ReportedBy: bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
        Regression: No


Created an attachment (id=24662)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24662)
Kernel log

Removing the ib_srp kernel module often (but not always) triggers a kernel
complaint about a possible circular locking dependency.

That complaint is triggered by the following script:

#!/bin/sh
while [ -e /sys/module/ib_srp ]
do
  rmmod ib_srp || sleep 1
done
modprobe ib_srp "${1:-srp_sg_tablesize=128}"
ibsrpdm -c -d /dev/infiniband/umad0 \
| while read target_info
  do
    echo "${target_info}"
    echo "${target_info}" > /sys/class/infiniband_srp/srp-mlx4_0-1/add_target
done

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
