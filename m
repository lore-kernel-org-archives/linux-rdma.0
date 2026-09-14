Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE114446E3;
	Mon, 14 Sep 2026 11:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385016; cv=none; b=M1UbaGEXwEL4PSOClBFpspX+V20qQQvPSE+8kpmRFQA1oiSgVkkUcWR9pQcHu1rnBrIg1SNT8CRlw8hCWDsH4v7609bldU5FiPTg6qqXdM3ZB+UV3WqVeU5QSLRrEET4D3egaQFRQ5HFpWmpOzvQPQHZV15wZ+NSxD1DvKJz+1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385016; c=relaxed/simple;
	bh=AhSwuYq8izIYeDSBz6OCwbM12Cifd8T1NxqOGMNPwsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=prr1gUXplrMRmppfHIHqeHop6WcQIsebEhELZ3zyKlRFqf6ynf4+WBgvwdTi+JQmLazRnkyEMit4VpIqISQz89uNAiIXBeVJ9NMwDxKWYfKXWgAjsDQ+b+NESjkzHAwFi9y68LqTZKSV5S/yxb5qEtvwsaRTinFwz2HiruYeazA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPYDErqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPYDErqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D3F1F00899;
	Mon, 14 Sep 2026 11:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789385014;
	bh=YwVvJhRoi+Lr5LSgnNr8iWhw0NvaGa2ylJrrKFpMPaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPYDErquy8xu5lhRblHc9AofDKWEHpjBQf6PRobDh2x+P10xN/KbU6iw8dQue5sNM
	 zEOs3zN1v+w6fXmTViZptuV7a5VvZb1P1+DlEQAt5vm5NKIUvSOc7QSsXq/zhZOq/y
	 qDwI5HvecmEpsYOLg2lhJ7kWVUs0Gb72UmL/MWvPMZsRkUrxZCDs99mjCuy0dJ5nyE
	 /TGwegrAmTu2IvWT9BnPZ8CmQ7mKWgdDMhOf4kbmaRlkAzWMquyu2gLRRXMLur7KXq
	 9+3GveIkSU6063g4YSdFbzRws6Xme0H0lxiidKYsARuJwzKL65ONG2KqqGS2e48+Eq
	 2OFWOWryScJgw==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v6 13/18] PCI/P2PDMA: Add KUnit tests for the ACS routing decisions
Date: Mon, 14 Sep 2026 14:22:46 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-13-5ef07ec9ef06@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
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
Exposing the two helpers moves their state enum into pci.h.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/Kconfig        |  15 ++++++
 drivers/pci/Makefile       |   1 +
 drivers/pci/p2pdma.c       |  13 ++---
 drivers/pci/pci.h          |  16 ++++++
 drivers/pci/pci_acs_test.c | 121 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 157 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 0c7408509ba2..7a3eb5beb328 100644
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
index 41ebc3b9a518..6305d128d3df 100644
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
index 60bd9ec5f993..955e3b41ec1f 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -515,13 +515,6 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
 	return NULL;
 }
 
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
@@ -531,7 +524,7 @@ enum pci_acs_p2pdma_state {
  * selects are a direct route and an ACS Violation, and neither one lets peer
  * bus addressing be assumed.
  */
-static enum pci_acs_p2pdma_state
+VISIBLE_IF_KUNIT enum pci_acs_p2pdma_state
 pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 {
 	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED) {
@@ -558,6 +551,7 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
 		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_acs_p2pdma_request);
 
 /*
  * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
@@ -565,7 +559,7 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
  * affects a Completion, and that one leaves Completions carrying the Relaxed
  * Ordering attribute alone.
  */
-static enum pci_acs_p2pdma_state
+VISIBLE_IF_KUNIT enum pci_acs_p2pdma_state
 pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 {
 	if (tlp_flags & PCI_P2PDMA_TLP_RELAXED_CPL)
@@ -574,6 +568,7 @@ pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
 				   PCI_ACS_P2PDMA_DIRECT;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_acs_p2pdma_completion);
 
 static const char *pci_acs_p2pdma_state_name(enum pci_acs_p2pdma_state state)
 {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index ba3c3fddddc2..c0d2711d73f9 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -2,6 +2,7 @@
 #ifndef DRIVERS_PCI_H
 #define DRIVERS_PCI_H
 
+#include <kunit/visibility.h>
 #include <linux/bug.h>
 #include <linux/align.h>
 #include <linux/bitfield.h>
@@ -1093,6 +1094,21 @@ resource_size_t pci_min_window_alignment(struct pci_bus *bus,
 
 void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
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
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
new file mode 100644
index 000000000000..ce6b9375da36
--- /dev/null
+++ b/drivers/pci/pci_acs_test.c
@@ -0,0 +1,121 @@
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
2.55.0

