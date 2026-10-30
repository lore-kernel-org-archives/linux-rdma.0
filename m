Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336043;
	b=DT7etWe6iHDgtXz0MgahY1i50VBBcwXT1IOMLsM4sekxdrhAx3fdVA/I9RSzf9kRijfa
	 gO0r0v6+W3DjoxsgM1rRi031N4zKUpawXb3xyml6gKZqPU+Jdt7zYgfEQeWH584Ad3stJ
	 BGb4b02gb3c1HljMfoMLIzkr+ivzXqiMTTijPIsZQjhK78oj7ERQPRuCA1xqCroJGygcL
	 rmrX0x4A8HTojp6E2RcdGcDQ/R7YJSdGWY0clFXTmKwChkZvq26nDX12mIS3cVxuKsa91
	 8ss51Me8NXuEivyfdf+VuC0XPBi/15gS2Dz8cY5KRViwdCKtBYK0NY66Pk/6p2juqwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336043;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JRdsfpJ2IqxmA70DTVEZFY/7+VSmFcTF4f9qYMGtPIg=;
	b=m/GD2vPha8bUR3S8+/KnYV//kXB9D6jpnYrcYB596r6M+q7GpBv0HPuUKv7LfxRZSTDH
	 XP42kNYdy5mo04dLpdKc7tgJZRjuO/UFSrZBIHb8cn2jaF/+4LFYzN4JmsPSLsm1J94N2
	 E/A3WeuHNtMffGlOZeb6508FOQihVqaEggAZiSLwRYKVeV0S9Tnh+LZWQxYPLSzu5jU8a
	 MOeL8zITbdJkHYN0as0E4HSwVp/sWlTD+cDt1xzK/3jt03o2nUZuz9MGalvD4ScBLEazs
	 ScdPevRlIaJBfYGY54mBIcw5UpfbBAUvZUZ3ziPY8NoQ7UDTLbjKHFVrBPEk+V4ZCEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MOwF+Umb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD54D606A31E
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MOwF+Umb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CA41F000C1;
	Fri, 30 Oct 2026 04:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336042;
	bh=JRdsfpJ2IqxmA70DTVEZFY/7+VSmFcTF4f9qYMGtPIg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=MOwF+UmbfUlutLb7FP/KK8gX2TLqBXS7zCHESWoxQ5JPxOIF2FrYkxYygmaYMUxv9
	 mbs8UhUGy1B0Gm1FensBMWl2/RaLms285B3k3sF8FKO/ZlwFlzuwYl4VCS+tq/e0xy
	 Ssn6OHaol+/6/80aR90cH+2gJ8TmL8XAIgGSkg+GGY3NqOPNTooP8NHoKlLrV0wOyp
	 NcsoysExca/x7XcnRys2HvSC8Ih9CJHg71HsfeEVKYUUGG7PTcBF5aEc0pUDytTahz
	 iQ+4bitSFBCbtBl3uSU7qvl6WT95Ty+nXkwa2NIG8Xu479Aa4CXEVlsPMPAf/0mxr3
	 s5F9IGpXVVzKg==
Message-ID: <sashiko-outbox-190396@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 net-next 1/9] octeontx2-af: npc: cn20k: debugfs
 enhancements
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ratheesh Kannoth" <rkannoth@marvell.com>, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260508034912.4082520-2-rkannoth@marvell.com>
References: <20260508034912.4082520-2-rkannoth@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:02 +0000
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
- [Medium] High-order kmalloc via single_open_size() will fail due to memor=
y fragmentation.
- [Low] Unnecessary acquisition of `stats_lock` in `npc_mcam_mismatch_show(=
)`.
- [Low] Unreachable dead code in `npc_mcam_dstats_show()` due to confusing =
logic.
--

commit 90a879ef1db5083da555645f4bdb9581acc62dc8
Author: Ratheesh Kannoth <rkannoth@marvell.com>

octeontx2-af: npc: cn20k: debugfs enhancements

This commit improves MCAM visibility and field debugging for CN20K NPC.
It extends the mcam_layout debugfs entry, adds a dstats entry to report
recently hit MCAM indices, and adds a mismatch entry to list allocated
but unmapped entries.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c b/=
drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c
> index 6f13296303cb5..9a4c2ea5b19e4 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c

[ ... ]

> +#define DEFINE_OCTEONTX2_DEBUGFS_ATTRIBUTE_WITH_SIZE(__name, __size)		\
> +static int __name ## _open(struct inode *inode, struct file *file)		\
> +{										\
> +	return single_open_size(file, __name ## _show, inode->i_private,	\
> +				__size);					\
> +}										\
> +__OCTEONTX2_DEBUGFS_ATTRIBUTE_FOPS(__name)
> +
> +static DEFINE_MUTEX(stats_lock);
> +
> +static u64 dstats[MAX_NUM_BANKS][MAX_SUBBANK_DEPTH * MAX_NUM_SUB_BANKS] =
=3D {};
> +static int npc_mcam_dstats_show(struct seq_file *s, void *unused)
> +{

[ ... ]

> +			if (!stats)
> +				continue;
> +			if (stats =3D=3D dstats[bank][idx])
> +				continue;
> +
> +			if (stats < dstats[bank][idx])
> +				dstats[bank][idx] =3D 0;
> +
> +			pf =3D 0xFFFF;
> +			map =3D xa_load(&npc_priv->xa_idx2pf_map, mcam_idx);
> +			if (map)
> +				pf =3D xa_to_value(map);
> +
> +			if (stats > dstats[bank][idx])
> +				delta =3D stats - dstats[bank][idx];
> +			else
> +				delta =3D stats;

Is this else block reachable?

The loop previously skips to the next iteration if stats =3D=3D dstats[bank=
][idx].
If stats < dstats[bank][idx], the code sets dstats[bank][idx] to 0. Since
stats is also checked to be non-zero earlier, stats will always be strictly
greater than dstats[bank][idx] by the time it reaches this condition.

> +
> +			snprintf(buff, sizeof(buff), "%u\t%#04x\t%llu\n",
> +				 mcam_idx, pf, delta);
> +			seq_puts(s, buff);
> +
> +			dstats[bank][idx] =3D stats;
> +		}
> +	}
> +
> +	mutex_unlock(&stats_lock);
> +	return 0;
> +}
> +
> +/*  "%u\t%#04x\t%llu\n" needs less than 64 characters to print */
> +#define TOTAL_SZ (MAX_NUM_BANKS * MAX_NUM_SUB_BANKS * MAX_SUBBANK_DEPTH =
* 64)
> +DEFINE_OCTEONTX2_DEBUGFS_ATTRIBUTE_WITH_SIZE(npc_mcam_dstats, TOTAL_SZ);

Will this single_open_size() allocation reliably succeed on a running syste=
m?

Because single_open_size() uses kmalloc(), it requires a physically
contiguous memory block. TOTAL_SZ is the product of multiple maximum
hardware limits, which can be hundreds of kilobytes. This could result
in a high-order allocation that fails with an out of memory error due to
fragmentation.

Would standard seq_open() be safer here, as it allows the buffer to grow
dynamically using kvmalloc()?

> +
> +static int npc_mcam_mismatch_show(struct seq_file *s, void *unused)
> +{
> +	struct npc_priv_t *npc_priv;
> +	struct npc_subbank *sb;
> +	int mcam_idx, sb_off;
> +	struct rvu *rvu;
> +	char buff[64];
> +	void *map;
> +	int rc;
> +
> +	npc_priv =3D npc_priv_get();
> +	rvu =3D s->private;
> +
> +	seq_puts(s, "index\tsb idx\tkw type\n");
> +	mutex_lock(&stats_lock);

Does this function need to acquire stats_lock?

The stats_lock mutex protects the static dstats array during dstats_show.
This loop only reads npc_priv->en_map (which is manipulated safely via
atomic bitops) and xa_idx2pf_map (which uses internal XArray RCU for safe
lookups). It does not appear to access dstats or any other shared state
that requires this mutex.

> +	for (int bank =3D npc_priv->num_banks - 1; bank >=3D 0; bank--) {
> +		for (int idx =3D npc_priv->bank_depth - 1; idx >=3D 0; idx--) {
> +			mcam_idx =3D bank * npc_priv->bank_depth + idx;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508034912.4082=
520-1-rkannoth@marvell.com?part=3D1
