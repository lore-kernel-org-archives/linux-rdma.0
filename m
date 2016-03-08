From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 114061] New: xorg session flickers after resume from suspend
Date: Tue, 08 Mar 2016 23:44:22 +0000
Message-ID: <bug-114061-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=114061

            Bug ID: 114061
           Summary: xorg session flickers after resume from suspend
           Product: Drivers
           Version: 2.5
    Kernel Version: 4.1.18
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: e.sovetkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
        Regression: No

Created attachment 208321
  --> https://bugzilla.kernel.org/attachment.cgi?id=208321&action=edit
git bisect log

Xorg session flickers after resume from suspend. Restarting Xorg solves the
issue.

The problem occurs in linux-lts 4.1.18-1 and linux-lts 4.1.19-1.
Downgrading to linux-lts 4.1.17-1 solves the issue.

Journal doesn't have any relevant messages (compared logs with 4.1.17-1 and
4.1.19-1 running kernel).

Additional info:
* Laptop: Medion Akoya
* CPU: Intel(R) Core(TM) M-5Y71 CPU @ 1.20GHz
* core/linux-lts 4.1.18-1, 4.1.19-1 affected. 4.1.17 is not affected

Steps to reproduce: put machine to suspend, resume.

git bisect leads to the following commit:
# first bad commit: [40ced0bb2cd8bd17c4f1061176c2ca1db71ec667] dmaengine:
at_xdmac: fix resume for cyclic transfers

git bisect log is attached

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
