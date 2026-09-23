Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12DC443C21;
	Wed, 23 Sep 2026 19:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790190387; cv=none; b=ICtoAtAF4qoSQLFb0C7PvwfsbcvigNaculbBi4uXo3XY4epsqDAdifAw9XtwfncGFeO/eQCivuPP+itv+ouWp+iJyQ/VqNduqvW24UTB4plRNJJQtq/VzONQ1JeGmOB7AMdmkcLkdjHcekdLJlXXv6r5Pwx+4X2Ie8RJbIWPcvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790190387; c=relaxed/simple;
	bh=D+sEsyJ8ay+08i/0UVkJ3/D1aucBN7E9uLKMfAxfu+k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tPvvm0UmTzbhWqzaWcGXZyBH0nh7ve/HfocAgmq1/wlh3EEp7+03gnfvlmR7gxksMiZq8sOTO8/gX3QeCnyLZuiqo6Gxn4qvpFx853E2UAtHJgcS4fx2HGKY55Bqh3QnLVi7TT3GpuiiuX5P4XkeoHOdUNI5w87WUeXf27w9GBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=S41j3WlW; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="S41j3WlW"
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NGTarb2648625;
	Wed, 23 Sep 2026 12:06:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=EAp7+VZt5
	hzoapzFr43mE63hJoaoG/BMyrXDtQRpJVM=; b=S41j3WlWBVt0S4FBqdxlLsY1M
	n8+nfcBFXIs3XDvqzsLqSlsLla2iHduGxXwyKlgtHzVw1K/9ZShm0bWhm71coU9D
	hVlnDEB3ppmuBLM32ELIsfjJ9Ez9mYV182HrAZEnvoMLXXSoMQ10u79LZ9ha1EkB
	OBOWvdPAtOFv3ESwbV8s7VXRibHDxfHO6MS+cKO+l+AYuddHtL6OrgRifVxzTViW
	eIRDF1WedUHrbVR9emRhx0ykfNkrFYJw4gNab5zFboofQKavHoyshbOBtlvd9rnV
	wCn5OCqHYaQQEbuLX8314LxrYdcQQOesoFkHR/wP3AcRUkWZnVxsvZUx3x+Ww==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4guyr1ahke-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 23 Sep 2026 12:06:13 -0700 (PDT)
Received: from devgpu031.atn1.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.49; Wed, 23 Sep 2026 19:06:12 +0000
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
Subject: [PATCH net v2] net/mlx5: Don't return firmware-owned command mailboxes to the DMA pool
Date: Wed, 23 Sep 2026 12:05:42 -0700
Message-ID: <20260923190542.848049-1-dcostantino@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA3NSBTYWx0ZWRfXw9yaGzm8Ccbm
 R6LxzDcCbtzU1fY3D7h45T8UaNHI5+UTWccNhH1Ory7jjgFimiaUpmDnQx3by8VMDpQCcoudRbQ
 mBhAz+kvRwHEdmhMS5SFvzTK0MfzH3dx/cC8FrCmgWNJ1G/78Qxz588D+AGS8oy5Xjl9ljxc7Q0
 +nlqfCKBuuv5Q0m0yi4vRhmv8S3T/6PupIZHkJ/9eZpM0U0xpE6Zr3IqO1OFyrWVhobf+WfIdew
 337rky3PJnayeYjW8yGoT3hW5Mww/RZm22vKJzHfkL+bG3DWJTO/tmwQo9mZG4g1iSwCbN+NVFf
 tN8M34Yw0D99t3vejFMMo27Sf3734fTuBH/ZZE/XlgqZotdEPuOVMa/7I2vgxGuJgkxvKvupaZ6
 BJrgz6flzHxN3Dui7dqdmZPb9tyTPnutfikhSwJFOEzBQMZ8Csao2odOuL8O9j5MKXkYjqF0RyD
 r72cmXndAKsxKh8ysfg==
X-Authority-Analysis: v=2.4 cv=DNMacCNb c=1 sm=1 tr=0 ts=6ab42325 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=U_y8lYiYyhHBU5rMqhb2:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=M9fkILYBk67UyVTxOGIA:9 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA3NSBTYWx0ZWRfX/1L1C1F5L7ar
 I22mRwCAHmYCXfibepoWq15J//kWzbyQ123MTt1qKgZ33N3j2iIDNGOS0XEDlA7+VRtVrTEyLYQ
 PMh7P9bapsfpqMvcWBTl1ZDjNYRukuM=
X-Proofpoint-ORIG-GUID: KasFjBz00eOuUJiCxqrxlZ_F746oJ4Ov
X-Proofpoint-GUID: KasFjBz00eOuUJiCxqrxlZ_F746oJ4Ov
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_06,2026-09-21_02,2025-10-01_01

On a command timeout mlx5_cmd_comp_handler(forced) keeps the entry and its
queue slot, because firmware may still complete the command and write to
ent->lay. cmd_exec() and the callback path free the mailboxes anyway,
while ent->lay->{in_ptr,out_ptr} still point at them.

dma_pool keeps its free list node in the first 16 bytes of the block,
which for mlx5 is the start of the command payload, so a late firmware
write corrupts the allocator:

  Unable to handle kernel paging request at virtual address
  0007c830040001a0
  pc : dma_pool_alloc+0x48/0x430   lr : mlx5_alloc_cmd_msg+0x154/0x318
  Call trace:
   dma_pool_alloc+0x48/0x430 (P)
   mlx5_alloc_cmd_msg+0x154/0x318
   cmd_exec+0x24c/0xb28
   mlx5_access_reg+0xe8/0x1c8

Two crash dumps show the aliasing: 31 of 32 slots held an entry with
ret == -ETIMEDOUT, 28 of 31 shared one ent->lay->out_ptr while every
in_ptr was distinct, and pool->next_block held a non-kernel address.

Transfer mailbox ownership to the entry and release it on its final put,
on both the synchronous and the callback path. For a real completion that
put is normally the last one, so nothing moves in practice.

An entry firmware never completes keeps its mailboxes for the lifetime of
the device. dma_pool_destroy() then reports the pool busy and declines to
free its pages, which is the memory safe outcome: the pages stay mapped,
so a late write lands there rather than in memory handed back to the
allocator.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Cc: stable@vger.kernel.org
Signed-off-by: Danielle Costantino <dcostantino@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 32 +++++++++++++++----
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 84583dc5eb1c0..4051f97b2ae12 100644
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
@@ -207,6 +214,11 @@ static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
 	}
 	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 
+	if (ent->own_msgs) {
+		mlx5_free_cmd_msg(dev, ent->out);
+		free_msg(dev, ent->in);
+	}
+
 	cmd_free_ent(ent);
 }
 
@@ -958,10 +970,6 @@ static void cb_timeout_handler(struct work_struct *work)
 	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
 }
 
-static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
-static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
-			      struct mlx5_cmd_msg *msg);
-
 static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
 {
 	if (cmd->allowed_opcode == CMD_ALLOWED_OPCODE_ALL)
@@ -1313,7 +1321,12 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
 
 	err = wait_func(dev, ent);
-	if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
+	if (err == -ETIMEDOUT) {
+		/* firmware may still DMA into the mailboxes; keep them */
+		ent->own_msgs = true;
+		goto out_free;
+	}
+	if (err == -ECANCELED || err == -EBUSY)
 		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
@@ -1816,8 +1829,10 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 								 ent->out,
 								 ent->uout_size);
 
-				mlx5_free_cmd_msg(dev, ent->out);
-				free_msg(dev, ent->in);
+				/* firmware may still DMA into the mailboxes;
+				 * keep them
+				 */
+				ent->own_msgs = true;
 
 				/* final consumer is done, release ent */
 				cmd_ent_put(ent);
@@ -2012,6 +2027,9 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	if (callback && !err)
 		return 0;
 
+	if (err == -ETIMEDOUT) /* the command entry owns the mailboxes now */
+		goto out_up;
+
 	if (err > 0) /* Failed in FW, command didn't execute */
 		err = deliv_status_to_err(err);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 83d0a83bbfbca..9fcbc6070869f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -855,6 +855,7 @@ struct mlx5_cmd_work_ent {
 	u64			ts2;
 	u16			op;
 	bool			polling;
+	bool			own_msgs;
 	/* Track the max comp handlers */
 	refcount_t              refcnt;
 };

base-commit: 9c572a83037a7dcd653ba3a9cc468c16b857d0c9
