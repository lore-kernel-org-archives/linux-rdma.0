From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/21] staging/rdma/hfi1: Add braces on all arms of statement
Date: Sun, 14 Feb 2016 20:22:00 -0800
Message-ID: <20160215042157.351.36096.stgit@scvm10.sc.intel.com>
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

Add braces on all arms of statements to fix checkpatch check:
CHECK: braces {} should be used on all arms of this statement

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c      |    8 ++++----
 drivers/staging/rdma/hfi1/driver.c    |   16 ++++++++--------
 drivers/staging/rdma/hfi1/file_ops.c  |    9 ++++++---
 drivers/staging/rdma/hfi1/init.c      |    3 ++-
 drivers/staging/rdma/hfi1/mad.c       |   23 ++++++++++++-----------
 drivers/staging/rdma/hfi1/pcie.c      |    3 ++-
 drivers/staging/rdma/hfi1/qp.c        |   13 ++++++++-----
 drivers/staging/rdma/hfi1/rc.c        |   25 ++++++++++++++-----------
 drivers/staging/rdma/hfi1/sdma.c      |    3 ++-
 drivers/staging/rdma/hfi1/twsi.c      |    4 ++--
 drivers/staging/rdma/hfi1/uc.c        |   31 ++++++++++++++++---------------
 drivers/staging/rdma/hfi1/ud.c        |   23 ++++++++++++++---------
 drivers/staging/rdma/hfi1/user_sdma.c |    6 ++++--
 drivers/staging/rdma/hfi1/verbs.c     |   11 ++++++-----
 14 files changed, 100 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index ce61883..0a77465 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13829,9 +13829,9 @@ int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey)
 	int ret = 0;
 	u64 reg;
 
-	if (ctxt < dd->num_rcv_contexts)
+	if (ctxt < dd->num_rcv_contexts) {
 		rcd = dd->rcd[ctxt];
-	else {
+	} else {
 		ret = -EINVAL;
 		goto done;
 	}
@@ -13857,9 +13857,9 @@ int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt)
 	int ret = 0;
 	u64 reg;
 
-	if (ctxt < dd->num_rcv_contexts)
+	if (ctxt < dd->num_rcv_contexts) {
 		rcd = dd->rcd[ctxt];
-	else {
+	} else {
 		ret = -EINVAL;
 		goto done;
 	}
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 50a3b5a..090b701 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -302,9 +302,9 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			goto drop;
 
 		/* Check for GRH */
-		if (lnh == HFI1_LRH_BTH)
+		if (lnh == HFI1_LRH_BTH) {
 			ohdr = &hdr->u.oth;
-		else if (lnh == HFI1_LRH_GRH) {
+		} else if (lnh == HFI1_LRH_GRH) {
 			u32 vtf;
 
 			ohdr = &hdr->u.l.oth;
@@ -314,9 +314,9 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			if ((vtf >> IB_GRH_VERSION_SHIFT) != IB_GRH_VERSION)
 				goto drop;
 			rcv_flags |= HFI1_HAS_GRH;
-		} else
+		} else {
 			goto drop;
-
+		}
 		/* Get the destination QP number. */
 		qp_num = be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
 		if (lid < be16_to_cpu(IB_MULTICAST_LID_BASE)) {
@@ -618,14 +618,14 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 			hfi1_get_msgheader(dd, rhf_addr);
 		lnh = be16_to_cpu(hdr->lrh[0]) & 3;
 
-		if (lnh == HFI1_LRH_BTH)
+		if (lnh == HFI1_LRH_BTH) {
 			ohdr = &hdr->u.oth;
-		else if (lnh == HFI1_LRH_GRH) {
+		} else if (lnh == HFI1_LRH_GRH) {
 			ohdr = &hdr->u.l.oth;
 			grh = &hdr->u.l.grh;
-		} else
+		} else {
 			goto next; /* just in case */
-
+		}
 		bth1 = be32_to_cpu(ohdr->bth[1]);
 		is_ecn = !!(bth1 & (HFI1_FECN_SMASK | HFI1_BECN_SMASK));
 
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 1bd1545..7846f31 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -399,8 +399,9 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 			ret = sc_enable(sc);
 			hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB,
 				     uctxt->ctxt);
-		} else
+		} else {
 			ret = sc_restart(sc);
+		}
 		if (!ret)
 			sc_return_credits(sc);
 		break;
@@ -1409,8 +1410,9 @@ static unsigned int poll_next(struct file *fp,
 		set_bit(HFI1_CTXT_WAITING_RCV, &uctxt->event_flags);
 		hfi1_rcvctrl(dd, HFI1_RCVCTRL_INTRAVAIL_ENB, uctxt->ctxt);
 		pollflag = 0;
-	} else
+	} else {
 		pollflag = POLLIN | POLLRDNORM;
+	}
 	spin_unlock_irq(&dd->uctxt_lock);
 
 	return pollflag;
@@ -1488,8 +1490,9 @@ static int manage_rcvq(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
 		if (uctxt->rcvhdrtail_kvaddr)
 			clear_rcvhdrtail(uctxt);
 		rcvctrl_op = HFI1_RCVCTRL_CTXT_ENB;
-	} else
+	} else {
 		rcvctrl_op = HFI1_RCVCTRL_CTXT_DIS;
+	}
 	hfi1_rcvctrl(dd, rcvctrl_op, uctxt->ctxt);
 	/* always; new head should be equal to new tail; see above */
 bail:
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index a721059..cb75fc7 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1713,8 +1713,9 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 				     rcd->egrbufs.buffers[j].len)) {
 					j++;
 					offset = 0;
-				} else
+				} else {
 					offset += new_size;
+				}
 			}
 			rcd->egrbufs.rcvtid_size = new_size;
 		}
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 7619b75..305b7ae 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -135,15 +135,16 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 			struct ib_ah *ah;
 
 			ah = hfi1_create_qp0_ah(ibp, ibp->rvp.sm_lid);
-			if (IS_ERR(ah))
+			if (IS_ERR(ah)) {
 				ret = PTR_ERR(ah);
-			else {
+			} else {
 				send_buf->ah = ah;
 				ibp->rvp.sm_ah = ibah_to_rvtah(ah);
 				ret = 0;
 			}
-		} else
+		} else {
 			ret = -EINVAL;
+		}
 	} else {
 		send_buf->ah = &ibp->rvp.sm_ah->ibah;
 		ret = 0;
@@ -769,9 +770,9 @@ static int __subn_get_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 			p[i] = cpu_to_be16(q[i]);
 		if (resp_len)
 			*resp_len += size;
-	} else
+	} else {
 		smp->status |= IB_SMP_INVALID_FIELD;
-
+	}
 	return reply((struct ib_mad_hdr *)smp);
 }
 
@@ -977,15 +978,15 @@ static int set_port_states(struct hfi1_pportdata *ppd, struct opa_smp *smp,
 			break;
 		/* FALLTHROUGH */
 	case IB_PORT_DOWN:
-		if (phys_state == IB_PORTPHYSSTATE_NOP)
+		if (phys_state == IB_PORTPHYSSTATE_NOP) {
 			link_state = HLS_DN_DOWNDEF;
-		else if (phys_state == IB_PORTPHYSSTATE_POLLING) {
+		} else if (phys_state == IB_PORTPHYSSTATE_POLLING) {
 			link_state = HLS_DN_POLL;
 			set_link_down_reason(ppd, OPA_LINKDOWN_REASON_FM_BOUNCE,
 					     0, OPA_LINKDOWN_REASON_FM_BOUNCE);
-		} else if (phys_state == IB_PORTPHYSSTATE_DISABLED)
+		} else if (phys_state == IB_PORTPHYSSTATE_DISABLED) {
 			link_state = HLS_DN_DISABLE;
-		else {
+		} else {
 			pr_warn("SubnSet(OPA_PortInfo) invalid physical state 0x%x\n",
 				phys_state);
 			smp->status |= IB_SMP_INVALID_FIELD;
@@ -1193,9 +1194,9 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 			set_link_width_downgrade_enabled(ppd, lwe);
 			call_link_downgrade_policy = 1;
 		}
-	} else
+	} else {
 		smp->status |= IB_SMP_INVALID_FIELD;
-
+	}
 	lse = be16_to_cpu(pi->link_speed.enabled);
 	if (lse) {
 		if (lse & be16_to_cpu(pi->link_speed.supported))
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index cbd61cf..2b0281c 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -123,8 +123,9 @@ int hfi1_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto bail;
 		}
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-	} else
+	} else {
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	}
 	if (ret) {
 		hfi1_early_err(&pdev->dev,
 			       "Unable to set DMA consistent mask: %d\n", ret);
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 50309f6..5b5b294 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -326,12 +326,15 @@ __be32 hfi1_compute_aeth(struct rvt_qp *qp)
 			x = (min + max) / 2;
 			if (credit_table[x] == credits)
 				break;
-			if (credit_table[x] > credits)
+			if (credit_table[x] > credits) {
 				max = x;
-			else if (min == x)
-				break;
-			else
-				min = x;
+			} else {
+				if (min == x) {
+					break;
+				} else {
+					min = x;
+				}
+			}
 		}
 		aeth |= x << HFI1_AETH_CREDIT_SHIFT;
 	}
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 28ff638..70a6e63 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -505,9 +505,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				len = pmtu;
 				break;
 			}
-			if (wqe->wr.opcode == IB_WR_SEND)
+			if (wqe->wr.opcode == IB_WR_SEND) {
 				qp->s_state = OP(SEND_ONLY);
-			else {
+			} else {
 				qp->s_state = OP(SEND_ONLY_WITH_IMMEDIATE);
 				/* Immediate data comes after the BTH */
 				ohdr->u.imm_data = wqe->wr.ex.imm_data;
@@ -542,9 +542,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				len = pmtu;
 				break;
 			}
-			if (wqe->wr.opcode == IB_WR_RDMA_WRITE)
+			if (wqe->wr.opcode == IB_WR_RDMA_WRITE) {
 				qp->s_state = OP(RDMA_WRITE_ONLY);
-			else {
+			} else {
 				qp->s_state =
 					OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE);
 				/* Immediate data comes after RETH */
@@ -672,9 +672,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			middle = HFI1_CAP_IS_KSET(SDMA_AHG);
 			break;
 		}
-		if (wqe->wr.opcode == IB_WR_SEND)
+		if (wqe->wr.opcode == IB_WR_SEND) {
 			qp->s_state = OP(SEND_LAST);
-		else {
+		} else {
 			qp->s_state = OP(SEND_LAST_WITH_IMMEDIATE);
 			/* Immediate data comes after the BTH */
 			ohdr->u.imm_data = wqe->wr.ex.imm_data;
@@ -712,9 +712,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			middle = HFI1_CAP_IS_KSET(SDMA_AHG);
 			break;
 		}
-		if (wqe->wr.opcode == IB_WR_RDMA_WRITE)
+		if (wqe->wr.opcode == IB_WR_RDMA_WRITE) {
 			qp->s_state = OP(RDMA_WRITE_LAST);
-		else {
+		} else {
 			qp->s_state = OP(RDMA_WRITE_LAST_WITH_IMMEDIATE);
 			/* Immediate data comes after the BTH */
 			ohdr->u.imm_data = wqe->wr.ex.imm_data;
@@ -1013,10 +1013,12 @@ static void restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 			hfi1_send_complete(qp, wqe, IB_WC_RETRY_EXC_ERR);
 			rvt_error_qp(qp, IB_WC_WR_FLUSH_ERR);
 			return;
-		} else /* need to handle delayed completion */
+		} else { /* need to handle delayed completion */
 			return;
-	} else
+		}
+	} else {
 		qp->s_retry--;
+	}
 
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
 	if (wqe->wr.opcode == IB_WR_RDMA_READ)
@@ -1612,8 +1614,9 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 
 			val = ((u64)be32_to_cpu(p[0]) << 32) |
 				be32_to_cpu(p[1]);
-		} else
+		} else {
 			val = 0;
+		}
 		if (!do_rc_ack(qp, aeth, psn, opcode, val, rcd) ||
 		    opcode != OP(RDMA_READ_RESPONSE_FIRST))
 			goto ack_done;
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 4880800..d989dee 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -2010,8 +2010,9 @@ static int sdma_check_progress(
 		ret = wait->sleep(sde, wait, tx, seq);
 		if (ret == -EAGAIN)
 			sde->desc_avail = sdma_descq_freecnt(sde);
-	} else
+	} else {
 		ret = -EBUSY;
+	}
 	return ret;
 }
 
diff --git a/drivers/staging/rdma/hfi1/twsi.c b/drivers/staging/rdma/hfi1/twsi.c
index 6c7f198..1cc0748 100644
--- a/drivers/staging/rdma/hfi1/twsi.c
+++ b/drivers/staging/rdma/hfi1/twsi.c
@@ -119,9 +119,9 @@ static void scl_out(struct hfi1_devdata *dd, u32 target, u8 bit)
 	 * Allow for slow slaves by simple
 	 * delay for falling edge, sampling on rise.
 	 */
-	if (!bit)
+	if (!bit) {
 		udelay(2);
-	else {
+	} else {
 		int rise_usec;
 
 		for (rise_usec = SCL_WAIT_USEC; rise_usec > 0; rise_usec -= 2) {
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index e24cb62..81b2dc7 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -139,9 +139,9 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				len = pmtu;
 				break;
 			}
-			if (wqe->wr.opcode == IB_WR_SEND)
+			if (wqe->wr.opcode == IB_WR_SEND) {
 				qp->s_state = OP(SEND_ONLY);
-			else {
+			} else {
 				qp->s_state =
 					OP(SEND_ONLY_WITH_IMMEDIATE);
 				/* Immediate data comes after the BTH */
@@ -168,9 +168,9 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				len = pmtu;
 				break;
 			}
-			if (wqe->wr.opcode == IB_WR_RDMA_WRITE)
+			if (wqe->wr.opcode == IB_WR_RDMA_WRITE) {
 				qp->s_state = OP(RDMA_WRITE_ONLY);
-			else {
+			} else {
 				qp->s_state =
 					OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE);
 				/* Immediate data comes after the RETH */
@@ -199,9 +199,9 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			middle = HFI1_CAP_IS_KSET(SDMA_AHG);
 			break;
 		}
-		if (wqe->wr.opcode == IB_WR_SEND)
+		if (wqe->wr.opcode == IB_WR_SEND) {
 			qp->s_state = OP(SEND_LAST);
-		else {
+		} else {
 			qp->s_state = OP(SEND_LAST_WITH_IMMEDIATE);
 			/* Immediate data comes after the BTH */
 			ohdr->u.imm_data = wqe->wr.ex.imm_data;
@@ -224,9 +224,9 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			middle = HFI1_CAP_IS_KSET(SDMA_AHG);
 			break;
 		}
-		if (wqe->wr.opcode == IB_WR_RDMA_WRITE)
+		if (wqe->wr.opcode == IB_WR_RDMA_WRITE) {
 			qp->s_state = OP(RDMA_WRITE_LAST);
-		else {
+		} else {
 			qp->s_state =
 				OP(RDMA_WRITE_LAST_WITH_IMMEDIATE);
 			/* Immediate data comes after the BTH */
@@ -353,8 +353,9 @@ inv:
 		    qp->r_state == OP(SEND_MIDDLE)) {
 			set_bit(RVT_R_REWIND_SGE, &qp->r_aflags);
 			qp->r_sge.num_sge = 0;
-		} else
+		} else {
 			rvt_put_ss(&qp->r_sge);
+		}
 		qp->r_state = OP(SEND_LAST);
 		switch (opcode) {
 		case OP(SEND_FIRST):
@@ -410,9 +411,9 @@ inv:
 	case OP(SEND_ONLY):
 	case OP(SEND_ONLY_WITH_IMMEDIATE):
 send_first:
-		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
+		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags)) {
 			qp->r_sge = qp->s_rdma_read_sge;
-		else {
+		} else {
 			ret = hfi1_rvt_get_rwqe(qp, 0);
 			if (ret < 0)
 				goto op_err;
@@ -523,9 +524,9 @@ rdma_first:
 			qp->r_sge.sge.length = 0;
 			qp->r_sge.sge.sge_length = 0;
 		}
-		if (opcode == OP(RDMA_WRITE_ONLY))
+		if (opcode == OP(RDMA_WRITE_ONLY)) {
 			goto rdma_last;
-		else if (opcode == OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE)) {
+		} else if (opcode == OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE)) {
 			wc.ex.imm_data = ohdr->u.rc.imm_data;
 			goto rdma_last_imm;
 		}
@@ -555,9 +556,9 @@ rdma_last_imm:
 		tlen -= (hdrsize + pad + 4);
 		if (unlikely(tlen + qp->r_rcv_len != qp->r_len))
 			goto drop;
-		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
+		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags)) {
 			rvt_put_ss(&qp->s_rdma_read_sge);
-		else {
+		} else {
 			ret = hfi1_rvt_get_rwqe(qp, 1);
 			if (ret < 0)
 				goto op_err;
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index ea8f706..65157a4 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -163,9 +163,9 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	/*
 	 * Get the next work request entry to find where to put the data.
 	 */
-	if (qp->r_flags & RVT_R_REUSE_SGE)
+	if (qp->r_flags & RVT_R_REUSE_SGE) {
 		qp->r_flags &= ~RVT_R_REUSE_SGE;
-	else {
+	} else {
 		int ret;
 
 		ret = hfi1_rvt_get_rwqe(qp, 0);
@@ -190,8 +190,9 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		hfi1_copy_sge(&qp->r_sge, &ah_attr->grh,
 			      sizeof(struct ib_grh), 1, 0);
 		wc.wc_flags |= IB_WC_GRH;
-	} else
+	} else {
 		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
+	}
 	ssge.sg_list = swqe->sg_list + 1;
 	ssge.sge = *swqe->sg_list;
 	ssge.num_sge = swqe->wr.num_sge;
@@ -383,8 +384,9 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		qp->s_hdrwords++;
 		ohdr->u.ud.imm_data = wqe->wr.ex.imm_data;
 		bth0 = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE << 24;
-	} else
+	} else {
 		bth0 = IB_OPCODE_UD_SEND_ONLY << 24;
+	}
 	sc5 = ibp->sl_to_sc[ah_attr->sl];
 	lrh0 |= (ah_attr->sl & 0xf) << 4;
 	if (qp->ibqp.qp_type == IB_QPT_SMI) {
@@ -820,8 +822,9 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	} else if (opcode == IB_OPCODE_UD_SEND_ONLY) {
 		wc.ex.imm_data = 0;
 		wc.wc_flags = 0;
-	} else
+	} else {
 		goto drop;
+	}
 
 	/*
 	 * A GRH is expected to precede the data even if not
@@ -832,9 +835,9 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	/*
 	 * Get the next work request entry to find where to put the data.
 	 */
-	if (qp->r_flags & RVT_R_REUSE_SGE)
+	if (qp->r_flags & RVT_R_REUSE_SGE) {
 		qp->r_flags &= ~RVT_R_REUSE_SGE;
-	else {
+	} else {
 		int ret;
 
 		ret = hfi1_rvt_get_rwqe(qp, 0);
@@ -857,8 +860,9 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		hfi1_copy_sge(&qp->r_sge, &hdr->u.l.grh,
 			      sizeof(struct ib_grh), 1, 0);
 		wc.wc_flags |= IB_WC_GRH;
-	} else
+	} else {
 		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
+	}
 	hfi1_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh),
 		      1, 0);
 	rvt_put_ss(&qp->r_sge);
@@ -884,8 +888,9 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 			}
 		}
 		wc.pkey_index = (unsigned)mgmt_pkey_idx;
-	} else
+	} else {
 		wc.pkey_index = 0;
+	}
 
 	wc.slid = be16_to_cpu(hdr->lrh[3]);
 	sc = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index ce94cbc..7287307 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -765,8 +765,9 @@ static inline u32 compute_data_length(struct user_sdma_request *req,
 		 * remaining.
 		 */
 		len = min(len, req->data_len - req->sent);
-	} else
+	} else {
 		len = min(req->data_len - req->sent, (u32)req->info.fragsize);
+	}
 	SDMA_DBG(req, "Data Length = %u", len);
 	return len;
 }
@@ -1337,8 +1338,9 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 								INTR) >> 16);
 			val &= cpu_to_le16(~(1U << 13));
 			AHG_HEADER_SET(req->ahg, diff, 7, 16, 14, val);
-		} else
+		} else {
 			AHG_HEADER_SET(req->ahg, diff, 7, 16, 12, val);
+		}
 	}
 
 	trace_hfi1_sdma_user_header_ahg(pq->dd, pq->ctxt, pq->subctxt,
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 275af19..0e650b4 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -400,9 +400,9 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 
 	/* Check for GRH */
 	lnh = be16_to_cpu(hdr->lrh[0]) & 3;
-	if (lnh == HFI1_LRH_BTH)
+	if (lnh == HFI1_LRH_BTH) {
 		packet->ohdr = &hdr->u.oth;
-	else if (lnh == HFI1_LRH_GRH) {
+	} else if (lnh == HFI1_LRH_GRH) {
 		u32 vtf;
 
 		packet->ohdr = &hdr->u.l.oth;
@@ -412,8 +412,9 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 		if ((vtf >> IB_GRH_VERSION_SHIFT) != IB_GRH_VERSION)
 			goto drop;
 		packet->rcv_flags |= HFI1_HAS_GRH;
-	} else
+	} else {
 		goto drop;
+	}
 
 	trace_input_ibhdr(rcd->dd, hdr);
 
@@ -528,9 +529,9 @@ static void verbs_sdma_complete(
 	struct rvt_qp *qp = tx->qp;
 
 	spin_lock(&qp->s_lock);
-	if (tx->wqe)
+	if (tx->wqe) {
 		hfi1_send_complete(qp, tx->wqe, IB_WC_SUCCESS);
-	else if (qp->ibqp.qp_type == IB_QPT_RC) {
+	} else if (qp->ibqp.qp_type == IB_QPT_RC) {
 		struct hfi1_ib_header *hdr;
 
 		hdr = &tx->phdr.hdr;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
