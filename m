From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/saquery.c: Modify dump_path_record
Date: Tue, 13 Oct 2009 09:04:54 -0400
Message-ID: <20091013130454.GA20198@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Similar to commit 27ea3c85500f7eff741c93e662a344742dbbea13
to fix gcc-4.4.1 warnings
    
Fix "dereferencing type-punned pointer will break strict-aliasing rules"
warning catched by gcc-4.4.1.


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/src/saquery.c b/infiniband-diags/src/saquery.c
index d880261..6c44b63 100644
--- a/infiniband-diags/src/saquery.c
+++ b/infiniband-diags/src/saquery.c
@@ -312,8 +312,7 @@ static void dump_path_record(void *data)
 	       "\t\trate....................0x%X\n"
 	       "\t\tpkt_life................0x%X\n"
 	       "\t\tpreference..............0x%X\n"
-	       "\t\tresv2...................0x%X\n"
-	       "\t\tresv3...................0x%X\n",
+	       "\t\tresv2...................0x%02X%02X%02X%02X%02X%02X\n",
 	       cl_ntoh64(p_pr->service_id),
 	       inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str, sizeof gid_str),
 	       inet_ntop(AF_INET6, p_pr->sgid.raw, gid_str2, sizeof gid_str2),
@@ -322,7 +321,8 @@ static void dump_path_record(void *data)
 	       cl_ntoh16(p_pr->pkey), ib_path_rec_qos_class(p_pr),
 	       ib_path_rec_sl(p_pr), p_pr->mtu, p_pr->rate, p_pr->pkt_life,
 	       p_pr->preference,
-	       *(uint32_t *) & p_pr->resv2, *((uint16_t *) & p_pr->resv2 + 2));
+	       p_pr->resv2[0], p_pr->resv2[1], p_pr->resv2[2],
+	       p_pr->resv2[3], p_pr->resv2[4], p_pr->resv2[5]);
 }
 
 static void dump_class_port_info(void *data)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
