From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 22/27] IB/hfi1: Add receive fault injection feature
Date: Wed, 08 Feb 2017 05:28:01 -0800
Message-ID: <20170208132800.16442.94549.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add fault injection capability:
  - Drop packets unconditionally (fault_by_packet)
  - Drop packets based on opcode (fault_by_opcode)

This feature is disabled by default and can be
enabled using the HFI1_FAULT_INJECTION Kconfig.

The faulting traces have been added:
  - misc/fault_opcode
  - misc/fault_packet

See 'Documentation/fault-injection/fault-injection.txt'
for details.

Examples:
  - Dropping packets by opcode:
    /sys/kernel/debug/hfi1/hfi1_X/fault_opcode
	# Enable fault
	echo Y > fault_by_opcode
	# Setprobability of dropping (0-100%)
	# echo 25 > probability
	# Set opcode
	echo 0x64 > opcode
	# Number of times to fault
	echo 3 > times
	# An optional mask allows you to fault
	# a range of opcodes
	echo 0xf0 > mask
    /sys/kernel/debug/hfi1/hfi1_X/fault_stats
    contains a value in parentheses to indicate
    number of each opcode dropped.

  - Dropping packets unconditionally
    /sys/kernel/debug/hfi1/hfi1_X/fault_packet
	# Enable fault
	echo Y > fault_by_packet
    /sys/kernel/debug/hfi1/hfi1_X/fault_packet/fault_stats
    contains the number of packets dropped.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/Kconfig      |    6 +
 drivers/infiniband/hw/hfi1/debugfs.c    |  222 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/debugfs.h    |   35 +++++
 drivers/infiniband/hw/hfi1/driver.c     |    8 +
 drivers/infiniband/hw/hfi1/trace_misc.h |   48 +++++++
 drivers/infiniband/hw/hfi1/verbs.c      |    6 +
 drivers/infiniband/hw/hfi1/verbs.h      |    4 +
 7 files changed, 329 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
index f6ea088..7465595 100644
--- a/drivers/infiniband/hw/hfi1/Kconfig
+++ b/drivers/infiniband/hw/hfi1/Kconfig
@@ -27,3 +27,9 @@ config SDMA_VERBOSITY
 	---help---
 	This is a configuration flag to enable verbose
 	SDMA debug
+config HFI1_FAULT_INJECTION
+	bool "Fault-injection capability"
+	depends on FAULT_INJECTION && FAULT_INJECTION_DEBUG_FS
+	default n
+	---help---
+	Provide fault-injection capability for HFI1 driver.
diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 8725f4c..b66eb01 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -50,8 +50,12 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/module.h>
+#include <linux/types.h>
+#include <linux/ratelimit.h>
+#include <linux/fault-inject.h>
 
 #include "hfi.h"
+#include "trace.h"
 #include "debugfs.h"
 #include "device.h"
 #include "qp.h"
@@ -1080,6 +1084,217 @@ static int _sdma_cpu_list_seq_show(struct seq_file *s, void *v)
 DEBUGFS_SEQ_FILE_OPEN(sdma_cpu_list)
 DEBUGFS_FILE_OPS(sdma_cpu_list);
 
+#ifdef CONFIG_HFI1_FAULT_INJECTION
+static void *_fault_stats_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct hfi1_opcode_stats_perctx *opstats;
+
+	if (*pos >= ARRAY_SIZE(opstats->stats))
+		return NULL;
+	return pos;
+}
+
+static void *_fault_stats_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct hfi1_opcode_stats_perctx *opstats;
+
+	++*pos;
+	if (*pos >= ARRAY_SIZE(opstats->stats))
+		return NULL;
+	return pos;
+}
+
+static void _fault_stats_seq_stop(struct seq_file *s, void *v)
+{
+}
+
+static int _fault_stats_seq_show(struct seq_file *s, void *v)
+{
+	loff_t *spos = v;
+	loff_t i = *spos, j;
+	u64 n_packets = 0, n_bytes = 0;
+	struct hfi1_ibdev *ibd = (struct hfi1_ibdev *)s->private;
+	struct hfi1_devdata *dd = dd_from_dev(ibd);
+
+	for (j = 0; j < dd->first_user_ctxt; j++) {
+		if (!dd->rcd[j])
+			continue;
+		n_packets += dd->rcd[j]->opstats->stats[i].n_packets;
+		n_bytes += dd->rcd[j]->opstats->stats[i].n_bytes;
+	}
+	if (!n_packets && !n_bytes)
+		return SEQ_SKIP;
+	if (!ibd->fault_opcode->n_rxfaults[i] &&
+	    !ibd->fault_opcode->n_txfaults[i])
+		return SEQ_SKIP;
+	seq_printf(s, "%02llx %llu/%llu (faults rx:%llu faults: tx:%llu)\n", i,
+		   (unsigned long long)n_packets,
+		   (unsigned long long)n_bytes,
+		   (unsigned long long)ibd->fault_opcode->n_rxfaults[i],
+		   (unsigned long long)ibd->fault_opcode->n_txfaults[i]);
+	return 0;
+}
+
+DEBUGFS_SEQ_FILE_OPS(fault_stats);
+DEBUGFS_SEQ_FILE_OPEN(fault_stats);
+DEBUGFS_FILE_OPS(fault_stats);
+
+static void fault_exit_opcode_debugfs(struct hfi1_ibdev *ibd)
+{
+	debugfs_remove_recursive(ibd->fault_opcode->dir);
+	kfree(ibd->fault_opcode);
+	ibd->fault_opcode = NULL;
+}
+
+static int __init fault_init_opcode_debugfs(struct hfi1_ibdev *ibd)
+{
+	struct dentry *parent = ibd->hfi1_ibdev_dbg;
+
+	ibd->fault_opcode = kzalloc(sizeof(*ibd->fault_opcode), GFP_KERNEL);
+	if (!ibd->fault_opcode)
+		return -ENOMEM;
+
+	ibd->fault_opcode->attr.interval = 1;
+	ibd->fault_opcode->attr.require_end = ULONG_MAX;
+	ibd->fault_opcode->attr.stacktrace_depth = 32;
+	ibd->fault_opcode->attr.dname = NULL;
+	ibd->fault_opcode->attr.verbose = 0;
+	ibd->fault_opcode->fault_by_opcode = false;
+	ibd->fault_opcode->opcode = 0;
+	ibd->fault_opcode->mask = 0xff;
+
+	ibd->fault_opcode->dir =
+		fault_create_debugfs_attr("fault_opcode",
+					  parent,
+					  &ibd->fault_opcode->attr);
+	if (IS_ERR(ibd->fault_opcode->dir)) {
+		kfree(ibd->fault_opcode);
+		return -ENOENT;
+	}
+
+	DEBUGFS_SEQ_FILE_CREATE(fault_stats, ibd->fault_opcode->dir, ibd);
+	if (!debugfs_create_bool("fault_by_opcode", 0600,
+				 ibd->fault_opcode->dir,
+				 &ibd->fault_opcode->fault_by_opcode))
+		goto fail;
+	if (!debugfs_create_x8("opcode", 0600, ibd->fault_opcode->dir,
+			       &ibd->fault_opcode->opcode))
+		goto fail;
+	if (!debugfs_create_x8("mask", 0600, ibd->fault_opcode->dir,
+			       &ibd->fault_opcode->mask))
+		goto fail;
+
+	return 0;
+fail:
+	fault_exit_opcode_debugfs(ibd);
+	return -ENOMEM;
+}
+
+static void fault_exit_packet_debugfs(struct hfi1_ibdev *ibd)
+{
+	debugfs_remove_recursive(ibd->fault_packet->dir);
+	kfree(ibd->fault_packet);
+	ibd->fault_packet = NULL;
+}
+
+static int __init fault_init_packet_debugfs(struct hfi1_ibdev *ibd)
+{
+	struct dentry *parent = ibd->hfi1_ibdev_dbg;
+
+	ibd->fault_packet = kzalloc(sizeof(*ibd->fault_packet), GFP_KERNEL);
+	if (!ibd->fault_packet)
+		return -ENOMEM;
+
+	ibd->fault_packet->attr.interval = 1;
+	ibd->fault_packet->attr.require_end = ULONG_MAX;
+	ibd->fault_packet->attr.stacktrace_depth = 32;
+	ibd->fault_packet->attr.dname = NULL;
+	ibd->fault_packet->attr.verbose = 0;
+	ibd->fault_packet->fault_by_packet = false;
+
+	ibd->fault_packet->dir =
+		fault_create_debugfs_attr("fault_packet",
+					  parent,
+					  &ibd->fault_opcode->attr);
+	if (IS_ERR(ibd->fault_packet->dir)) {
+		kfree(ibd->fault_packet);
+		return -ENOENT;
+	}
+
+	if (!debugfs_create_bool("fault_by_packet", 0600,
+				 ibd->fault_packet->dir,
+				 &ibd->fault_packet->fault_by_packet))
+		goto fail;
+	if (!debugfs_create_u64("fault_stats", 0400,
+				ibd->fault_packet->dir,
+				&ibd->fault_packet->n_faults))
+		goto fail;
+
+	return 0;
+fail:
+	fault_exit_packet_debugfs(ibd);
+	return -ENOMEM;
+}
+
+static void fault_exit_debugfs(struct hfi1_ibdev *ibd)
+{
+	fault_exit_opcode_debugfs(ibd);
+	fault_exit_packet_debugfs(ibd);
+}
+
+static int __init fault_init_debugfs(struct hfi1_ibdev *ibd)
+{
+	int ret = 0;
+
+	ret = fault_init_opcode_debugfs(ibd);
+	if (ret)
+		return ret;
+
+	ret = fault_init_packet_debugfs(ibd);
+	if (ret)
+		fault_exit_opcode_debugfs(ibd);
+
+	return ret;
+}
+
+bool hfi1_dbg_fault_opcode(struct rvt_qp *qp, u32 opcode, bool rx)
+{
+	bool ret = false;
+	struct hfi1_ibdev *ibd = to_idev(qp->ibqp.device);
+
+	if (!ibd->fault_opcode || !ibd->fault_opcode->fault_by_opcode)
+		return false;
+	if (ibd->fault_opcode->opcode != (opcode & ibd->fault_opcode->mask))
+		return false;
+	ret = should_fail(&ibd->fault_opcode->attr, 1);
+	if (ret) {
+		trace_hfi1_fault_opcode(qp, opcode);
+		if (rx)
+			ibd->fault_opcode->n_rxfaults[opcode]++;
+		else
+			ibd->fault_opcode->n_txfaults[opcode]++;
+	}
+	return ret;
+}
+
+bool hfi1_dbg_fault_packet(struct hfi1_packet *packet)
+{
+	struct rvt_dev_info *rdi = &packet->rcd->ppd->dd->verbs_dev.rdi;
+	struct hfi1_ibdev *ibd = dev_from_rdi(rdi);
+	bool ret = false;
+
+	if (!ibd->fault_packet || !ibd->fault_packet->fault_by_packet)
+		return false;
+
+	ret = should_fail(&ibd->fault_packet->attr, 1);
+	if (ret) {
+		++ibd->fault_packet->n_faults;
+		trace_hfi1_fault_packet(packet);
+	}
+	return ret;
+}
+#endif
+
 void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 {
 	char name[sizeof("port0counters") + 1];
@@ -1129,12 +1344,19 @@ void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 					    !port_cntr_ops[i].ops.write ?
 					    S_IRUGO : S_IRUGO | S_IWUSR);
 		}
+
+#ifdef CONFIG_HFI1_FAULT_INJECTION
+	fault_init_debugfs(ibd);
+#endif
 }
 
 void hfi1_dbg_ibdev_exit(struct hfi1_ibdev *ibd)
 {
 	if (!hfi1_dbg_root)
 		goto out;
+#ifdef CONFIG_HFI1_FAULT_INJECTION
+	fault_exit_debugfs(ibd);
+#endif
 	debugfs_remove(ibd->hfi1_ibdev_link);
 	debugfs_remove_recursive(ibd->hfi1_ibdev_dbg);
 out:
diff --git a/drivers/infiniband/hw/hfi1/debugfs.h b/drivers/infiniband/hw/hfi1/debugfs.h
index b6fb681..260bf46 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.h
+++ b/drivers/infiniband/hw/hfi1/debugfs.h
@@ -53,6 +53,41 @@
 void hfi1_dbg_ibdev_exit(struct hfi1_ibdev *ibd);
 void hfi1_dbg_init(void);
 void hfi1_dbg_exit(void);
+
+#ifdef CONFIG_HFI1_FAULT_INJECTION
+#include <linux/fault-inject.h>
+struct fault_opcode {
+	struct fault_attr attr;
+	struct dentry *dir;
+	bool fault_by_opcode;
+	u64 n_rxfaults[256];
+	u64 n_txfaults[256];
+	u8 opcode;
+	u8 mask;
+};
+
+struct fault_packet {
+	struct fault_attr attr;
+	struct dentry *dir;
+	bool fault_by_packet;
+	u64 n_faults;
+};
+
+bool hfi1_dbg_fault_opcode(struct rvt_qp *qp, u32 opcode, bool rx);
+bool hfi1_dbg_fault_packet(struct hfi1_packet *packet);
+#else
+static inline bool hfi1_dbg_fault_packet(struct hfi1_packet *packet)
+{
+	return false;
+}
+
+static inline bool hfi1_dbg_fault_opcode(struct rvt_qp *qp,
+					 u32 opcode, bool rx)
+{
+	return false;
+}
+#endif
+
 #else
 static inline void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 {
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 3881c95..c0b012f 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -59,6 +59,7 @@
 #include "trace.h"
 #include "qp.h"
 #include "sdma.h"
+#include "debugfs.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
@@ -1354,6 +1355,9 @@ void handle_eflags(struct hfi1_packet *packet)
  */
 int process_receive_ib(struct hfi1_packet *packet)
 {
+	if (unlikely(hfi1_dbg_fault_packet(packet)))
+		return RHF_RCV_CONTINUE;
+
 	trace_hfi1_rcvhdr(packet->rcd->ppd->dd,
 			  packet->rcd->ctxt,
 			  rhf_err_flags(packet->rhf),
@@ -1409,6 +1413,8 @@ int process_receive_error(struct hfi1_packet *packet)
 
 int kdeth_process_expected(struct hfi1_packet *packet)
 {
+	if (unlikely(hfi1_dbg_fault_packet(packet)))
+		return RHF_RCV_CONTINUE;
 	if (unlikely(rhf_err_flags(packet->rhf)))
 		handle_eflags(packet);
 
@@ -1421,6 +1427,8 @@ int kdeth_process_eager(struct hfi1_packet *packet)
 {
 	if (unlikely(rhf_err_flags(packet->rhf)))
 		handle_eflags(packet);
+	if (unlikely(hfi1_dbg_fault_packet(packet)))
+		return RHF_RCV_CONTINUE;
 
 	dd_dev_err(packet->rcd->dd,
 		   "Unhandled eager packet received. Dropping.\n");
diff --git a/drivers/infiniband/hw/hfi1/trace_misc.h b/drivers/infiniband/hw/hfi1/trace_misc.h
index d308454..372d516 100644
--- a/drivers/infiniband/hw/hfi1/trace_misc.h
+++ b/drivers/infiniband/hw/hfi1/trace_misc.h
@@ -72,6 +72,54 @@
 		      __entry->src)
 );
 
+#ifdef CONFIG_HFI1_FAULT_INJECTION
+TRACE_EVENT(hfi1_fault_opcode,
+	    TP_PROTO(struct rvt_qp *qp, u8 opcode),
+	    TP_ARGS(qp, opcode),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
+			     __field(u32, qpn)
+			     __field(u8, opcode)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+			   __entry->qpn = qp->ibqp.qp_num;
+			   __entry->opcode = opcode;
+			   ),
+	    TP_printk("[%s] qpn 0x%x opcode 0x%x",
+		      __get_str(dev), __entry->qpn, __entry->opcode)
+);
+
+TRACE_EVENT(hfi1_fault_packet,
+	    TP_PROTO(struct hfi1_packet *packet),
+	    TP_ARGS(packet),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(packet->rcd->ppd->dd)
+			     __field(u64, eflags)
+			     __field(u32, ctxt)
+			     __field(u32, hlen)
+			     __field(u32, tlen)
+			     __field(u32, updegr)
+			     __field(u32, etail)
+			     ),
+	     TP_fast_assign(DD_DEV_ASSIGN(packet->rcd->ppd->dd);
+			    __entry->eflags = rhf_err_flags(packet->rhf);
+			    __entry->ctxt = packet->rcd->ctxt;
+			    __entry->hlen = packet->hlen;
+			    __entry->tlen = packet->tlen;
+			    __entry->updegr = packet->updegr;
+			    __entry->etail = rhf_egr_index(packet->rhf);
+			    ),
+	     TP_printk(
+		"[%s] ctxt %d eflags 0x%llx hlen %d tlen %d updegr %d etail %d",
+		__get_str(dev),
+		__entry->ctxt,
+		__entry->eflags,
+		__entry->hlen,
+		__entry->tlen,
+		__entry->updegr,
+		__entry->etail
+		)
+);
+#endif
+
 #endif /* __HFI1_TRACE_MISC_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 72f459e..2f98c8e 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -60,6 +60,7 @@
 #include "trace.h"
 #include "qp.h"
 #include "verbs_txreq.h"
+#include "debugfs.h"
 
 static unsigned int hfi1_lkey_table_size = 16;
 module_param_named(lkey_table_size, hfi1_lkey_table_size, uint,
@@ -583,6 +584,11 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 			rcu_read_unlock();
 			goto drop;
 		}
+		if (unlikely(hfi1_dbg_fault_opcode(packet->qp, opcode,
+						   true))) {
+			rcu_read_unlock();
+			goto drop;
+		}
 		spin_lock_irqsave(&packet->qp->r_lock, flags);
 		packet_handler = qp_ok(opcode, packet);
 		if (likely(packet_handler))
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 3a0b589..4b7fc2d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -195,6 +195,10 @@ struct hfi1_ibdev {
 	struct dentry *hfi1_ibdev_dbg;
 	/* per HFI symlinks to above */
 	struct dentry *hfi1_ibdev_link;
+#ifdef CONFIG_HFI1_FAULT_INJECTION
+	struct fault_opcode *fault_opcode;
+	struct fault_packet *fault_packet;
+#endif
 #endif
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
