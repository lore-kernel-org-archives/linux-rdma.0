From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 04/17] IB/mlx4: Fix a typo in a comment line
Date: Fri, 21 Apr 2017 20:30:41 +0200
Message-ID: <c5cae195-ad8e-6f36-726f-7245ca7ff0a1@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, trivial@kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Apr 2017 12:28:35 +0200

Add a missing character in this description and adjust
the comment formatting.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
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
2.12.2
