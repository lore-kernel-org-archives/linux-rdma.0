From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 36/37] librdmacm: check if kernel supports AF_IB
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <393EDF2B00D64E9FB8B6027D854C5EF7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add check during initialization to determine if the kernel
supports AF_IB.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/cma.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index faf4264..66a7643 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -195,6 +195,32 @@ static int check_abi_version(void)
 	return 0;
 }
 
+/*
+ * This function is called holding the mutex lock
+ * cma_dev_cnt must be set before calling this function to
+ * ensure that the lock is not acquired recursively.
+ */
+static void ucma_set_af_ib_support(void)
+{
+	struct rdma_cm_id *id;
+	struct sockaddr_ib sib;
+	int ret;
+
+	ret = rdma_create_id(NULL, &id, NULL, RDMA_PS_IB);
+	if (ret)
+		return;
+
+	memset(&sib, 0, sizeof sib);
+	sib.sib_family = AF_IB;
+	sib.sib_sid = htonll(RDMA_IB_IP_PS_TCP);
+	sib.sib_sid_mask = htonll(RDMA_IB_IP_PS_MASK);
+	af_ib_support = 1;
+	ret = rdma_bind_addr(id, (struct sockaddr *) &sib);
+	af_ib_support = !ret;
+
+	rdma_destroy_id(id);
+}
+
 int ucma_init(void)
 {
 	struct ibv_device **dev_list = NULL;
@@ -263,6 +289,7 @@ int ucma_init(void)
 	if (ib)
 		ucma_ib_init();
 	cma_dev_cnt = dev_cnt;
+	ucma_set_af_ib_support();
 	pthread_mutex_unlock(&mut);
 	ibv_free_device_list(dev_list);
 	return 0;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
