From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net 0/2] qed: iWARP - fix some syn related issues.
Date: Mon, 18 Feb 2019 15:24:01 +0200
Message-ID: <20190218132403.12487-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This series fixes two bugs related to iWARP syn processing flow. 

Michal Kalderon (2):
  qed: Fix iWARP buffer size provided for syn packet processing.
  qed: Fix iWARP syn packet mac address validation.

 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 21 +++++++++++++++------
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h |  1 -
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.9.5
