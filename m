From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 109391] New: Packet and byte counters only 32bit
Date: Tue, 15 Dec 2015 10:18:02 +0000
Message-ID: <bug-109391-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=109391

            Bug ID: 109391
           Summary: Packet and byte counters only 32bit
           Product: Drivers
           Version: 2.5
    Kernel Version: git HEAD
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: philipp.marek-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org
        Regression: No

Trying to find packet and byte counters for the RDMA transports I stumbled upon
this directory:

    /sys/class/infiniband/mlx5_1/ports/1/counters/

This seems to have all the requested data; but, looking again, I can see

    port_rcv_data: 4294967295

which looks awful.


And indeed, in 

   
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/infiniband/core/sysfs.c#n401

there's a 32bit width, with explicit code in

   
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/infiniband/hw/qib/qib_mad.c#n1507

to cap on that limit...


That is useless for the upcoming speeds. The MLX5 driver can drive Connect-X4
cards which go 100GBit/sec; that is 11GByte/sec, which means that the 32bit
counter will overflow ~3 times a second. So it can't be monitored.


Please provide 64bit counters (for packets and bytes, at least)!

Thanks a lot.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
