Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795511758;
	b=PKEWClvQ/H/BPo0+FrUb5j7wgSzjNEoiN4mzKMS40V442ydZqY06qIESO7XrrhPkPCXt
	 SpVbFiCLCXgpC3FNaHU+j7JjB/u2dqiMHFzTHJnzDn8Yby/ox+d2ODf0wwRSo6VqV+buU
	 m8Beh0lE+xrK0LCyVc8QDg9gM7MI60mxqurtd5NupqiMfdMb8pQUkxZKwveU67zwGOqyv
	 yMXbdGlSaSQoXgd0cnHpa8lX5QPBikvyNRHWGLtv75CeXX0RiWF7UXRMKKyytL1nYLWqV
	 ukl5eG5BD3p0f5yEbM8M51DZeCSI6l97qCkEi+0/ycazqsY7nRvGdsE3z3wWMfl8U1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795511758;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=rAmNr0PvPZe5cozyWsymO5nmaJM/3KKINYWFnk/GZu4=;
	b=mD1h5a2YHtBSc9qEJHxHxCcXL8V7/vdAisFOqj2veYTvNFo/YbmuwAp3JR9M9SgrQOXz
	 Nh8MP0j/7/Mo04ro7lz4E/MUXZTrR7s5RLmEq7BUmDd50Fj83ark3UFa3QbfMBCP/EDFU
	 /6DsHzqd9rPYVMrp0XRzbKBBmy9g0rWVFG1BlqMzLoeFDUy53eTkmD2GGScR8aC5CB0cN
	 B0S5FSKgSOoilD0moXiP4+ID2a19w3RqkppPPQd7opX/BXlTeN4dVrIkQiNLUyjL+5Rp1
	 aoUHunoUUdt/0O3g23P3IASpQuogb4cy5TZtEHfKOEe2aE/bwSjUxbuipI3tKyz2ecg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=dHX9fK2g;
	arc=none smtp.remote-ip=220.197.31.9
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8791C606A32E;
	Tue, 24 Nov 2026 09:15:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8791C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=dHX9fK2g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=rA
	mNr0PvPZe5cozyWsymO5nmaJM/3KKINYWFnk/GZu4=; b=dHX9fK2gcsM1P0Ny0M
	EOXgmJnJ+wWZ2eewfXa9pYY8Gmsnv19kJzyJUDaXNRZafASNTlhr4uLSBfLtdNRO
	iAdYK5vHkW3arMRfeLHPEVZ5OIz7EAC0k3NrTL8lR19pBXzPrsRMsHEd1qFz1CEP
	t4rS3fYzj5UaCsQoHjxISW79k=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDXzz+hVQVrYLMcDQ--.60726S4;
	Tue, 24 Nov 2026 17:15:15 +0800 (CST)
From: Jin Qi <jinvas@126.com>
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
Subject: [PATCH net v4 0/1] net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
Date: Tue, 24 Nov 2026 17:14:54 +0800
Message-Id: <20261124091455.1714-1-jinvas@126.com>
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
X-CM-TRANSID:_____wDXzz+hVQVrYLMcDQ--.60726S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Xr1xAw4kCw1xGr1kur48WFg_yoWxGFW3pF
	43X3ZrKrs5JrW7Gws7Aw1Yqry8AF4fAay5GF13K3yFkF45Cr1xJFWIg3yrZFy7CFZ5J3sr
	trn8X34YyFyDAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zEbyCtUUUUU=
X-CM-SenderInfo: xmlq4tbv6rjloofrz/xtbBswOZMGsFVaMv+AAA3W

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

6. Scope

The patch was reviewed against v7.4-rc2 and applies cleanly. The crash
itself was reproduced on a virtual mlx5 device; the patched kernel was
not booted, so this patch is not marked as tested.

---
v4:
  - Repost with a real name as author and sign off, as requested by
    Jakub Kicinski. No change to the patch itself.
  - Add the Reviewed-by tags received on v3.
v3:
  - Rework the commit message as suggested by Tariq Toukan: describe how
    the bug was found, on which device it was hit, that the fix is not
    tested, and add a trimmed oops.
  - Drop the sentence claiming consistency with mlx5e_create_l2_table()
    from the commit message. That was wrong: the L2 path frees ft->g
    itself, the opposite of what this patch does.
  - Return -ENOMEM directly when the allocation of "in" fails, instead
    of jumping to a label that frees a NULL "in".
v2:
  - Cc Simon Horman and Zhipeng Lu, who last touched the code being
    modified here. The netdev CI "cc_maintainers" check pointed this out.
    No change to the patch itself.
v1: https://lore.kernel.org/netdev/20261114144325.816-1-jinvas@126.com/

--

Jin Qi (1):
  net/mlx5e: fix NULL pointer dereference in arfs_create_groups()

 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

base-commit: 8d7fe9885c62fc9a95bf55d9db244d9672a8aadc
-- 
2.28.0.windows.1

