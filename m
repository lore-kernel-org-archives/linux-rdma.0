From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH v2 02/26] sysfs: export sysfs_remove_file_self()
Date: Fri, 18 May 2018 15:03:49 +0200
Message-ID: <20180518130413.16997-3-roman.penyaev@profitbricks.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, Swapnil Ingle <swapnil.ingle@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>, Roman Pen <roman.penyaev@profitbricks.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Function is going to be used in transport over RDMA module
in subsequent patches.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 fs/sysfs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 5c13f29bfcdb..ff7443ac2aa7 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -444,6 +444,7 @@ bool sysfs_remove_file_self(struct kobject *kobj, const struct attribute *attr)
 	kernfs_put(kn);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sysfs_remove_file_self);
 
 void sysfs_remove_files(struct kobject *kobj, const struct attribute **ptr)
 {
-- 
2.13.1
