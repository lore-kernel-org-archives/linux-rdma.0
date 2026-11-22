Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795343847;
	b=5cNu3q+rSxmlwsK0TrCgIVKaCLj3aDG2p9kbMoNS//0qhegVZMUWMrjP6xAuJhJadqOt
	 ApQz+pqCJ1BI3GiEMq+D6bTrlYBIkq9/F+K2UKUGgVgtstO2LOCrMG0xKu3rQ3HkIgv79
	 aVf4CGgDiQZr74Pl5hKINdM8QYfzmD110Dh7RPa2DBWzT989xqyrogtrevkfAu3LiyBYY
	 1M6eLcqww20WoNErilKr4NbcyWGbtpQWN+XHqW2mxpNes9OaXQPbWhkkSaDDfg4obCUIL
	 wGdWLOvkTtFrLyUQoDGYrRlRI+0qY+dQ2Y5knIkTZ/jBUh5vdyOJ332wGkH7+A+K50g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795343847;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=rR8mVZg1RTbtY+DPUPqTofyFY6a0VQAk2vhrLev7VdY=;
	b=DEE7KRwsP0AsFlbOHNYzmXaWPboDF1ef8/yLufUvNn2P04G18Sq4rpFJ4+Kw2NnL9xo7
	 oimU+WlDtnSU/myDaGXwNJjxirqbCsUWbYuhHDl0hXvtpdk0nbMHm+Wxra3Vmv9m/PDOh
	 i7cYC1EOged6R2HcBL85rzPjERAhzSoc0VJfK9n6RMbfBQ3fgBiWWJt6NJDGqqObz0voo
	 QB168DEQ81bZRbiJVOglTQjTHTXoiHXjhO+TRpxJ7KdSxFIGHijfFND7jCV7flgl+KFv8
	 MXrQJEGWMg1YTfeGaTqhqF0hIcsvh8COSLRDyOZo4fdy/RWTWKQaA9zxgTNbRm5j9Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=ihRz5VLQ;
	arc=none smtp.remote-ip=109.224.244.22
Received: from mail-24422.protonmail.ch (mail-24422.protonmail.ch [109.224.244.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA300606A32C;
	Sun, 22 Nov 2026 10:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA300606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=ihRz5VLQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1795343844; x=1795603044;
	bh=rR8mVZg1RTbtY+DPUPqTofyFY6a0VQAk2vhrLev7VdY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ihRz5VLQMFyA8VfbjCeqdmYl/lu4GHmlUZbPenBX4RdduWaPFRyjC1CkZuP55qmtV
	 b/hinkPDcyy9k2tUJrHQ9d1/DRJTCG6knT+fBAccmAmpNIZF6K6ZzPP+hwhcMqJ8DO
	 nmWBi6/aW5NLTy85ZKpS5Sl9dJI+bySmobX2YZwYs1YzKF2M6H98TJ8tGm2czY2oop
	 a2iIMv0Dvm8VvB4SPhuZ+nevuMezRy1G5Tshep3B5nxzw6FmQ/SOc8RPn7o3ViuuVr
	 xiEGTjZSudp/4folDeM9NxPmaJIT4RNd0qNibv3fL27iDTU+dAlRCDoCCQOClNJiil
	 nilVs6rJTvu0w==
Date: Sun, 22 Nov 2026 10:37:21 +0000
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] RDMA/mlx5: Preserve DEVX objects after failed output copy
Message-ID: <20261122103715.51731-1-lee@jaeyeong.cc>
In-Reply-To: <20261115135123.GD42525@unreal>
References: <20261111105346.3220427-1-lee@jaeyeong.cc> <20261115135123.GD42525@unreal>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: 74f9f4dc1e82908e201ed1dabfc4e3b3c26b5def
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

A DEVX create can successfully create and publish a hardware object
before uverbs_copy_to() returns an error. The error path currently
destroys the object directly and frees struct devx_obj without checking
whether destruction succeeded.

This is unsafe for DCTs. mlx5_core_destroy_dct() returns immediately if
the DRAIN_DCT command fails, leaving core_dct in qp_table.dct_xa. A later
DCT_DRAINED event retrieves the stale entry and completes the embedded
completion after devx_obj was freed.

The failure was reproduced by forcing DRAIN_DCT to fail and then
delivering a DCT_DRAINED event:

  BUG: KASAN: slab-use-after-free in complete+0x1a7/0x1b0
  Write of size 4 at addr ffff88800b112ca8 by task insmod/77
  Call Trace:
   complete+0x1a7/0x1b0
   rsc_event_notifier+0x1fc/0x410
   init_module+0x454/0xff0 [mlx5_dct_repro]

Initialize the object ID and indirect mkey bookkeeping before marking
the uobject as holding a valid hardware object. Mark it valid immediately
before copying the output. On a copy failure, the uverbs abort path now
invokes devx_obj_cleanup(). If destruction fails,
rdma_alloc_abort_uobject() commits the uobject, keeping its wrapper alive
for another cleanup attempt at file close.

Keep the direct unwind path for indirect mkey setup failures because
those occur before the uobject is marked valid. This avoids running
generic cleanup against partially initialized mkey bookkeeping.

The issue was found by NSCV static analysis.

Fixes: c5ae1954c47d3 ("IB/mlx5: Use mlx5 core to create/destroy a DEVX DCT"=
)
Cc: stable@vger.kernel.org
Signed-off-by: Finder16 <nakamurajames123@gmail.com>
Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
---
Changes in v2:
- Include the KASAN reproducer trace and describe the failed DCT destroy
  path.
- Initialize obj_id and indirect mkey state before finalizing the uobject.
- Keep the direct unwind path for failures before uobject finalization.

 drivers/infiniband/hw/mlx5/devx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5=
/devx.c
index 5ba783bc7f9b7..fd41104fe42fe 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1614,10 +1614,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CR=
EATE)(
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
@@ -1627,6 +1623,14 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CR=
EATE)(
 =09=09if (err)
 =09=09=09goto obj_destroy;
 =09}
+
+=09uverbs_finalize_uobj_create(attrs,
+=09=09=09=09    MLX5_IB_ATTR_DEVX_OBJ_CREATE_HANDLE);
+=09err =3D uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT,
+=09=09=09     cmd_out, cmd_out_len);
+=09if (err)
+=09=09return err;
+
 =09return 0;
=20
 obj_destroy:

base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed
--=20
2.43.0


