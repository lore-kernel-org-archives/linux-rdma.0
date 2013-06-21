From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/qib; fix static sparse warnings
Date: Fri, 21 Jun 2013 11:23:09 -0400
Message-ID: <20130621152309.1776.33246.stgit@phlsvslse11.ph.intel.com>
References: <20130621152303.1776.36117.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130621152303.1776.36117.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch corrects the following sparse warnings:

qib_iba7322.c:2746:6: warning: symbol
'qib_irq_notifier_notify' was not declared. Should it be static?
qib_iba7322.c:2762:6: warning: symbol
'qib_irq_notifier_release' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 5f266d0..46ffea0 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2751,7 +2751,7 @@ static void qib_setup_dca(struct qib_devdata *dd)
 		setup_dca_notifier(dd, &cspec->msix_entries[i]);
 }
 
-void qib_irq_notifier_notify(struct irq_affinity_notify *notify,
+static void qib_irq_notifier_notify(struct irq_affinity_notify *notify,
 			     const cpumask_t *mask)
 {
 	struct qib_irq_notify *n =
@@ -2767,7 +2767,7 @@ void qib_irq_notifier_notify(struct irq_affinity_notify *notify,
 	}
 }
 
-void qib_irq_notifier_release(struct kref *ref)
+static void qib_irq_notifier_release(struct kref *ref)
 {
 	struct qib_irq_notify *n =
 		container_of(ref, struct qib_irq_notify, notify.kref);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
