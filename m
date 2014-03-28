From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 00/16] ibacm: Implement dynamic IP support
Date: Thu, 27 Mar 2014 22:49:54 -0700
Message-ID: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following patch series implements dynamic system IP address updates for
ibacm.  System IP's are read at start up and Netlink is monitored to respond to
system IP address changes.

IP's are no longer required or supported in ibacm_addr.cfg after this series.
Support for ibacm_addr.cfg was maintained through the first 13 patches in case
this feature breaks some user in some unforeseen way. 

Ira

--
Sending this on Ira's behalf, who is experiencing technical difficulties.

- Sean

Ira Weiny (16):
  ibacm: get_devaddr remove unused variable from signature
  ibacm: pass interface name rather than 'struct ifreq' to get_devaddr,
    get_sgid, and get_pkey
  ibacm: use sysfs (in acm_if_is_ib) rather than ioctl(...
    SIOCGIFHWADDR ...) to read interface type
  ibacm: move sysfs helper functions to acm_util 'module'
  ibacm: Move calling of helper functions out of get_devaddr
  ibacm: move acm_if_iter_sys to acm_util.c
  ibacm: convert logging in acm_util.c to acm_log
  ibacm: add separate acm_ep_insert_addr function
  ibacm: read system IP's into endpoints at startup
  ibacm: add locking around end point address arrays
  ibacm: Add thread to monitor IP address changes
  ibacm: add/remove addr's in EP's when added/removed from the system.
  ibacm: fix handling of aliased IPoIB devices
  ibacm: ib_acme remove IP addresses from ibacm_addr.cfg file
    generation
  ibacm: remove acm_if_iter_sys function
  ibacm: remove processing of IP's from ibacm_addr.cfg

 Makefile.am        |   10 +-
 linux/acme_linux.c |  217 ---------------------------
 man/ib_acme.1      |    3 +-
 src/acm.c          |  419 +++++++++++++++++++++++++++++++++++++++++++++++++---
 src/acm_util.c     |  124 ++++++++++++++++
 src/acm_util.h     |   51 +++++++
 src/acme.c         |   13 +-
 7 files changed, 581 insertions(+), 256 deletions(-)
 delete mode 100644 linux/acme_linux.c
 create mode 100644 src/acm_util.c
 create mode 100644 src/acm_util.h

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
