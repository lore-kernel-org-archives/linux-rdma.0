From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH 0/2] IB/mlx4: Enable debug print of SMPs and enhance output for MADs
Date: Mon, 17 Sep 2018 16:53:07 +0200
Message-ID: <20180917145309.1255642-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, yishaih@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca
Cc: jackm@dev.mellanox.co.il
List-Id: linux-rdma@vger.kernel.org

SMPs were not printed at all. Added printing of port number and TID to
all MADs





Håkon Bugge (2):
  IB/mlx4: Enable debug print of SMPs
  IB/mlx4: Add port and TID to MAD debug print

 drivers/infiniband/hw/mlx4/mad.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--
2.14.3
