Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336046;
	b=yUmzoTx1VIbQ+LN4e2lvYaZC3kAmS80FqduFmAzElCUOQjE3uz/44bc6KIOHE8xc3dmi
	 Zt8xdU4OHqtlFlt3Jhp3PxC0HrYMvfmGvEEf3OeLN1OXLXhICvCqMFzzHkRrhrnTpfHic
	 JsOk+RoOAoWynyJ3Jp89sK47p6FwwDUe8Of9jKHfwhkXWHKcYoEdYy1wNQsg27Sl6XycC
	 labLTqQq4v9eSgCgR/FHP7PS7tTL0BgqW1mMAQg+oRMZv/AGPqPnSHBGsv/lKWYVejtYX
	 wGxEPYnR8Y0DPjV3M4F6sAjrskuXOvUBF/QMirjz2saBD12BCGPAUOm8hw7w6hZWSyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336046;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lMJW8cai72jO0PLtgQZThN8PGr82BqFszCODZ+WLfWo=;
	b=a7A/u/ljegQ4ZtoDMz6xvJoK1UyhHz2a0RiQXHgRk842zd7QS8QyvnNwhJlI7ojiPlTx
	 rNFwnze4XgpkHXEAlkWbmTdvnP2v2SIGzOqT02Pcbpv0xw/v2dq3bTd6sYjnzSfbpafFx
	 w5GnWkbmNLRtZfKqYsRqxewARvFRj4gOH/vaZvvd1H1dqhtDRPY2BOYcysSR6ruYCm5Tu
	 oD8PNkgcUVfIMi4VpohoDlpHwKX0lxkVsGyRVq7aesKyksKbZ0nTWc0Tj83jcpVSqFlVO
	 dwEAPvmYiWHiFp4XE70vF+/CdhYueZX8knLVHixLjttneKMKcv0PbFyg5/1ZQJHEwNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kICIbNhh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CE4606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kICIbNhh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9751F00A02;
	Fri, 30 Oct 2026 04:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336045;
	bh=lMJW8cai72jO0PLtgQZThN8PGr82BqFszCODZ+WLfWo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=kICIbNhhsHGkkLNYvpCJGqaWx1t/MGt6swh3s1PSGjFBCNERBPMeROf9tuwcWxtM3
	 L+Qb2tbHRzgdmT1U5Vipe2uQfpuTTMfiAPK1GHswku0hbti0DZXB+y3zQ8626sEB3q
	 iJFlc6yKvxj8pX/0NVZm52rqO/jzc7YcP/kZNhjDROeEQ7pmpI2weBVEK2dOStYBU7
	 VycOrNMwTWLGCnm/rKBdnfautCIK9W2YcNF+NpfnmYxC+FwoRpVolHbSTTuSy6Mvce
	 YkuJvOdpjf8K2cN9AGetvw6F+KOAzAyccK8u8eXFrh4n5J1rKYGg2r4ptJYpOxOD1C
	 pYjH8tJ+/WpFQ==
Message-ID: <sashiko-outbox-190401@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 net-next 7/9] octeontx2-af: npc: Support for custom
 KPU profile from filesystem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ratheesh Kannoth" <rkannoth@marvell.com>, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260508034912.4082520-8-rkannoth@marvell.com>
References: <20260508034912.4082520-8-rkannoth@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Global Data Corruption and Data Race via shared static array
- [High] Integer underflow and missing bounds checks in legacy firmware par=
sers
- [High] Fragile firmware ABI heavily coupled to internal kernel structure =
size
- [High] Filesystem profile loading truncates KPU programming, breaking def=
ault parsing rules
- [Medium] Missing endianness conversion for u16 fields
--

commit c9233fb2ae7b0ce301cfbbff2b1cd306d7c325ba
Author: Ratheesh Kannoth <rkannoth@marvell.com>

octeontx2-af: npc: Support for custom KPU profile from filesystem

This commit provides a mechanism to load a custom KPU (Key Parse Unit)
profile directly from the filesystem at module load time.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/ne=
t/ethernet/marvell/octeontx2/af/npc.h
> index cefc5d70f3e49..c8c0cb68535c7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> @@ -265,6 +265,19 @@ struct npc_kpu_profile_cam {
>  	u16 dp2_mask;
>  } __packed;
> =20
> +struct npc_kpu_profile_cam2 {
> +	u8 state;
> +	u8 state_mask;
> +	u16 dp0;
> +	u16 dp0_mask;
> +	u16 dp1;
> +	u16 dp1_mask;
> +	u16 dp2;
> +	u16 dp2_mask;

Since the firmware image is little-endian, should these fields be defined as
__le16?

When they are accessed as host-order integers without le16_to_cpu() convers=
ion,
will this lead to incorrect packet parsing rules and silent data corruption=
 on
big-endian architectures?

[ ... ]

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/driver=
s/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> index 5fa9e1c7ae9fa..a0f97e683145f 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
[ ... ]
> @@ -1788,26 +1872,168 @@ static void npc_prepare_default_kpu(struct rvu *=
rvu,
>  	npc_cn20k_update_action_entries_n_flags(rvu, profile);
>  }
> =20
> -static int npc_apply_custom_kpu(struct rvu *rvu,
> -				struct npc_kpu_profile_adapter *profile)
> +static int npc_alloc_kpu_cam2_n_action2(struct rvu *rvu, int kpu_num,
> +					int num_entries)
> +{
> +	struct npc_kpu_profile_adapter *adapter =3D &rvu->kpu;
> +	struct npc_kpu_profile *kpu;
> +
> +	kpu =3D &adapter->kpu[kpu_num];
> +
> +	kpu->cam2 =3D devm_kcalloc(rvu->dev, num_entries,
> +				 sizeof(*kpu->cam2), GFP_KERNEL);
> +	if (!kpu->cam2)
> +		return -ENOMEM;
> +
> +	kpu->action2 =3D devm_kcalloc(rvu->dev, num_entries,
> +				    sizeof(*kpu->action2), GFP_KERNEL);

Will this cause data corruption and a use-after-free across devices?

In npc_prepare_default_kpu(), the device's profile->kpu pointer is initiali=
zed
to point to the statically defined npc_kpu_profiles global array.

Here, we are assigning device-scoped devm_kcalloc memory directly into this
globally shared array. If multiple RVU devices probe concurrently, they mig=
ht
data-race on this shared state. Additionally, upon device unbind, devres wi=
ll
free the memory, leaving dangling pointers in the global array.

[ ... ]
> +static int npc_apply_custom_kpu_from_fw(struct rvu *rvu,
> +					struct npc_kpu_profile_adapter *profile)
>  {
>  	size_t hdr_sz =3D sizeof(struct npc_kpu_profile_fwdata), offset =3D 0;
> +	const struct npc_kpu_profile_fwdata *fw;
>  	struct npc_kpu_profile_action *action;
> -	struct npc_kpu_profile_fwdata *fw;
>  	struct npc_kpu_profile_cam *cam;
>  	struct npc_kpu_fwdata *fw_kpu;
> -	int entries;
> -	u16 kpu, entry;
> +	int entries, entry, kpu;
> =20
> -	if (is_cn20k(rvu->pdev))
> -		return npc_cn20k_apply_custom_kpu(rvu, profile);
> +	fw =3D rvu->kpu_fwdata;
> +
> +	for (kpu =3D 0; kpu < fw->kpus; kpu++) {
> +		if (rvu->kpu_fwdata_sz < hdr_sz + offset) {
> +			dev_warn(rvu->dev,
> +				 "Profile size mismatch on KPU%i parsing\n",
> +				 kpu + 1);
> +			return -EINVAL;
> +		}
> +
> +		fw_kpu =3D (struct npc_kpu_fwdata *)(fw->data + offset);
> +		if (fw_kpu->entries > KPU_MAX_CST_ENT)
> +			dev_warn(rvu->dev,
> +				 "Too many custom entries on KPU%d: %d > %d\n",
> +				 kpu, fw_kpu->entries, KPU_MAX_CST_ENT);
> +		entries =3D min_t(int, fw_kpu->entries, KPU_MAX_CST_ENT);
> +		cam =3D (struct npc_kpu_profile_cam *)fw_kpu->data;
> +		offset +=3D sizeof(*fw_kpu) + fw_kpu->entries * sizeof(*cam);

Is there a missing bounds check here for negative values?

Since fw_kpu->entries is read as a signed int, a malicious firmware blob
providing a negative value (e.g., -1) could cause the offset calculation to
underflow the unsigned size_t offset.

This would wrap the offset backwards, allowing the boundary check
(rvu->kpu_fwdata_sz < hdr_sz + offset) to incorrectly pass in the next
iteration, resulting in an out-of-bounds access.

[ ... ]
> +static int npc_apply_custom_kpu_from_fs(struct rvu *rvu,
> +					struct npc_kpu_profile_adapter *profile)
> +{
> +	size_t hdr_sz =3D sizeof(struct npc_kpu_profile_fwdata), offset =3D 0;
> +	const struct npc_kpu_profile_fwdata *fw;
> +	struct npc_kpu_profile_action *action;
> +	struct npc_kpu_profile_cam2 *cam2;
> +	struct npc_kpu_fwdata *fw_kpu;
> +	int entries, ret, entry, kpu;
> =20
>  	fw =3D rvu->kpu_fwdata;
> =20
> +	/* Binary blob contains ikpu actions entries at start of data[0] */
> +	profile->ikpu2 =3D devm_kcalloc(rvu->dev, 1,
> +				      sizeof(ikpu_action_entries),
> +				      GFP_KERNEL);
> +	if (!profile->ikpu2)
> +		return -ENOMEM;
> +
> +	action =3D (struct npc_kpu_profile_action *)(fw->data + offset);
> +
> +	if (rvu->kpu_fwdata_sz < hdr_sz + sizeof(ikpu_action_entries))
> +		return -EINVAL;
> +
> +	/* The firmware layout does dependent on the internal size of
> +	 * ikpu_action_entries.
> +	 */
> +	memcpy((void *)profile->ikpu2, action, sizeof(ikpu_action_entries));
> +	offset +=3D sizeof(ikpu_action_entries);

Will this create a fragile firmware ABI coupled to the internal kernel
structure size?

Because ikpu_action_entries is a kernel-internal static array, its size
depends on the number of port kinds (NPC_MAX_PKIND) defined in the specific
kernel version compiling it.

If future kernel versions add elements to this array, the parser will expec=
t a
larger initial block than the firmware file actually provides. This would
misalign all subsequent read offsets, causing the driver to interpret garba=
ge
memory.

[ ... ]
> +static int npc_load_kpu_profile_from_fs(struct rvu *rvu)
> +{
> +	struct npc_kpu_profile_adapter *profile =3D &rvu->kpu;
> +	const char *kpu_profile =3D rvu->kpu_pfl_name;
> +	const struct firmware *fw =3D NULL;
> +	int ret, fw_kpus =3D 0;
> +	char path[512] =3D "kpu/";
> +
> +	if (strlen(kpu_profile) > sizeof(path) - strlen("kpu/") - 1) {
> +		dev_err(rvu->dev, "kpu profile name is too big\n");
> +		return -ENOSPC;
> +	}
> +
> +	strcat(path, kpu_profile);
> +
> +	if (request_firmware_direct(&fw, path, rvu->dev))
> +		return -ENOENT;
> +
> +	dev_info(rvu->dev, "Loading KPU profile from filesystem: %s\n",
> +		 path);
> +
> +	rvu->kpu_fwdata =3D fw->data;
> +	rvu->kpu_fwdata_sz =3D fw->size;
> +
> +	ret =3D npc_apply_custom_kpu(rvu, profile, true, &fw_kpus);
> +	release_firmware(fw);
> +	rvu->kpu_fwdata =3D NULL;
> +
> +	if (ret) {
> +		rvu->kpu_fwdata_sz =3D 0;
> +		dev_err(rvu->dev,
> +			"Loading KPU profile from filesystem failed\n");
> +		return ret;
> +	}
> +
> +	rvu->kpu.kpus =3D fw_kpus;
> +	profile->kpus =3D fw_kpus;

Does this truncate the hardware programming loop in npc_parser_profile_init=
()?

By explicitly updating profile->kpus to fw_kpus, the hardware programming l=
oop
will only configure up to fw_kpus. Since all KPUs are disabled at the begin=
ning
of npc_parser_profile_init(), the remaining hardware KPUs will be left
completely disabled, breaking network parsing for traffic reliant on default
KPU logic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508034912.4082=
520-1-rkannoth@marvell.com?part=3D7
