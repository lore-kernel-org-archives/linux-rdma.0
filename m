From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: SoftiWARP: new patchset
Date: Fri, 22 Jul 2011 20:45:37 +0200
Message-ID: <OFC1BE1396.C1ACB810-ONC12578D5.00644648-C12578D5.00670E1B@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Dear all,
many thanks for commenting on the software iWARP RDMA
driver code is sent about 5 weeks ago. I hope I now
incorporated all recent suggestions and fixes.

These are the main changes:

o changing siw device attachment to be dynamic based on
  netlink events
o enabling inline data for kernel clients
  (now inline data are stored within wqe structure)
o bitmask access to packet headers removing the
  '#if defined(__LITTLE_ENDIAN_BITFIELD)' style
o moving debug stuff to debugfs
o shrinking the stack size of the core tx
  function
o updates to documentation


Due to the number of lines of code changed, it might be
appropriate if I send a complete new patchset. I'll
keep patch packaging as before.

I made the current siw code available at
www.gitorious.org/softiwarp
and will keep it up-to-date. This code is now free
of kernel version dependencies. It has been tested
on different kernel versions from version 2.6.36.2
up to 3.0.0-rc1+. I tested on both big an little
endian machines.

I would be very happy to get further input. I work on
this project only part of my time - all your input speeds
up code maturing. I would be happy if the code reaches an
acceptable status soon. Thank you.


Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
