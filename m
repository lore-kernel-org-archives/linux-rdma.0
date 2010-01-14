From: Nico <parpandet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mode connected infiniband
Date: Thu, 14 Jan 2010 09:11:17 +0100
Message-ID: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'am using an infiniband kernel 2.6.32-trunk-686 from debian,
and it seems /sys/class/net/ib0/mode is missing :

vza:/sys/class/net/ib0# ls -l
total 0
-r--r--r-- 1 root root 4096 janv. 14 08:55 address
-r--r--r-- 1 root root 4096 janv. 14 08:55 addr_len
-r--r--r-- 1 root root 4096 janv. 14 08:55 broadcast
-r--r--r-- 1 root root 4096 janv. 14 08:55 carrier
--w--w--w- 1 root root 4096 janv. 14 08:55 create_child
--w--w--w- 1 root root 4096 janv. 14 08:55 delete_child
lrwxrwxrwx 1 root root    0 janv. 14 08:55 device -> ../../../0000:05:00.0
-r--r--r-- 1 root root 4096 janv. 14 08:55 dev_id
-r--r--r-- 1 root root 4096 janv. 14 08:55 dormant
-r--r--r-- 1 root root 4096 janv. 14 08:55 features
-rw-r--r-- 1 root root 4096 janv. 14 08:55 flags
-rw-r--r-- 1 root root 4096 janv. 14 08:55 ifalias
-r--r--r-- 1 root root 4096 janv. 14 08:55 ifindex
-r--r--r-- 1 root root 4096 janv. 14 08:55 iflink
-r--r--r-- 1 root root 4096 janv. 14 08:55 link_mode
-rw-r--r-- 1 root root 4096 janv. 14 08:55 mtu
-r--r--r-- 1 root root 4096 janv. 14 08:55 operstate
-r--r--r-- 1 root root 4096 janv. 14 08:55 pkey
drwxr-xr-x 2 root root    0 janv. 14 08:55 power
drwxr-xr-x 2 root root    0 janv. 14 08:55 statistics
lrwxrwxrwx 1 root root    0 janv. 14 08:55 subsystem ->
../../../../../../../../class/net
-rw-r--r-- 1 root root 4096 janv. 14 08:55 tx_queue_len
-r--r--r-- 1 root root 4096 janv. 14 08:55 type
-rw-r--r-- 1 root root 4096 janv. 14 08:55 uevent
-rw-r--r-- 1 root root 4096 janv. 14 08:55 umcast

as I am doing some benchs and wanted to size up MTU with connected mode,

* is there another way to use connected mode ?
* is it related to debian packaging ?

Regards.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
