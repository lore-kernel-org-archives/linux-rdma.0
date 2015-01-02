From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 90581] New: Silent Data Corruption with NFS/RDMA and Mellanox
 MTHCA
Date: Fri, 02 Jan 2015 11:57:54 +0000
Message-ID: <bug-90581-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90581

            Bug ID: 90581
           Summary: Silent Data Corruption with NFS/RDMA and Mellanox
                    MTHCA
           Product: Drivers
           Version: 2.5
    Kernel Version: 3.18.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: hendrikborghorst-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
        Regression: No

I've upgraded my desktop PC to a new Motherboard/CPU combination the last days.
I'm using an AMD FX-8350 CPU with an Gigabyte GA-990FXA-UD3.

Since the update I'm experiencing some weird Infiniband data corruptions. My
Setup is Desktop<Infiniband>Server. The server houses an raid and the desktop
writes all its data to the server. 

Since the update however all data written from the desktop to the server gets
corrupted at some point. Especially files with a size of a few GB are never
transferred without corruption. The got different md5sums everytime I'll copy
them from the desktop to the server.

I also have disabled RDMA for my NFS mounts which seems to work without
corruption. 

One problem I've noticed is that the Mellanox IB card on the new mainboard is
only running at x4 PCI-Express speed but this shouldn't cause silent data
corruption or am I wrong?

I think this is a serious bug/fault and should probably not occur, especially
because you can only recognize the corruption if you're lucky. To be sure I'll
also memtested both PCs.

My Setup Desktop:
- AMD FX-8350
- Gigabyte GA-990FXA-UD3
- Mellanox Technologies MT25204 (Firmware Version 1.2.0)

My Setup Server:
- Intel i5-3450
- Gigabyte Z77X-UD3H
- Mellanox Technologies MT25204 (Firmware Version 1.2.0)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
