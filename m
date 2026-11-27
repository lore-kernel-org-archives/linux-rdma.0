Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795749062;
	b=z7Z94hTejZzgJtmLfyu9D5ml5VM547VOPSjl+4FsvTf1CAKxXfPGTM+dQ7oQ3Orc7YqP
	 nzqCK5mIYwY+by9KFqpT2WvtPF3s7nmOzuOxOKx9lmSlwlIsKWL7FQAXd18Dj9TrBOtxt
	 Ga0QD9Z/WkZX7WWvhnYsbLSRLbxBDLB8KjO6LgXf96HxhkpftoLzWNOnVDF+dPhipZhP5
	 sQP5G9QwIJmeVELJP0zeh3K/7VGsD+kMOrb7fFE0o/8AyoRiLH8noAuj5E0HRmI9FrQKU
	 glUlGS7bqyOpPSEDAV8E1eO5KY1w2S0+oI3cr9eya40iS3BVto/2EOSLedqKWV+/85A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795749062;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=wHp+e3aR7rIbxlOtPRoLgM0Yx1gXW62yOBOxxAW76U4=;
	b=SnLMn55W+4ysvbckcXTwiaYIAhFEhh9jkc38Q60+FyP7pg3N8YorizUw+dG+XUGnv9ch
	 WsPkUljb81nrsRv9wIVeo/G0klfBQSM3wj4Vqn3XAehlaCbcuPROL1WnQ5kUlMqLyGi5q
	 SL4kFKGdVlYkAY+/8qIv+SKjAoWOsp+tCgGElc3cChKKcvraG33CvyaN4pC2IHmYz0wo1
	 s0wrZ5XhWiyhFM2xlqVsG3MbQddTWIfTy5AdRq8TX07IOtNuKIRM0qrlUotD4zWaf/qA7
	 7gaAvGz/aGCNUvw2kP5c72nFbniLxbQFOJNjmZt1PeleRJSB6zOcwObylxLI1rKz/uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=A0VohSvt;
	arc=none smtp.remote-ip=109.224.244.22
Received: from mail-24422.protonmail.ch (mail-24422.protonmail.ch [109.224.244.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4121606A331;
	Fri, 27 Nov 2026 03:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4121606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=A0VohSvt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1795749059; x=1796008259;
	bh=wHp+e3aR7rIbxlOtPRoLgM0Yx1gXW62yOBOxxAW76U4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=A0VohSvtLu23ll3ZjmX5r8qh29efkxGFhyuGk5VrpwRCFslbOC+oIKWFOkfcUHsIZ
	 ay6VJH/oZfjZ3QnwWiaQ/33u/BOTLRkIw/BFHMjzU9ulEU81RAuU3U4DVrWvFL+Ilv
	 8PEN2QqXgAmgMlyQMljahLaEldvyMw/Aw7vtC+bB3bgUE014A9by0KvJF4qOIWDflH
	 UcEK4ezcxtGm3UDiMe3F1qbz2hl99ZbsdzXm0Ek0OKS/ItydKNW1Xs/b0Oj9yvQaOn
	 eqORRr91ZD2CE7zRDRxAlhg80T/BcVaqXX71xvtJBWfmAyqMtD9+J0G1DcRsKvDiZ+
	 lWs78ky5Mw5gQ==
Date: Fri, 27 Nov 2026 03:10:55 +0000
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3] RDMA/mlx5: Preserve DEVX objects after failed output copy
Message-ID: <179574905000.68536.2524255610860968331@jaeyeong.cc>
In-Reply-To: <20261122103715.51731-1-lee@jaeyeong.cc>
References: <20261111105346.3220427-1-lee@jaeyeong.cc> <20261115135123.GD42525@unreal> <20261122103715.51731-1-lee@jaeyeong.cc>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: f67b138fcdff37f68344eb7af0628cad44256252
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

A DEVX create command can succeed before indirect mkey registration or
copying the command output to userspace fails. The current unwind path
destroys the hardware object directly, ignores a destroy failure, and
frees struct devx_obj.

If the object cannot be destroyed, it remains live while its software
wrapper is gone. A later event or cleanup can then access the freed
wrapper.

Mark the uobject as containing a valid hardware object once all state
required by devx_obj_cleanup() is initialized. Return later errors
directly so the uverbs abort path runs devx_obj_cleanup(). If destruction
fails, rdma_alloc_abort_uobject() commits the uobject and keeps it alive
for another cleanup attempt at file close.

This also routes indirect mkey registration failures through the same
cleanup path and removes the duplicate manual unwind.

Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
Cc: stable@vger.kernel.org
Signed-off-by: Finder16 <nakamurajames123@gmail.com>
Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
---
Changes in v3:
- Finalize the uobject before indirect mkey registration and output copy.
- Route both failure paths through the uverbs abort cleanup.
- Remove the manual obj_destroy unwind.
- Describe the generic failed-destroy lifetime issue instead of relying on
  the DCT-specific reproducer.

 drivers/infiniband/hw/mlx5/devx.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5=
/devx.c
index 5ba783bc7f9b7..b6ba6d7aa5c8f 100644
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
@@ -1614,29 +1613,25 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_C=
REATE)(
 =09=09=09=09   &obj_id);
 =09WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
=20
-=09err =3D uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT, cmd=
_out, cmd_out_len);
-=09if (err)
-=09=09goto obj_destroy;
-
 =09if (opcode =3D=3D MLX5_CMD_OP_CREATE_GENERAL_OBJECT)
 =09=09obj_type =3D MLX5_GET(general_obj_in_cmd_hdr, cmd_in, obj_type);
 =09obj->obj_id =3D get_enc_obj_id(opcode | obj_type << 16, obj_id);
+=09uverbs_finalize_uobj_create(attrs,
+=09=09=09=09    MLX5_IB_ATTR_DEVX_OBJ_CREATE_HANDLE);
=20
 =09if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
 =09=09err =3D devx_handle_mkey_indirect(obj, dev, cmd_in, cmd_out);
 =09=09if (err)
-=09=09=09goto obj_destroy;
+=09=09=09return err;
 =09}
+
+=09err =3D uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT,
+=09=09=09     cmd_out, cmd_out_len);
+=09if (err)
+=09=09return err;
+
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

base-commit: 94e81a1f3ffabb388f7d0a9674bb1d3acc067e00
--=20
2.43.0


