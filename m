From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH linux-next] rds: rds_info_from_znotifier() can be static
Date: Thu, 8 Mar 2018 19:37:30 +0800
Message-ID: <20180308113729.GA89557@cairo>
References: <201803081946.adQaZcK5%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201803081946.adQaZcK5%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc: kbuild-all@01.org, Santosh Shilimkar <santosh.shilimkar@oracle.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 message.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 90dcdcf..f422b2f 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -67,7 +67,7 @@ static inline bool rds_zcookie_add(struct rds_msg_zcopy_info *info, u32 cookie)
 	return true;
 }
 
-struct rds_msg_zcopy_info *rds_info_from_znotifier(struct rds_znotifier *znotif)
+static struct rds_msg_zcopy_info *rds_info_from_znotifier(struct rds_znotifier *znotif)
 {
 	return container_of(znotif, struct rds_msg_zcopy_info, znotif);
 }
