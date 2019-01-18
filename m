From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] IB/hw: remove unneeded semicolon
Date: Fri, 18 Jan 2019 11:09:00 +0800
Message-ID: <20190118030900.14636-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: oulijun@huawei.com, dledford@redhat.com, jgg@ziepe.ca, Michal.Kalderon@cavium.com, Ariel.Elior@cavium.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

remove unneeded semicolon

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |  2 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c    |  2 +-
 drivers/infiniband/hw/qedr/verbs.c         | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 298c6f7..9e630b4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4578,7 +4578,7 @@ static int hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 			dev_err(dev, "Unhandled event %d on EQ %d at idx %u.\n",
 				event_type, eq->eqn, eq->cons_index);
 			break;
-		};
+		}
 
 		eq->event_type = event_type;
 		eq->sub_type = sub_type;
diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 93b16237..0555e5a 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -349,7 +349,7 @@ qedr_iw_event_handler(void *context, struct qed_iwarp_cm_event_params *params)
 	default:
 		DP_NOTICE(dev, "Unknown event received %d\n", params->event);
 		break;
-	};
+	}
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index bdd887e..df22cfb 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2116,7 +2116,7 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 		default:
 			status = -EINVAL;
 			break;
-		};
+		}
 		break;
 	case QED_ROCE_QP_STATE_INIT:
 		switch (new_state) {
@@ -2137,7 +2137,7 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 			/* Invalid state change. */
 			status = -EINVAL;
 			break;
-		};
+		}
 		break;
 	case QED_ROCE_QP_STATE_RTR:
 		/* RTR->XXX */
@@ -2150,7 +2150,7 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 			/* Invalid state change. */
 			status = -EINVAL;
 			break;
-		};
+		}
 		break;
 	case QED_ROCE_QP_STATE_RTS:
 		/* RTS->XXX */
@@ -2163,7 +2163,7 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 			/* Invalid state change. */
 			status = -EINVAL;
 			break;
-		};
+		}
 		break;
 	case QED_ROCE_QP_STATE_SQD:
 		/* SQD->XXX */
@@ -2175,7 +2175,7 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 			/* Invalid state change. */
 			status = -EINVAL;
 			break;
-		};
+		}
 		break;
 	case QED_ROCE_QP_STATE_ERR:
 		/* ERR->XXX */
@@ -2193,12 +2193,12 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 		default:
 			status = -EINVAL;
 			break;
-		};
+		}
 		break;
 	default:
 		status = -EINVAL;
 		break;
-	};
+	}
 
 	return status;
 }
-- 
2.7.0
