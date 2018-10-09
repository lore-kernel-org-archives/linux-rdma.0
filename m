From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH  v3 0/2] IB/mlx4: Enable debug print of SMPs and enhance output for MADs
Date: Tue,  9 Oct 2018 15:27:38 +0200
Message-ID: <20181009132740.2210085-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: leon@kernel.org
List-Id: linux-rdma@vger.kernel.org

SMPs were not printed at all. Added printing of port number and TID to
all MADs


Håkon Bugge (2):
  IB/mlx4: Enable debug print of SMPs
  IB/mlx4: Add port and TID to MAD debug print

 drivers/infiniband/hw/mlx4/mad.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--

v1 -> v2
    * Fixed incorrect format for printing the TID for the second patch
v2 -> v3
   * Made v3 consistently for cover-letter and the two patches, my v2
     was partly original submission plus a v2. That probably fooled
     both the kbuild bot and patchwork

2.14.3
