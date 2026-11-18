Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795009612;
	b=FZJj7WvLH/fjQQNNwldyrtjOSq2noebpdelL3lFHScA1ls/ynC9mTuQQYlq1vPM0yVUm
	 MSli3z81HC9pOMaDPxkzq0dZkRgwJ1jyymA7xd0GB9BK6Ek4Po0Xz0IzJbZ57WAZ1FaXb
	 tCEtIVnYf3S/tCVEW1MaUECXGYB9DCHGlXPy41wZzlE+wFvwK932CX2YuZuXMlKfqIiiw
	 wES3L5uYxa7me7elEPPZi26DV+6oue665603RSnLroQ/pnPWasQGxV5a/wQRBXbtruiQT
	 1F/POCBte8/uXPJ7eqwvMc7IFkq6GZ0N1LMQjcmEmaih3pxADZAC0RFmCkWcxEOBYDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009612;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=t7NeEPLoYnvjcxVnE1Z3D99rPFDU6XaQdSpEyou6UBY=;
	b=J1iEC8FXtr39uHqNbcb89OpzrZi0cuzNYwhRKcOD62voj35Z1sczoXs7X0v1hdGBxEZD
	 Jciix4ZV9SldYuYYxk7gtC1VjJ8PIHO/stbxUDAza9u04bRhnB+YZtlCobWV2W9BxzjNQ
	 occl3C/7v87eCI22TtV6KhmG+J9cJAtvxj6VC3imeQEvZRxHhiPJSojfRC9rJNr0sVGZl
	 603iBEkviw2L278FBLJvemqvTFv1ve+cnqdLzlaWr6xF4+wgRTFb20i53fsv1R6d8Qnnt
	 hgLfVCYgy1P9tr2CtH9NJqhTkHaf5Nhg2o6wAdcnYHsEHVFM3EiwAgyXVzvYC0b6Bsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=Cq9pSZ4v;
	arc=none smtp.remote-ip=117.135.210.9
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DC8606A331;
	Wed, 18 Nov 2026 13:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2DC8606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=Cq9pSZ4v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=t7
	NeEPLoYnvjcxVnE1Z3D99rPFDU6XaQdSpEyou6UBY=; b=Cq9pSZ4vHpK3SQyFOj
	JgYDsDrxRP5dKoq221IiOwNJWiiSSOu2v2MaZLQmzhBt3hpRuDVR0hhRmavEF/5X
	ZKHbddxO94+51U7Y7NtsgZ9hV12I4944NLu4WZ5lAA1IbPiCPSbjj/A1GkrwL9Cp
	PqqZQJ1sOHHMjT+xfNgDAfhss=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD37yb9q_1qGwFIDg--.29240S4;
	Wed, 18 Nov 2026 21:45:36 +0800 (CST)
From: Jinvas <jinvas@126.com>
To: saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leonro@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	jinvas@126.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	horms@kernel.org,
	alexious@zju.edu.cn
Subject: [PATCH net v3 0/1] net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
Date: Wed, 18 Nov 2026 21:45:13 +0800
Message-Id: <20261118134514.1765-1-jinvas@126.com>
X-Mailer: git-send-email 2.28.0.windows.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD37yb9q_1qGwFIDg--.29240S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Xr1xAw4kCw1xGr1kur48WFg_yoWxGrW3pF
	43X3ZrKrs5JrW7Gws7Aw1Yqry8AF4fAay5C3W3K3yFkFs8Cr1xtFWIg3yrZFy7CFZ5J342
	qr15XryYyFyDAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UUsqAUUUUU=
X-CM-SenderInfo: xmlq4tbv6rjloofrz/xtbBpQBF22r9rACS0QAA3D

The following patch fixes a NULL pointer dereference in the mlx5e aRFS
code, which oopses the kernel during NIC bring-up.

The bug was introduced by commit 3c6d5189246f ("net/mlx5e: fix a
double-free in arfs_create_groups", in v6.8) and is still present in
v7.4-rc2.

1. What happens

arfs_create_groups() creates up to two flow groups in ft->g[], and
increments ft->num_groups for each group that was created successfully.
If creating the second group fails, the error path frees ft->g and sets
it to NULL, but leaves ft->num_groups at 1.

The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
the error path, which calls mlx5e_destroy_groups():

	for (i = ft->num_groups - 1; i >= 0; i--) {
		if (!IS_ERR_OR_NULL(ft->g[i]))
			mlx5_destroy_flow_group(ft->g[i]);
		ft->g[i] = NULL;
	}

ft->g is NULL at this point, so ft->g[0] is a NULL pointer dereference.
Note that only a failure of the *second* group triggers this; if the
first group fails, num_groups is still 0 and the loop body never runs.

The same error path also leaks the flow group that was created
successfully before the failure, since ft->g is freed without the group
being destroyed.

2. How this was introduced

Commit 3c6d5189246f fixed a double free of ft->g between
arfs_create_groups() and its caller. Before that commit, the group
failure path did not touch ft->g at all:

	err:
		err = PTR_ERR(ft->g[ft->num_groups]);
		ft->g[ft->num_groups] = NULL;
	out:
		kvfree(in);
		return err;

so the caller destroyed the flow groups that had been created and then
freed the array. That commit fixed the double free in the allocation
failure path by freeing ft->g here as well, and in doing so changed the
group failure path too:

	err_clean_group:
		err = PTR_ERR(ft->g[ft->num_groups]);
		ft->g[ft->num_groups] = NULL;
	err_free_in:
		kvfree(in);
	err_free_g:
		kfree(ft->g);
		ft->g = NULL;
		return err;

The reset of ft->num_groups that would have prevented this was
suggested during review, but deferred ("it is a better idea to leave it
to a refector patch one day"), and that patch never landed.

3. The oops

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Oops [#1]
epc : mlx5e_destroy_groups+0x38/0x6c
 ra : mlx5e_destroy_flow_table+0x10/0x30
status: 0000000200000120 badaddr: 0000000000000000 cause: 000000000000000d
[<ffffffff80843604>] mlx5e_arfs_create_tables+0x44c/0x5d8
[<ffffffff80815bd6>] mlx5e_create_flow_steering+0x42/0x6bc
[<ffffffff808043e4>] mlx5e_init_nic_rx+0x84/0x14c
[<ffffffff80808a4c>] mlx5e_attach_netdev+0xb8/0x2e8
[<ffffffff8080f36e>] mlx5e_probe+0x48e/0x81c
Code: 89b3 40f9 e052 098e 7a7d a011 84be 3783 0109 97a6 (6398) 853a
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

The register dump shows a5 = 0, i.e. ft->g was read as NULL. Offset 16
of struct mlx5e_flow_table is ft->g, and the faulting instruction loads
from the address in a5, so the faulting access is the ft->g[0] read.

Note that the bug itself is not architecture specific. It is a plain
error path in C, and it is reachable on any architecture; the register
dump above is only from the machine on which it was hit.

4. How this was hit

This was found while testing a virtual mlx5 device whose firmware
answers host mailbox commands. The device took longer than the
firmware's own timeout to answer one CREATE_FLOW_GROUP command, so the
firmware reported the command as failed even though the device had
completed it. The host then took its error path, and the bug above
turned a command failure into a kernel panic.

That is only the trigger though, not the cause: the host oopses on any
error returned by CREATE_FLOW_GROUP, no matter where the error comes
from (a device that rejects the command, a resource shortage, a command
timeout, ...). A firmware that returns an error for the second
CREATE_FLOW_GROUP is enough to reproduce it.

A minimal reproduction is therefore: enable aRFS, and make the second
CREATE_FLOW_GROUP of one of the aRFS flow tables fail. The kernel
then calls mlx5e_destroy_flow_table() with ft->num_groups == 1 and
ft->g == NULL, and dereferences the NULL array.

5. The fix

The patch leaves the free of ft->g to the caller:
mlx5e_destroy_flow_table() frees ft->g exactly once, and also destroys
the flow groups that were created. This fixes the NULL pointer
dereference and the leak, while keeping the double free fixed.

For the three error paths of arfs_create_groups():

  ft->g     num_groups  what the caller does
  --------  ----------  ----------------------------------------
  NULL      0           kfree(NULL), no group to destroy
  non-NULL  0           kfree(ft->g), no group to destroy
  non-NULL  1           destroy the created group, then kfree(ft->g)

ft->g is therefore freed exactly once in all three cases, so the double
free that 3c6d5189246f fixed stays fixed.

The patch also makes the error handling of this function consistent
with the rest of the driver, e.g. mlx5e_create_l2_table().

6. Scope

The patch was reviewed against v7.4-rc2 and applies cleanly. The crash
itself was reproduced on a virtual mlx5 device; the patched kernel was
not booted, so this patch is not marked as tested.

---
v3:
  - Rework the commit message as suggested by Tariq Toukan: describe how
    the bug was found, on which device it was hit, that the fix is not
    tested, and add a trimmed oops.
  - Drop the sentence claiming consistency with mlx5e_create_l2_table().
    That was wrong: the L2 path frees ft->g itself, the opposite of
    what this patch does.
  - Return -ENOMEM directly when the allocation of "in" fails, instead
    of jumping to a label that frees a NULL "in".
v2:
  - Cc Simon Horman and Zhipeng Lu, who last touched the code being
    modified here. The netdev CI "cc_maintainers" check pointed this out.
    No change to the patch itself.
v1: https://lore.kernel.org/netdev/20261114144325.816-1-jinvas@126.com/

--

Jinvas (1):
  net/mlx5e: fix NULL pointer dereference in arfs_create_groups()

 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

base-commit: 20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca
-- 
2.28.0.windows.1

