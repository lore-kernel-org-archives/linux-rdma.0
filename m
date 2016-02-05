From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 111921] New: Severe IPoIB Routed Performance Regression
Date: Fri, 05 Feb 2016 05:23:14 +0000
Message-ID: <bug-111921-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111921

            Bug ID: 111921
           Summary: Severe IPoIB Routed Performance Regression
           Product: Drivers
           Version: 2.5
    Kernel Version: 4.4.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: thesaxophonist-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
        Regression: No

(Apologies if this is in the wrong section)

There appears to be a significant performance regression somewhere in the
Infiniband or IPoIB stack starting with kernel 4.4. IP performance over the
infiniband network itself is fine, however I have my internet connection routed
from my ethernet network to my infiniband network. In kernel versions up
through 4.3.3, this worked fine and provided my ISP line speed of ~180Mbps over
IB. However in 4.4 this has dropped over an order of magnitude and I can now
only achieve ~5Mbps when traversing from ethernet to infiniband or vice versa.
I'm running IPoIB in connected mode.

Reference: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1536837

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
