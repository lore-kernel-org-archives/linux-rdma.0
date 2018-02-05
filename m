From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH rfc 1/5] irq-am: Introduce library implementing generic adaptive moderation
Date: Tue,  6 Feb 2018 00:03:12 +0200
Message-ID: <20180205220316.30236-2-sagi@grimberg.me>
References: <20180205220316.30236-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205220316.30236-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

irq-am library helps I/O devices implement interrupt moderation in
an adaptive fashion, based on online stats.

The consumer can initialize an irq-am context with a callback that
performs the device specific moderation programming and also the number
of am (adaptive moderation) levels which are also, abstracted and allows
for device specific tuning.

The irq-am code will sample once every nr_events and will check for significant
change in workload characteristics (completions per second, events per second)
and if it detects one, will perform an am level update(called a step).

The irq-am code  assumes that the am levels are sorted in an increasing order when
the lowest level corresponds to the optimum latency tuning (short time and low
completion-count) and gradually increasing towards the throughput optimum tuning
(longer time and higher completion-count). So there is a trend and tuning direction
tracked by the moderator. When the moderator collects sufficient statistics (also
controlled by the consumer defining nr_events), it compares the current stats with the
previous stats and if a significant changed was observed in the load, the moderator
attempts to increment/decrement its current level (step) and schedules a program
dispatch work.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 include/linux/irq-am.h | 116 +++++++++++++++++++++++++++++++
 lib/Kconfig            |   5 ++
 lib/Makefile           |   1 +
 lib/irq-am.c           | 182 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 304 insertions(+)
 create mode 100644 include/linux/irq-am.h
 create mode 100644 lib/irq-am.c

diff --git a/include/linux/irq-am.h b/include/linux/irq-am.h
new file mode 100644
index 000000000000..5ddd5ca268aa
--- /dev/null
+++ b/include/linux/irq-am.h
@@ -0,0 +1,116 @@
+/*
+ * Adaptive moderation support for I/O devices.
+ * Copyright (c) 2018 Lightbits Labs.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#ifndef _IRQ_AM_H
+#define _IRQ_AM_H
+
+#include <linux/ktime.h>
+#include <linux/workqueue.h>
+
+struct irq_am;
+typedef int (irq_am_fn)(struct irq_am *, unsigned short level);
+
+/*
+ * struct irq_am_sample_stats - sample stats for adpative moderation
+ * @cps:        completions per-second
+ * @eps:        events per-second
+ * @cpe:	completions per event
+ */
+struct irq_am_sample_stats {
+	u32 cps;
+	u32 eps;
+	u32 cpe;
+};
+
+/*
+ * struct irq_am_sample - per-irq interrupt batch sample unit
+ * @time:         current time
+ * @comps:     completions count since last sample
+ * @events:    events count since the last sample
+ */
+struct irq_am_sample {
+	ktime_t	time;
+	u64	comps;
+	u64	events;
+};
+
+/*
+ * enum irq_am_state - adaptive moderation monitor states
+ * @IRQ_AM_START_MEASURING:        collect first sample (start_sample)
+ * @IRQ_AM_MEASURING:              measurement in progress
+ * @IRQ_AM_PROGRAM_MODERATION:     moderatio program scheduled
+ *                                 so we should not react to any stats
+ *                                 from the old moderation profile.
+ */
+enum irq_am_state {
+	IRQ_AM_START_MEASURING,
+	IRQ_AM_MEASURING,
+	IRQ_AM_PROGRAM_MODERATION,
+};
+
+enum irq_am_tune_state {
+	IRQ_AM_GOING_UP,
+	IRQ_AM_GOING_DOWN,
+};
+
+enum irq_am_relative_diff {
+	IRQ_AM_STATS_WORSE,
+	IRQ_AM_STATS_SAME,
+	IRQ_AM_STATS_BETTER,
+};
+
+struct irq_am_stats {
+	u64	events;
+	u64	comps;
+};
+
+/*
+ * struct irq_am - irq adaptive moderation monitor
+ * @state:             adaptive moderation monitor state
+ * @tune_state:        tuning state of the moderation monitor
+ * @am_stats:          overall completions and events counters
+ * @start_sample:      first sample in moderation batch
+ * @prev_stats:        previous stats for trend detection
+ * @nr_events:         number of events between samples
+ * @nr_levels:         number of moderation levels
+ * @curr_level:        current moderation level
+ * @work:              schedule moderation program
+ * @program:           moderation program handler
+ */
+struct irq_am {
+	enum irq_am_state		state;
+	enum irq_am_tune_state		tune_state;
+
+	struct irq_am_stats		am_stats;
+	struct irq_am_sample		start_sample;
+	struct irq_am_sample_stats	prev_stats;
+
+	u16				nr_events;
+	unsigned short			nr_levels;
+	unsigned short			curr_level;
+
+	struct work_struct		work;
+	irq_am_fn			*program;
+};
+
+void irq_am_add_event(struct irq_am *am);
+static inline void irq_am_add_comps(struct irq_am *am, u64 n)
+{
+	am->am_stats.comps += n;
+}
+
+void irq_am_cleanup(struct irq_am *am);
+void irq_am_init(struct irq_am *am, unsigned int nr_events,
+	unsigned short nr_levels, unsigned short start_level, irq_am_fn *fn);
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 4dd5c11366f9..bbb4c9eea84d 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -504,6 +504,11 @@ config DDR
 	  information. This data is useful for drivers handling
 	  DDR SDRAM controllers.
 
+config IRQ_AM
+	bool "IRQ adaptive moderation library"
+	help
+	  Helper library to implement adaptive moderation for I/O devices.
+
 config IRQ_POLL
 	bool "IRQ polling library"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index d11c48ec8ffd..795583a685b9 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -193,6 +193,7 @@ obj-$(CONFIG_SG_SPLIT) += sg_split.o
 obj-$(CONFIG_SG_POOL) += sg_pool.o
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 obj-$(CONFIG_IRQ_POLL) += irq_poll.o
+obj-$(CONFIG_IRQ_AM) += irq-am.o
 
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
diff --git a/lib/irq-am.c b/lib/irq-am.c
new file mode 100644
index 000000000000..ed7befd7a560
--- /dev/null
+++ b/lib/irq-am.c
@@ -0,0 +1,182 @@
+/*
+ * Adaptive moderation support for I/O devices.
+ * Copyright (c) 2018 Lightbits Labs.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/irq-am.h>
+
+static void irq_am_try_step(struct irq_am *am)
+{
+	if (am->tune_state == IRQ_AM_GOING_UP &&
+	    am->curr_level != am->nr_levels - 1) {
+		am->curr_level++;
+	} else if (am->tune_state == IRQ_AM_GOING_DOWN &&
+		   am->curr_level != 0) {
+		am->curr_level--;
+	}
+}
+
+static inline bool irq_am_on_edge(struct irq_am *am)
+{
+	return am->curr_level == 0 || am->curr_level == am->nr_levels - 1;
+}
+
+static void irq_am_turn(struct irq_am *am)
+{
+	am->tune_state = am->tune_state == IRQ_AM_GOING_UP ?
+		IRQ_AM_GOING_DOWN : IRQ_AM_GOING_UP;
+	irq_am_try_step(am);
+}
+
+#define IRQ_AM_SIGNIFICANT_DIFF(val, ref) \
+	(((100 * abs((val) - (ref))) / (ref)) > 20) /* more than 20% difference */
+
+static int irq_am_stats_compare(struct irq_am *am, struct irq_am_sample_stats *curr)
+{
+	struct irq_am_sample_stats *prev = &am->prev_stats;
+
+	/* first stat */
+	if (!prev->cps)
+		return IRQ_AM_STATS_SAME;
+
+	/* more completions per second is better */
+	if (IRQ_AM_SIGNIFICANT_DIFF(curr->cps, prev->cps))
+		return (curr->cps > prev->cps) ? IRQ_AM_STATS_BETTER :
+						 IRQ_AM_STATS_WORSE;
+
+	/* less events per second is better */
+	if (IRQ_AM_SIGNIFICANT_DIFF(curr->eps, prev->eps))
+		return (curr->eps < prev->eps) ? IRQ_AM_STATS_BETTER :
+						 IRQ_AM_STATS_WORSE;
+
+	/*
+	 * we get 1 completion per event, no point in trying to aggregate
+	 * any further, start declining moderation
+	 */
+	if (curr->cpe == 1 && am->curr_level)
+		return am->tune_state == IRQ_AM_GOING_UP ?
+			IRQ_AM_STATS_WORSE : IRQ_AM_STATS_BETTER;
+
+	return IRQ_AM_STATS_SAME;
+}
+
+static bool irq_am_decision(struct irq_am *am,
+		struct irq_am_sample_stats *curr_stats)
+{
+	unsigned short prev_level = am->curr_level;
+	enum irq_am_relative_diff diff;
+	bool changed;
+
+	diff = irq_am_stats_compare(am, curr_stats);
+	switch (diff) {
+	default:
+	case IRQ_AM_STATS_SAME:
+		/* fall through */
+		break;
+	case IRQ_AM_STATS_WORSE:
+		irq_am_turn(am);
+		break;
+	case IRQ_AM_STATS_BETTER:
+		irq_am_try_step(am);
+		break;
+	}
+
+	changed = am->curr_level != prev_level || irq_am_on_edge(am);
+	if (changed || !am->prev_stats.cps)
+		am->prev_stats = *curr_stats;
+
+	return changed;
+}
+
+static void irq_am_sample(struct irq_am *am, struct irq_am_sample *s)
+{
+	s->time = ktime_get();
+	s->events = am->am_stats.events;
+	s->comps = am->am_stats.comps;
+}
+
+static void irq_am_calc_stats(struct irq_am *am, struct irq_am_sample *start,
+		struct irq_am_sample *end,
+		struct irq_am_sample_stats *curr_stats)
+{
+	/* u32 holds up to 71 minutes, should be enough */
+	u32 delta_us = ktime_us_delta(end->time, start->time);
+	u32 ncomps = end->comps - start->comps;
+
+	if (!delta_us)
+		return;
+
+	curr_stats->cps = DIV_ROUND_UP(ncomps * USEC_PER_SEC, delta_us);
+	curr_stats->eps = DIV_ROUND_UP(am->nr_events * USEC_PER_SEC, delta_us);
+	curr_stats->cpe = DIV_ROUND_UP(ncomps, am->nr_events);
+}
+
+void irq_am_add_event(struct irq_am *am)
+{
+	struct irq_am_sample end_sample;
+	struct irq_am_sample_stats curr_stats;
+	u16 nr_events;
+
+	am->am_stats.events++;
+
+	switch (am->state) {
+	case IRQ_AM_MEASURING:
+		nr_events = am->am_stats.events - am->start_sample.events;
+		if (nr_events < am->nr_events)
+			break;
+
+		irq_am_sample(am, &end_sample);
+		irq_am_calc_stats(am, &am->start_sample, &end_sample,
+				    &curr_stats);
+		if (irq_am_decision(am, &curr_stats)) {
+			am->state = IRQ_AM_PROGRAM_MODERATION;
+			schedule_work(&am->work);
+			break;
+		}
+		/* fall through */
+	case IRQ_AM_START_MEASURING:
+		irq_am_sample(am, &am->start_sample);
+		am->state = IRQ_AM_MEASURING;
+		break;
+	case IRQ_AM_PROGRAM_MODERATION:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(irq_am_add_event);
+
+static void irq_am_program_moderation_work(struct work_struct *w)
+{
+	struct irq_am *am = container_of(w, struct irq_am, work);
+
+	WARN_ON_ONCE(am->program(am, am->curr_level));
+	am->state = IRQ_AM_START_MEASURING;
+}
+
+
+void irq_am_cleanup(struct irq_am *am)
+{
+	flush_work(&am->work);
+}
+EXPORT_SYMBOL_GPL(irq_am_cleanup);
+
+void irq_am_init(struct irq_am *am, unsigned int nr_events,
+	unsigned short nr_levels, unsigned short start_level, irq_am_fn *fn)
+{
+	memset(am, 0, sizeof(*am));
+	am->state = IRQ_AM_START_MEASURING;
+	am->tune_state = IRQ_AM_GOING_UP;
+	am->nr_levels = nr_levels;
+	am->nr_events = nr_events;
+	am->curr_level = start_level;
+	am->program = fn;
+	INIT_WORK(&am->work, irq_am_program_moderation_work);
+}
+EXPORT_SYMBOL_GPL(irq_am_init);
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
