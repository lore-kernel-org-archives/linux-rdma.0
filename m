From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core/srp_daemon PATCH] Correct method field for PathRecord request
Date: Tue, 11 Apr 2017 23:28:53 +0800
Message-ID: <1491924533-2548-1-git-send-email-honli@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

According to InfiniBand Architecture Release 1.2.1, Table 208
Example PathRecord Request MAD Header Fields, MADHeader:Method
should setup to 0x12 (SubnAdmGetTable()).

Before send the MAD packet for PathRecord request, init_srp_mad setup
out_mad->method to SRP_MAD_METHOD_GET (0x01) for get_shared_pkeys. But
get_shared_pkeys setup the attr_id field to SRP_SA_ATTR_PATH_REC (0x35).

Because of this incorrect field in MAD packet, upstream srptools-1.0.3
failed with an embedded subnet manager running on an Intel True Scale
Edge Switch 12300.

Upstream srptools-1.0.3 works with upstream opensm, because
sa_mad_ctrl_process post the MAD to the dispatcher based on the attr_id
field. As attr_id had been set to SRP_SA_ATTR_PATH_REC (0x35),
PathRecord query works with opensm.

opensm/opensm/osm_sa_mad_ctrl.c
   292	static void sa_mad_ctrl_rcv_callback(IN osm_madw_t * p_madw, IN void *context,
.........
   357		switch (p_sa_mad->method) {
.........
   370		case IB_MAD_METHOD_GET:        // 0x01
   371		case IB_MAD_METHOD_GETTABLE:   // 0x12
   372	#if defined (VENDOR_RMPP_SUPPORT) && defined (DUAL_SIDED_RMPP)
   373		case IB_MAD_METHOD_GETMULTI:
   374	#endif
   375			is_get_request = TRUE;
   376		case IB_MAD_METHOD_SET:
   377		case IB_MAD_METHOD_DELETE:
   378			/* if we are closing down simply do nothing */
   379			if (osm_exit_flag)
   380				osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
   381			else
   382				sa_mad_ctrl_process(p_ctrl, p_madw, is_get_request);
   383			break;
   384

2ad09524931dbf98d412e1912c1bdbf22f8ac81d ("srp_daemon: Work around SM
bug over non-default P_Key support") in the old git tree [1] introduced
this regression issue. Upstream srptools-0.0.4 works with the embedded
subnet manager.

[1] git://git.openfabrics.org/~bvanassche/srptools.git

Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 71b5f07..f905c6f 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -1134,6 +1134,7 @@ static int get_shared_pkeys(struct resources *res,
 			continue;
 
 		/* Mark components: DLID, SLID, PKEY */
+		out_sa_mad->method = SRP_SA_METHOD_GET_TABLE;
 		out_sa_mad->comp_mask = htobe64(1 << 4 | 1 << 5 | 1 << 13);
 		out_sa_mad->rmpp_hdr.rmpp_version = UMAD_RMPP_VERSION;
 		out_sa_mad->rmpp_hdr.rmpp_type = 1;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
