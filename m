From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] ibacm: incorrect ifc_len is specified in SIOCGIFCONF request
Date: Wed,  3 Dec 2014 11:10:59 -0500
Message-ID: <1417623059-15183-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ifc->ifs_len in the ioctl SIOCGIFCONF request should only specify the
associated ifreq buffer length and not include the ifc header length.
This bug was found by running ibacm with Valgrind:

==8201== Syscall param ioctl(SIOCGIFCONF).ifc_buf points to unaddressable byte(s)
==8201==    at 0x3E886DF7B7: ioctl (in /lib64/libc-2.12.so)
==8201==    by 0x40A11A: acm_if_iter_sys (acm_util.c:154)
==8201==    by 0x406979: acm_get_system_ips (acm.c:1584)
==8201==    by 0x4069FD: acm_assign_ep_names (acm.c:1602)
==8201==    by 0x4070D1: acm_ep_up (acm.c:1744)
==8201==    by 0x407799: acm_port_up (acm.c:1896)
==8201==    by 0x407DE1: acm_activate_devices (acm.c:2027)
==8201==    by 0x409CAC: main (acm.c:2728)
==8201==  Address 0x5063470 is 0 bytes after a block of size 2,576 alloc'd
==8201==    at 0x4A05FDE: malloc (vg_replace_malloc.c:236)
==8201==    by 0x40A0BB: acm_if_iter_sys (acm_util.c:144)
==8201==    by 0x406979: acm_get_system_ips (acm.c:1584)
==8201==    by 0x4069FD: acm_assign_ep_names (acm.c:1602)
==8201==    by 0x4070D1: acm_ep_up (acm.c:1744)
==8201==    by 0x407799: acm_port_up (acm.c:1896)
==8201==    by 0x407DE1: acm_activate_devices (acm.c:2027)
==8201==    by 0x409CAC: main (acm.c:2728)


Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/acm_util.c b/src/acm_util.c
index 50b46d8..d54f520 100644
--- a/src/acm_util.c
+++ b/src/acm_util.c
@@ -148,7 +148,7 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 	}
 
 	memset(ifc, 0, len);
-	ifc->ifc_len = len;
+	ifc->ifc_len = len - sizeof(*ifc);
 	ifc->ifc_req = (struct ifreq *) (ifc + 1);
 
 	ret = ioctl(s, SIOCGIFCONF, ifc);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
