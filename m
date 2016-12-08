From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/23] IB/hfi1: Show statistics counters under IB stats
 interface
Date: Wed, 07 Dec 2016 19:32:53 -0800
Message-ID: <20161208033252.21135.29594.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Previously tools like hfi1stats had to access these counters through
debugfs, which often caused permission issue for non-root users. It is
not always acceptable to change the debugfs mounting permission due
to security concerns. When exposed under the IB stats interface, the
counters are universally readable by default.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |  154 ++++++++++++++++++++++++++++++++++++
 1 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index f1dead3..0913258 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1609,6 +1609,154 @@ static void hfi1_get_dev_fw_str(struct ib_device *ibdev, char *str,
 		 dc8051_ver_min(ver));
 }
 
+static const char * const driver_cntr_names[] = {
+	/* must be element 0*/
+	"DRIVER_KernIntr",
+	"DRIVER_ErrorIntr",
+	"DRIVER_Tx_Errs",
+	"DRIVER_Rcv_Errs",
+	"DRIVER_HW_Errs",
+	"DRIVER_NoPIOBufs",
+	"DRIVER_CtxtsOpen",
+	"DRIVER_RcvLen_Errs",
+	"DRIVER_EgrBufFull",
+	"DRIVER_EgrHdrFull"
+};
+
+static const char **dev_cntr_names;
+static const char **port_cntr_names;
+static int num_driver_cntrs = ARRAY_SIZE(driver_cntr_names);
+static int num_dev_cntrs;
+static int num_port_cntrs;
+static int cntr_names_initialized;
+
+/*
+ * Convert a list of names separated by '\n' into an array of NULL terminated
+ * strings. Optionally some entries can be reserved in the array to hold extra
+ * external strings.
+ */
+static int init_cntr_names(const char *names_in,
+			   const int names_len,
+			   int num_extra_names,
+			   int *num_cntrs,
+			   const char ***cntr_names)
+{
+	char *names_out, *p, **q;
+	int i, n;
+
+	n = 0;
+	for (i = 0; i < names_len; i++)
+		if (names_in[i] == '\n')
+			n++;
+
+	names_out = kmalloc((n + num_extra_names) * sizeof(char *) + names_len,
+			    GFP_KERNEL);
+	if (!names_out) {
+		*num_cntrs = 0;
+		*cntr_names = NULL;
+		return -ENOMEM;
+	}
+
+	p = names_out + (n + num_extra_names) * sizeof(char *);
+	memcpy(p, names_in, names_len);
+
+	q = (char **)names_out;
+	for (i = 0; i < n; i++) {
+		q[i] = p;
+		p = strchr(p, '\n');
+		*p++ = '\0';
+	}
+
+	*num_cntrs = n;
+	*cntr_names = (const char **)names_out;
+	return 0;
+}
+
+static struct rdma_hw_stats *alloc_hw_stats(struct ib_device *ibdev,
+					    u8 port_num)
+{
+	int i, err;
+
+	if (!cntr_names_initialized) {
+		struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+
+		err = init_cntr_names(dd->cntrnames,
+				      dd->cntrnameslen,
+				      num_driver_cntrs,
+				      &num_dev_cntrs,
+				      &dev_cntr_names);
+		if (err)
+			return NULL;
+
+		for (i = 0; i < num_driver_cntrs; i++)
+			dev_cntr_names[num_dev_cntrs + i] =
+				driver_cntr_names[i];
+
+		err = init_cntr_names(dd->portcntrnames,
+				      dd->portcntrnameslen,
+				      0,
+				      &num_port_cntrs,
+				      &port_cntr_names);
+		if (err) {
+			kfree(dev_cntr_names);
+			dev_cntr_names = NULL;
+			return NULL;
+		}
+		cntr_names_initialized = 1;
+	}
+
+	if (!port_num)
+		return rdma_alloc_hw_stats_struct(
+				dev_cntr_names,
+				num_dev_cntrs + num_driver_cntrs,
+				RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	else
+		return rdma_alloc_hw_stats_struct(
+				port_cntr_names,
+				num_port_cntrs,
+				RDMA_HW_STATS_DEFAULT_LIFESPAN);
+}
+
+static u64 hfi1_sps_ints(void)
+{
+	unsigned long flags;
+	struct hfi1_devdata *dd;
+	u64 sps_ints = 0;
+
+	spin_lock_irqsave(&hfi1_devs_lock, flags);
+	list_for_each_entry(dd, &hfi1_dev_list, list) {
+		sps_ints += get_all_cpu_total(dd->int_counter);
+	}
+	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
+	return sps_ints;
+}
+
+static int get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
+			u8 port, int index)
+{
+	u64 *values;
+	int count;
+
+	if (!port) {
+		u64 *stats = (u64 *)&hfi1_stats;
+		int i;
+
+		hfi1_read_cntrs(dd_from_ibdev(ibdev), NULL, &values);
+		values[num_dev_cntrs] = hfi1_sps_ints();
+		for (i = 1; i < num_driver_cntrs; i++)
+			values[num_dev_cntrs + i] = stats[i];
+		count = num_dev_cntrs + num_driver_cntrs;
+	} else {
+		struct hfi1_ibport *ibp = to_iport(ibdev, port);
+
+		hfi1_read_portcntrs(ppd_from_ibp(ibp), NULL, &values);
+		count = num_port_cntrs;
+	}
+
+	memcpy(stats->value, values, count * sizeof(u64));
+	return count;
+}
+
 /**
  * hfi1_register_ib_device - register our device with the infiniband core
  * @dd: the device data structure
@@ -1656,6 +1804,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->phys_port_cnt = dd->num_pports;
 	ibdev->dma_device = &dd->pcidev->dev;
 	ibdev->modify_device = modify_device;
+	ibdev->alloc_hw_stats = alloc_hw_stats;
+	ibdev->get_hw_stats = get_hw_stats;
 
 	/* keep process mad in the driver */
 	ibdev->process_mad = hfi1_process_mad;
@@ -1770,6 +1920,10 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 
 	del_timer_sync(&dev->mem_timer);
 	verbs_txreq_exit(dev);
+
+	kfree(dev_cntr_names);
+	kfree(port_cntr_names);
+	cntr_names_initialized = 0;
 }
 
 void hfi1_cnp_rcv(struct hfi1_packet *packet)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
