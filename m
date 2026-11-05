Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894980;
	b=BjHaSeQfOe8FAarujgqDuGgeMYUPR4GAGO4v/ujbnTiZE8tWRLW/JlUh/hFQEAc3Khk/
	 zG3lLkH7J5Q8aHMwD11pc9Zy8M5X5dFVSsfQFh4cjkO9Oy4+Wzt0mrCMh7xhf7KUYKQSO
	 5hy2dt2Cvjdg5X25izpDvvOhUd/8GGJfZvvhYwYQP13q6vLFOLLx1dYz5CUBDhU0TCVCp
	 o9nUrvKyeZTycSKHaE2Bh2cbC069CNyF6D39+LvWlv4ejgq1jH5hv132kH3rha1VZkNqG
	 pYZtEG74AXrPborYx5tCas7j5lFEE66l1NiW98FIiZ5u5xknwLJEM+Dt/2iA455Eeqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894980;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JhxNhtKgUx4rf5QWiBGWpIU6hlg42wIe4BmPVg3td0s=;
	b=Gfmi7TcS89g+M5kgE8B4Sk+Y0JM3iq5pS7za9uVw8/jK1jWbYtrtrWbbvSZk7F8ffkCY
	 eVIl8RdeymV8hiRgDgI9Hx+QPXPZP7SnfP498OckRDaJ7LYDcPDteWLdKEbZppHEfs/xu
	 W32rljBZ3acjtAdxlHEy28YMNj/lUTMtk/SICOxuJHqLmX4WAA2oZqzFXIRt7ujEVGXbj
	 entB7AT/DhsBbjjs/EEmzbhiQfwquX4l7m58FXmc5jjnTeuCWinXe9wQLXU5C57+UAKGF
	 lPo97MqFen85x6HACnNS1lPWQCoVUpYztlD9BXh5eXNYpuNe6pSwZF/WnbrDFfJOkWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDCvUEf+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BF7606BEB1
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDCvUEf+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7511F0093A;
	Thu,  5 Nov 2026 16:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894979;
	bh=JhxNhtKgUx4rf5QWiBGWpIU6hlg42wIe4BmPVg3td0s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iDCvUEf+yz+KbgiB78ZAigXIh5RJEE0H7XaXywDsYwxT+7JCEwA+EObGRCGsgYOZT
	 bpg/5CWZcmxe/q5Si1SYioXLLaDOr46gGn+j453Ewzr6xiefQ5YDHinmchg8pfi5MY
	 LY+w4rh67i0GHoG6V/YKRASl1sthzCGS67o6X0cfW+zjoGZtyvFRQAA8xKRcogJtAI
	 GFo6vvHr4pYhzy2q0FQeYgES+uGvtkR9vGhwd6usQxIip7SitEaCXEQCr62ku5vmiV
	 5SFxwLugJxvXY81BqoiWU7NdXvRxGW59yIcVvFmPekLk0PTiShGXFWKMxVeegqtgFk
	 tMcsoaI0ZWXcw==
Message-ID: <sashiko-outbox-199437@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 15/15] RDMA/xsc: add RDMA counters and sysfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155726.37053-16-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155726.37053-16-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] RDMA/xsc: cast counter pointers to __be64 * in xsc_ib_get_hw_stats()
--

commit 9a3d01fb1064f09ed97cbe2bb05c71e3ed77198c
Author: Xin Tian <tianx@yunsilicon.com>

RDMA/xsc: add RDMA counters and sysfs

This commit adds the RDMA hw_stats callbacks to query per-function and
card-global statistics from firmware, and exposes the hca_type and hw_rev
sysfs attributes on the ib_device class device.

> diff --git a/drivers/infiniband/hw/xsc/counters.c b/drivers/infiniband/hw=
/xsc/counters.c
> new file mode 100644
> index 0000000000000..c29a5bf8007f1
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/counters.c
> @@ -0,0 +1,134 @@

[ ... ]

> +int xsc_ib_get_hw_stats(struct ib_device *ib_dev, struct rdma_hw_stats *=
stats,
> +		       u32 port_num, int index)
> +{
> +	struct xsc_core_device *xdev =3D to_xdev(ib_dev)->xdev;
> +	struct xsc_hw_stats_rdma stats_rdma;
> +	u8 *hw_stats;
> +	int ret;
> +	int i;
> +
> +	ret =3D xsc_ib_query_hw_stats_rdma(xdev, &stats_rdma);
> +	if (ret)
> +		return ret;
> +
> +	hw_stats =3D (u8 *)&stats_rdma.stats.pf_stats;
> +
> +	for (i =3D 0; i < stats->num_counters && i < XSC_NUM_PF_STATS; i++)
> +		stats->value[i] =3D
> +			be64_to_cpu(*(u64 *)(hw_stats + (uintptr_t)stats->descs[i].priv));
> +
> +	if (stats->num_counters > XSC_NUM_PF_STATS) {
> +		struct xsc_hw_global_stats_mbox_in gin =3D {};
> +		struct xsc_hw_global_stats_mbox_out gout =3D {};
> +
> +		gin.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_QUERY_HW_GLOBAL_STATS);
> +		ret =3D xsc_cmd_exec(xdev, &gin, sizeof(gin), &gout, sizeof(gout));
> +		if (ret || gout.hdr.status)
> +			return -EIO;
> +
> +		hw_stats =3D (u8 *)&gout.hw_stats;
> +		for (i =3D XSC_NUM_PF_STATS; i < stats->num_counters; i++)
> +			stats->value[i] =3D be64_to_cpu(
> +				*(u64 *)(hw_stats + (uintptr_t)stats->descs[i].priv));
> +	}

[Severity: Low]
In xsc_ib_get_hw_stats(), both loops cast the counter field address to
u64 * before passing the dereferenced value to be64_to_cpu().

In drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h, the counter
fields in struct xsc_hw_stats_rdma_pf and struct xsc_hw_global_stats_rdma
are declared as __be64. Passing a host-typed u64 expression to
be64_to_cpu() triggers Sparse endianness warnings (cast to restricted
__be64) when building with C=3D1.

Should these casts in xsc_ib_get_hw_stats() use (__be64 *) instead of
(u64 *)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D15
