Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834319;
	b=PGVwVYMvfr6Ojnow64UDh8xRewQ9cOLoUvjFfb6q4kr6rJDreTooOlLHZjrtN0DJsafl
	 I3AkWbxkQ2QbYHdCYB/sXHcK+TVtxYbdWn0c6Yw0XuUdgaSI7rha6Vq9mvqMUkq3ooIBS
	 XlT2jmM2j7imWT5Bp2xCxypwwdngy90H+zcmUX2onkEa02YGoHozBv24+nYrQpvK9zlT8
	 +mwD00rk8fBa0ohEtZmsRS+OVNrAJOUdoi1o8p/MD200vi5omJEzzSM1/ow1GWPXSOVWp
	 ixPUF1QLtSKfBtTHLtpBHAFQlUuFncgKB3CV0u+tEAjt6lH2xVUm3x7q0qutbZNNqhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834319;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=OwyQW54fp0yUdCPqTm4CKYT+tQvCkTtiN5jRuWjNPTY=;
	b=ERHrK0QzZTr4Y+40rpf+3MboGjGl4tzOVMIEeyGJApv5Q0pTzgc6/qxTLIDocfarZ5+Q
	 nE+NTwSDSR4YICdjm5iZbBdFHnlQVchPykZ6TqoUEAQpePaIoJdtksuZxi9s0PwBXzqs4
	 jJ//7U/B41jh4vckYPql5SalJC61eSaNvJBfDxgEBQzMJyLAxaLIsYx00sxyThFFRcIg+
	 tqofTAr/iwf8+bNWRiuRjTFEUw/rVpUAnDWKrWZdjYOYBBV5kHll1+NOQDlP94ROr4+w5
	 EatdvY/xkcClf6sUIGMr5Z+BVdbFbi3zPxfCA4TGaVeaK3ecM79eK/ppiq1mj5hp1xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=qTYPjAbU;
	arc=none smtp.remote-ip=220.197.31.6
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D201606A880;
	Mon, 16 Nov 2026 13:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D201606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=qTYPjAbU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ow
	yQW54fp0yUdCPqTm4CKYT+tQvCkTtiN5jRuWjNPTY=; b=qTYPjAbUABr7W3ZE6D
	XkHjadgw07G4xppYcQk1XhUwL193xJcneUaLSt3+IJTmxrS5wnfOt9GEwGKklQFS
	Yl9D8ikOwbNMCNQG6vaImhgyHAYAC8n/2Y08+szZndTh77VmD8lb6p+VfHvddnl1
	lOewSoacIJYof+fWxk1LUTXc8=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCkvCgD3HwFW__pqIFseDg--.45028S4;
	Mon, 16 Nov 2026 21:04:25 +0800 (CST)
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
Subject: [PATCH net v2 0/1] net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
Date: Mon, 16 Nov 2026 21:04:05 +0800
Message-Id: <20261116130406.1171-1-jinvas@126.com>
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
X-CM-TRANSID:QCkvCgD3HwFW__pqIFseDg--.45028S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Xr1xAw4kCw1xGr1kur48WFg_yoW7uFy7pr
	sxX3ZrKrs5JrW7Gws7A34Fq348AF4Syay5CF13K3yFkFs8Cr18JFWIg3yrZFy7CFZ5J347
	tr45Jw1YyFyDAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UUsqAUUUUU=
X-CM-SenderInfo: xmlq4tbv6rjloofrz/xtbBpRlvBmr6-1nxzwAA3d

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
v2:
  - Cc Simon Horman and Zhipeng Lu, who last touched the code being
    modified here. The netdev CI "cc_maintainers" check pointed this out.
    No change to the patch itself.
v1: https://lore.kernel.org/netdev/20261114144325.816-1-jinvas@126.com/

--

Jinvas (1):
  net/mlx5e: fix NULL pointer dereference in arfs_create_groups()

 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
-- 
2.28.0.windows.1

