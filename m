From: Martin Kletzander <mkletzan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] staging: rdma: Fix braces around if/else
Date: Sat,  3 Oct 2015 22:55:49 +0200
Message-ID: <1b3a2e933e163bf11a2163c76bedd074551c1b9a.1443901389.git.mkletzan@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Get rid of all ELSE_AFTER_BRACE type errors reported by checkpatch.pl.

Signed-off-by: Martin Kletzander <mkletzan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
There is one warning reported in this patch though.  That's because of
the multiline string and it's pre-existing.  Feel free to let me know
if that should be fixed too, I'd also remove the pointless '#' then.
On the other hand, it'll create more-than-80-columns long line.

 drivers/staging/rdma/ipath/ipath_driver.c    | 19 ++++++++-----------
 drivers/staging/rdma/ipath/ipath_file_ops.c  | 12 ++++++------
 drivers/staging/rdma/ipath/ipath_iba6110.c   |  7 +++----
 drivers/staging/rdma/ipath/ipath_init_chip.c | 10 +++++-----
 drivers/staging/rdma/ipath/ipath_intr.c      |  7 +++----
 drivers/staging/rdma/ipath/ipath_sysfs.c     |  7 +++----
 drivers/staging/rdma/ipath/ipath_verbs.c     |  4 ++--
 7 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_driver.c b/drivers/staging/rdma/ipath/ipath_driver.c
index 871dbe56216a..46d98980d66a 100644
--- a/drivers/staging/rdma/ipath/ipath_driver.c
+++ b/drivers/staging/rdma/ipath/ipath_driver.c
@@ -490,8 +490,7 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				"Unable to set DMA mask for unit %u: %d\n",
 				dd->ipath_unit, ret);
 			goto bail_regions;
-		}
-		else {
+		} else {
 			ipath_dbg("No 64bit DMA mask, used 32 bit mask\n");
 			ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (ret)
@@ -501,8 +500,7 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					dd->ipath_unit, ret);

 		}
-	}
-	else {
+	} else {
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (ret)
 			dev_info(&pdev->dev,
@@ -1229,11 +1227,10 @@ reloop:
 			ipath_cdbg(PKT, "typ %x, opcode %x (eager, "
 				   "qp=%x), len %x; ignored\n",
 				   etype, opcode, qp, tlen);
-		}
-		else if (etype == RCVHQ_RCV_TYPE_EXPECTED)
+		} else if (etype == RCVHQ_RCV_TYPE_EXPECTED) {
 			ipath_dbg("Bug: Expected TID, opcode %x; ignored\n",
 				  be32_to_cpu(hdr->bth[0]) >> 24);
-		else {
+		} else {
 			/*
 			 * error packet, type of error unknown.
 			 * Probably type 3, but we don't know, so don't
@@ -1270,8 +1267,9 @@ reloop:
 				pd->port_seq_cnt = 1;
 			if (seq != pd->port_seq_cnt)
 				last = 1;
-		} else if (l == hdrqtail)
+		} else if (l == hdrqtail) {
 			last = 1;
+		}
 		/*
 		 * update head regs on last packet, and every 16 packets.
 		 * Reduce bus traffic, while still trying to prevent
@@ -1821,15 +1819,14 @@ int ipath_create_rcvhdrq(struct ipath_devdata *dd,
 			   (unsigned long) pd->port_rcvhdrq_phys,
 			   (unsigned long) pd->port_rcvhdrq_size,
 			   pd->port_port);
-	}
-	else
+	} else {
 		ipath_cdbg(VERBOSE, "reuse port %d rcvhdrq @%p %llx phys; "
 			   "hdrtailaddr@%p %llx physical\n",
 			   pd->port_port, pd->port_rcvhdrq,
 			   (unsigned long long) pd->port_rcvhdrq_phys,
 			   pd->port_rcvhdrtail_kvaddr, (unsigned long long)
 			   pd->port_rcvhdrqtailaddr_phys);
-
+	}
 	/* clear for security and sanity on each use */
 	memset(pd->port_rcvhdrq, 0, pd->port_rcvhdrq_size);
 	if (pd->port_rcvhdrtail_kvaddr)
diff --git a/drivers/staging/rdma/ipath/ipath_file_ops.c b/drivers/staging/rdma/ipath/ipath_file_ops.c
index c11f6c58ce53..04fe2dc51fe2 100644
--- a/drivers/staging/rdma/ipath/ipath_file_ops.c
+++ b/drivers/staging/rdma/ipath/ipath_file_ops.c
@@ -825,13 +825,13 @@ static void ipath_clean_part_key(struct ipath_portdata *pd,
 				ipath_stats.sps_pkeys[j] =
 					dd->ipath_pkeys[j] = 0;
 				pchanged++;
+			} else {
+				ipath_cdbg(VERBOSE, "p%u key %x matches #%d, "
+					   "but ref still %d\n", pd->port_port,
+					   pd->port_pkeys[i], j,
+					   atomic_read(&dd->ipath_pkeyrefs[j]));
+				break;
 			}
-			else ipath_cdbg(
-				VERBOSE, "p%u key %x matches #%d, "
-				"but ref still %d\n", pd->port_port,
-				pd->port_pkeys[i], j,
-				atomic_read(&dd->ipath_pkeyrefs[j]));
-			break;
 		}
 		pd->port_pkeys[i] = 0;
 	}
diff --git a/drivers/staging/rdma/ipath/ipath_iba6110.c b/drivers/staging/rdma/ipath/ipath_iba6110.c
index 7cc305488a3d..5f13572a5e24 100644
--- a/drivers/staging/rdma/ipath/ipath_iba6110.c
+++ b/drivers/staging/rdma/ipath/ipath_iba6110.c
@@ -666,9 +666,9 @@ static void ipath_ht_handle_hwerrors(struct ipath_devdata *dd, char *msg,
 		 * other reset is possible.
 		 */
 		dd->ipath_flags &= ~IPATH_INITTED;
-	}
-	else
+	} else {
 		*msg = 0; /* recovered from all of them */
+	}
 	if (*msg)
 		ipath_dev_err(dd, "%s hardware error\n", msg);
 	if (isfatal && !ipath_diag_inuse && dd->ipath_freezemsg)
@@ -1134,8 +1134,7 @@ static void ipath_setup_ht_setextled(struct ipath_devdata *dd,
 			extctl &= ~INFINIPATH_EXTC_LEDGBLERR_OFF;
 		if (lst == INFINIPATH_IBCS_L_STATE_ACTIVE)
 			extctl |= INFINIPATH_EXTC_LEDGBLOK_ON;
-	}
-	else {
+	} else {
 		extctl = dd->ipath_extctrl &
 			~(INFINIPATH_EXTC_LED1PRIPORT_ON |
 			  INFINIPATH_EXTC_LED2PRIPORT_ON);
diff --git a/drivers/staging/rdma/ipath/ipath_init_chip.c b/drivers/staging/rdma/ipath/ipath_init_chip.c
index be2a60e142b0..e95af81ca3ca 100644
--- a/drivers/staging/rdma/ipath/ipath_init_chip.c
+++ b/drivers/staging/rdma/ipath/ipath_init_chip.c
@@ -324,10 +324,10 @@ static int init_chip_first(struct ipath_devdata *dd)
 			  dd->ipath_pio2kbase, dd->ipath_piobcnt4k,
 			  dd->ipath_piosize4k, dd->ipath_pio4kbase,
 			  dd->ipath_4kalign);
+	} else {
+		ipath_dbg("%u 2k piobufs @ %p\n",
+			  dd->ipath_piobcnt2k, dd->ipath_pio2kbase);
 	}
-	else ipath_dbg("%u 2k piobufs @ %p\n",
-		       dd->ipath_piobcnt2k, dd->ipath_pio2kbase);
-
 done:
 	return ret;
 }
@@ -903,9 +903,9 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 		ipath_dev_err(dd, "failed to allocate kernel port's "
 			      "rcvhdrq and/or egr bufs\n");
 		goto done;
-	}
-	else
+	} else {
 		enable_chip(dd, reinit);
+	}

 	/* after enable_chip, so pioavailshadow setup */
 	ipath_chg_pioavailkernel(dd, 0, piobufs, 1);
diff --git a/drivers/staging/rdma/ipath/ipath_intr.c b/drivers/staging/rdma/ipath/ipath_intr.c
index 01ba792791a0..e56897108722 100644
--- a/drivers/staging/rdma/ipath/ipath_intr.c
+++ b/drivers/staging/rdma/ipath/ipath_intr.c
@@ -514,15 +514,14 @@ static unsigned handle_frequent_errors(struct ipath_devdata *dd,
 			*noprint = 1;
 			if (!supp_msgs++)
 				nextmsg_time = nc + HZ * 3;
-		}
-		else if (supp_msgs) {
+		} else if (supp_msgs) {
 			handle_supp_msgs(dd, supp_msgs, msg, msgsz);
 			supp_msgs = 0;
 			nmsgs = 0;
 		}
-	}
-	else if (!nmsgs++ || time_after(nc, nextmsg_time))
+	} else if (!nmsgs++ || time_after(nc, nextmsg_time)) {
 		nextmsg_time = nc + HZ / 2;
+	}

 	return supp_msgs;
 }
diff --git a/drivers/staging/rdma/ipath/ipath_sysfs.c b/drivers/staging/rdma/ipath/ipath_sysfs.c
index 75558f33f1cb..b12b1f6caf59 100644
--- a/drivers/staging/rdma/ipath/ipath_sysfs.c
+++ b/drivers/staging/rdma/ipath/ipath_sysfs.c
@@ -662,8 +662,7 @@ static ssize_t store_enabled(struct device *dev,
 			dd->ipath_flags &= ~IPATH_DISABLED;
 			*dd->ipath_statusp &= ~IPATH_STATUS_ADMIN_DISABLED;
 		}
-	}
-	else if (!(dd->ipath_flags & IPATH_DISABLED)) {
+	} else if (!(dd->ipath_flags & IPATH_DISABLED)) {
 		dev_info(dev, "Disabling unit %d\n", dd->ipath_unit);
 		ipath_shutdown_device(dd);
 		dd->ipath_flags |= IPATH_DISABLED;
@@ -1176,9 +1175,9 @@ int ipath_expose_reset(struct device *dev)
 	if (!exposed) {
 		ret = device_create_file(dev, &dev_attr_reset);
 		exposed = 1;
-	}
-	else
+	} else {
 		ret = 0;
+	}

 	return ret;
 }
diff --git a/drivers/staging/rdma/ipath/ipath_verbs.c b/drivers/staging/rdma/ipath/ipath_verbs.c
index ed2bbc2f7eae..17d9dca65755 100644
--- a/drivers/staging/rdma/ipath/ipath_verbs.c
+++ b/drivers/staging/rdma/ipath/ipath_verbs.c
@@ -739,9 +739,9 @@ static void ipath_ib_timer(struct ipath_ibdev *dev)
 			dev->ipath_spkts = tc - dev->ipath_spkts;
 			dev->ipath_rpkts = td - dev->ipath_rpkts;
 			dev->ipath_xmit_wait = te - dev->ipath_xmit_wait;
-		}
-		else
+		} else {
 			dev->pma_sample_interval--;
+		}
 	}
 	spin_unlock_irqrestore(&dev->pending_lock, flags);

--
2.6.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
