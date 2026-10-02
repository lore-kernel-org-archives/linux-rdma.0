Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231D634F24E;
	Fri,  2 Oct 2026 20:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790974618; cv=none; b=mE2Q+5NdBJb6l0PMYWrCOM8hH+/vbzRv2OP4qooui7rFt+8YahcFZJ8dZU0iUUUYhamfk8MAHDdyhNwKp/y50+EnQfcUqr3Y9hBLvU9AlfxcqCtDKkZjbeQw1sX/SsFCHXnuvB8FnAXb4cpyNzfLkptzQ7XbSQhbMamRac63hxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790974618; c=relaxed/simple;
	bh=0Y3r+DbGExKM3bexsbSnnoGZNoSSnLdMRyNwX47/JWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WXfwsKiTnKCXveo5liCtviIo1iDGBfZxBE3gHZXVe2zeaKZzWvALojTAOsDkUAtVucZn5NjFtcqQAOrokOYyZkU9e3tGs2Xnq9InQ3ViGJpoT6PKp4w+9oHCj708iP0G9WfZAvcKsYoaU7HN4TbliwlVdWGo6lPcS2Uw4Um2Ogg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l2MzhLkc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l2MzhLkc"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692EbaN33287676;
	Fri, 2 Oct 2026 20:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=kCOP7hnhDnbrGAKGQRVXGUMhHn5lk
	WLK0A+/3W8iGT8=; b=l2MzhLkcy/Erzyvvm3kQSWYYAMw/nCsxtZA9+3Gis1/lR
	dnf+4XhlHduws1MkJZGzZYb1IjdT0AQhJhn9tOV75TcyQXKVrXCxVbcykzPvraV3
	ntYY1JJeggP8Kfy/2yWJuiKlMAF2NKXqZdZz19sS2ZZCWqAGS0IpG3lEoBNU7RMG
	pAqP+aDJ9Vr2q79IoqlHE2yXOHxX5Bc/kdapa516Lq5Ks0LAX7srtv2cRY3sXZkT
	bLWioI3A+ytRk+9tRBbSBx5+vJCeZkSCU8NtPUjZ6L2SgbTjDsXAiinBTqhVLhMr
	WstlNNwS3gsfJMpBo7bvgV47xNlSYbFZuGVGizFyA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx5ns4kkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 20:56:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692Ko1lY036940;
	Fri, 2 Oct 2026 20:56:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gg6duv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 20:56:51 +0000 (GMT)
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 692Kuodd012238;
	Fri, 2 Oct 2026 20:56:51 GMT
Received: from mbpatil-ws.osdevelopmeniad.oraclevcn.com (mbpatil-ws.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.248.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4gx4gg6dud-1;
	Fri, 02 Oct 2026 20:56:50 +0000 (GMT)
From: Manjunath Patil <manjunath.b.patil@oracle.com>
To: saeedm@nvidia.com
Cc: leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Manjunath Patil <manjunath.b.patil@oracle.com>
Subject: [PATCH net] net/mlx5: retain command mailboxes after timeout
Date: Fri,  2 Oct 2026 20:56:49 +0000
Message-ID: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610020083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4MyBTYWx0ZWRfXw9udXpwPApbF
 HVH/Vnnj/KPSwHT3PbF/dsvryZUb7ABSuqefREn28BbDIzM6AriIcNFCUvmLp1o0XjsB/21HYfL
 CRzjETpFISfYZZkGOj8seHAYo8oOxXKgL3zmBe9la/APLdn5X3GYzz/V7oE84iadgsj3CpOgUo+
 Z3Kd4VLwRrRdWChx6QU8JGhYaroGd+9W3iI7QS6ff32qSvPZTSyy3WZyXHNEqh7gVr1BTzGf24E
 V/FLKVeWyuNZv3UwqYkmvRgAI4Od+oW+27gDSjIbJI0pVwlhFhzc19wqlwB7NUQ8Y88cTJxmOCX
 +lRoHSNbIQ+ElU9yeTNG1GFWPmgXwIFpnDeMg2czgL6Tl5ebp5mgAVMkk0axywiaZ/O+RjTSx9l
 8umRS4QUD25QKozxGdcRv0klmNrSps/9JeW9e9fqssyr4VEPjr1aovrXixJdjTFiwr8D5GPLOs1
 JFaMhT0G9ycWCGX/ovg==
X-Proofpoint-GUID: EQU8pirZfaHEbbeATr4QCc3IvklSGYCE
X-Authority-Analysis: v=2.4 cv=T8QZ3PKQ c=1 sm=1 tr=0 ts=6ac01a94 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=UclNb3vuK5x6yrke_OMA:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4MyBTYWx0ZWRfX0cVAMziyrejb
 aTCqDn9zlpgKAiLoOqimXK3zd+KL92p3uSICCMCZSSCaA1eorB4Ms4gRZp0chaNK/frZAb3OGtj
 7Z8MZPhjZp04Q+mynww31Hrfer9VtMKRd2AJtG01h5RQOOR2xkgw
X-Proofpoint-ORIG-GUID: EQU8pirZfaHEbbeATr4QCc3IvklSGYCE

Firmware can access command DMA mailboxes after the driver times out.
The command entry already keeps a reference for a possible firmware
completion, which keeps its slot allocated, but the blocking caller
and async callback can still free their input and output mailboxes on
timeout. A late firmware access can therefore hit reallocated DMA
pool memory.

Give the entry ownership of the mailboxes on timeout and free them when
its final reference is dropped. If timeout claims PENDING_COMP first,
retain the firmware-event reference while a real completion remains
possible; a late completion drops it.

The real EQ handler may instead claim PENDING_COMP before the blocking
timeout handler runs and still be reading the mailboxes. Set
RETAIN_MSGS before forcing timeout completion in the blocking path.
The EQ handler holds its entry reference through its last mailbox
access and done notification, so the caller can return on timeout
without freeing memory beneath it.

Serialize completion claims and firmware-reference handoffs under
alloc_lock. The existing reset/error flush marks synthetic
completions with MLX5_TRIGGERED_CMD_COMP and treats them as terminal
for firmware ownership; only such a triggered completion drops a
reference retained by an earlier timeout. Normal command EQ teardown
and its slot-drain policy are unchanged.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Assisted-by: Codex:gpt-5
Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 127 ++++++++++++++----
 include/linux/mlx5/driver.h                   |   1 +
 2 files changed, 103 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 84583dc5eb1c..22508b26972d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -142,8 +142,19 @@ cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
 	return ent;
 }
 
+static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
+static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
+			      struct mlx5_cmd_msg *msg);
+
 static void cmd_free_ent(struct mlx5_cmd_work_ent *ent)
 {
+	if (test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state)) {
+		struct mlx5_core_dev *dev = container_of(ent->cmd,
+							  struct mlx5_core_dev, cmd);
+
+		mlx5_free_cmd_msg(dev, ent->out);
+		free_msg(dev, ent->in);
+	}
 	kfree(ent);
 }
 
@@ -958,10 +969,6 @@ static void cb_timeout_handler(struct work_struct *work)
 	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
 }
 
-static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
-static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
-			      struct mlx5_cmd_msg *msg);
-
 static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
 {
 	if (cmd->allowed_opcode == CMD_ALLOWED_OPCODE_ALL)
@@ -1163,6 +1170,10 @@ static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
 		       mlx5_command_str(ent->op), ent->op);
 
 	ent->ret = -ETIMEDOUT;
+	/* The real handler may have claimed the completion but still be using
+	 * the mailboxes. Keep them with the entry until its last reference.
+	 */
+	set_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
 	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 }
 
@@ -1260,7 +1271,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 			   struct mlx5_cmd_msg *out, void *uout, int uout_size,
 			   mlx5_cmd_cbk_t callback,
 			   void *context, int page_queue,
-			   u8 token, bool force_polling)
+			   u8 token, bool force_polling, bool *retain_msgs)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 	struct mlx5_cmd_work_ent *ent;
@@ -1313,6 +1324,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
 
 	err = wait_func(dev, ent);
+	*retain_msgs = test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
 	if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
 		goto out_free;
 
@@ -1732,6 +1744,66 @@ static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg)
 	}
 }
 
+/*
+ * cmd_work_handler() takes an entry reference for the firmware event and
+ * sets PENDING_COMP before ringing the command doorbell. Firmware can still
+ * use the input and output DMA mailboxes after the caller times out.
+ *
+ * Claim PENDING_COMP under alloc_lock so exactly one handler makes the
+ * mailbox and firmware-reference decisions:
+ *
+ * - A timeout that wins retains the mailboxes in the entry. If the command
+ *   interface is still up and the opcode is allowed, firmware can still
+ *   generate a real completion, so TIMEDOUT retains the firmware-event ref.
+ * - A real completion that wins consumes its firmware-event ref normally.
+ * - A real completion that loses is the late event after a timeout. It drops
+ *   the ref retained by TIMEDOUT; RETAIN_MSGS stays set until entry teardown.
+ * - A reset completion cannot be followed by a real firmware event. It drops
+ *   a ref only when TIMEDOUT says the timeout retained one.
+ *
+ * A blocking timeout retains the mailboxes even when a real completion has
+ * claimed PENDING_COMP. That handler keeps its firmware-event reference until
+ * it finishes using the mailboxes. Keeping the reference transitions under
+ * alloc_lock prevents timeout, firmware, and reset from consuming the same
+ * reference.
+ */
+static bool mlx5_cmd_claim_completion(struct mlx5_core_dev *dev,
+				      struct mlx5_cmd_work_ent *ent, u64 vec,
+				      bool forced, bool *drop_fw_ref)
+{
+	struct mlx5_cmd *cmd = &dev->cmd;
+	unsigned long flags;
+	bool timed_out = forced && ent->ret == -ETIMEDOUT;
+	bool pending;
+
+	*drop_fw_ref = false;
+	spin_lock_irqsave(&cmd->alloc_lock, flags);
+	pending = test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP,
+				     &ent->state);
+	if (pending) {
+		if (timed_out)
+			set_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
+
+		if (timed_out && !mlx5_cmd_is_down(dev) &&
+		    opcode_allowed(cmd, ent->op)) {
+			set_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
+		} else {
+			clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
+			*drop_fw_ref = true;
+		}
+	} else if (!forced) {
+		clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
+		*drop_fw_ref = true;
+	} else if (vec & MLX5_TRIGGERED_CMD_COMP) {
+		/* Reset cannot receive a late firmware completion. */
+		*drop_fw_ref = test_and_clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
+						  &ent->state);
+	}
+	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
+
+	return pending;
+}
+
 static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
@@ -1744,38 +1816,33 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 	struct mlx5_cmd_stats *stats;
 	unsigned long flags;
 	unsigned long vector;
+	bool pending;
+	bool drop_fw_ref;
 
 	/* there can be at most 32 command queues */
 	vector = vec & 0xffffffff;
 	for (i = 0; i < (1 << cmd->vars.log_sz); i++) {
 		if (test_bit(i, &vector)) {
 			ent = cmd->ent_arr[i];
-
-			if (forced && ent->ret == -ETIMEDOUT)
-				set_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
-					&ent->state);
-			else if (!forced) /* real FW completion */
-				clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
-					  &ent->state);
+			pending = mlx5_cmd_claim_completion(dev, ent, vec, forced,
+							    &drop_fw_ref);
 
 			/* if we already completed the command, ignore it */
-			if (!test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP,
-						&ent->state)) {
-				/* only real completion can free the cmd slot */
+			if (!pending) {
 				if (!forced) {
-					mlx5_core_err(dev, "Command completion arrived after timeout (entry idx = %d).\n",
+					mlx5_core_err(dev,
+						      "Command completion arrived after timeout (entry idx = %d).\n",
 						      ent->idx);
-					cmd_ent_put(ent);
 				}
+				if (drop_fw_ref)
+					cmd_ent_put(ent);
 				continue;
 			}
 
 			if (ent->callback && cancel_delayed_work(&ent->cb_timeout_work))
 				cmd_ent_put(ent); /* timeout work was canceled */
 
-			if (!forced || /* Real FW completion */
-			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
-			     !opcode_allowed(cmd, ent->op))
+			if (drop_fw_ref && ent->callback)
 				cmd_ent_put(ent);
 
 			ent->ts2 = ktime_get_ns();
@@ -1816,17 +1883,23 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 								 ent->out,
 								 ent->uout_size);
 
-				mlx5_free_cmd_msg(dev, ent->out);
-				free_msg(dev, ent->in);
+				if (!test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS,
+					      &ent->state)) {
+					mlx5_free_cmd_msg(dev, ent->out);
+					free_msg(dev, ent->in);
+				}
 
 				/* final consumer is done, release ent */
 				cmd_ent_put(ent);
 				callback(err, context);
 			} else {
-				/* release wait_func() so mlx5_cmd_invoke()
-				 * can make the final ent_put()
+				/* No mailbox accesses after done. If the caller timed out,
+				 * the firmware reference keeps ent and its mailboxes alive
+				 * until this handler has finished.
 				 */
 				complete(&ent->done);
+				if (drop_fw_ref)
+					cmd_ent_put(ent);
 			}
 		}
 	}
@@ -1965,6 +2038,7 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	gfp_t gfp;
 	u8 token;
 	int err;
+	bool retain_msgs = false;
 
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode))
 		return -ENXIO;
@@ -2008,9 +2082,12 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	}
 
 	err = mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, context,
-			      pages_queue, token, force_polling);
+			      pages_queue, token, force_polling, &retain_msgs);
 	if (callback && !err)
 		return 0;
+	/* The entry releases retained DMA mailboxes with its final reference. */
+	if (retain_msgs)
+		goto out_up;
 
 	if (err > 0) /* Failed in FW, command didn't execute */
 		err = deliv_status_to_err(err);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 83d0a83bbfbc..99cabe13e6c1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -829,6 +829,7 @@ typedef void (*mlx5_cmd_cbk_t)(int status, void *context);
 enum {
 	MLX5_CMD_ENT_STATE_PENDING_COMP,
 	MLX5_CMD_ENT_STATE_TIMEDOUT,
+	MLX5_CMD_ENT_STATE_RETAIN_MSGS,
 };
 
 struct mlx5_cmd_work_ent {
-- 
2.52.0

