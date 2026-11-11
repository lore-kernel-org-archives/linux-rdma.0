Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394442;
	b=FWByqdY2otyUFCSe6drn9Ljn0Y5XfH4kEG1dDNqnetI1VEGMnMUh6jKCcYBK0LeFHrXk
	 TcRZpfhDFNkzEDgwlIot9oEeWzTqJWI6ojm6LVfO1xoUCt+lQkaJsdHjesB2WSiQ4p4mb
	 fuavpqkJJAl79wVnQd7wUGybQs3oPYJqDNyiYK+QEUggsc6xboBjw9icFmBIiPbpLBjXB
	 e7m2wGC6roC8bl+E9JQ/j3KJyR3jUO/kwHCfavL+aiURkFe82VOA/Y8FCLOiutpRj+Wms
	 PvLO9dDFFYRnw8tYD0eyoZARbOn/IiYi7+ckwKOcrXb141pDSJjq7Pzrl9beYv/dlpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394442;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=iXFYm1rwpINzGOBrnIKYtrC/8IaweHvoD3rwqbZJT3w=;
	b=Ze5PeF5vE3bE9cnA3MDZTNEVkizXzBHE2fYBZSZwHNtDMqYFE88N7jWg/X97aXXxdpJn
	 E82mlhfS4WzYGMUvpMdmQkIO3uOln5HtQf98Z2cMdum0yovFw0rnXuOxdsYRANAOSFVWV
	 8n2xDD5BwJ6Wq/bpKn0p7w9F0fuFJWraPGfm8x5Rr2lMk36xj8wLbHLCmtZetEJzXPjSO
	 sKTzIb4xH6EqhqmrFIhd6N/JJwD89miaWmqBS4EHtebddP7zhAD77Li3u18CJD4QEplfS
	 a1q7xd9iPEdpmVkKn88PnBAC+TdDtgXQN39df8LnQ9e71Wb6O4vjLI0d+hFYCW5VTBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=nyOFvRuQ;
	arc=none smtp.remote-ip=185.70.43.17
Received: from mail-4317.protonmail.ch (mail-4317.protonmail.ch [185.70.43.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328D2606A337;
	Wed, 11 Nov 2026 10:54:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 328D2606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=nyOFvRuQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1794394438; x=1794653638;
	bh=iXFYm1rwpINzGOBrnIKYtrC/8IaweHvoD3rwqbZJT3w=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=nyOFvRuQ29bk1lrgmZExUrXRbNuK71Vqa7ubroVA1Ac5Jy5AaE6FaUlxKvcPib8q3
	 aXY47sBnzv5kTHAaP6QH5B98DwhS0KxhcV5RciyqRojxdx+MkD6NctAhgzVrxuBYl1
	 RFGPARs8ufw7CfQb9dFNPyOHqRrGD2/b9htBgYdbC54n5vo4OTVlVItUNpW+NR3KBO
	 sKw/kFKUgA2ekwCxMV89NUK/sJhtTdTUHrjBojEbnK6x49n3MSMpPsAWnDoX8PhzP/
	 8/2MCbhO8AawznbSk06Y0GGykJoQTAAsSpAoLKpDFcXaTMDpR3iv6TDiWzGDNiHA8J
	 YrCppiCU9vVxQ==
Date: Wed, 11 Nov 2026 10:53:54 +0000
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jaeyeong Lee <lee@jaeyeong.cc>, stable@vger.kernel.org
Subject: [PATCH] RDMA/mlx5: Fix UAF after DEVX DCT create failure
Message-ID: <20261111105346.3220427-1-lee@jaeyeong.cc>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: d781ec1a4076d205e8c9fc3bd603d023538d5b66
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The DEVX object create handler destroys and frees a hardware object itself
when copying the command output or setting up an indirect mkey fails.

For DCT objects, mlx5_core_destroy_dct() can fail while leaving the DCT in
qp_table.dct_xa. The error is ignored and the enclosing devx_obj is freed.
A later DCT_DRAINED event then loads the stale xarray entry and calls
complete() on freed memory.

Mark the uobject as holding a valid hardware object immediately after the
DEVX object is initialized. Let the uverbs abort path invoke
devx_obj_cleanup() for subsequent failures. If hardware destruction fails,
rdma_alloc_abort_uobject() commits the uobject instead of freeing it. This
keeps the object alive for cleanup at file close.

A KASAN QEMU reproducer that forces DRAIN_DCT to fail and delivers a
DCT_DRAINED event reports:

  BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave
  complete
  rsc_event_notifier

The issue was found with a static analysis tool. OpenAI Codex assisted with
reproducer validation and patch preparation.

Fixes: c5ae1954c47d3 ("IB/mlx5: Use mlx5 core to create/destroy a DEVX DCT"=
)
Cc: stable@vger.kernel.org
Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
---
 drivers/infiniband/hw/mlx5/devx.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5=
/devx.c
index fc6f793dcc658..037c2b6ff9714 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1535,7 +1535,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CRE=
ATE)(
 =09struct mlx5_ib_ucontext *c =3D rdma_udata_to_drv_context(
 =09=09&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
 =09struct mlx5_ib_dev *dev =3D to_mdev(c->ibucontext.device);
-=09u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 =09struct devx_obj *obj;
 =09u16 obj_type =3D 0;
 =09int err, err2 =3D 0;
@@ -1613,10 +1612,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_C=
REATE)(
 =09devx_obj_build_destroy_cmd(cmd_in, cmd_out, obj->dinbox, &obj->dinlen,
 =09=09=09=09   &obj_id);
 =09WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
+=09uverbs_finalize_uobj_create(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_HANDLE)=
;
=20
 =09err =3D uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT, cmd=
_out, cmd_out_len);
 =09if (err)
-=09=09goto obj_destroy;
+=09=09return err;
=20
 =09if (opcode =3D=3D MLX5_CMD_OP_CREATE_GENERAL_OBJECT)
 =09=09obj_type =3D MLX5_GET(general_obj_in_cmd_hdr, cmd_in, obj_type);
@@ -1625,18 +1625,10 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_C=
REATE)(
 =09if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
 =09=09err =3D devx_handle_mkey_indirect(obj, dev, cmd_in, cmd_out);
 =09=09if (err)
-=09=09=09goto obj_destroy;
+=09=09=09return err;
 =09}
 =09return 0;
=20
-obj_destroy:
-=09if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-=09=09mlx5_core_destroy_dct(obj->ib_dev, &obj->core_dct);
-=09else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
-=09=09mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
-=09else
-=09=09mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox, obj->dinlen, out,
-=09=09=09      sizeof(out));
 obj_free:
 =09kfree(obj);
 =09return err2 ?: err;

