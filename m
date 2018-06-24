From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Sun, 24 Jun 2018 11:23:49 +0300
Message-ID: <20180624082353.16138-9-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Add shift_overflow() helper to help driver authors to ensure that
shift operand doesn't cause to overflow, which is very common pattern
for RDMA drivers.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/overflow.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 8712ff70995f..2a3395248e94 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -202,6 +202,29 @@

 #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */

+/**
+ * shift_overflow() - Peform shift operation with overflow check
+ * @a: value to be shifted
+ * @b: shift operand
+ *
+ * Checks if a << b will overflow
+ *
+ * Returns: result of shift for no overflow or SIZE_MAX for overflow
+ */
+static inline __must_check size_t shift_overflow(size_t a, size_t b)
+{
+	size_t c, res;
+
+	if (b >= sizeof(size_t) * BITS_PER_BYTE)
+		return SIZE_MAX;
+
+	c = (size_t)1 << b;
+	if (check_mul_overflow(a, c, &res))
+		return SIZE_MAX;
+
+	return res;
+}
+
 /**
  * array_size() - Calculate size of 2-dimensional array.
  *
--
2.14.4
