From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] IB/hfi1: Clean up type used and casting
Date: Fri, 26 Aug 2016 06:49:25 +0200
Message-ID: <1472186965-9103-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

In all other places in this file where 'find_first_bit' is called,
port_num is defined as a 'u8' and no casting is done.

Do the same here in order to be more consistent.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/infiniband/hw/hfi1/mad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 2c6c138c41b2..b9e47d1c462b 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2599,7 +2599,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	u8 lq, num_vls;
 	u8 res_lli, res_ler;
 	u64 port_mask;
-	unsigned long port_num;
+	u8 port_num;
 	unsigned long vl;
 	u32 vl_select_mask;
 	int vfi;
@@ -2634,7 +2634,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	port_mask = be64_to_cpu(req->port_select_mask[3]);
 	port_num = find_first_bit((unsigned long *)&port_mask, 64);
 
-	if ((u8)port_num != port) {
+	if (port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)pmp);
 	}
-- 
2.7.4


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
