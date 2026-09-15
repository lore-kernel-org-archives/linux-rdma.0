Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5075A4B7166;
	Tue, 15 Sep 2026 23:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789513234; cv=none; b=kS8wF3RIF5gkAH3PFdp9Vu3rsMNqe5tTwJZ8s5Bf6FgR3+czK4Ctu41a+D07AxuST6pwItI7nKjnp/JKUsSLSKi0zJnE+XHsCHGu9Fa8I9VYEUwci6HTYdcmVx46T1ZxnLTiJaHmWI0mAJKF/JsFKbaGH8ezkMyE051OO4bASpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789513234; c=relaxed/simple;
	bh=/YgJVZoHrdnJ7EczIgDxCdiG7JjI0ZArJOgne917T+w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=U9Kv4YpbVtBvadGe+ZKF3SFWHc4lOQ+THpJEsoJyB8e5YABBmrXbPBM0Xujauy5sNf0L4SHPWagKEUoLXq3L+UqrhZAmTFQfgL27VDJIWrzLxABJPZqE10LorHkbGO5EylMmmciuihUc3qkpRi4RzMhP86b1DY/CynszJwIWxAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=TtqLBlJS; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="TtqLBlJS"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMObFE1201369;
	Tue, 15 Sep 2026 16:00:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=5SYYR2gME
	zo9KBuRZkXl7m340BNohq+1tc71dUL+rU4=; b=TtqLBlJSAuLWHVgLtn/F5Tykd
	uu7iLYLEwVCzulJsdcOs2eKyj2h4PhxkEsc9Ll2aye9V+czEc0G+i9I1lpiiz9l+
	Pphm9dq05Yw0IOTNmiJ/L+nrBLd8PkgPZJy56ZvGCqfbkp28uKTl3yRg8bajHddR
	k+50o1o9zuCVUdnRSBNoLjmL/AzklASoJ0pKRYpVpHdttmbI2pGMC9jfaRR/w6sO
	40vGgnglIEwooXfzG9NL5zgU78HaLd5/aaYqpfso4QpNUW1pXgj5rVypytH3VToX
	LssEFmeSbTbiV7ZXsT62L9fQTxp5nXYHFGh0HUT6lslBbtxT/hplrjPzxpwMA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gqcw191ug-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 15 Sep 2026 16:00:16 -0700 (PDT)
Received: from devgpu031.atn1.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Tue, 15 Sep 2026 23:00:03 +0000
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
        Danielle Costantino <dcostantino@meta.com>
Subject: [PATCH net 0/2] net/mlx5: command mailbox use-after-free, and the teardown hang hiding it
Date: Tue, 15 Sep 2026 15:59:38 -0700
Message-ID: <20260915225941.554568-1-dcostantino@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDMzNSBTYWx0ZWRfXz3c3lz9RWoOG
 xmaBA84LlBRqvEolah/x/SgkysfEduxOw14EPnr+8QGS9jOUDnheU16ZjdDcrFX2kBg2VajYtRX
 E1reVCG6zIhb3WPC+tf4yV2Wc1cfjYIRNvXy39/hI/R8cvFxORd0WjWAdN07esiAgKl95B9uBAL
 1Hcdm0D7JyDnlRu3m6OPGVkTHch8cAr/2LNcP9Q6ZFEDVxJIProDtFTOIP6CuuIJYHLJ9oGl1gw
 2YEnMG+lvw17tFZO3iFeOKpLYCP+Ko13wYhQnh4UOp7ZOGy4r+pHv85HRs0qioGG6Hl6NjUBVt6
 GtPqlNFD6og1bIOct+zYeKYVr4/O48iUICgPDUIGN4nWtZySCEAemCIJW06Fn07MwkDcMkGpdH1
 gHrighrfAO2c38Msx2SslbPRksSQjmgoQ2i+rydp7s3XqxCEEIt3f7uwtkzrC4OgMSiDdboCsxY
 DL5xJRjea1K9ne/aPrA==
X-Proofpoint-ORIG-GUID: 6ODaJ9a8iXal0jhqdVZPLmF9aP9d7Wfn
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDMzNSBTYWx0ZWRfX87gMAiyT5alK
 LSdU8bQ+m+cW++CpAQro7+DJvdC3vUZ6vFjoMJWOT/TCiPRzdAiS/oSSWNSpwxWMB2T/dmlrSg5
 OdfN2S/6gN47rfcBQjpkE71CkdNKwok=
X-Authority-Analysis: v=2.4 cv=HKBWhYtv c=1 sm=1 tr=0 ts=6aa9ce00 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=N6mVrVnJ9CvU1J3POAcA:9 a=O8hF6Hzn-FEA:10
X-Proofpoint-GUID: 6ODaJ9a8iXal0jhqdVZPLmF9aP9d7Wfn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01

Two defects in the mlx5 command interface, both reached through the same
door: a firmware command that times out.

1/2 bounds the drain in mlx5_cmd_allowed_opcode() and
mlx5_cmd_change_mod().  Both take every unit of cmd->vars.sem, and since
commit 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once got
index free") a unit is only returned when the entry's refcount reaches
zero, which for a timed-out entry never happens.  One stalled slot blocks
them forever, and destroy_async_eqs() calls both from mlx5_unload(), so a
function with any stalled command cannot be removed: the task stays in D
state holding the devlink instance lock, and reboot hits the same path.

2/2 stops the driver handing a firmware-owned DMA mailbox back to
dev->cmd.pool.  When mlx5_cmd_comp_handler(forced) keeps an entry and its
queue slot because firmware may still complete the command, cmd_exec() and
the callback path free the mailboxes anyway.  dmapool keeps its free list
node in the first 16 bytes of the block, which for mlx5 is the start of the
command payload, so a late firmware write corrupts the allocator and a
subsequent dma_pool_alloc() follows a poisoned pointer.  That is the crash.

1/2 comes first because it is what makes 2/2's teardown cleanup reachable:
without it teardown deadlocks long before mlx5_cmd_disable(), so nothing in
this series would ever run there.  They are otherwise independent - 1/2
does not touch anything 2/2 changes - and each builds on its own.

Testing
=======

A 32-slot aarch64 device with 22 mlx5 functions, debug kernel (KASAN,
DEBUG_OBJECTS, DEBUG_LIST, DMA_API_DEBUG, DEBUG_SPINLOCK), driving real
-ETIMEDOUT by swallowing firmware completions with a kprobe, then
unbinding the function.

  control, unbind/rebind with no stalled slots
      unbind 10s, rebind 3s, no warnings, no splats - the drain refactor
      leaves the normal path alone

  1/2, with 13 stalled slots
      before  unbind never returns; task in D state in
              mlx5_cmd_allowed_opcode() with cmd->vars.sem at 0
      after   the drain gives up three times, once per quiesce call in
              destroy_async_eqs(), at 61.4s intervals - the command
              timeout - then the unbind completes in 195s and the
              function rebinds in 2s
      the partial drain declines to narrow the allowed opcode, once,
      and still widens it back afterwards

  2/2, same 13 stalled slots
      mailbox ownership taken on 13 of 13 timed-out entries
      slots sharing one lay->out_ptr ............. 0   (7 and 6 before)
      firmware-owned mailbox on pool free list ... 0   (8 and 7 before)
      pool->next_block .......................... valid, was garbage
      entries retired ........................... 13, matching the slots
      "dma_pool_destroy mlx5_cmd busy" .......... 0   (1 without the
                                                      reclaim)
      kmemleak reports of mlx5_cmd_work_ent ..... 0   (14 without it)

  across every run
      no KASAN, refcount_t, list corruption or dma_pool warnings

Danielle Costantino (2):
  net/mlx5: Bound the command interface drain so teardown cannot hang
  net/mlx5: Don't return firmware-owned command mailboxes to the DMA
    pool

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 231 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  21 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
 include/linux/mlx5/driver.h                   |   6 +
 4 files changed, 228 insertions(+), 32 deletions(-)


base-commit: 83a945a529d6e002dd7339c532288a931f463dba
