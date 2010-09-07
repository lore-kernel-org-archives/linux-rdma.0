From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_pkey_record.c: removing unused variable
Date: Tue, 7 Sep 2010 17:57:35 +0300
Message-ID: <4C8652DF.4010705@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa_pkey_record.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/opensm/opensm/osm_sa_pkey_record.c b/opensm/opensm/osm_sa_pkey_record.c
index 5b1c794..e4930d0 100644
--- a/opensm/opensm/osm_sa_pkey_record.c
+++ b/opensm/opensm/osm_sa_pkey_record.c
@@ -210,7 +210,6 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 	const ib_sa_mad_t *p_rcvd_mad;
 	const ib_pkey_table_record_t *p_rcvd_rec;
 	const osm_port_t *p_port = NULL;
-	const ib_pkey_table_t *p_pkey;
 	cl_qlist_t rec_list;
 	osm_pkey_search_ctxt_t context;
 	ib_net64_t comp_mask;
@@ -264,8 +263,6 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}

-	p_pkey = ib_sa_mad_get_payload_ptr(p_rcvd_mad);
-
 	cl_qlist_init(&rec_list);

 	context.p_rcvd_rec = p_rcvd_rec;
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
