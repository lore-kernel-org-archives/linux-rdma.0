From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v4 03/17] RDMA/restrack: Add an API to attach a task to a resource
Date: Tue, 18 Jun 2019 20:26:11 +0300
Message-ID: <20190618172625.13432-4-leon@kernel.org>
References: <20190618172625.13432-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618172625.13432-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add rdma_restrack_attach_task() which is able to attach a task
other then "current" to a resource.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/restrack.c | 14 ++++++++++++++
 drivers/infiniband/core/restrack.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 95573f292aae..3714634ae296 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -194,6 +194,20 @@ void rdma_restrack_set_task(struct rdma_restrack_entry *res,
 }
 EXPORT_SYMBOL(rdma_restrack_set_task);

+/**
+ * rdma_restrack_attach_task() - attach the task onto this resource
+ * @res:  resource entry
+ * @task: the task to attach, the current task will be used if it is NULL.
+ */
+void rdma_restrack_attach_task(struct rdma_restrack_entry *res,
+			       struct task_struct *task)
+{
+	if (res->task)
+		put_task_struct(res->task);
+	get_task_struct(task);
+	res->task = task;
+}
+
 static void rdma_restrack_add(struct rdma_restrack_entry *res)
 {
 	struct ib_device *dev = res_to_dev(res);
diff --git a/drivers/infiniband/core/restrack.h b/drivers/infiniband/core/restrack.h
index 09a1fbdf578e..d084e5f89849 100644
--- a/drivers/infiniband/core/restrack.h
+++ b/drivers/infiniband/core/restrack.h
@@ -25,4 +25,6 @@ struct rdma_restrack_root {

 int rdma_restrack_init(struct ib_device *dev);
 void rdma_restrack_clean(struct ib_device *dev);
+void rdma_restrack_attach_task(struct rdma_restrack_entry *res,
+			       struct task_struct *task);
 #endif /* _RDMA_CORE_RESTRACK_H_ */
