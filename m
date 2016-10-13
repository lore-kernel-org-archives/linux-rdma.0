From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/32] libibumad: mark symbols as static where possible
Date: Thu, 13 Oct 2016 19:51:07 +0200
Message-ID: <1476381095-20041-5-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 libibumad/tests/umad_reg2_compat.c | 10 +++++-----
 libibumad/tests/umad_register2.c   | 12 ++++++------
 libibumad/umad.c                   |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/libibumad/tests/umad_reg2_compat.c b/libibumad/tests/umad_reg2_compat.c
index 264882c..9224372 100644
--- a/libibumad/tests/umad_reg2_compat.c
+++ b/libibumad/tests/umad_reg2_compat.c
@@ -42,7 +42,7 @@
 #define UNLIKELY_MGMT_CLASS 0x2F
 #define UNLIKELY_RMPP_MGMT_CLASS 0x4F
 
-int test_failures = 0;
+static int test_failures = 0;
 
 /** =========================================================================
  * Stolen from OpenSM's register
@@ -69,7 +69,7 @@ static void set_bit64(int b, uint64_t *buf)
 	*addr |= mask;
 }
 
-void dump_reg_attr(struct umad_reg_attr *reg_attr)
+static void dump_reg_attr(struct umad_reg_attr *reg_attr)
 {
 	printf("\nmgmt_class %u\n"
 		"mgmt_class_version %u\n"
@@ -85,7 +85,7 @@ void dump_reg_attr(struct umad_reg_attr *reg_attr)
 	      reg_attr->rmpp_version);
 }
 
-int open_test_device(void)
+static int open_test_device(void)
 {
 	int fd = umad_open_port(NULL, 0);
 	if (fd < 0) {
@@ -96,7 +96,7 @@ int open_test_device(void)
 	return fd;
 }
 
-void test_register(void)
+static void test_register(void)
 {
 	int agent_id;
 	long method_mask[16 / sizeof(long)];
@@ -147,7 +147,7 @@ void test_register(void)
 }
 
 
-void test_fall_back(void)
+static void test_fall_back(void)
 {
 	int rc = 0;
 	struct umad_reg_attr reg_attr;
diff --git a/libibumad/tests/umad_register2.c b/libibumad/tests/umad_register2.c
index 7a9b655..477bd29 100644
--- a/libibumad/tests/umad_register2.c
+++ b/libibumad/tests/umad_register2.c
@@ -57,9 +57,9 @@ struct ib_user_mad_reg_req2 {
 	uint8_t  reserved[3];
 };
 
-int test_failures = 0;
+static int test_failures = 0;
 
-void dump_reg_attr(struct umad_reg_attr *reg_attr)
+static void dump_reg_attr(struct umad_reg_attr *reg_attr)
 {
 	printf("\nmgmt_class %u\n"
 		"mgmt_class_version %u\n"
@@ -75,7 +75,7 @@ void dump_reg_attr(struct umad_reg_attr *reg_attr)
 	      reg_attr->rmpp_version);
 }
 
-int open_test_device(void)
+static int open_test_device(void)
 {
 	int fd = umad_open_port(NULL, 0);
 	if (fd < 0) {
@@ -86,7 +86,7 @@ int open_test_device(void)
 	return fd;
 }
 
-void test_fail(void)
+static void test_fail(void)
 {
 	int rc = 0;
 	struct umad_reg_attr reg_attr;
@@ -194,7 +194,7 @@ out:
 	printf("\n *****\nEnd invalid tests\n");
 }
 
-void test_oui(void)
+static void test_oui(void)
 {
 	int rc = 0;
 	struct umad_reg_attr reg_attr;
@@ -251,7 +251,7 @@ out:
 	printf("\n End valid oui tests\n *****\n");
 }
 
-void check_register2_support(void)
+static void check_register2_support(void)
 {
 	struct ib_user_mad_reg_req2 req;
 	int fd;
diff --git a/libibumad/umad.c b/libibumad/umad.c
index c1b7338..1ac2948 100644
--- a/libibumad/umad.c
+++ b/libibumad/umad.c
@@ -83,7 +83,7 @@ struct ib_user_mad_reg_req2 {
 #define TRACE	if (umaddebug)	IBWARN
 #define DEBUG	if (umaddebug)	IBWARN
 
-int umaddebug = 0;
+static int umaddebug = 0;
 
 #define UMAD_DEV_FILE_SZ	256
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
