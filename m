From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 8/8] nvme: add keep-alive support
Date: Mon, 13 Jun 2016 16:45:28 +0200
Message-ID: <1465829128-22993-9-git-send-email-hch@lst.de>
References: <1465829128-22993-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465829128-22993-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Periodic keep-alive is a mandatory feature in NVMe over Fabrics, and
optional in NVMe 1.2.1 for PCIe.  This patch adds periodic keep-alive
sent from the host to verify that the controller is still responsive
and vice-versa.  The keep-alive timeout is user-defined (with
keep_alive_tmo connection parameter) and defaults to 5 seconds.

In order to avoid a race condition where the host sends a keep-alive
competing with the target side keep-alive timeout expiration, the host
adds a grace period of 10 seconds when publishing the keep-alive timeout
to the target.

In case a keep-alive failed (or timed out), a transport specific error
recovery kicks in.

For now only NVMe over Fabrics is wired up to support keep alive, but
we can add PCIe support easily once controllers actually supporting it
become available.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/core.c    | 76 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/fabrics.c | 33 +++++++++++++++++++-
 drivers/nvme/host/fabrics.h |  3 ++
 drivers/nvme/host/nvme.h    |  8 +++++
 4 files changed, 119 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e5c1d75..c01687d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -30,6 +30,7 @@
 #include <asm/unaligned.h>
 
 #include "nvme.h"
+#include "fabrics.h"
 
 #define NVME_MINORS		(1U << MINORBITS)
 
@@ -463,6 +464,74 @@ int nvme_submit_user_cmd(struct request_queue *q, struct nvme_command *cmd,
 			result, timeout);
 }
 
+static void nvme_keep_alive_end_io(struct request *rq, int error)
+{
+	struct nvme_ctrl *ctrl = rq->end_io_data;
+
+	blk_mq_free_request(rq);
+
+	if (error) {
+		dev_err(ctrl->device,
+			"failed nvme_keep_alive_end_io error=%d\n", error);
+		return;
+	}
+
+	schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+}
+
+static int nvme_keep_alive(struct nvme_ctrl *ctrl)
+{
+	struct nvme_command c;
+	struct request *rq;
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode = nvme_admin_keep_alive;
+
+	rq = nvme_alloc_request(ctrl->admin_q, &c, BLK_MQ_REQ_RESERVED,
+			NVME_QID_ANY);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
+
+	rq->timeout = ctrl->kato * HZ;
+	rq->end_io_data = ctrl;
+
+	blk_execute_rq_nowait(rq->q, NULL, rq, 0, nvme_keep_alive_end_io);
+
+	return 0;
+}
+
+static void nvme_keep_alive_work(struct work_struct *work)
+{
+	struct nvme_ctrl *ctrl = container_of(to_delayed_work(work),
+			struct nvme_ctrl, ka_work);
+
+	if (nvme_keep_alive(ctrl)) {
+		/* allocation failure, reset the controller */
+		dev_err(ctrl->device, "keep-alive failed\n");
+		ctrl->ops->reset_ctrl(ctrl);
+		return;
+	}
+}
+
+void nvme_start_keep_alive(struct nvme_ctrl *ctrl)
+{
+	if (unlikely(ctrl->kato == 0))
+		return;
+
+	INIT_DELAYED_WORK(&ctrl->ka_work, nvme_keep_alive_work);
+	schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+}
+EXPORT_SYMBOL_GPL(nvme_start_keep_alive);
+
+void nvme_stop_keep_alive(struct nvme_ctrl *ctrl)
+{
+	if (unlikely(ctrl->kato == 0))
+		return;
+
+	cancel_delayed_work_sync(&ctrl->ka_work);
+}
+EXPORT_SYMBOL_GPL(nvme_stop_keep_alive);
+
 int nvme_identify_ctrl(struct nvme_ctrl *dev, struct nvme_id_ctrl **id)
 {
 	struct nvme_command c = { };
@@ -1179,6 +1248,7 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 
 	nvme_set_queue_limits(ctrl, ctrl->admin_q);
 	ctrl->sgls = le32_to_cpu(id->sgls);
+	ctrl->kas = le16_to_cpu(id->kas);
 
 	if (ctrl->ops->is_fabrics) {
 		ctrl->icdoff = le16_to_cpu(id->icdoff);
@@ -1192,6 +1262,12 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 		 */
 		if (ctrl->cntlid != le16_to_cpu(id->cntlid))
 			ret = -EINVAL;
+
+		if (!ctrl->opts->discovery_nqn && !ctrl->kas) {
+			dev_err(ctrl->dev,
+				"keep-alive support is mandatory for fabrics\n");
+			ret = -EINVAL;
+		}
 	} else {
 		ctrl->cntlid = le16_to_cpu(id->cntlid);
 	}
diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index efa86d0..b86b637 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -360,6 +360,12 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
 	cmd.connect.fctype = nvme_fabrics_type_connect;
 	cmd.connect.qid = 0;
 	cmd.connect.sqsize = cpu_to_le16(ctrl->sqsize);
+	/*
+	 * Set keep-alive timeout in seconds granularity (ms * 1000)
+	 * and add a grace period for controller kato enforcement
+	 */
+	cmd.connect.kato = ctrl->opts->discovery_nqn ? 0 :
+		cpu_to_le32((ctrl->kato + NVME_KATO_GRACE) * 1000);
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -499,6 +505,7 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_NR_IO_QUEUES,	"nr_io_queues=%d"	},
 	{ NVMF_OPT_TL_RETRY_COUNT,	"tl_retry_count=%d"	},
 	{ NVMF_OPT_RECONNECT_DELAY,	"reconnect_delay=%d"	},
+	{ NVMF_OPT_KATO,		"keep_alive_tmo=%d"	},
 	{ NVMF_OPT_HOSTNQN,		"hostnqn=%s"		},
 	{ NVMF_OPT_ERR,			NULL			}
 };
@@ -610,6 +617,28 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			opts->tl_retry_count = token;
 			break;
+		case NVMF_OPT_KATO:
+			if (match_int(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (opts->discovery_nqn) {
+				pr_err("Discovery controllers cannot accept keep_alive_tmo != 0\n");
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (token < 0) {
+				pr_err("Invalid keep_alive_tmo %d\n", token);
+				ret = -EINVAL;
+				goto out;
+			} else if (token == 0) {
+				/* Allowed for debug */
+				pr_warn("keep_alive_tmo 0 won't execute keep alives!!!\n");
+			}
+			opts->kato = token;
+			break;
 		case NVMF_OPT_HOSTNQN:
 			if (opts->host) {
 				pr_err("hostnqn already user-assigned: %s\n",
@@ -661,6 +690,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 	}
 
 out:
+	if (!opts->discovery_nqn && !opts->kato)
+		opts->kato = NVME_DEFAULT_KATO;
 	kfree(options);
 	return ret;
 }
@@ -717,7 +748,7 @@ EXPORT_SYMBOL_GPL(nvmf_free_options);
 
 #define NVMF_REQUIRED_OPTS	(NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
 #define NVMF_ALLOWED_OPTS	(NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUEUES | \
-				 NVMF_OPT_HOSTNQN)
+				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN)
 
 static struct nvme_ctrl *
 nvmf_create_ctrl(struct device *dev, const char *buf, size_t count)
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index 12038308..b540674 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -49,6 +49,7 @@ enum {
 	NVMF_OPT_QUEUE_SIZE	= 1 << 4,
 	NVMF_OPT_NR_IO_QUEUES	= 1 << 5,
 	NVMF_OPT_TL_RETRY_COUNT	= 1 << 6,
+	NVMF_OPT_KATO		= 1 << 7,
 	NVMF_OPT_HOSTNQN	= 1 << 8,
 	NVMF_OPT_RECONNECT_DELAY = 1 << 9,
 };
@@ -72,6 +73,7 @@ enum {
  *		     kicking upper layer(s) error recovery.
  * @reconnect_delay: Time between two consecutive reconnect attempts.
  * @discovery_nqn: indicates if the subsysnqn is the well-known discovery NQN.
+ * @kato:	Keep-alive timeout.
  * @host:	Virtual NVMe host, contains the NQN and Host ID.
  */
 struct nvmf_ctrl_options {
@@ -85,6 +87,7 @@ struct nvmf_ctrl_options {
 	unsigned short		tl_retry_count;
 	unsigned int		reconnect_delay;
 	bool			discovery_nqn;
+	unsigned int		kato;
 	struct nvmf_host	*host;
 };
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ef28d4e..8d8cbc4 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -38,6 +38,9 @@ extern unsigned char admin_timeout;
 extern unsigned char shutdown_timeout;
 #define SHUTDOWN_TIMEOUT	(shutdown_timeout * HZ)
 
+#define NVME_DEFAULT_KATO	5
+#define NVME_KATO_GRACE		10
+
 enum {
 	NVME_NS_LBA		= 0,
 	NVME_NS_LIGHTNVM	= 1,
@@ -109,10 +112,13 @@ struct nvme_ctrl {
 	u8 vwc;
 	u32 vs;
 	u32 sgls;
+	u16 kas;
+	unsigned int kato;
 	bool subsystem;
 	unsigned long quirks;
 	struct work_struct scan_work;
 	struct work_struct async_event_work;
+	struct delayed_work ka_work;
 
 	/* Fabrics only */
 	u16 sqsize;
@@ -273,6 +279,8 @@ int nvme_get_features(struct nvme_ctrl *dev, unsigned fid, unsigned nsid,
 int nvme_set_features(struct nvme_ctrl *dev, unsigned fid, unsigned dword11,
 			dma_addr_t dma_addr, u32 *result);
 int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
+void nvme_start_keep_alive(struct nvme_ctrl *ctrl);
+void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 
 struct sg_io_hdr;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
