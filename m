From: Colin King <colin.king@canonical.com>
Subject: [PATCH][rds-next] rds: make functions rds_info_from_znotifier and rds_message_zcopy_from_user static
Date: Sun, 11 Mar 2018 18:03:40 +0100
Message-ID: <20180311170340.27696-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Functions rds_info_from_znotifier and rds_message_zcopy_from_user are
local to the source and do not need to be in global scope, so make them
static.

Cleans up sparse warnins:
net/rds/message.c:70:27: warning: symbol 'rds_info_from_znotifier' was
not declared. Should it be static?
net/rds/message.c:358:5: warning: symbol 'rds_message_zcopy_from_user'
was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/rds/message.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 9c41bdd9e444..7448fa192543 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -67,7 +67,8 @@ static inline bool rds_zcookie_add(struct rds_msg_zcopy_info *info, u32 cookie)
 	return true;
 }
 
-struct rds_msg_zcopy_info *rds_info_from_znotifier(struct rds_znotifier *znotif)
+static struct rds_msg_zcopy_info *
+rds_info_from_znotifier(struct rds_znotifier *znotif)
 {
 	return container_of(znotif, struct rds_msg_zcopy_info, znotif);
 }
@@ -355,7 +356,8 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	return rm;
 }
 
-int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *from)
+static int rds_message_zcopy_from_user(struct rds_message *rm,
+				       struct iov_iter *from)
 {
 	struct scatterlist *sg;
 	int ret = 0;
-- 
2.15.1
