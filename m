Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E7735AC33;
	Tue, 15 Sep 2026 23:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789513231; cv=none; b=VvgvB2ZwQMVfQ3+/qPLME3AW6/hqep+bZ4zz4bTM59iEH/G5JuzSCD9uMKq9NKh1KgE2/46hJPWGXb55Uz0z5uv4RDZYMk+OnpPatTn59oytUtc7pjrOV6eR9A0UvwcCyd+imNa4n1wgAcdvBUiLubMXIAF+h9meKRfKrcb0+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789513231; c=relaxed/simple;
	bh=JCha9pC7+QN3P1InVt0V+DvqihHeD2b5ZY69pk7Dhss=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k4g4HPpPm4dyE2vgBm70kHAuRNkJuol3LK1VBwWPYdrxtmnQQAaivzvCGiEJxjvTwl4adBBD0G9o0t9e4bIPKpmrTjHW0Ido+75AXb34y9JoffGyJZCcNRJ/Ml1+sqyCkwbvBTbHjBh9DPpYqomPOWbQkgz+0ziujUgXvXh7HIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Hbb17WbT; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Hbb17WbT"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMObFH1201369;
	Tue, 15 Sep 2026 16:00:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=/7wMsNMTWbPyL3fPI/YPFAfXDR2ot92C5qcYW
	PZkYss=; b=Hbb17WbT3V4Pe2BOC8mmzj+EiAcsGQOgjaWr/iMfIFAM2LlsmzxZG
	4s3biLyY6hDjIjwKBkgZIYryQDhlxi2hCT+DxLjF6LDSqYlVmGP70e0i4lO6o4L/
	mBw+6zy8kDdnDGt/E/hXaJopgEsJbOTnjqDOY+DnFE4GKeZXLGkkaA98Q+FRutLs
	tQFYAcuOUykDmpLMLCJlzR6U0CaD5zM5NHm0d+c+tt1k3lrJ/16TtMN0ldk0945T
	TMyCLMEkfd0lWwtsT1Q9iI17Z9oUaXId27kD1xA0zeoaIJhx+YoLU1Pyx/3m+3TJ
	/MVWG2bnQf1gJqtGPcWe1SPjWiQxL1DjA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gqcw191ug-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 15 Sep 2026 16:00:17 -0700 (PDT)
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
Subject: [PATCH net 1/2] net/mlx5: Bound the command interface drain so teardown cannot hang
Date: Tue, 15 Sep 2026 15:59:39 -0700
Message-ID: <20260915225941.554568-2-dcostantino@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDMzNSBTYWx0ZWRfX8pnZbHowSVVG
 WAZWapooM8nCwZZDe2XjR6oDL+wtTTEwkBq00vJ8h6c1ommKoO3cIHq6KhSbfNXf+mCb02+FXVg
 SkHPbxQWuMBF4wfGjjVQUb6ckteKulc5phLiXvthueB7BzHHjZVC8Wqe/tDM4ORX0Rswm5T0LE/
 JbpRjELggyNwtQYqyni+LUIEg/ykK+UoR6kMtBRr/pCg7r2Bm/vltCcVg6ZhC+7WizoEfiacYTr
 dPljNM5hQOz9pslOJLB1EPQ1kyJL7cOGu0kqoEDXDmD0+nfz2rp9NDFtLUngPaDMwr4c/IT3jtp
 sKbsWlvaLHrfYRd+7/xvTVD8HiJqdK5jEDAAcF8mLX22KDILyONr8GFgILRkyA1EKpemtL13Q58
 c0xbnJIemGWq5FpuJc/pIaSGCUsDvEzRTVPk8MtHPOr1qZbT4EQd7aw+5KTGtE2x6Ks/yNZSZ/p
 KC8hwfD2xoS2AuBIpFA==
X-Proofpoint-ORIG-GUID: nF5gDvsELxuCNANJThDm-6OJkyJriOIT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDMzNSBTYWx0ZWRfX9dO3swmI9dl/
 qUYhlu/tkHoWtZSpbDtRXuwW9gXU/ovNnLyMQQlNEqUXfqwxn/TdE+1u0qyP7478qVhIf9bPHUH
 ycBVjfXRv3I4kiGNvw2VtC+PYR3033w=
X-Authority-Analysis: v=2.4 cv=HKBWhYtv c=1 sm=1 tr=0 ts=6aa9ce01 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=FuP7fAYJB1pi65jk6foA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: nF5gDvsELxuCNANJThDm-6OJkyJriOIT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01

mlx5_cmd_allowed_opcode() and mlx5_cmd_change_mod() drain the command
interface before updating a field that every in flight command reads, by
taking every unit of cmd->vars.sem:

	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
		down(&cmd->vars.sem);
	down(&cmd->vars.pages_sem);

Since commit 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once
got index free") a unit is handed back from cmd_ent_put(), under the
refcount that reaches zero:

	if (ent->idx >= 0) {
		cmd_free_index(cmd, ent->idx);
		up(ent->page_queue ? &cmd->vars.pages_sem : &cmd->vars.sem);
	}

A command that timed out never gets there.  mlx5_cmd_comp_handler(forced)
deliberately keeps the entry and its index allocated because firmware may
still complete the command, so the entry keeps a reference, the refcount
never reaches zero, and the unit is never returned.  Before that change the
up() ran unconditionally at the end of the completion loop and a timed out
entry did give its unit back; only the index was withheld.

So a single stalled command slot makes both functions block forever.

That is not a corner case, because destroy_async_eqs() calls both while
tearing the device down:

	mlx5_cmd_allowed_opcode(dev, MLX5_CMD_OP_DESTROY_EQ);
	mlx5_cmd_use_polling(dev);		/* mlx5_cmd_change_mod() */
	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);

and that runs from mlx5_eq_table_destroy() <- mlx5_unload(), so a function
with any stalled command cannot be removed:

  mlx5_cmd_allowed_opcode+0x70/0x188
  destroy_async_eqs+0x168/0x440
  mlx5_eq_table_destroy+0x29c/0x2e0
  mlx5_unload+0xa8/0xe8
  mlx5_uninit_one+0xa0/0x190
  remove_one+0x80/0x100
  pci_device_remove+0x9c/0x1c0
  device_release_driver_internal+0x358/0x5a8
  unbind_store+0x14c/0x188

The task stays in D state indefinitely and holds the devlink instance lock
while it does, so concurrent devlink users pile up behind it.  Reboot does
not recover it quickly either, since the same teardown runs on the way
down.

Reproduced by swallowing firmware completions with a kprobe so that
commands take the real -ETIMEDOUT path, then unbinding the function.  With
20 of the 31 register slots stalled, inspecting the hung device shows
cmd->vars.sem drained to 0 while cmd->vars.bitmask still reports 11 slots
free: mlx5_cmd_allowed_opcode() took the 11 units that were available and
then blocked on the 20 that are never coming back.

Bound the wait by the command timeout, which is the longest a command that
is merely in flight can legitimately take, and update the field without a
full drain if it expires.  Give the two callers a shared helper so the
unwind releases exactly what was acquired.  Failing to drain is worth a
warning but not a hang: the entries still holding units have already timed
out, so they are the least likely to be disturbed by the update, and the
alternative is an unrecoverable teardown.

mlx5_cmd_invoke() already bounds the same semaphore this way, see
commit 485d65e13571 ("net/mlx5: Add a timeout to acquire the command
queue semaphore").

Fixes: 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once got index free")
Cc: stable@vger.kernel.org
Signed-off-by: Danielle Costantino <dcostantino@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 77 +++++++++++++++----
 1 file changed, 61 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 84583dc5eb1c0..571ed540957b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1656,36 +1656,81 @@ static void create_debugfs_files(struct mlx5_core_dev *dev)
 	debugfs_create_file("run", 0200, dbg->dbg_root, dev, &fops);
 }
 
-void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
+/* Drain the command interface so that cmd->allowed_opcode and cmd->mode can be
+ * updated without an in flight command straddling the change.  A command that
+ * timed out keeps its index, and with it its semaphore unit, until firmware
+ * completes it - which may never happen - so bound the wait by the command
+ * timeout instead of blocking forever.  Returns the number of cmd->vars.sem
+ * units taken, and reports separately whether the page queue unit was taken;
+ * both have to be handed back by cmd_sem_up_all().
+ */
+static int cmd_sem_down_all(struct mlx5_core_dev *dev, bool *pages_sem)
 {
+	unsigned long end = jiffies + msecs_to_jiffies(mlx5_tout_ms(dev, CMD));
 	struct mlx5_cmd *cmd = &dev->cmd;
+	long left;
 	int i;
 
-	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
-		down(&cmd->vars.sem);
-	down(&cmd->vars.pages_sem);
+	for (i = 0; i < cmd->vars.max_reg_cmds; i++) {
+		left = end - jiffies;
+		if (left <= 0 || down_timeout(&cmd->vars.sem, left))
+			break;
+	}
 
-	cmd->allowed_opcode = opcode;
+	left = end - jiffies;
+	*pages_sem = left > 0 && !down_timeout(&cmd->vars.pages_sem, left);
 
-	up(&cmd->vars.pages_sem);
-	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
+	if (i < cmd->vars.max_reg_cmds)
+		mlx5_core_warn(dev, "command interface did not drain, %d of %d slots still busy\n",
+			       cmd->vars.max_reg_cmds - i, cmd->vars.max_reg_cmds);
+	if (!*pages_sem)
+		mlx5_core_warn(dev, "command interface did not drain, page queue slot still busy\n");
+
+	return i;
+}
+
+static void cmd_sem_up_all(struct mlx5_core_dev *dev, int nr, bool pages_sem)
+{
+	struct mlx5_cmd *cmd = &dev->cmd;
+
+	if (pages_sem)
+		up(&cmd->vars.pages_sem);
+	while (nr--)
 		up(&cmd->vars.sem);
 }
 
-static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
+void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
-	int i;
+	bool pages_sem;
+	int nr;
 
-	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
-		down(&cmd->vars.sem);
-	down(&cmd->vars.pages_sem);
+	nr = cmd_sem_down_all(dev, &pages_sem);
 
-	cmd->mode = mode;
+	/* Narrowing the set is only safe once the interface has drained.
+	 * mlx5_cmd_comp_handler() reads !opcode_allowed() as "no real
+	 * firmware completion is expected" and releases the entry, so
+	 * narrowing while a command is still posted would hand its mailboxes
+	 * back to dev->cmd.pool with firmware still able to write them.
+	 * Widening back to CMD_ALLOWED_OPCODE_ALL is always safe.
+	 */
+	if (opcode == CMD_ALLOWED_OPCODE_ALL ||
+	    (nr == cmd->vars.max_reg_cmds && pages_sem))
+		cmd->allowed_opcode = opcode;
+	else
+		mlx5_core_warn(dev, "leaving command opcodes unrestricted, interface did not drain\n");
 
-	up(&cmd->vars.pages_sem);
-	for (i = 0; i < cmd->vars.max_reg_cmds; i++)
-		up(&cmd->vars.sem);
+	cmd_sem_up_all(dev, nr, pages_sem);
+}
+
+static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
+{
+	bool pages_sem;
+	int nr;
+
+	nr = cmd_sem_down_all(dev, &pages_sem);
+	dev->cmd.mode = mode;
+	cmd_sem_up_all(dev, nr, pages_sem);
 }
 
 static int cmd_comp_notifier(struct notifier_block *nb,
