From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] DAPL: Support for Linux on System z in libibverbs library
Date: Thu, 19 Dec 2013 12:53:16 +0100
Message-ID: <1387453998-27416-4-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1387453998-27416-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387453998-27416-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, klaus.wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

s390: Add DAPL support for Linux on System z in libibverbs

Changes required to support the OFED stack on the System z platform. These
changes include:
	* mb, rmb, wmb, and wc_wmb macro definitions for the System z platform;
	* new Infiniband verb command identifier.
The new Infiniband verb command was added to allow data transfer from user
space applications to infiniband devices on System z.


diff -aurp /usr/src/packages/BUILD/libibverbs-1.1.7/include/infiniband/arch.h libibverbs-1.1.7/include/infiniband/arch.h
--- /usr/src/packages/BUILD/libibverbs-1.1.7/include/infiniband/arch.h	2011-02-03 19:36:36.000000000 +0100
+++ libibverbs-1.1.7/include/infiniband/arch.h	2013-12-11 16:46:18.713796712 +0100
@@ -115,6 +115,13 @@ static inline uint64_t ntohll(uint64_t x
 #define wmb()	 mb()
 #define wc_wmb() wmb()
 
+#elif defined(__s390x__)
+
+#define mb()	 asm volatile("" ::: "memory")
+#define rmb()	 mb()
+#define wmb()	 mb()
+#define wc_wmb() wmb()
+
 #else
 
 #warning No architecture specific defines found.  Using generic implementation.
diff -aurp /usr/src/packages/BUILD/libibverbs-1.1.7/include/infiniband/kern-abi.h libibverbs-1.1.7/include/infiniband/kern-abi.h
--- /usr/src/packages/BUILD/libibverbs-1.1.7/include/infiniband/kern-abi.h	2011-12-22 18:50:48.000000000 +0100
+++ libibverbs-1.1.7/include/infiniband/kern-abi.h	2013-12-11 16:46:18.713796712 +0100
@@ -85,7 +85,8 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_KWRITE_MMIO=52
 };
 
 /*
@@ -804,6 +805,7 @@ enum {
 	 * trick opcodes in IBV_INIT_CMD() doesn't break.
 	 */
 	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
+	IB_USER_VERBS_CMD_KWRITE_MMIO_V2 = -1,
 };
 
 struct ibv_destroy_cq_v1 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
