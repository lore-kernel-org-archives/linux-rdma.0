From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] IB/mlx5: Fix a parameter of find_first_bit
Date: Fri, 26 Aug 2016 07:16:17 +0200
Message-ID: <1472188577-14550-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matanb@mellanox.com, leonro@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

The 2nd parameter of 'find_first_bit' is the number of bits to search.
In this case, we are passing 'sizeof(tmp)' which is likely to be 4 or 8
because 'tmp' is an 'unsigned long'.

It is likely that the number of bits of 'tmp' was expected here. So use
BITS_PER_LONG instead.

It has been spotted by the following coccinelle script:
@@
expression ret, x;

@@
*  ret = \(find_first_bit \| find_first_zero_bit\) (x, sizeof(...));

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
__ffs could be used to reduce code verbosity
---
 drivers/infiniband/hw/mlx5/mem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 40df2cca0609..996b54e366b0 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -71,7 +71,7 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 
 	addr = addr >> page_shift;
 	tmp = (unsigned long)addr;
-	m = find_first_bit(&tmp, sizeof(tmp));
+	m = find_first_bit(&tmp, BITS_PER_LONG);
 	skip = 1 << m;
 	mask = skip - 1;
 	i = 0;
@@ -81,7 +81,7 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 		for (k = 0; k < len; k++) {
 			if (!(i & mask)) {
 				tmp = (unsigned long)pfn;
-				m = min_t(unsigned long, m, find_first_bit(&tmp, sizeof(tmp)));
+				m = min_t(unsigned long, m, find_first_bit(&tmp, BITS_PER_LONG));
 				skip = 1 << m;
 				mask = skip - 1;
 				base = pfn;
@@ -89,7 +89,7 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 			} else {
 				if (base + p != pfn) {
 					tmp = (unsigned long)p;
-					m = find_first_bit(&tmp, sizeof(tmp));
+					m = find_first_bit(&tmp, BITS_PER_LONG);
 					skip = 1 << m;
 					mask = skip - 1;
 					base = pfn;
-- 
2.7.4


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
