From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [Trivial PATCH] infiniband: Remove unnecessary semicolons
Date: Tue, 08 Oct 2013 16:07:22 -0700
Message-ID: <1381273642.23937.7.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These aren't necessary after switch blocks.

Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2_ae.c      | 2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c      | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 6 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 6 +++---
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_ae.c b/drivers/infiniband/hw/amso1100/c2_ae.c
index d5d1929..cedda25 100644
--- a/drivers/infiniband/hw/amso1100/c2_ae.c
+++ b/drivers/infiniband/hw/amso1100/c2_ae.c
@@ -141,7 +141,7 @@ static const char *to_qp_state_str(int state)
 		return "C2_QP_STATE_ERROR";
 	default:
 		return "<invalid QP state>";
-	};
+	}
 }
 
 void c2_ae_event(struct c2_dev *c2dev, u32 mq_index)
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 7c9d35f..6902017 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -357,7 +357,7 @@ static int mthca_eq_int(struct mthca_dev *dev, struct mthca_eq *eq)
 			mthca_warn(dev, "Unhandled event %02x(%02x) on EQ %d\n",
 				   eqe->type, eqe->subtype, eq->eqn);
 			break;
-		};
+		}
 
 		set_eqe_hw(eqe);
 		++eq->cons_index;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 4ed8235..50219ab 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -150,7 +150,7 @@ enum ib_qp_state get_ibqp_state(enum ocrdma_qp_state qps)
 		return IB_QPS_SQE;
 	case OCRDMA_QPS_ERR:
 		return IB_QPS_ERR;
-	};
+	}
 	return IB_QPS_ERR;
 }
 
@@ -171,7 +171,7 @@ static enum ocrdma_qp_state get_ocrdma_qp_state(enum ib_qp_state qps)
 		return OCRDMA_QPS_SQE;
 	case IB_QPS_ERR:
 		return OCRDMA_QPS_ERR;
-	};
+	}
 	return OCRDMA_QPS_ERR;
 }
 
@@ -1982,7 +1982,7 @@ int ocrdma_mbx_create_qp(struct ocrdma_qp *qp, struct ib_qp_init_attr *attrs,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_CREATE_QP, sizeof(*cmd));
 	if (!cmd)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 56e0049..0ce7674 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -531,7 +531,7 @@ static void ocrdma_event_handler(struct ocrdma_dev *dev, u32 event)
 	case BE_DEV_DOWN:
 		ocrdma_close(dev);
 		break;
-	};
+	}
 }
 
 static struct ocrdma_driver ocrdma_drv = {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 6e982bb..69f1d12 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -141,7 +141,7 @@ static inline void get_link_speed_and_width(struct ocrdma_dev *dev,
 		/* Unsupported */
 		*ib_speed = IB_SPEED_SDR;
 		*ib_width = IB_WIDTH_1X;
-	};
+	}
 }
 
 
@@ -2331,7 +2331,7 @@ static enum ib_wc_status ocrdma_to_ibwc_err(u16 status)
 	default:
 		ibwc_status = IB_WC_GENERAL_ERR;
 		break;
-	};
+	}
 	return ibwc_status;
 }
 
@@ -2370,7 +2370,7 @@ static void ocrdma_update_wc(struct ocrdma_qp *qp, struct ib_wc *ibwc,
 		pr_err("%s() invalid opcode received = 0x%x\n",
 		       __func__, hdr->cw & OCRDMA_WQE_OPCODE_MASK);
 		break;
-	};
+	}
 }
 
 static void ocrdma_set_cqe_status_flushed(struct ocrdma_qp *qp,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
