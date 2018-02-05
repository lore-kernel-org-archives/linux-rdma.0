From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH rfc 3/5] irq_poll: wire up irq_am
Date: Tue,  6 Feb 2018 00:03:14 +0200
Message-ID: <20180205220316.30236-4-sagi@grimberg.me>
References: <20180205220316.30236-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205220316.30236-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update online stats for fired event and completions on
each poll cycle.

Also expose am initialization interface. The irqpoll consumer will
initialize the irq-am context of the irq-poll context.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 include/linux/irq_poll.h |  9 +++++++++
 lib/Kconfig              |  1 +
 lib/irq_poll.c           | 30 +++++++++++++++++++++++++++++-
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq_poll.h b/include/linux/irq_poll.h
index 16aaeccb65cb..de3055359fd8 100644
--- a/include/linux/irq_poll.h
+++ b/include/linux/irq_poll.h
@@ -2,14 +2,20 @@
 #ifndef IRQ_POLL_H
 #define IRQ_POLL_H
 
+#include <linux/irq-am.h>
+
 struct irq_poll;
 typedef int (irq_poll_fn)(struct irq_poll *, int);
+typedef int (irq_poll_am_fn)(struct irq_poll *, unsigned short);
 
 struct irq_poll {
 	struct list_head list;
 	unsigned long state;
 	int weight;
 	irq_poll_fn *poll;
+
+	struct irq_am am;
+	irq_poll_am_fn *amfn;
 };
 
 enum {
@@ -23,4 +29,7 @@ extern void irq_poll_complete(struct irq_poll *);
 extern void irq_poll_enable(struct irq_poll *);
 extern void irq_poll_disable(struct irq_poll *);
 
+extern void irq_poll_init_am(struct irq_poll *iop, unsigned int nr_events,
+        unsigned short nr_levels, unsigned short start_level,
+	irq_poll_am_fn *amfn);
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index bbb4c9eea84d..d495b21cd241 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -511,6 +511,7 @@ config IRQ_AM
 
 config IRQ_POLL
 	bool "IRQ polling library"
+	select IRQ_AM
 	help
 	  Helper library to poll interrupt mitigation using polling.
 
diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 86a709954f5a..6bc86a677d8c 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -53,6 +53,7 @@ static void __irq_poll_complete(struct irq_poll *iop)
 	list_del(&iop->list);
 	smp_mb__before_atomic();
 	clear_bit_unlock(IRQ_POLL_F_SCHED, &iop->state);
+	irq_am_add_event(&iop->am);
 }
 
 /**
@@ -106,8 +107,10 @@ static void __latent_entropy irq_poll_softirq(struct softirq_action *h)
 
 		weight = iop->weight;
 		work = 0;
-		if (test_bit(IRQ_POLL_F_SCHED, &iop->state))
+		if (test_bit(IRQ_POLL_F_SCHED, &iop->state)) {
 			work = iop->poll(iop, weight);
+			irq_am_add_comps(&iop->am, work);
+		}
 
 		budget -= work;
 
@@ -144,6 +147,7 @@ static void __latent_entropy irq_poll_softirq(struct softirq_action *h)
  **/
 void irq_poll_disable(struct irq_poll *iop)
 {
+	irq_am_cleanup(&iop->am);
 	set_bit(IRQ_POLL_F_DISABLE, &iop->state);
 	while (test_and_set_bit(IRQ_POLL_F_SCHED, &iop->state))
 		msleep(1);
@@ -185,6 +189,30 @@ void irq_poll_init(struct irq_poll *iop, int weight, irq_poll_fn *poll_fn)
 }
 EXPORT_SYMBOL(irq_poll_init);
 
+static int irq_poll_am(struct irq_am *am, unsigned short level)
+{
+	struct irq_poll *iop = container_of(am, struct irq_poll, am);
+
+	return iop->amfn(iop, level);
+}
+
+/**
+ * irq_poll_init_am - Initialize adaptive moderation parameters on this @iop
+ * @iop:      The parent iopoll structure
+ * @weight:   The default weight (or command completion budget)
+ * @poll_fn:  The handler to invoke
+ *
+ * Description:
+ *     Initialize adaptive moderation for this irq_poll structure.
+ **/
+void irq_poll_init_am(struct irq_poll *iop, unsigned int nr_events,
+        unsigned short nr_levels, unsigned short start_level, irq_poll_am_fn *amfn)
+{
+	iop->amfn = amfn;
+	irq_am_init(&iop->am, nr_events, nr_levels, start_level, irq_poll_am);
+}
+EXPORT_SYMBOL(irq_poll_init_am);
+
 static int irq_poll_cpu_dead(unsigned int cpu)
 {
 	/*
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
