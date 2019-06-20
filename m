From: Jack Wang <jinpuwang@gmail.com>
Subject: [PATCH v4 01/25] sysfs: export sysfs_remove_file_self()
Date: Thu, 20 Jun 2019 17:03:13 +0200
Message-ID: <20190620150337.7847-2-jinpuwang@gmail.com>
References: <20190620150337.7847-1-jinpuwang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620150337.7847-1-jinpuwang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, sagi@grimberg.me, bvanassche@acm.org, jgg@mellanox.com, dledford@redhat.com, danil.kipnis@cloud.ionos.com, rpenyaev@suse.de, Roman Pen <roman.penyaev@profitbricks.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Roman Pen <roman.penyaev@profitbricks.com>

Function is going to be used in transport over RDMA module
in subsequent patches.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 fs/sysfs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 130fc6fbcc03..1ff4672d7746 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -492,6 +492,7 @@ bool sysfs_remove_file_self(struct kobject *kobj, const struct attribute *attr)
 	kernfs_put(kn);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sysfs_remove_file_self);
 
 void sysfs_remove_files(struct kobject *kobj, const struct attribute * const *ptr)
 {
-- 
2.17.1
