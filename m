From: Honggang LI <honli@redhat.com>
Subject: [PATCH 0/2] IB/core: Set invalid active widths to 1X when port is not active
Date: Thu, 15 Mar 2018 17:02:12 +0800
Message-ID: <20180315090214.21706-1-honli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Cc: noaos@mellanox.com, linux-kernel@vger.kernel.org, honli@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Honggang Li <honli@redhat.com>

Before the mlx5 RoCE port negotiate the active rate and width
with remote side, the mlx5_ib driver set them to zero.

The tool 'ibstat' of 'infiniband-diags' package will panic as it
read invalid width from the sys file. Set the active widths to
lowest valid vaule as what ib_core module did for invalid rates.

Honggang Li (2):
  IB/core: Set speed string to SDR for invalid active rates
  IB/core: Set width to 1X for invalid active widths when port is down

 drivers/infiniband/core/sysfs.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

-- 
2.14.GIT
