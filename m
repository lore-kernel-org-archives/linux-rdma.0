From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH] umad.c: memset() ib_user_mad_reg_req structure to 0 before
 invoking ioctl()
Date: Mon, 4 Jul 2011 11:53:14 +0200
Message-ID: <20110704115314.7c15c6ac@b012350-ux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vincent <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This fixes the following warning issued by valgrind:

==5287== Syscall param ioctl(generic) points to uninitialised byte(s)
==5287==    at 0x3C466D95D7: ioctl (in /lib64/libc-2.12.so)
==5287==    by 0x526C292: umad_register (umad.c:947)
==5287==    by 0x568D206: smp_engine_init (query_smp.c:228)
==5287==    by 0x5689F8F: ibnd_discover_fabric (ibnetdisc.c:537)
==5287==    by 0x411700: devmgr_discover_fabric (devmgr_discover.c:66)

Signed-off-by: Jean-Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>

---

diff --git a/src/umad.c b/src/umad.c
index 45a9423..cac46a4 100644
--- a/src/umad.c
+++ b/src/umad.c
@@ -892,6 +892,7 @@ int umad_register_oui(int fd, int mgmt_class, uint8_t rmpp_version,
 		return -EINVAL;
 	}
 
+	memset(&req, 0, sizeof(req));
 	req.qpn = 1;
 	req.mgmt_class = mgmt_class;
 	req.mgmt_class_version = 1;
@@ -928,6 +929,7 @@ int umad_register(int fd, int mgmt_class, int mgmt_version,
 	    ("fd %d mgmt_class %u mgmt_version %u rmpp_version %d method_mask %p",
 	     fd, mgmt_class, mgmt_version, rmpp_version, method_mask);
 
+	memset(&req, 0, sizeof(req));
 	req.qpn = qp = (mgmt_class == 0x1 || mgmt_class == 0x81) ? 0 : 1;
 	req.mgmt_class = mgmt_class;
 	req.mgmt_class_version = mgmt_version;
-- 
1.7.1.rc2.7.g3e7f1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
