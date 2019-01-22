From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 02/12] IB/core: Allocate bit for SRQ ODP support
Date: Tue, 22 Jan 2019 08:48:41 +0200
Message-ID: <20190122064851.6032-3-leon@kernel.org>
References: <20190122064851.6032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122064851.6032-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

ODP support matrix is per operation and per transport. The support for
each transport (RC, UD, etc.)  is described with a bit field.

ODP for SRQ WQEs is considered a different kind of support from ODP for
RQ WQs and therefore need a different capability bit.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/rdma/ib_verbs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d6e0a7d35097..38438561b648 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -268,6 +268,7 @@ enum ib_odp_transport_cap_bits {
 	IB_ODP_SUPPORT_WRITE	= 1 << 2,
 	IB_ODP_SUPPORT_READ	= 1 << 3,
 	IB_ODP_SUPPORT_ATOMIC	= 1 << 4,
+	IB_ODP_SUPPORT_SRQ_RECV	= 1 << 5,
 };
 
 struct ib_odp_caps {
-- 
2.19.1
