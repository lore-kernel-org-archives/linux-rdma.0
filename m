From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/4] IB/core: Remove unused variables in ucm/ucma
Date: Thu, 23 Aug 2012 17:09:02 +0300
Message-ID: <1345730945-1843-2-git-send-email-ogerlitz@mellanox.com>
References: <1345730945-1843-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345730945-1843-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Remove unused wait objects from ucm/ucma events flow.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ucm.c  |    1 -
 drivers/infiniband/core/ucma.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 06f0871..49b15ac 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -397,7 +397,6 @@ static ssize_t ib_ucm_event(struct ib_ucm_file *file,
 	struct ib_ucm_event_get cmd;
 	struct ib_ucm_event *uevent;
 	int result = 0;
-	DEFINE_WAIT(wait);
 
 	if (out_len < sizeof(struct ib_ucm_event_resp))
 		return -ENOSPC;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 055ed59..7972bae 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -310,7 +310,6 @@ static ssize_t ucma_get_event(struct ucma_file *file, const char __user *inbuf,
 	struct rdma_ucm_get_event cmd;
 	struct ucma_event *uevent;
 	int ret = 0;
-	DEFINE_WAIT(wait);
 
 	if (out_len < sizeof uevent->resp)
 		return -ENOSPC;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
