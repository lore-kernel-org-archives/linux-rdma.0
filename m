From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH linux-next] rds: rds_message_zcopy_from_user() can be
 static
Date: Thu, 8 Mar 2018 18:56:14 +0800
Message-ID: <20180308105614.GA22202@cairo>
References: <201803081854.WYn8kS5Y%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201803081854.WYn8kS5Y%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc: kbuild-all@01.org, Santosh Shilimkar <santosh.shilimkar@oracle.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Fixes: d40a126b16ea ("rds: refactor zcopy code into rds_message_zcopy_from_user")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 message.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index c36edbb9..6d87910b 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -333,7 +333,7 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	return rm;
 }
 
-int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *from)
+static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *from)
 {
 	unsigned long sg_off;
 	struct scatterlist *sg;
