Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873192;
	b=SpaJCPw55jDcOF+YMjWyoAzeZMA63sieDXGmpHNvV9B8M8A7QRX2fZ9iLwZU7GWPmamS
	 P8dF0IBPbHTyLRijUfg8GAs1QdmnMjNdB/F2k82WzLUp6ynuScVTwUusm1duykqRM1+6i
	 8k++Xc7kQcTfxVPqGBQJakumGJWQzHWViiO/NCK/QjEs6jJAZfE6vakIiZnximgQ1T/Gs
	 xP/XDESgL7IsYQsnoI97/+7zNZv9TLAkKeG01mQo7QC53fX38cmW0gY1sgbVV1H0lo7DZ
	 uJtuV3kLsFXdxx5QsNbsWo8M+eZSTwvcYwOSq+htS7zde6HiVvPtGDeEP91wwo+nKmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=OeLLpMFGCS2suxbq7XM8vS9gKtc3pdn/2Uzfvpj8zPo=;
	b=iY5XcNPvQ3AixqokAUyXyL6/np2GRwJ17Fc1fBrJ5y0SgG1ZhPoU2vU1sAX2vo5BvgjT
	 MrSvcGZ19BJRWC+1PpJVkU6IOA6IkDyAcTlQAtigw+RpKUITpPQj0+c0fcdqv6LwgCDSm
	 u2mGgsH4DPqxHXAnz+b7SRTBynmcs9hLKmRNjeaE2gEXyF3ibwOfNw/R9sFW68RBaG4HH
	 iLQ3N7JtommiUMdWf0vqrEFjfIyp9Q4TGC59x4FijvBGtxdfIkNr0DS0a32fRaNUTnn0H
	 jPbSzr4AWal0PrwGYyjPY42dczjhbVbexg7gyHxzlHNhVTfTRoOvUL742pCy5r7Xb+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gA8GUWPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871EA606D81C;
	Thu,  5 Nov 2026 10:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gA8GUWPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851A61F00A02;
	Thu,  5 Nov 2026 10:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873192;
	bh=OeLLpMFGCS2suxbq7XM8vS9gKtc3pdn/2Uzfvpj8zPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gA8GUWPE5RXNJVKZSljcRvywhr8tF++LRgs8OP8NIYRYEMOclCNm/RlXoHXXLouLr
	 8E+sSddohnAJ4LED7vV2Ef3OACHiYx8SAtrXnQo6pB8b4hugG7pOimwFd/Qc9SP0lb
	 v3L+QJQ1W2ie32lIUET2P619E33ZMxPKx/R5IicaK4R98E4jMIIDaCk4PbUP1yXrso
	 p/WAoMDZSPBHJDREt1HRRpH+OY6qPwpAYwFQzewbgI3a0ceBVKnuniUfcg3r3y3VS8
	 xh77AKS99OJMRzr8AiivAwMgnxfLQUZIK0CYFyXa62p1sVhIZt4ApvdATLSmNihGSi
	 NKI4iGGGM7nUw==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v13 13/19] PCI/P2PDMA: Add KUnit tests for the ACS routing decisions
Date: Thu,  5 Nov 2026 12:04:44 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-13-3dd065907c3b@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

pci_acs_p2pdma_request() and pci_acs_p2pdma_completion() turn an ACS
Control register and a TLP class into a routing decision. Which bits apply
to which direction and which class is easy to get wrong, and hardware that
exposes a given combination may not be at hand.

Drive both from a table of register values and classes, covering the
redirect controls per direction and Translation Blocking, Direct Translated
P2P and Relaxed Ordering. Direct Translated P2P gets a case with and
without a redirect to override, since it changes nothing without one.
Exposing the two helpers moves their state enum and the TLP flags into
pci.h.

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/Kconfig        |  15 ++++++
 drivers/pci/Makefile       |   1 +
 drivers/pci/p2pdma.c       |  38 ++------------
 drivers/pci/pci.h          |  41 +++++++++++++++
 drivers/pci/pci_acs_test.c | 122 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 183 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 0c7408509ba24..7a3eb5beb3281 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -226,6 +226,21 @@ config PCI_P2PDMA
 
 	  If unsure, say N.
 
+config PCI_ACS_KUNIT_TEST
+	tristate "KUnit tests for PCI ACS P2P routing" if !KUNIT_ALL_TESTS
+	depends on PCI_P2PDMA && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable KUnit tests for the PCI ACS peer-to-peer routing decision
+	  logic, including direction-specific Request and Completion
+	  controls that cannot all be exercised on typical peer-to-peer
+	  hardware.
+
+	  For more information on KUnit and unit tests in general, refer to
+	  the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config PCI_LABEL
 	def_bool y if (DMI || ACPI)
 	select NLS
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 41ebc3b9a5182..6305d128d3dff 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_PCI_STUB)		+= pci-stub.o
 obj-$(CONFIG_PCI_PF_STUB)	+= pci-pf-stub.o
 obj-$(CONFIG_PCI_ECAM)		+= ecam.o
 obj-$(CONFIG_PCI_P2PDMA)	+= p2pdma.o
+obj-$(CONFIG_PCI_ACS_KUNIT_TEST) += pci_acs_test.o
 obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
 obj-$(CONFIG_VGA_ARB)		+= vgaarb.o
 obj-$(CONFIG_PCI_DOE)		+= doe.o
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 1f00371d9f757..c8e08f0f13d70 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -530,38 +530,6 @@ static u16 pci_acs_p2pdma_quirk_redirect(struct pci_dev *pdev, u16 ctrl)
 	return ctrl;
 }
 
-/**
- * enum pci_p2pdma_tlp_flags - Properties of the TLPs a client will issue
- *
- * These describe the traffic rather than the topology, and select which ACS
- * controls apply along the peer-to-peer path. A value of 0 means strictly
- * ordered Requests carrying an Untranslated address.
- *
- * @PCI_P2PDMA_TLP_TRANSLATED: Requests carry an ATS Translated address. PCIe
- *	r7.0 sec 6.12.3 routes those to the peer regardless of ACS P2P Request
- *	Redirect and ACS P2P Egress Control wherever ACS Direct Translated P2P
- *	is enabled.
- * @PCI_P2PDMA_TLP_RELAXED_CPL: Non-Posted Requests carry the Relaxed
- *	Ordering attribute, and PCIe r7.0 sec 2.2.9.1 requires the Completer to
- *	return it in their Completions. Sec 6.12.1.1 never redirects those, so
- *	ACS P2P Completion Redirect does not gate the path.
- */
-enum pci_p2pdma_tlp_flags {
-	PCI_P2PDMA_TLP_TRANSLATED	= 1 << 0,
-	PCI_P2PDMA_TLP_RELAXED_CPL	= 1 << 1,
-};
-
-/* Every combination of the flags above selects one routing class. */
-#define PCI_P2PDMA_TLP_CLASSES \
-	((PCI_P2PDMA_TLP_TRANSLATED | PCI_P2PDMA_TLP_RELAXED_CPL) + 1)
-
-enum pci_acs_p2pdma_state {
-	PCI_ACS_P2PDMA_NOT_SUPPORTED,
-	PCI_ACS_P2PDMA_DIRECT,
-	PCI_ACS_P2PDMA_REDIRECT,
-	PCI_ACS_P2PDMA_BLOCKED,
-};
-
 /*
  * Decide how a peer-to-peer Request at an ACS-capable ingress port routes,
  * from that port's ACS Control register and the Request's Address Type.
@@ -571,7 +539,7 @@ enum pci_acs_p2pdma_state {
  * selects are a direct route and an ACS Violation, and neither one lets peer
  * bus addressing be assumed.
  */
-static enum pci_acs_p2pdma_state
+VISIBLE_IF_KUNIT enum pci_acs_p2pdma_state
 pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 {
 	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED) {
@@ -598,6 +566,7 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
 		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_acs_p2pdma_request);
 
 /*
  * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
@@ -605,7 +574,7 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
  * affects a Completion, and that one leaves Completions carrying the Relaxed
  * Ordering attribute alone.
  */
-static enum pci_acs_p2pdma_state
+VISIBLE_IF_KUNIT enum pci_acs_p2pdma_state
 pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 {
 	if (tlp_flags & PCI_P2PDMA_TLP_RELAXED_CPL)
@@ -614,6 +583,7 @@ pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
 				   PCI_ACS_P2PDMA_DIRECT;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_acs_p2pdma_completion);
 
 static const char *pci_acs_p2pdma_state_name(enum pci_acs_p2pdma_state state)
 {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index f800308d198f6..363383dcc4e4a 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -2,6 +2,7 @@
 #ifndef DRIVERS_PCI_H
 #define DRIVERS_PCI_H
 
+#include <kunit/visibility.h>
 #include <linux/bug.h>
 #include <linux/align.h>
 #include <linux/bitfield.h>
@@ -1099,6 +1100,46 @@ resource_size_t pci_min_window_alignment(struct pci_bus *bus,
 
 void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
+
+/**
+ * enum pci_p2pdma_tlp_flags - Properties of the TLPs a client will issue
+ *
+ * These describe the traffic rather than the topology, and select which ACS
+ * controls apply along the peer-to-peer path. A value of 0 means strictly
+ * ordered Requests carrying an Untranslated address.
+ *
+ * @PCI_P2PDMA_TLP_TRANSLATED: Requests carry an ATS Translated address. PCIe
+ *	r7.0 sec 6.12.3 routes those to the peer regardless of ACS P2P Request
+ *	Redirect and ACS P2P Egress Control wherever ACS Direct Translated P2P
+ *	is enabled.
+ * @PCI_P2PDMA_TLP_RELAXED_CPL: Non-Posted Requests carry the Relaxed
+ *	Ordering attribute, and PCIe r7.0 sec 2.2.9.1 requires the Completer to
+ *	return it in their Completions. Sec 6.12.1.1 never redirects those, so
+ *	ACS P2P Completion Redirect does not gate the path.
+ */
+enum pci_p2pdma_tlp_flags {
+	PCI_P2PDMA_TLP_TRANSLATED	= 1 << 0,
+	PCI_P2PDMA_TLP_RELAXED_CPL	= 1 << 1,
+};
+
+/* Every combination of the flags above selects one routing class. */
+#define PCI_P2PDMA_TLP_CLASSES \
+	((PCI_P2PDMA_TLP_TRANSLATED | PCI_P2PDMA_TLP_RELAXED_CPL) + 1)
+
+enum pci_acs_p2pdma_state {
+	PCI_ACS_P2PDMA_NOT_SUPPORTED,
+	PCI_ACS_P2PDMA_DIRECT,
+	PCI_ACS_P2PDMA_REDIRECT,
+	PCI_ACS_P2PDMA_BLOCKED,
+};
+
+#if IS_ENABLED(CONFIG_KUNIT)
+enum pci_acs_p2pdma_state pci_acs_p2pdma_request(u16 ctrl,
+						unsigned int tlp_flags);
+enum pci_acs_p2pdma_state pci_acs_p2pdma_completion(u16 ctrl,
+						    unsigned int tlp_flags);
+#endif
+
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_read_acs_ctrl(struct pci_dev *dev, u16 *ctrl);
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
new file mode 100644
index 0000000000000..18bcc4b8e7582
--- /dev/null
+++ b/drivers/pci/pci_acs_test.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for PCI ACS peer-to-peer routing decisions.
+ *
+ * These exercise Request and Completion routing independently of the ACS
+ * settings exposed by available PCIe hardware.
+ */
+#include <kunit/test.h>
+
+#include <linux/pci.h>
+#include <linux/pci-p2pdma.h>
+#include <linux/pci_regs.h>
+
+#include "pci.h"
+
+struct acs_decision_case {
+	const char *desc;
+	u16 ctrl;
+	unsigned int tlp_flags;
+	enum pci_acs_p2pdma_state expect;
+};
+
+/* Shorthands to keep the tables below readable. */
+#define ACS_DIRECT	PCI_ACS_P2PDMA_DIRECT
+#define ACS_REDIR	PCI_ACS_P2PDMA_REDIRECT
+#define ACS_RO		PCI_P2PDMA_TLP_RELAXED_CPL
+#define ACS_AT		PCI_P2PDMA_TLP_TRANSLATED
+#define ACS_BLOCK	PCI_ACS_P2PDMA_BLOCKED
+
+/* Request routing ignores Completion Redirect. */
+static const struct acs_decision_case acs_request_cases[] = {
+	{ "req/none", 0, 0, ACS_DIRECT },
+	{ "req/rr", PCI_ACS_RR, 0, ACS_REDIR },
+	{ "req/cr", PCI_ACS_CR, 0, ACS_DIRECT },
+	{ "req/rr_cr", PCI_ACS_RR | PCI_ACS_CR, 0, ACS_REDIR },
+	{ "req/ec", PCI_ACS_EC, 0, ACS_REDIR },
+	{ "req/ec_cr", PCI_ACS_EC | PCI_ACS_CR, 0, ACS_REDIR },
+
+	/*
+	 * Direct Translated P2P overrides the redirect controls, but only for
+	 * a Request that actually carries a Translated address.
+	 */
+	{ "req/dt", PCI_ACS_DT, 0, ACS_DIRECT },
+	{ "req/dt_rr", PCI_ACS_DT | PCI_ACS_RR, 0, ACS_REDIR },
+	{ "req/at", 0, ACS_AT, ACS_DIRECT },
+	{ "req/at_rr", PCI_ACS_RR, ACS_AT, ACS_REDIR },
+	{ "req/at_dt", PCI_ACS_DT, ACS_AT, ACS_DIRECT },
+	{ "req/at_dt_rr", PCI_ACS_DT | PCI_ACS_RR, ACS_AT, ACS_DIRECT },
+	{ "req/at_dt_ec", PCI_ACS_DT | PCI_ACS_EC, ACS_AT, ACS_DIRECT },
+
+	/*
+	 * Translation Blocking rejects a Translated address outright, and
+	 * makes the port ignore Direct Translated P2P.
+	 */
+	{ "req/tb", PCI_ACS_TB, 0, ACS_DIRECT },
+	{ "req/tb_rr", PCI_ACS_TB | PCI_ACS_RR, 0, ACS_REDIR },
+	{ "req/at_tb", PCI_ACS_TB, ACS_AT, ACS_BLOCK },
+	{ "req/at_tb_dt", PCI_ACS_TB | PCI_ACS_DT, ACS_AT, ACS_BLOCK },
+};
+
+/* Completion routing depends only on Completion Redirect. */
+static const struct acs_decision_case acs_completion_cases[] = {
+	{ "cpl/none", 0, 0, ACS_DIRECT },
+	{ "cpl/rr", PCI_ACS_RR, 0, ACS_DIRECT },
+	{ "cpl/cr", PCI_ACS_CR, 0, ACS_REDIR },
+	{ "cpl/rr_cr", PCI_ACS_RR | PCI_ACS_CR, 0, ACS_REDIR },
+	{ "cpl/ec", PCI_ACS_EC, 0, ACS_DIRECT },
+	{ "cpl/ec_cr", PCI_ACS_EC | PCI_ACS_CR, 0, ACS_REDIR },
+
+	/* Relaxed Ordering Completions are never redirected. */
+	{ "cpl/ro", 0, ACS_RO, ACS_DIRECT },
+	{ "cpl/ro_cr", PCI_ACS_CR, ACS_RO, ACS_DIRECT },
+	{ "cpl/ro_rr_cr", PCI_ACS_RR | PCI_ACS_CR, ACS_RO, ACS_DIRECT },
+};
+
+#undef ACS_DIRECT
+#undef ACS_REDIR
+#undef ACS_RO
+#undef ACS_AT
+#undef ACS_BLOCK
+
+static void acs_decision_desc(const struct acs_decision_case *c, char *desc)
+{
+	strscpy(desc, c->desc, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(acs_request, acs_request_cases, acs_decision_desc);
+KUNIT_ARRAY_PARAM(acs_completion, acs_completion_cases, acs_decision_desc);
+
+static void pci_acs_p2pdma_request_test(struct kunit *test)
+{
+	const struct acs_decision_case *c = test->param_value;
+
+	KUNIT_EXPECT_EQ(test, pci_acs_p2pdma_request(c->ctrl, c->tlp_flags),
+			c->expect);
+}
+
+static void pci_acs_p2pdma_completion_test(struct kunit *test)
+{
+	const struct acs_decision_case *c = test->param_value;
+
+	KUNIT_EXPECT_EQ(test, pci_acs_p2pdma_completion(c->ctrl, c->tlp_flags),
+			c->expect);
+}
+
+static struct kunit_case pci_acs_test_cases[] = {
+	KUNIT_CASE_PARAM(pci_acs_p2pdma_request_test,
+			 acs_request_gen_params),
+	KUNIT_CASE_PARAM(pci_acs_p2pdma_completion_test,
+			 acs_completion_gen_params),
+	{}
+};
+
+static struct kunit_suite pci_acs_test_suite = {
+	.name = "pci_acs",
+	.test_cases = pci_acs_test_cases,
+};
+kunit_test_suite(pci_acs_test_suite);
+
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit tests for PCI ACS peer-to-peer routing decisions");

-- 
2.56.0

