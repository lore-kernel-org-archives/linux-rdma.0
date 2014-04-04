From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/14 V2] Add Dynamic IP processing to ibacm.
Date: Thu,  3 Apr 2014 20:51:40 -0400
Message-ID: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a new version of the entire patch series.  In addition to fixing
comments from Bart and Sean I removed the additional thread which removed the
need for additional locking.

[PATCH 01/14] ibacm: get_devaddr remove unused variable from signature
[PATCH 02/14] ibacm: pass interface name rather than 'struct ifreq' to get_devaddr, get_sgid, and get_pkey
[PATCH 03/14] ibacm: use sysfs (in acm_if_is_ib) rather than ioctl(... SIOCGIFHWADDR ...) to read interface type
[PATCH 04/14] ibacm: move sysfs helper functions to acm_util 'module'
[PATCH 05/14] ibacm: Move calling of helper functions out of get_devaddr
[PATCH 06/14] ibacm: move acm_if_iter_sys to acm_util.c
[PATCH 07/14] ibacm: convert logging in acm_util.c to acm_log
[PATCH 08/14] ibacm: add separate acm_ep_insert_addr function
[PATCH 09/14] ibacm: read system IP's into endpoints at startup
[PATCH 10/14] ibacm: Add Netlink socket to monitor IP address changes
[PATCH 11/14] ibacm: add/remove addr's in EP's when added/removed from the system.
[PATCH 12/14] ibacm: fix handling of aliased IPoIB devices
[PATCH 13/14] ibacm: ib_acme remove IP addresses from ibacm_addr.cfg file generation
[PATCH 14/14] ibacm: by default remove processing of IP's from ibacm_addr.cfg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
