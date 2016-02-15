From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/21] staging/rdma/hfi1: Remove blank line before close
 brace
Date: Sun, 14 Feb 2016 20:20:06 -0800
Message-ID: <20160215042003.351.12252.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove extra blank line before close brace to fix checkpatch check:
CHECK: Blank lines aren't necessary before a close brace '}'

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c      |    1 -
 drivers/staging/rdma/hfi1/driver.c    |    1 -
 drivers/staging/rdma/hfi1/intr.c      |    1 -
 drivers/staging/rdma/hfi1/mad.c       |    2 --
 drivers/staging/rdma/hfi1/pcie.c      |    1 -
 drivers/staging/rdma/hfi1/sysfs.c     |    1 -
 drivers/staging/rdma/hfi1/uc.c        |    1 -
 drivers/staging/rdma/hfi1/ud.c        |    2 --
 drivers/staging/rdma/hfi1/user_sdma.c |    2 --
 9 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 05e4f07..51256ba 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13710,7 +13710,6 @@ static void assign_cm_au_table(struct hfi1_devdata *dd, u32 cu,
 			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE6_SHIFT
 		| 64ull * cu <<
 			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE7_SHIFT);
-
 }
 
 static void assign_local_cm_au_table(struct hfi1_devdata *dd, u8 vcu)
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index b5dfdb6..fee5e39 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -762,7 +762,6 @@ static inline void finish_packet(struct hfi1_packet *packet)
 	 */
 	update_usrhead(packet->rcd, packet->rcd->head, packet->updegr,
 		       packet->etail, rcv_intr_dynamic, packet->numpkt);
-
 }
 
 static inline void process_rcv_qp_work(struct hfi1_packet *packet)
diff --git a/drivers/staging/rdma/hfi1/intr.c b/drivers/staging/rdma/hfi1/intr.c
index 9a9b331..685fb4d 100644
--- a/drivers/staging/rdma/hfi1/intr.c
+++ b/drivers/staging/rdma/hfi1/intr.c
@@ -178,7 +178,6 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 		/* notify IB of the link change */
 		signal_ib_event(ppd, ev);
 	}
-
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index a7e5f92..adfd0a9 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -3805,7 +3805,6 @@ static int subn_get_opa_aggregate(struct opa_smp *smp,
 			return reply((struct ib_mad_hdr *)smp);
 		}
 		next_smp += agg_size;
-
 	}
 
 	return reply((struct ib_mad_hdr *)smp);
@@ -3849,7 +3848,6 @@ static int subn_set_opa_aggregate(struct opa_smp *smp,
 			return reply((struct ib_mad_hdr *)smp);
 		}
 		next_smp += agg_size;
-
 	}
 
 	return reply((struct ib_mad_hdr *)smp);
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 0368516..725e282 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -316,7 +316,6 @@ do_intx:
 		   nvec, ret);
 	*msixcnt = 0;
 	hfi1_enable_intx(dd->pcidev);
-
 }
 
 /* return the PCIe link speed from the given link status */
diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/staging/rdma/hfi1/sysfs.c
index 3c34f77..fe232c1 100644
--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -568,7 +568,6 @@ static ssize_t show_serial(struct device *device,
 	struct hfi1_devdata *dd = dd_from_dev(dev);
 
 	return scnprintf(buf, PAGE_SIZE, "%s", dd->serial);
-
 }
 
 static ssize_t store_chip_reset(struct device *device,
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index e58ec15..afdf539 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -604,5 +604,4 @@ drop:
 op_err:
 	hfi1_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 	return;
-
 }
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 5779f3a..c3f0697 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -772,7 +772,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 			mgmt_pkey_idx = hfi1_lookup_pkey_idx(ibp, pkey);
 			if (mgmt_pkey_idx < 0)
 				goto drop;
-
 		}
 		if (unlikely(qkey != qp->qkey)) {
 			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_Q_KEY, qkey,
@@ -810,7 +809,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		mgmt_pkey_idx = hfi1_lookup_pkey_idx(ibp, pkey);
 		if (mgmt_pkey_idx < 0)
 			goto drop;
-
 	}
 
 	if (qp->ibqp.qp_num > 1 &&
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 03a10c8..097d278 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -713,7 +713,6 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 				msecs_to_jiffies(
 					SDMA_IOWAIT_TIMEOUT));
 		}
-
 	}
 	*count += idx;
 	return 0;
@@ -1194,7 +1193,6 @@ static int set_txreq_header(struct user_sdma_request *req,
 		if (ret)
 			return ret;
 		goto done;
-
 	}
 
 	hdr->bth[2] = cpu_to_be32(

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
