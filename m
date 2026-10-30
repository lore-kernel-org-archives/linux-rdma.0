Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336045;
	b=W+S4qG7PFnotVrSbzVAr2AGEe1Vnv2soAWz5cpuXuOJWWRLrVSJunGbbpvFuKCKdfeeT
	 NSlPyjaO4oSf0z7Ktnov/ic9eemOnp2Sqz7HrKVAngZC+c9vh0j9AX/4GukxtUA9j9+bo
	 pHphB4NdL56wP1ptvJRyX0BMr0slfmr5cCEAU2qrM3NJwxkCvQIYqjGDmvJAmVdJ4/JyI
	 EXjotbQHyP11JvBlw3DWTTnfgz9fx9Y+b2PJvQ0COlUi78mVdxM2b2eDQQcCSwLO52UAq
	 V1nl+ZeoklDlvBYYP+j1Zw16MxKi3QZuCxyhC9gE/bIihjbqhUKcEri7RqoI5YBUOzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336045;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WZUqRIwrWV03ww6mCmoTaLg7G36LVvV1oA7ZJfK8ASY=;
	b=u5/xHR07zcFFTpYfZ13kNhY0QHMHnv5C7/uek1pLMjkj/lma88NoO6pm8SeajqjgdRBU
	 t8LBN5JydFIYwEpnzEtxHP7lVkFex0YAqkj5aAkfj11prO++f5LGXj+g4WwqLFpxDHm0D
	 T8hBPANcTcmaM6IO94/irsNo3d1o7xtjXAqMRtVbJu1NN7P/+o/lRYKQatw1xhO7bTlCv
	 XYzaNLb5FcweDIstOFH4m7HL4RDc/eOrYKp6Ng1pU0V0H82Nl3zW6v+kFdtg8i0QtWeyP
	 GsPnxu9GlWxCVjsKChAgRPfunhuSAPUim0gXSqvro88OblGTrZtSQAr2EYN7vC6xh+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecAWO65x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC8E606A329
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecAWO65x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6619E1F0093A;
	Fri, 30 Oct 2026 04:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336044;
	bh=WZUqRIwrWV03ww6mCmoTaLg7G36LVvV1oA7ZJfK8ASY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ecAWO65xSqaOmUOJm7wwdpmUdEj/wCwxMGf3L1PFyzc2VjXjPmJ85w7j3NNmZzkvg
	 AWJKUoqPf/dbNTHWapNNCLL/3lum2pQegsxVRRs1Fr1b6kmrJ8WDcvsi6EtGy6vtuk
	 uMaUhSJt1Dz1KGgMxuKgpKN/TCoOqsPS/AAEFDaxpKm3rQrhphLfSMraZbxmSPa8bc
	 zHQQp3Mi2DdFBOaj5rwL6nesAxxbapJ6M+5V9pF60LIH6Fn5FfxfeiLRIPh8CRNQtl
	 2smIT/U4jLMYbgYjtE7rsH9mL91HmDnAElmeSOiHMf1Xi3pfmN1ao24MAIYgkWsUqj
	 vTLCrs9STSZYQ==
Message-ID: <sashiko-outbox-190399@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 net-next 5/9] octeontx2-af: npc: cn20k: add subbank
 search order control
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ratheesh Kannoth" <rkannoth@marvell.com>, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260508034912.4082520-6-rkannoth@marvell.com>
References: <20260508034912.4082520-6-rkannoth@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing xa_erase() during search order update causes stale duplica=
te entries in tracking xarrays.
- [High] Missing error rollback in npc_cn20k_search_order_set() leaves inte=
rnal allocator structures in a permanently corrupted state.
- [Low] Format string mismatch in rvu_af_dl_npc_srch_order_validate() cause=
s potentially garbled logs.
--

commit 360483b7660f8774a4adf83ec93cc5565c7337b4
Author: Ratheesh Kannoth <rkannoth@marvell.com>

octeontx2-af: npc: cn20k: add subbank search order control

This commit adds a runtime parameter srch_order to control the search
order of MCAM subbanks during allocation in the octeontx2 driver. It
allows configuring the priority of the 32 subbanks for the CN20K NPC.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c b/driv=
ers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
> index e9aad0ad3fa68..6f8f42234b068 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
[ ... ]
> @@ -3906,6 +3906,56 @@ static void npc_unlock_all_subbank(void)
>  		mutex_unlock(&npc_priv.sb[i].lock);
>  }
> =20
> +int npc_cn20k_search_order_set(struct rvu *rvu,
> +			       u64 narr[MAX_NUM_SUB_BANKS], int cnt)
> +{
> +	struct npc_mcam *mcam =3D &rvu->hw->mcam;
> +	struct npc_subbank *sb;
> +	struct xarray *xa;
> +	int sb_idx, rc;
> +
> +	if (cnt !=3D npc_priv.num_subbanks) {
> +		dev_err(rvu->dev, "Number of entries(%u) !=3D %u\n",
> +			cnt, npc_priv.num_subbanks);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&mcam->lock);
> +	npc_lock_all_subbank();
> +	restrict_valid =3D false;
> +
> +	for (sb_idx =3D 0; sb_idx < cnt; sb_idx++) {
> +		sb =3D &npc_priv.sb[sb_idx];
> +
> +		xa =3D &npc_priv.xa_sb_free;
> +		if (sb->flags & NPC_SUBBANK_FLAG_USED)
> +			xa =3D &npc_priv.xa_sb_used;
> +
> +		sb->arr_idx =3D narr[sb_idx];
> +
> +		rc =3D xa_err(xa_store(xa, sb->arr_idx,
> +				     xa_mk_value(sb_idx), GFP_KERNEL));

If the new index assignment swaps indices between a free subbank and a used
subbank, is the old index in the original xarray ever overwritten?

Since xa_erase() is not called on the old arr_idx, this might leave the
subbank mapped at both its old and new arr_idx if they don't overwrite each
other.

Can this result in stale duplicate entries?

> +		if (rc)
> +			goto fail;

If xa_store() fails (for example, due to -ENOMEM from GFP_KERNEL) and retur=
ns
an error, the code jumps to the fail label. Are the successful modifications
made to previously processed subbanks rolled back?

If not, could this leave the system in a torn state where restrict_valid is
false, and some subbanks have updated indices while others keep their old
ones?

> +	}
> +
> +	for (int i =3D 0; i < cnt; i++)
> +		subbank_srch_order[i] =3D (u32)narr[i];
> +
> +fail:
> +	npc_unlock_all_subbank();
> +	mutex_unlock(&mcam->lock);
> +
> +	return rc;
> +}
[ ... ]
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/dr=
ivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
> index a42404e6db7cc..aa3ecab5ebd88 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
[ ... ]
> @@ -1619,12 +1620,83 @@ static int rvu_devlink_eswitch_mode_set(struct de=
vlink *devlink, u16 mode,
[ ... ]
> +static int rvu_af_dl_npc_srch_order_validate(struct devlink *devlink, u3=
2 id,
> +					     union devlink_param_value *val,
> +					     struct netlink_ext_ack *extack)
> +{
> +	struct rvu_devlink *rvu_dl =3D devlink_priv(devlink);
> +	struct rvu *rvu =3D rvu_dl->rvu;
> +	bool restricted_order;
> +	unsigned long w =3D 0;
> +	u64 *arr;
> +	u32 sz;
> +
> +	npc_cn20k_search_order_get(&restricted_order, &sz);
> +	if (sz !=3D val->u64arr.size) {
> +		dev_err(rvu->dev,
> +			"Wrong size %llu, should be %u\n",
> +			val->u64arr.size, sz);

The size field in devlink array values is a 32-bit unsigned integer (u32),
but the error message uses the %llu format specifier.

On some architectures, could this cause printk to consume 8 bytes from the
arguments and read garbage from adjacent memory?

> +		return -EINVAL;
> +	}
> +
> +	arr =3D val->u64arr.val;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508034912.4082=
520-1-rkannoth@marvell.com?part=3D5
