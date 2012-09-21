From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: fix bug with loop ports where SMP queries
 are needed
Date: Fri, 21 Sep 2012 14:18:46 -0700
Message-ID: <20120921141846.c8b845600aeddcbf8765dd4d@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/perfquery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/perfquery.c b/src/perfquery.c
index 605ece9..df8556b 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -659,7 +659,7 @@ static int process_opt(void *context, int ch, char *optarg)
 
 int main(int argc, char **argv)
 {
-	int mgmt_classes[2] = { IB_SA_CLASS, IB_PERFORMANCE_CLASS };
+	int mgmt_classes[3] = { IB_SMI_CLASS, IB_SA_CLASS, IB_PERFORMANCE_CLASS };
 	ib_portid_t portid = { 0 };
 	int mask = 0xffff;
 	uint64_t ext_mask = 0xffffffffffffffffULL;
@@ -758,7 +758,7 @@ int main(int argc, char **argv)
 		mask = ext_mask;
 	}
 
-	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
