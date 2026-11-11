Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395616;
	b=fkB4ZQhZLSeIN9aEJVrnFrytqCJi3zhvbmbOBCXxxAlfsMe2XKhEUFuD7yZ2LUhIqOMQ
	 OcmgByECDqz1Gs9IF1KbJQxRG/NYLu/s5C8S6b4vUsCZALPIlT+v++wSnoZjIWF5teMu2
	 NizrZnA4lb/J12jEwVb+hcxQhA+8tgjUJp0SwGlf9ijfXnlb+iWQGlP+pJ1wlm4tzY1rv
	 RWlWYJYZb+aBBqE7X9810atUY5i7DbKnxU/nilFKH7YR+8Ji5+P18OelFy9Jm1mYgaC4m
	 CEJiAgJ7GcN1v6FwbRFh/maH99R25xFYtfOPrBkk82qXRWR1NLmUSwNcWR9BES/NKkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395616;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Dyvput64/sz4T8SMtoOhm7vN/EQSogyL5Xxg2DUY94E=;
	b=5Q5B1wvbj8disFXeIwStAJG/hN7lHGUalVS1QhaKlcQml2yUSLx7edtRAdvnbsHfm2OL
	 7Rw0Yu1HFEToZgBWWD0pgGLlrPtvl1eOYP42caQSnb9LU6Ulb3yN3u63DlcTilJ6eGb6S
	 gLezmDFppk/rQrjioBkxlqR2sBG8IrZXBRQ5HO+hkC8gthsMKtahQkEadg9iaPUMLw7NG
	 yf8z7gP4YJ6S/ZOjKUi1gKjWbhv6ZyoEUfP4dve+NkSukcqTCQ0MaQldLijwp7IqOheHa
	 9DSgYCtriwsNOid7TqXQZX+2064VZkgDfDj2f4PjJ/pl2V+vgKyodRmj2i1SUBQungw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="hKrzaW/4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E369B606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 11:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKrzaW/4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A1C1F00A05;
	Wed, 11 Nov 2026 11:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794395615;
	bh=Dyvput64/sz4T8SMtoOhm7vN/EQSogyL5Xxg2DUY94E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hKrzaW/49k6lw0AotrjMfCARaRR29hqPp9c3Js/BINsN5iLJ1/VQJcM7DGMa4EZWU
	 vAP+wuP5inHZrVClrdYarkKnpKK5dPY1GimDxYl2NcabUdt1ksNecLj5thtdPQ7F1k
	 156e/peOkcMIscQVlONmGhY0SpXyVFgZF19uo/6Qv9YbUhWBy7seNeLdHPqRVtciGv
	 XUn3HcF9LiiAhPcyXCOnw63VD6MX/3oe7E9RBb/ZXzR1LTkukamBaRm53iG9HB+B/R
	 cQwDLNl1hhq6tB+p5arvwl2MK039lL9qkweqn2mnvC0xW6Dya9DAWgxZ5KOfU4lDx8
	 +pqpSgtk1bZMg==
Message-ID: <sashiko-outbox-208858@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix UAF after DEVX DCT create failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111105346.3220427-1-lee@jaeyeong.cc>
References: <20261111105346.3220427-1-lee@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 11:13:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] RDMA/mlx5: uninitialized or uninserted mkey cleanup in
  devx_obj_cleanup()
- [Medium] RDMA/mlx5: uninitialized obj->obj_id on abort-commit in
  devx_obj_create
--

commit d3fab8d64df61af1d9b384a2ecf8764391f6c971
Author: Jaeyeong Lee <lee@jaeyeong.cc>

RDMA/mlx5: Fix UAF after DEVX DCT create failure

This commit calls uverbs_finalize_uobj_create() immediately after building
the DEVX destroy command and removes the local obj_destroy error path so
that uverbs abort cleanup handles subsequent failures.

> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index fc6f793dcc658..037c2b6ff9714 100644
> --- a/drivers/infiniband/hw/mlx5/devx.c
> +++ b/drivers/infiniband/hw/mlx5/devx.c
[ ... ]
> @@ -1613,10 +1612,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ=
_CREATE)(
>  	devx_obj_build_destroy_cmd(cmd_in, cmd_out, obj->dinbox, &obj->dinlen,
>  				   &obj_id);
>  	WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
> +	uverbs_finalize_uobj_create(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_HANDLE);
> =20
>  	err =3D uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT, cmd=
_out, cmd_out_len);
>  	if (err)
> -		goto obj_destroy;
> +		return err;
> =20
>  	if (opcode =3D=3D MLX5_CMD_OP_CREATE_GENERAL_OBJECT)
>  		obj_type =3D MLX5_GET(general_obj_in_cmd_hdr, cmd_in, obj_type);
> @@ -1625,18 +1625,10 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ=
_CREATE)(

[Severity: Medium]
Can returning on a uverbs_copy_to() failure leave obj->obj_id uninitialized
when rdma_alloc_abort_uobject() commits uobj?

If uverbs_copy_to() fails and hardware destruction in devx_obj_cleanup()
also fails, rdma_alloc_abort_uobject() commits uobj with obj->obj_id still
zero.  At file close, mlx5_ib_ufile_hw_cleanup() then reads a zero opcode
from get_dec_obj_type() and misses MLX5_OBJ_TYPE_QP objects during async
teardown, while MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT decodes both the object
type and ID as 0 and inserts event subscriptions into event_xa under the
wrong key.  Initializing obj->obj_id before uverbs_finalize_uobj_create()
avoids this.

>  	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
>  		err =3D devx_handle_mkey_indirect(obj, dev, cmd_in, cmd_out);
>  		if (err)
> -			goto obj_destroy;
> +			return err;
>  	}

[Severity: Medium]
Does calling uverbs_finalize_uobj_create() before devx_handle_mkey_indirect=
()
cause devx_obj_cleanup() to clean up an uninitialized or uninserted
obj->mkey?

devx_handle_mkey_create() sets DEVX_OBJ_FLAGS_INDIRECT_MKEY before the
command executes, whereas obj->mkey is only initialized and stored in
dev->odp_mkeys by devx_handle_mkey_indirect():

drivers/infiniband/hw/mlx5/devx.c:devx_obj_cleanup() {
	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY &&
	    xa_erase(&obj->ib_dev->odp_mkeys,
		     mlx5_base_mkey(obj->mkey.key)))
		mlx5r_deref_wait_odp_mkey(&obj->mkey);

If uverbs_copy_to() fails on an indirect mkey, devx_obj_cleanup() runs with
obj->mkey still zeroed: if key 0 is present in dev->odp_mkeys, xa_erase()
removes that unrelated entry and mlx5r_deref_wait_odp_mkey() underflows a
zero refcount_t and waits on an uninitialized wait_queue_head_t.  If
devx_handle_mkey_indirect() fails in mlx5r_store_odp_mkey(),
devx_obj_cleanup() likewise erases mlx5_base_mkey(obj->mkey.key) from
dev->odp_mkeys even though storing it failed, reintroducing the regression
fixed by 0da4d48d99df ("IB/mlx5: Fix bad flow upon DEVX mkey creation").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111105346.3220=
427-1-lee@jaeyeong.cc?part=3D1
