From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 08/15] IB/rxe: Issue warnings once
Date: Tue, 10 Jan 2017 11:15:47 -0800
Message-ID: <20170110191554.17359-9-bart.vanassche@sandisk.com>
References: <20170110191554.17359-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110191554.17359-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is strongly recommended to report kernel warnings once instead
of every time a condition is hit. Hence change WARN_ON() into
WARN_ON_ONCE() / BUILD_BUG_ON() as appropriate.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c   |  6 +++---
 drivers/infiniband/sw/rxe/rxe_resp.c | 11 ++++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index d369f24425f9..e912e5396e8c 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -254,7 +254,7 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 	}
 
 	/* Check operation validity. */
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 8ca3acd327b3..8cf38b253c37 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -123,7 +123,7 @@ static int rxe_mem_alloc(struct rxe_dev *rxe, struct rxe_mem *mem, int num_buf)
 			goto err2;
 	}
 
-	WARN_ON(!is_power_of_2(RXE_BUF_PER_MAP));
+	BUILD_BUG_ON(!is_power_of_2(RXE_BUF_PER_MAP));
 
 	mem->map_shift	= ilog2(RXE_BUF_PER_MAP);
 	mem->map_mask	= RXE_BUF_PER_MAP - 1;
@@ -189,7 +189,7 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe_pd *pd, u64 start,
 		goto err1;
 	}
 
-	WARN_ON(!is_power_of_2(umem->page_size));
+	WARN_ON_ONCE(!is_power_of_2(umem->page_size));
 
 	mem->page_shift		= ilog2(umem->page_size);
 	mem->page_mask		= umem->page_size - 1;
@@ -375,7 +375,7 @@ int rxe_mem_copy(struct rxe_mem *mem, u64 iova, void *addr, int length,
 		return 0;
 	}
 
-	WARN_ON(!mem->map);
+	WARN_ON_ONCE(!mem->map);
 
 	err = mem_check_range(mem, iova, length);
 	if (err) {
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 3435efff8799..6dbd069689fc 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -307,7 +307,7 @@ static enum resp_states check_op_valid(struct rxe_qp *qp,
 		break;
 
 	default:
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		break;
 	}
 
@@ -495,7 +495,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 		}
 	}
 
-	WARN_ON(qp->resp.mr);
+	WARN_ON_ONCE(qp->resp.mr);
 
 	qp->resp.mr = mem;
 	return RESPST_EXECUTE;
@@ -808,9 +808,10 @@ static enum resp_states execute(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 		err = process_atomic(qp, pkt);
 		if (err)
 			return err;
-	} else
+	} else {
 		/* Unreachable */
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
+	}
 
 	/* We successfully processed this new request. */
 	qp->resp.msn++;
@@ -1396,7 +1397,7 @@ int rxe_responder(void *arg)
 			goto exit;
 
 		default:
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 		}
 	}
 
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
