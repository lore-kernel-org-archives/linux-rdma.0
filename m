From: Michal Kalderon <Michal.Kalderon@cavium.com>
Subject: [PATCH net 0/2] qed*: Rdma fixes
Date: Tue, 8 May 2018 21:29:17 +0300
Message-ID: <20180508182919.23590-1-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@cavium.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, chad.dupuis@cavium.com, Michal Kalderon <Michal.Kalderon@cavium.com>, Sudarsana Kalluru <Sudarsana.Kalluru@cavium.com>
List-Id: linux-rdma@vger.kernel.org

This patch series include two fixes for bugs related to rdma.
The first has to do with loading the driver over an iWARP
device. 
The second fixes a previous commit that added proper link
indication for iWARP / RoCE.

Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>
Signed-off-by: Sudarsana Kalluru <Sudarsana.Kalluru@cavium.com>

Michal Kalderon (2):
  qed: Fix l2 initializations over iWARP personality
  qede: Fix gfp flags sent to rdma event node allocation

 drivers/net/ethernet/qlogic/qed/qed_l2.c     | 6 ++----
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

-- 
2.9.5
