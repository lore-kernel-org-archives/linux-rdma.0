From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Fri, 26 Aug 2016 06:49:09 +0200
Message-ID: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

The 2nd parameter of 'find_first_bit' is the number of bits to search.
In this case, we are passing 'sizeof(unsigned long)' which is likely to
be 4 or 8.

It is likely that the number of bits of 'port_mask' was expected here. This
variable is a 'u64', so use 64 instead.

It has been spotted by the following coccinelle script:
@@
expression ret, x;

@@
*  ret = \(find_first_bit \| find_first_zero_bit\) (x, sizeof(...));

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Not sure that using 64 directly is the best option.
Maybe '8 * sizeof(port_mask)' as used in the same file for
'for_each_set_bit' would be better
---
 drivers/infiniband/hw/hfi1/mad.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 1263abe01999..2c6c138c41b2 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2632,8 +2632,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	 * port the request came in on.
 	 */
 	port_mask = be64_to_cpu(req->port_select_mask[3]);
-	port_num = find_first_bit((unsigned long *)&port_mask,
-				  sizeof(port_mask));
+	port_num = find_first_bit((unsigned long *)&port_mask, 64);
 
 	if ((u8)port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
@@ -2836,8 +2835,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	 * port the request came in on.
 	 */
 	port_mask = be64_to_cpu(req->port_select_mask[3]);
-	port_num = find_first_bit((unsigned long *)&port_mask,
-				  sizeof(port_mask));
+	port_num = find_first_bit((unsigned long *)&port_mask, 64);
 
 	if (port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
@@ -3009,8 +3007,7 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 	 * the request came in on.
 	 */
 	port_mask = be64_to_cpu(req->port_select_mask[3]);
-	port_num = find_first_bit((unsigned long *)&port_mask,
-				  sizeof(port_mask));
+	port_num = find_first_bit((unsigned long *)&port_mask, 64);
 
 	if (port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
@@ -3246,8 +3243,7 @@ static int pma_set_opa_errorinfo(struct opa_pma_mad *pmp,
 	 * the request came in on.
 	 */
 	port_mask = be64_to_cpu(req->port_select_mask[3]);
-	port_num = find_first_bit((unsigned long *)&port_mask,
-				  sizeof(port_mask));
+	port_num = find_first_bit((unsigned long *)&port_mask, 64);
 
 	if (port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
-- 
2.7.4


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
