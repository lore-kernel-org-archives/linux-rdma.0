Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336047;
	b=OLZ2Fp5oWIiXJaJvrnpEbJ2KVyKvdpZehQAsi+ulMJaDgWsKZsrgmS6r6TdW9fcHDGoN
	 A55OJnuFFvmPyQ5YFdRappI2PdMtA1zvRkZIy3xPKTF1aVyBrmhcKRh2r2YkzseS+jPbz
	 aZejL7nfajZJ7Rvk4bv7S52YesZN5XmvzswB4A44bSIRm/Ie28RHhcxXYuV70pNprDv5F
	 j0A23RS25pxuJsXfBDCiho59lQI/WESFXQK3Dvxy/29scv2FBtpqKiAS3c5vWW5gtgWCX
	 ZkmquebQyEBzR9wrTmnD1HHINkttaIcyzim7llBWAGJ4u+hU4NairjKk3HgLnj9ipnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336047;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mFlnYRXt6kkYCz7qLsrR0bZ97Ul4eAtWvFF8Ha2RNnM=;
	b=tb7dBz9jgHCoQo3PdRCr2h8YfZvSHDJ5A93/CDuUYnv5mDqTTrrfQmW3Y4QZX7FZti2b
	 VWjC0sBWb4DKU5Y3mX7t2u1MFFBluuDcB5cpRtZUtbQ2mGdSD3UE/I1rjBPfW0GxZNroI
	 soF5IcnVNoaq/n1wBSXz4zAhZwSeatlE9hvK4RNSvXvGP3zcLEOVKEN6pwL/Lyb9vnArM
	 8FH/ZXp1hK0SjD0s4/iOh+6C7MadynMKGeQGLYNtTUwRnAwW73JQPMtESOvjc9bbE2aBj
	 suIJQLT6ndiNobX8Ub+/pSZecVvch1RLMvvkyMLyGTZk8e7zpZE/MJMkcEEBRhmTmmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XW00FVnK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2999606A325
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XW00FVnK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBF81F000C1;
	Fri, 30 Oct 2026 04:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336046;
	bh=mFlnYRXt6kkYCz7qLsrR0bZ97Ul4eAtWvFF8Ha2RNnM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=XW00FVnKmO1yj/aznMw3gJLEtGfaOiQxNdlwyaAHP7vW8fX8dSjpzACFeDkR8ICef
	 dZq0OCKiAwd471ceSdjMqTU0VejXqUECLVetN772mYgzWee7W6ufAJwm6LTjmdF1Jd
	 +XsQWH3z7ftDvBd2rmTPyq34R5C4phqlkKr//mfTYrv1bh9x+E25G2Pk3DNzKO6pCT
	 3hqt39qFZfNVEwC1tAsN2fAArzRoNguotUmtVCZnl/eMKOl916R2LuVg9Ha3cBmb4V
	 sNdW/Oao5pGHq5kOEEC1G9+eFw1yvqh7HYtOnbi4THKiZTXXHk++xI50irIvHRiq6m
	 WpGopReSr+4ZA==
Message-ID: <sashiko-outbox-190402@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 net-next 8/9] octeontx2: cn20k: Respect NPC MCAM
 X2/X4 profile in flows and DFT alloc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ratheesh Kannoth" <rkannoth@marvell.com>, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260508034912.4082520-9-rkannoth@marvell.com>
References: <20260508034912.4082520-9-rkannoth@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The primary default rule allocation still hardcodes X2 keys and un=
masked reference indices, completely ignoring the X4 hardware profile for P=
Fs and successful VF attempts.
- [Medium] Caching device-specific hardware profile information in a global=
 static variable causes a data race across concurrent device instances.
--

commit 0a14e92cf2754f6d4cb9d8447914740b55c1a43e
Author: Ratheesh Kannoth <rkannoth@marvell.com>

octeontx2: cn20k: Respect NPC MCAM X2/X4 profile in flows and DFT alloc

This commit updates the default CN20K NPC rule allocation and flow-install=
=20
path to respect the active MCAM keyword width, dynamically selecting X2 or =
X4=20
and masking reference indices accordingly. It caches the profile informatio=
n=20
on the PF.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c b/driv=
ers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
> index 67dfbe5ca903f..15b3f29d60ee9 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
> @@ -4467,11 +4467,18 @@ int npc_cn20k_dft_rules_alloc(struct rvu *rvu, u1=
6 pcifunc)
>  	 * as NPC_DFT_RULE_PRIO - 1 (higher hw priority)
>  	 */
>  	req.contig =3D false;
> -	req.kw_type =3D NPC_MCAM_KEY_X2;
>  	req.count =3D cnt;
>  	req.hdr.pcifunc =3D pcifunc;
>  	req.ref_prio =3D NPC_MCAM_LOWER_PRIO;
> -	req.ref_entry =3D eidx + 1;
> +
> +	if (npc_priv.kw =3D=3D NPC_MCAM_KEY_X4) {
> +		req.kw_type =3D NPC_MCAM_KEY_X4;
> +		req.ref_entry =3D eidx & (npc_priv.bank_depth - 1);
> +	} else {
> +		req.kw_type =3D NPC_MCAM_KEY_X2;
> +		req.ref_entry =3D eidx;
> +	}
> +

Does the initial allocation attempt unconditionally hardcode X2 keys?

Looking at the code just above this fallback path in
npc_cn20k_dft_rules_alloc(), the primary allocation hardcodes the key type:

    req.contig =3D false;
    req.ref_prio =3D NPC_MCAM_HIGHER_PRIO;
    req.ref_entry =3D eidx;
    req.kw_type =3D NPC_MCAM_KEY_X2;
    ...
    ret =3D rvu_mbox_handler_npc_mcam_alloc_entry(rvu, &req, &rsp);

If this first attempt succeeds, VFs might incorrectly get assigned X2 rules
on X4 silicon. Since PFs bypass the fallback path entirely if this fails,
will PF default rule allocation fail completely on X4 profiles?

[ ... ]

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/dr=
ivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> index 38cc539d724d8..5dd0591fed999 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> @@ -37,14 +37,13 @@ static void otx2_clear_ntuple_flow_info(struct otx2_n=
ic *pfvf, struct otx2_flow_
>  	flow_cfg->max_flows =3D 0;
>  }
> =20
> -static int otx2_mcam_pfl_info_get(struct otx2_nic *pfvf, bool *is_x2,
> -				  u16 *x4_slots)
> +static int otx2_mcam_pfl_info_get(struct otx2_nic *pfvf, u16 *x4_slots, =
u8 *kw_type)
>  {
>  	struct npc_get_pfl_info_rsp *rsp;
>  	struct msg_req *req;
>  	static struct {
>  		bool is_set;
> -		bool is_x2;
> +		u8 kw_type;
>  		u16 x4_slots;
>  	} pfl_info;

Does caching this profile information in a static structure cause a data
race across concurrent device instances?

The accesses to this shared cache are protected by mutex_lock(&pfvf->mbox.l=
ock).
Since this is a per-device instance lock, multiple network devices could
concurrently acquire their own independent locks and read or write the shar=
ed
pfl_info structure.

Could this lack of synchronization lead to torn reads, such as reading x4_s=
lots
as 0 if the compiler reorders the write to is_set before x4_slots?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508034912.4082=
520-1-rkannoth@marvell.com?part=3D8
