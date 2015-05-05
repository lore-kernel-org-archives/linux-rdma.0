From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v8 16/23] IB/Verbs: Use management helper rdma_cap_ib_smi()
Date: Tue,  5 May 2015 14:50:33 +0200
Message-ID: <1430830240-32389-17-git-send-email-yun.wang@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430830240-32389-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce helper rdma_cap_ib_smi() to help us check if the port of an
IB device support Infiniband Subnet Management Interface.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/agent.c |  2 +-
 drivers/infiniband/core/mad.c   |  2 +-
 include/rdma/ib_verbs.h         | 15 +++++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 89d4fbc..a6fc4d6 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -156,7 +156,7 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 		goto error1;
 	}
 
-	if (rdma_protocol_ib(device, port_num)) {
+	if (rdma_cap_ib_smi(device, port_num)) {
 		/* Obtain send only MAD agent for SMI QP */
 		port_priv->agent[0] = ib_register_mad_agent(device, port_num,
 							    IB_QPT_SMI, NULL, 0,
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 80777cd..e9699c9 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2938,7 +2938,7 @@ static int ib_mad_port_open(struct ib_device *device,
 	init_mad_qp(port_priv, &port_priv->qp_info[1]);
 
 	cq_size = mad_sendq_size + mad_recvq_size;
-	has_smi = rdma_protocol_ib(device, port_num);
+	has_smi = rdma_cap_ib_smi(device, port_num);
 	if (has_smi)
 		cq_size *= 2;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 23ba66e..e983e33 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1789,6 +1789,21 @@ static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
 	return rdma_ib_or_iboe(device, port_num);
 }
 
+/**
+ * rdma_cap_ib_smi - Check if the port of device has the capability Infiniband
+ * Subnet Management Interface.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return false when port of the device don't support Infiniband
+ * Subnet Management Interface.
+ */
+static inline bool rdma_cap_ib_smi(struct ib_device *device, u8 port_num)
+{
+	return rdma_protocol_ib(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
