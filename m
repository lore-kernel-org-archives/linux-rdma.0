From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] Avoid that check_shl_overflow() triggers a compiler warning when building with W=1
Date: Wed,  6 Mar 2019 17:01:53 -0800
Message-ID: <20190307010153.81157-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that the following warning is reported when building
the mlx5 driver with W=1:

drivers/infiniband/hw/mlx5/qp.c: In function set_user_rq_size:
./include/linux/overflow.h:230:6: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
   _s >= 0 && _s < 8 * sizeof(*d) ? _s : 0;  \
      ^
drivers/infiniband/hw/mlx5/qp.c:5820:6: note: in expansion of macro check_shl_overflow
  if (check_shl_overflow(rwq->wqe_count, rwq->wqe_shift, &rwq->buf_size))
      ^~~~~~~~~~~~~~~~~~

Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Fixes: 0c66847793d1 ("overflow.h: Add arithmetic shift helper") # v4.19
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/overflow.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 40b48e2133cb..8afe0c0ada6f 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -202,6 +202,24 @@
 
 #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
 
+/*
+ * Evaluate a >= 0 without triggering a compiler warning if the type of a
+ * is an unsigned type.
+ */
+#define is_positive(a) ({					\
+	typeof(a) _minus_one = -1LL;				\
+	typeof((a) + 0U) _sign_mask = _minus_one > 0 ? 0 :	\
+				1ULL << (8 * sizeof(a) - 1);	\
+								\
+	((a) & _sign_mask) == 0;				\
+})
+
+/*
+ * Evaluate a < 0 without triggering a compiler warning if the type of a
+ * is an unsigned type.
+ */
+#define is_negative(a) !is_positive(a)
+
 /** check_shl_overflow() - Calculate a left-shifted value and check overflow
  *
  * @a: Value to be shifted
@@ -227,9 +245,9 @@
 	typeof(d) _d = d;						\
 	u64 _a_full = _a;						\
 	unsigned int _to_shift =					\
-		_s >= 0 && _s < 8 * sizeof(*d) ? _s : 0;		\
+		is_positive(_s) && _s < 8 * sizeof(*d) ? _s : 0;	\
 	*_d = (_a_full << _to_shift);					\
-	(_to_shift != _s || *_d < 0 || _a < 0 ||			\
+	(_to_shift != _s || is_negative(*_d) || is_negative(_a) ||	\
 		(*_d >> _to_shift) != _a);				\
 })
 
-- 
2.21.0
