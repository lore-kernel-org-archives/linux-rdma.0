From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/5] IB/srp: Fix CONFIG_DYNAMIC_DEBUG=n build
Date: Mon, 21 Nov 2016 13:56:46 -0800
Message-ID: <faf984ea-2507-f191-9862-ef6685c3fbcd@sandisk.com>
References: <ba32b251-135f-c57d-44cc-658ae35a49ca@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ba32b251-135f-c57d-44cc-658ae35a49ca-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the kernel build fails as follows if dynamic debug support
is disabled:

drivers/infiniband/ulp/srp/ib_srp.c:2272:3: error: implicit declaration of function 'DEFINE_DYNAMIC_DEBUG_METADATA'
drivers/infiniband/ulp/srp/ib_srp.c:2272:33: error: 'ddm' undeclared (first use in this function)
drivers/infiniband/ulp/srp/ib_srp.c:2275:39: error: '_DPRINTK_FLAGS_PRINT' undeclared (first use in this function)

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d980fb4..8bb720c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -64,6 +64,11 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_INFO(release_date, DRV_RELDATE);
 
+#if !defined(CONFIG_DYNAMIC_DEBUG)
+#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)
+#define DYNAMIC_DEBUG_BRANCH(descriptor) false
+#endif
+
 static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
@@ -1556,7 +1561,6 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 	return 0;
 }
 
-#if defined(DYNAMIC_DATA_DEBUG)
 static void srp_check_mapping(struct srp_map_state *state,
 			      struct srp_rdma_ch *ch, struct srp_request *req,
 			      struct scatterlist *scat, int count)
@@ -1580,7 +1584,6 @@ static void srp_check_mapping(struct srp_map_state *state,
 		       scsi_bufflen(req->scmnd), desc_len, mr_len,
 		       state->ndesc, state->nmdesc);
 }
-#endif
 
 /**
  * srp_map_data() - map SCSI data buffer onto an SRP request
@@ -1669,14 +1672,12 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	if (ret < 0)
 		goto unmap;
 
-#if defined(DYNAMIC_DEBUG)
 	{
 		DEFINE_DYNAMIC_DEBUG_METADATA(ddm,
 			"Memory mapping consistency check");
-		if (unlikely(ddm.flags & _DPRINTK_FLAGS_PRINT))
+		if (DYNAMIC_DEBUG_BRANCH(ddm))
 			srp_check_mapping(&state, ch, req, scat, count);
 	}
-#endif
 
 	/* We've mapped the request, now pull as much of the indirect
 	 * descriptor table as we can into the command buffer. If this
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
