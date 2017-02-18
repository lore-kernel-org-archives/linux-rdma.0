From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 05/29] IB/mlx4: Fix a typo in a comment line
Date: Sat, 18 Feb 2017 21:52:58 +0100
Message-ID: <b2be5d37-e334-5b97-7088-ee4a4c824824@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 17 Feb 2017 20:48:59 +0100

Add a missing character in this description and adjust
the comment formatting.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/mad.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index ea4892b0f39e..d8c27e3ed69a 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1559,8 +1559,10 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 		}
 	}
 
-	/* We are using standard ib_core services to send the mad, so generate a
-	 * stadard address handle by decoding the tunnelled mlx4_ah fields */
+	/*
+	 * We are using standard ib_core services to send the mad, so generate
+	 * a standard address handle by decoding the tunnelled mlx4_ah fields.
+	 */
 	memcpy(&ah.av, &tunnel->hdr.av, sizeof (struct mlx4_av));
 	ah.ibah.device = ctx->ib_dev;
 
-- 
2.11.1

