From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibsim: Do not return allportselect for non-switches
Date: Tue, 18 Jun 2013 17:51:08 -0700
Message-ID: <1371603068.19017.95.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ibsim only supports allportselect (i.e. port 0xff) for switches
but not HCAs.  However the allportselect flag would be returned
for all classportinfo requests, leading to unexpected results
when running some infiniband-diag tools against ibsim.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim_mad.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
index 0b52c52..223d507 100644
--- a/ibsim/sim_mad.c
+++ b/ibsim/sim_mad.c
@@ -235,6 +235,7 @@ static int reply_MAD(void *buf, ib_rpc_t * rpc, ib_dr_path_t * path,
 
 static int do_cpi(Port * port, unsigned op, uint32_t mod, uint8_t * data)
 {
+	Node *node = port->node;
 	int status = 0;
 
 	if (op != IB_MAD_METHOD_GET)
@@ -242,7 +243,10 @@ static int do_cpi(Port * port, unsigned op, uint32_t mod, uint8_t * data)
 	memset(data, 0, IB_SMP_DATA_SIZE);
 	mad_set_field(data, 0, IB_CPI_BASEVER_F, 1);
 	mad_set_field(data, 0, IB_CPI_CLASSVER_F, 1);
-	mad_set_field(data, 0, IB_CPI_CAPMASK_F, 0x300);
+	if (node->type != SWITCH_NODE)
+		mad_set_field(data, 0, IB_CPI_CAPMASK_F, 0x200);
+	else
+		mad_set_field(data, 0, IB_CPI_CAPMASK_F, 0x300);
 	mad_set_field(data, 0, IB_CPI_RESP_TIME_VALUE_F, 0x12);
 	return status;
 }
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
