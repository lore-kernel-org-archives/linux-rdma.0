From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 076/123] IB/mlx5: Fix page fault handling for MW
Date: Wed,  5 Dec 2018 04:35:08 -0500
Message-ID: <20181205093555.5386-76-sashal@kernel.org>
References: <20181205093555.5386-1-sashal@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181205093555.5386-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko@mellanox.com>

[ Upstream commit 75b7b86bdb0df37e08e44b6c1f99010967f81944 ]

Memory windows are implemented with an indirect MKey, when a page fault
event comes for a MW Mkey we need to find the MR at the end of the list of
the indirect MKeys by iterating on all items from the first to the last.

The offset calculated during this process has to be zeroed after the first
iteration or the next iteration will start from a wrong address, resulting
incorrect ODP faulting behavior.

Fixes: db570d7deafb ("IB/mlx5: Add ODP support to MW")
Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index d216e0d2921d..9e1cac8cb260 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -724,6 +724,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 			head = frame;
 
 			bcnt -= frame->bcnt;
+			offset = 0;
 		}
 		break;
 
-- 
2.17.1
