Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D0726FD9B;
	Tue, 15 Sep 2026 23:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789513232; cv=none; b=bXJZwGuuoLy0tCrmgtxZ1WBRU8cRov1Kfq+YP+VO3mTm8AxjvE3+oaidnQBPfNcvTRhlWNXpNZmumV4OmqZGv++T1zUbhtfGsjuJllFnR9CcacEATwRpWcUdm+Y+NBYXW5+ArQa+ZgGMzxvEtZtZV7oRwMsrJYT4MaXD6Xg6ghI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789513232; c=relaxed/simple;
	bh=TYKD6vPWLAs+ctV/G3yEUh5H7IDF1+smlbMM4jVkTdY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kc/Jv1yH7j2HKWMWsxPJ2YRhrASkLaT6anuTseFstLYEEEWYsjVIIXptEyIs/PXx9mkusRyf95TyUKFZLZJ/ub9XJ7u7G++nYHOMPvr8L4A5SuidzqMjBIwgxHvfydq4TBSLWVSpf/fv1+AIATC+B+X3QsCoubB+gFHgj3Zrcko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=DhsqVc0P; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="DhsqVc0P"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMObFJ1201369;
	Tue, 15 Sep 2026 16:00:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Bm5a808XI3/iCqVrVZYUCa89AED9HEkwD0Yvc
	RILXXk=; b=DhsqVc0PMDo0rSZj0/NwI/Oh1IRS7e80TUIq2+k36mrxtDRtts8wt
	1gvecDj+PxHb3GfeViin8bXmOQ5/8lV9hd7a9gC9wz41X2c2E4O6lbGTxl4mOrdF
	wub1xBEyO3zgtPSVo+QUPCw1L7sfgaTP9mTaA/3UsDtpUM0MRjvk5SKxg4pUMZDD
	BNTQ6FtEOfxXuzt1NYMZcmF83zpbxAM9yE1ZzyiHO6KBu5f9m9btkkr18n9r2lqr
	3KB8Beu3PW+UAmhf/7qEXKBsV+1RrxtIF5JM/Jdf9yybVo+qFJCWftNBeIlaymSY
	1XM9XF9u7jxq5OIvNiM4jDkJ+N41i3ihA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gqcw191ug-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 15 Sep 2026 16:00:18 -0700 (PDT)
Received: from devgpu031.atn1.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Tue, 15 Sep 2026 23:00:04 +0000
From: Danielle Costantino <dcostantino@meta.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha
	<eranbe@nvidia.com>
CC: <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Danielle Costantino <dcostantino@meta.com>, <stable@vger.kernel.org>
Subject: [PATCH net 2/2] net/mlx5: Don't return firmware-owned command mailboxes to the DMA pool
Date: Tue, 15 Sep 2026 15:59:40 -0700
Message-ID: <20260915225941.554568-3-dcostantino@meta.com>
In-Reply-To: <20260915225941.554568-1-dcostantino@meta.com>
References: <20260915225941.554568-1-dcostantino@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDMzNSBTYWx0ZWRfX+ynvlq0Szf3Q
 9CoNo95SkpoF/+Pzyiet6Pz4ePz/BTf4wtE7y2lUGXlESPRNA6cbPxf7pOHZHhiq50RoTp7jukr
 IUpB9sB/Xi68LFZPH4v/h3ybxYCApeBwkern1ptSrcGOLQfkYXy1JO9L5vI3yxgKB/9N45Ov1nG
 biLhkkVBH08d3nvEKKufttHT3pXbHPjM+XOK0LenQmr24nyFjffvCZvC9cyOEEMtDDLXfPG83BU
 TcfQKlxGimU1LXQ94ypiCJ9JIATw0DqpGc6uNZkt1y5asS9erlXevn30zAwXHbBRMiY2JVn7Ov3
 uETAx5j0APZop3CLAl4OXPMzS4W4IdcpIuIuU9xUjrhAfDV8vGyHZ2coZQXuYcDBwCnL7vV55kz
 PhK1gO5d+zQywh7r2YHGBWkR/GRkNU1GWX2YxZlIhzbyA1CgEhcswjI/obmN9yhoheN5d1o7V0V
 mWcjdE3Hm+5UaSUM/aQ==
X-Proofpoint-ORIG-GUID: CKTMDsum4D2RihXrJeEs0Sc7Rgw5Ni9T
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDMzNSBTYWx0ZWRfX09iuHIkdO8QS
 yFPrdselUj7mIjUe4NJU8mhkxNxzw7kFcgbgZeHicztiXzLJld67XhWvLwkbwfe/vRhNPBqjzY4
 BeaWUKn1kQrM/0BXKDoQ/F8Srlss9xo=
X-Authority-Analysis: v=2.4 cv=HKBWhYtv c=1 sm=1 tr=0 ts=6aa9ce02 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=VHFCzTapb2jfXy5aJ24A:9 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: CKTMDsum4D2RihXrJeEs0Sc7Rgw5Ni9T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01

When a firmware command times out, mlx5_cmd_comp_handler(forced=true)
deliberately skips cmd_ent_put():

	if (!forced ||                 /* real FW completion */
	     mlx5_cmd_is_down(dev) ||  /* no FW completion expected */
	     !opcode_allowed(cmd, ent->op))
		cmd_ent_put(ent);

so the command entry and its command queue slot stay allocated - the
documented "Will cause a leak of a command resource" behavior, which exists
precisely because firmware may still complete the command and write to
ent->lay.

Neither free site honors that for the mailboxes.  cmd_exec() falls through
to out_out:/out_in: on any error from mlx5_cmd_invoke(), including
-ETIMEDOUT, and the callback branch of mlx5_cmd_comp_handler() frees
ent->out and ent->in unconditionally - in both cases while ent->lay->in_ptr
and ent->lay->out_ptr still point at those buffers, and while the entry is
deliberately being kept alive for exactly that reason.

dma_pool_free() is explicit about the contract it is given:

 * Caller promises neither device nor driver will again touch this
 * block unless it is first re-allocated.

and pool_block_push() stores the free list node (struct dma_block:
next_block, dma) in the first 16 bytes of the DMA coherent block itself.
For mlx5 that is block->data[0..15] of struct mlx5_cmd_prot_block - the
start of the command payload firmware writes.  A late firmware completion
therefore overwrites dma_pool's free list pointer, and a subsequent
dma_pool_alloc() from that pool dereferences it:

  Unable to handle kernel paging request at virtual address
  0007c830040001a0
  pc : dma_pool_alloc+0x48/0x430   lr : mlx5_alloc_cmd_msg+0x154/0x318
  Call trace:
   dma_pool_alloc+0x48/0x430 (P)   // pool_block_pop(), mm/dmapool.c:187
   mlx5_alloc_cmd_msg+0x154/0x318
   cmd_exec+0x24c/0xb28
   mlx5_cmd_do+0x34/0x70
   mlx5_access_reg+0xe8/0x1c8
   mlx5_health_log_ts_update+0x80/0xb0

Two crash dumps taken after a firmware stall show the aliasing directly.
On each, 31 of the 32 command slots held an entry with ret == -ETIMEDOUT,
and 28 of 31 (30 of 31 on the second) carried the same ent->lay->out_ptr,
while all 31 ent->lay->in_ptr were distinct - the outbox is always a fresh
dma_pool_zalloc() and the pool free list is LIFO, so the mailbox freed by
the command that just timed out is handed straight to the next one, whereas
inboxes come from cmd->cache[].  pool->next_block held a value that is not
a kernel address.  The driver also logged "Command completion arrived after
timeout" hundreds of times, i.e. firmware really did complete those
commands after their mailboxes had been released.

Transfer ownership of the mailboxes to the command entry instead, on both
the synchronous and the callback path, and release them on its final put.
For a real completion nothing moves in practice, because that put is
normally the last one.

A command firmware never completes would then keep its mailboxes for the
lifetime of the device, and dma_pool_destroy() checks pool wide and all or
nothing: one stranded block makes it skip dma_free_coherent() for every
page and then free the descriptors anyway, stranding the whole ~4 MB
command pool - and its IOVA range under an IOMMU - on every teardown that
had a stalled slot.  So retire those entries in mlx5_cmd_disable(), before
destroy_msg_cache() so a reclaimed inbox lands back on its cache list and
is freed there.

Return the mailboxes to the pool only once firmware has confirmed it is
finished with them.  A successful DISABLE_HCA is that confirmation, so
check its result, which mlx5_function_disable() until now discarded, and
pass it to mlx5_cmd_disable().  Five other paths reach mlx5_cmd_disable()
without having issued it at all, among them the mlx5_function_enable()
error path and the light init and unload paths; those pass false, the
mailboxes stay allocated, and dma_pool_destroy() leaves the pool's pages
mapped so a late write lands in memory the driver still owns.  There is no
hardware backstop to fall back on: remove_one() runs mlx5_uninit_one(), and
with it the whole teardown, before mlx5_pci_close(), so bus mastering is
still enabled here.  Note free_cmd_page() just below makes the opposite
choice for the command queue page, which firmware writes lay->status_own
into, and has since the driver was merged; this does not change that.

The entry itself is retired unconditionally, because firmware is never
given its address: the only addresses the driver hands the device are the
mailbox DMA addresses in lay->in_ptr and lay->out_ptr and the command queue
page in cmdq_addr_h/l, and ent->lay points into that page rather than into
the entry.

Retiring it means dropping the reference firmware owes it, and nothing
tracked that.  Add MLX5_CMD_ENT_STATE_FW_REF, minted in cmd_work_handler()
together with the cmd_ent_get() it stands for and published before
MLX5_CMD_ENT_STATE_PENDING_COMP.  Every completion handler that acts on an
entry first clears PENDING_COMP, so ordering it last guarantees such a
handler sees FW_REF already set - including mlx5_cmd_trigger_completions(),
which can walk the slot as soon as cmd_alloc_index() has published it and
does not wait for the doorbell.  All three places that may drop the
reference - the retention condition when it declines to keep the entry, a
late real completion, and the reclaim - consume it with
test_and_clear_bit(), so exactly one of them wins.

A separate marker is needed rather than reusing own_msgs: the callback path
sets own_msgs whenever it hands the mailboxes over, while the reference is
only retained conditionally, so own_msgs alone would over put an entry
whose reference the retention condition had already dropped.  Gating
own_msgs on FW_REF too stops the driver withholding mailboxes it has
already decided firmware is finished with.

As a side effect the existing put on the "Command completion arrived after
timeout" path becomes paired with the reference rather than unconditional,
which closes a pre-existing over put: a force-polling command can be
completed both by cmd_work_handler() and by the event queue, and the second
one used to put a reference it did not own.

cb_timeout_work runs on the system workqueue, which the
flush_workqueue(cmd->wq) at the top of mlx5_cmd_disable() does not cover,
so drain it before the firmware reference is dropped.

Every other error path is unchanged: -EBUSY, -EAGAIN, -ECANCELED and
-EALREADY all fail before the doorbell is rung, so returning their
mailboxes immediately is correct.

This is distinct from commit fbb9933666e3 ("net/mlx5: Abort new commands if
all command slots are stalled"), which stops new commands once every slot
is stalled.  That limits how long the driver spins, but it does not gate
the mailbox free, and it does not help a device that corrupts the pool
before its slots are exhausted - one of the affected machines crashed after
only 18 timeouts, with slots still free.

One related hole is left in place, pre-existing.  A command that was posted
and then force completed with -ENXIO - by mlx5_cmd_comp_handler() under
MLX5_TRIGGERED_CMD_COMP, or by poll_timeout() when the interface goes down
- has its mailboxes freed immediately.  Both run only once the device is on
its way to a reset, where the driver already assumes firmware is finished
with the command queue.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Cc: stable@vger.kernel.org
Signed-off-by: Danielle Costantino <dcostantino@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 154 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/main.c    |  21 ++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
 include/linux/mlx5/driver.h                   |   6 +
 4 files changed, 167 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 571ed540957b1..890a2a2613ca0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -185,6 +185,10 @@ static void cmd_free_index(struct mlx5_cmd *cmd, int idx)
 	set_bit(idx, &cmd->vars.bitmask);
 }
 
+static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
+static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
+			      struct mlx5_cmd_msg *msg);
+
 static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
 {
 	refcount_inc(&ent->refcnt);
@@ -193,8 +197,11 @@ static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
 static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
 {
 	struct mlx5_cmd *cmd = ent->cmd;
+	struct mlx5_core_dev *dev;
 	unsigned long flags;
 
+	dev = container_of(cmd, struct mlx5_core_dev, cmd);
+
 	spin_lock_irqsave(&cmd->alloc_lock, flags);
 	if (!refcount_dec_and_test(&ent->refcnt)) {
 		spin_unlock_irqrestore(&cmd->alloc_lock, flags);
@@ -207,6 +214,15 @@ static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
 	}
 	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 
+	/* These were withheld from dev->cmd.pool because firmware still owned
+	 * them.  Nothing references the entry any more, so whoever dropped the
+	 * last reference has established that firmware is done with them.
+	 */
+	if (ent->own_msgs) {
+		mlx5_free_cmd_msg(dev, ent->out);
+		free_msg(dev, ent->in);
+	}
+
 	cmd_free_ent(ent);
 }
 
@@ -958,10 +974,6 @@ static void cb_timeout_handler(struct work_struct *work)
 	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
 }
 
-static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
-static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
-			      struct mlx5_cmd_msg *msg);
-
 static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
 {
 	if (cmd->allowed_opcode == CMD_ALLOWED_OPCODE_ALL)
@@ -1059,9 +1071,19 @@ static void cmd_work_handler(struct work_struct *work)
 
 	if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, timeout))
 		cmd_ent_get(ent);
-	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
 	cmd_ent_get(ent); /* for the _real_ FW event on completion */
+	/* Publish the reference, then its marker, and only then
+	 * MLX5_CMD_ENT_STATE_PENDING_COMP.  Whoever clears PENDING_COMP owns
+	 * the completion, so it has to see FW_REF already set or it will fail
+	 * to drop the reference.  Ordering PENDING_COMP last is what
+	 * guarantees that: mlx5_cmd_trigger_completions() can walk this slot
+	 * as soon as cmd_alloc_index() published it, long before the doorbell.
+	 */
+	set_bit(MLX5_CMD_ENT_STATE_FW_REF, &ent->state);
+	/* order FW_REF before PENDING_COMP, see the comment above */
+	smp_mb__before_atomic();
+	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 	/* Skip sending command to fw if internal error */
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
 		ent->ret = -ENXIO;
@@ -1313,7 +1335,19 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
 
 	err = wait_func(dev, ent);
-	if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
+	if (err == -ETIMEDOUT) {
+		/* The command was posted to firmware and firmware never
+		 * completed it.  Unless the device is already down,
+		 * mlx5_cmd_comp_handler(forced) keeps this entry and its
+		 * queue slot allocated because firmware may still complete
+		 * it, so ent->lay->{in_ptr,out_ptr} keep referencing the
+		 * mailboxes.  Take ownership of them so that cmd_exec()
+		 * cannot hand them back to dev->cmd.pool.
+		 */
+		ent->own_msgs = true;
+		goto out_free;
+	}
+	if (err == -ECANCELED || err == -EBUSY)
 		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
@@ -1810,7 +1844,9 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				if (!forced) {
 					mlx5_core_err(dev, "Command completion arrived after timeout (entry idx = %d).\n",
 						      ent->idx);
-					cmd_ent_put(ent);
+					if (test_and_clear_bit(MLX5_CMD_ENT_STATE_FW_REF,
+							       &ent->state))
+						cmd_ent_put(ent);
 				}
 				continue;
 			}
@@ -1818,9 +1854,11 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 			if (ent->callback && cancel_delayed_work(&ent->cb_timeout_work))
 				cmd_ent_put(ent); /* timeout work was canceled */
 
-			if (!forced || /* Real FW completion */
+			if ((!forced || /* Real FW completion */
 			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
-			     !opcode_allowed(cmd, ent->op))
+			     !opcode_allowed(cmd, ent->op)) &&
+			    test_and_clear_bit(MLX5_CMD_ENT_STATE_FW_REF,
+					       &ent->state))
 				cmd_ent_put(ent);
 
 			ent->ts2 = ktime_get_ns();
@@ -1861,8 +1899,22 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 								 ent->out,
 								 ent->uout_size);
 
-				mlx5_free_cmd_msg(dev, ent->out);
-				free_msg(dev, ent->in);
+				/* Same reasoning as the -ETIMEDOUT path in
+				 * mlx5_cmd_invoke(): when the entry was
+				 * retained just above, firmware may still DMA
+				 * into ent->lay->{in_ptr,out_ptr}, so hand the
+				 * mailboxes to the entry and let its last
+				 * cmd_ent_put() release them.  Otherwise the
+				 * driver has decided firmware is done and they
+				 * go straight back to the pool, as before.
+				 */
+				if (test_bit(MLX5_CMD_ENT_STATE_FW_REF,
+					     &ent->state)) {
+					ent->own_msgs = true;
+				} else {
+					mlx5_free_cmd_msg(dev, ent->out);
+					free_msg(dev, ent->in);
+				}
 
 				/* final consumer is done, release ent */
 				cmd_ent_put(ent);
@@ -2057,6 +2109,10 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	if (callback && !err)
 		return 0;
 
+	/* The mailboxes are owned by the command entry now */
+	if (err == -ETIMEDOUT)
+		goto out_up;
+
 	if (err > 0) /* Failed in FW, command didn't execute */
 		err = deliv_status_to_err(err);
 
@@ -2590,12 +2646,86 @@ int mlx5_cmd_enable(struct mlx5_core_dev *dev)
 	return err;
 }
 
-void mlx5_cmd_disable(struct mlx5_core_dev *dev)
+/* Retire the entries that timed out and were never completed by firmware.
+ * Each still holds the reference a real completion would have dropped, and
+ * with it a command queue slot, a semaphore unit, its own allocation, and -
+ * since the timeout paths hand mailbox ownership to the entry - blocks of
+ * cmd->pool.  The mailboxes matter most: dma_pool_destroy() checks pool wide
+ * and all or nothing, so one stranded block makes it skip dma_free_coherent()
+ * for every page and then free the descriptors anyway, stranding the whole
+ * command pool - and its IOVA range under an IOMMU - on every teardown.
+ */
+static void cmd_reclaim_stalled_ents(struct mlx5_core_dev *dev, bool fw_stopped)
+{
+	struct mlx5_cmd_work_ent *ent;
+	struct mlx5_cmd *cmd = &dev->cmd;
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < (1 << cmd->vars.log_sz); i++) {
+		/* Take a reference before dropping alloc_lock, otherwise a
+		 * concurrent last put could free the entry under us.  Holding
+		 * alloc_lock with the bit clear guarantees the refcount has
+		 * not reached zero, because cmd_ent_put() sets that bit under
+		 * the same lock before it frees anything.
+		 */
+		spin_lock_irqsave(&cmd->alloc_lock, flags);
+		ent = test_bit(i, &cmd->vars.bitmask) ? NULL : cmd->ent_arr[i];
+		if (ent)
+			cmd_ent_get(ent);
+		spin_unlock_irqrestore(&cmd->alloc_lock, flags);
+
+		if (!ent)
+			continue;
+
+		/* cb_timeout_work sits on the system workqueue, which the
+		 * flush_workqueue(cmd->wq) above does not cover.  Left queued
+		 * it would run cb_timeout_handler() once the async EQs are
+		 * gone and the caller has destroyed the message cache and the
+		 * pool.  If it was still pending, drop the reference taken
+		 * when it was scheduled.
+		 */
+		if (ent->callback &&
+		    cancel_delayed_work_sync(&ent->cb_timeout_work))
+			cmd_ent_put(ent);
+
+		/* The entry itself is never visible to firmware - the only
+		 * addresses it is ever given are the mailbox and command
+		 * queue DMA addresses - so it can always be retired.  Its
+		 * mailboxes are a different matter: hand those back only once
+		 * firmware has acknowledged it released the function.  If it
+		 * has not, drop ownership without freeing.  dma_pool_destroy()
+		 * then reports the pool busy and skips dma_free_coherent(),
+		 * so the pages stay mapped and are never handed back to the
+		 * allocator; a late write lands there harmlessly.
+		 */
+		if (!fw_stopped)
+			ent->own_msgs = false;
+
+		/* Only drop the firmware reference if it is really owed;
+		 * test_and_clear_bit() makes this safe against a late real
+		 * completion that got there first.
+		 */
+		if (test_and_clear_bit(MLX5_CMD_ENT_STATE_FW_REF, &ent->state)) {
+			mlx5_core_warn(dev, "reclaiming outstanding cmd[%d]: %s(0x%x)\n",
+				       i, mlx5_command_str(ent->op), ent->op);
+			cmd_ent_put(ent);
+		}
+
+		cmd_ent_put(ent);
+	}
+}
+
+void mlx5_cmd_disable(struct mlx5_core_dev *dev, bool fw_stopped)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 
 	flush_workqueue(cmd->wq);
 	clean_debug_files(dev);
+	/* Before destroy_msg_cache(): a reclaimed inbox goes back on its cache
+	 * list via free_msg(), and destroy_msg_cache() then frees it.
+	 */
+	cmd_reclaim_stalled_ents(dev, fw_stopped);
 	destroy_msg_cache(dev);
 	free_cmd_page(dev, cmd);
 	dma_pool_destroy(cmd->pool);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5f28d906c35b6..88f0a8089a0e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1164,18 +1164,33 @@ static int mlx5_function_enable(struct mlx5_core_dev *dev, bool boot, u64 timeou
 	mlx5_core_disable_hca(dev, 0);
 err_cmd_cleanup:
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
-	mlx5_cmd_disable(dev);
+	/* Nothing here has confirmed that firmware released the function */
+	mlx5_cmd_disable(dev, false);
 
 	return err;
 }
 
 static void mlx5_function_disable(struct mlx5_core_dev *dev, bool boot)
 {
+	bool fw_stopped;
+
 	mlx5_reclaim_startup_pages(dev);
 	mlx5_stop_health_poll(dev, boot);
-	mlx5_core_disable_hca(dev, 0);
+	/* A DISABLE_HCA that firmware really completed is it acknowledging
+	 * that it has released the function, and so that it is done with the
+	 * buffers the driver gave it.  mlx5_cmd_disable() needs to know,
+	 * because it can only hand command mailboxes back to the DMA pool
+	 * once that holds.
+	 *
+	 * A zero return is not sufficient on its own: mlx5_cmd_check() turns
+	 * the -ENXIO from an interface that is already down into success for
+	 * DISABLE_HCA, deliberately, so that reset flows proceed smoothly.
+	 * That is exactly the case where nothing was posted and firmware
+	 * acknowledged nothing, so require the interface to still be up.
+	 */
+	fw_stopped = !mlx5_core_disable_hca(dev, 0) && !mlx5_cmd_is_down(dev);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
-	mlx5_cmd_disable(dev);
+	mlx5_cmd_disable(dev, fw_stopped);
 }
 
 static int mlx5_function_open(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index d6713a2ce6769..c736537ecd81f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -223,7 +223,7 @@ int mlx5_query_module_num(struct mlx5_core_dev *dev, int *module_num);
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
 void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
 int mlx5_cmd_enable(struct mlx5_core_dev *dev);
-void mlx5_cmd_disable(struct mlx5_core_dev *dev);
+void mlx5_cmd_disable(struct mlx5_core_dev *dev, bool fw_stopped);
 void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
 			enum mlx5_cmdif_state cmdif_state);
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, u32 *sw_owner_id);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 83d0a83bbfbca..4c3812dfcc61b 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -829,6 +829,11 @@ typedef void (*mlx5_cmd_cbk_t)(int status, void *context);
 enum {
 	MLX5_CMD_ENT_STATE_PENDING_COMP,
 	MLX5_CMD_ENT_STATE_TIMEDOUT,
+	/* Firmware still owes this entry the reference that a real completion
+	 * would drop.  Consume it with test_and_clear_bit() so that exactly
+	 * one of the possible consumers takes it.
+	 */
+	MLX5_CMD_ENT_STATE_FW_REF,
 };
 
 struct mlx5_cmd_work_ent {
@@ -855,6 +860,7 @@ struct mlx5_cmd_work_ent {
 	u64			ts2;
 	u16			op;
 	bool			polling;
+	bool			own_msgs;
 	/* Track the max comp handlers */
 	refcount_t              refcnt;
 };
