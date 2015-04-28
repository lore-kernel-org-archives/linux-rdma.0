From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v7 15/23] IB/Verbs: Use management helper cap_ib_mad()
Date: Tue, 28 Apr 2015 17:10:15 +0200
Message-ID: <1430233823-7075-16-git-send-email-yun.wang@profitbricks.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430233823-7075-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce helper cap_ib_mad() to help us check if the port of an
IB device support Infiniband Management Datagrams.

Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/mad.c      |  6 +++---
 drivers/infiniband/core/user_mad.c |  6 +++---
 include/rdma/ib_verbs.h            | 15 +++++++++++++++
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 507eb67..59459e7 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3066,7 +3066,7 @@ static void ib_mad_init_device(struct ib_device *device)
 	}
 
 	for (i = start; i <= end; i++) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		if (ib_mad_port_open(device, i)) {
@@ -3087,7 +3087,7 @@ error_agent:
 
 error:
 	while (--i >= start) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		if (ib_agent_port_close(device, i))
@@ -3111,7 +3111,7 @@ static void ib_mad_remove_device(struct ib_device *device)
 	}
 
 	for (i = start; i <= end; i++) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		if (ib_agent_port_close(device, i))
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index aa8b334..e3ccbf2 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1294,7 +1294,7 @@ static void ib_umad_add_one(struct ib_device *device)
 	umad_dev->end_port   = e;
 
 	for (i = s; i <= e; ++i) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		umad_dev->port[i - s].umad_dev = umad_dev;
@@ -1315,7 +1315,7 @@ static void ib_umad_add_one(struct ib_device *device)
 
 err:
 	while (--i >= s) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		ib_umad_kill_port(&umad_dev->port[i - s]);
@@ -1333,7 +1333,7 @@ static void ib_umad_remove_one(struct ib_device *device)
 		return;
 
 	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i) {
-		if (rdma_ib_or_iboe(device, i))
+		if (cap_ib_mad(device, i))
 			ib_umad_kill_port(&umad_dev->port[i]);
 	}
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index acdba60..cb3ba2d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1774,6 +1774,21 @@ static inline int rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
 	return (pt == RDMA_PROTOCOL_IB || pt == RDMA_PROTOCOL_IBOE);
 }
 
+/**
+ * cap_ib_mad - Check if the port of device has the capability Infiniband
+ * Management Datagrams.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support Infiniband
+ * Management Datagrams.
+ */
+static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
+{
+	return rdma_ib_or_iboe(device, port_num);
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
