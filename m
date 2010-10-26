From: Nicolas Kaiser <nikai@nikai.net>
Subject: [PATCH] infiniband/ipath: don't reset disabled devices
Date: Tue, 26 Oct 2010 17:47:52 +0200
Message-ID: <20101026174752.0f7f28dd@absol.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ralph Campbell <infinipath@qlogic.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The comment some lines above states that disabled devices
must not reset.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/infiniband/hw/ipath/ipath_sysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_sysfs.c b/drivers/infiniband/hw/ipath/ipath_sysfs.c
index b8cb2f1..8991677 100644
--- a/drivers/infiniband/hw/ipath/ipath_sysfs.c
+++ b/drivers/infiniband/hw/ipath/ipath_sysfs.c
@@ -557,6 +557,7 @@ static ssize_t store_reset(struct device *dev,
 		dev_info(dev,"Unit %d is disabled, can't reset\n",
 			 dd->ipath_unit);
 		ret = -EINVAL;
+		goto bail;
 	}
 	ret = ipath_reset_device(dd->ipath_unit);
 bail:
-- 
1.7.2.2
