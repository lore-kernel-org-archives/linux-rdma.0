From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH] IB/cma: use strlcpy() instead of strncpy()
Date: Fri, 12 Jan 2018 15:56:05 +0800
Message-ID: <1515743765-116090-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com
Cc: arnd@arndb.de
List-Id: linux-rdma@vger.kernel.org

From: Xiongfeng Wang <xiongfeng.wang@linaro.org>

gcc-8 reports

drivers/infiniband/core/cma_configfs.c: In function 'make_cma_dev':
./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
bound 64 equals destination size [-Wstringop-truncation]

We need to use strlcpy() to make sure the string is nul-terminated.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 drivers/infiniband/core/cma_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index 31dfee0..eee38b4 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -295,7 +295,7 @@ static struct config_group *make_cma_dev(struct config_group *group,
 		goto fail;
 	}
 
-	strncpy(cma_dev_group->name, name, sizeof(cma_dev_group->name));
+	strlcpy(cma_dev_group->name, name, sizeof(cma_dev_group->name));
 
 	config_group_init_type_name(&cma_dev_group->ports_group, "ports",
 				    &cma_ports_group_type);
-- 
1.8.3.1
