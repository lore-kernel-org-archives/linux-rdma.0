From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/8] staging/rdma/hfi1: fix 0-day syntax error
Date: Thu, 18 Feb 2016 11:11:59 -0800
Message-ID: <20160218191153.20983.21495.stgit@scvm10.sc.intel.com>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218191005.20983.64127.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Setting CONFIG_HFI1_DEBUG_SDMA_ORDER causes a syntax error:
sdma.c: In function =E2=80=98complete_tx=E2=80=99:
sdma.c:370: error: =E2=80=98txp=E2=80=99 undeclared (first use in
this function)
sdma.c:370: error: (Each undeclared identifier is reported only once
sdma.c:370: error: for each function it appears in.)

Adjust code under ifdef to reference the tx properly.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sdma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hf=
i1/sdma.c
index 134b888..56dc54a 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -367,10 +367,10 @@ static inline void complete_tx(struct sdma_engine=
 *sde,
 	callback_t complete =3D tx->complete;
=20
 #ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
-	trace_hfi1_sdma_out_sn(sde, txp->sn);
-	if (WARN_ON_ONCE(sde->head_sn !=3D txp->sn))
+	trace_hfi1_sdma_out_sn(sde, tx->sn);
+	if (WARN_ON_ONCE(sde->head_sn !=3D tx->sn))
 		dd_dev_err(sde->dd, "expected %llu got %llu\n",
-			   sde->head_sn, txp->sn);
+			   sde->head_sn, tx->sn);
 	sde->head_sn++;
 #endif
 	sdma_txclean(sde->dd, tx);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
