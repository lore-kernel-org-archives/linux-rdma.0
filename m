From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@intel.com>
Subject: [PATCH] nvmet-rdma: Fix use after free
Date: Tue, 16 Aug 2016 15:11:25 +0200
Message-ID: <1471353085-6743-1-git-send-email-vincent.stehle@intel.com>
References: <1470230393-23671-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470230393-23671-1-git-send-email-sagi@grimberg.me>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

Avoid dereferencing the queue pointer in nvmet_rdma_release_queue_work()
after it has been freed by nvmet_rdma_free_queue().

Fixes: d8f7750a08968b10 ("nvmet-rdma: Correctly handle RDMA device hot removal")
Signed-off-by: Vincent Stehlé <vincent.stehle@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/target/rdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index b4d6485..5de8d0a 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -978,10 +978,11 @@ static void nvmet_rdma_release_queue_work(struct work_struct *w)
 		container_of(w, struct nvmet_rdma_queue, release_work);
 	struct rdma_cm_id *cm_id = queue->cm_id;
 	struct nvmet_rdma_device *dev = queue->dev;
+	enum nvmet_rdma_queue_state state = queue->state;
 
 	nvmet_rdma_free_queue(queue);
 
-	if (queue->state != NVMET_RDMA_IN_DEVICE_REMOVAL)
+	if (state != NVMET_RDMA_IN_DEVICE_REMOVAL)
 		rdma_destroy_id(cm_id);
 
 	kref_put(&dev->ref, nvmet_rdma_free_dev);
-- 
2.8.1
