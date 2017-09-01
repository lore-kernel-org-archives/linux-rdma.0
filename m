From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] IB/core: fix spelling mistake: "aceess" -> "access"
Date: Fri,  1 Sep 2017 09:22:14 +0100
Message-ID: <20170901082214.7959-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in WARN message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/core/uverbs_ioctl_merge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_ioctl_merge.c b/drivers/infiniband/core/uverbs_ioctl_merge.c
index 76ddb6564578..062485f9300d 100644
--- a/drivers/infiniband/core/uverbs_ioctl_merge.c
+++ b/drivers/infiniband/core/uverbs_ioctl_merge.c
@@ -376,7 +376,7 @@ static struct uverbs_method_spec *build_method_with_attrs(const struct uverbs_me
 				 min_id) ||
 			    WARN(attr_obj_with_special_access &&
 				 !(attr->flags & UVERBS_ATTR_SPEC_F_MANDATORY),
-				 "ib_uverbs: Tried to merge attr (%d) but it's an object with new/destroy aceess but isn't mandatory\n",
+				 "ib_uverbs: Tried to merge attr (%d) but it's an object with new/destroy access but isn't mandatory\n",
 				 min_id) ||
 			    WARN(IS_ATTR_OBJECT(attr) &&
 				 attr->flags & UVERBS_ATTR_SPEC_F_MIN_SZ,
-- 
2.14.1
