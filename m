From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH rdma-next 1/5] RDMA/hns: Implement the disassociate_ucontext API
Date: Thu, 17 May 2018 16:02:49 +0800
Message-ID: <1526544173-106587-2-git-send-email-xavier.huwei@huawei.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org

This patch Implements the IB core disassociate_ucontext API.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 36 +++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 96fb6a9..7fafe9d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -33,6 +33,9 @@
 #include <linux/acpi.h>
 #include <linux/of_platform.h>
 #include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/sched/mm.h>
+#include <linux/sched/task.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
@@ -422,6 +425,38 @@ static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
 	return 0;
 }
 
+static void hns_roce_disassociate_ucontext(struct ib_ucontext *ibcontext)
+{
+	struct task_struct *process;
+	struct mm_struct   *mm;
+
+	process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
+	if (!process)
+		return;
+
+	mm = get_task_mm(process);
+	if (!mm) {
+		pr_info("no mm, disassociate ucontext is pending task termination\n");
+		while (1) {
+			put_task_struct(process);
+			usleep_range(1000, 2000);
+			process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
+			if (!process || process->state == TASK_DEAD) {
+				pr_info("disassociate ucontext done, task was terminated\n");
+				/* if task was dead, need to release the task
+				 * struct.
+				 */
+				if (process)
+					put_task_struct(process);
+				return;
+			}
+		}
+	}
+
+	mmput(mm);
+	put_task_struct(process);
+}
+
 static void hns_roce_unregister_device(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_ib_iboe *iboe = &hr_dev->iboe;
@@ -516,6 +551,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 
 	/* OTHERS */
 	ib_dev->get_port_immutable	= hns_roce_port_immutable;
+	ib_dev->disassociate_ucontext	= hns_roce_disassociate_ucontext;
 
 	ib_dev->driver_id = RDMA_DRIVER_HNS;
 	ret = ib_register_device(ib_dev, NULL);
-- 
1.9.1
