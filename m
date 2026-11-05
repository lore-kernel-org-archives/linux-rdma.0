Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894972;
	b=FQl1og927890qerQ8fMmCR6/NGQyO3oinGqM2vQATGDfv7PkWKtpQinXJ4Pso8Y4bUEp
	 uod4Qre7IV+ae99MBmB6oAjFEFUXPI4mShDWuLRvWq0BJyCPcyoVppksEMI+vJGfJ6Lmc
	 8jabUVD2adKLgO7bCykint1iKCVSGxf82pSG3+QBZQxikrCt5NxqWqjqYv3hX5RRuzji8
	 0nuLbxxzjUGJ6HIhFWclXUAAukUKJemB5jnmfXOJEayuClICot8TKhzIpjBUBVs+oUhFR
	 4yT1liPkaXyKya0+PpsBHM2v6j8M5V51KMXF4kwGE42Ofz/W6yH4LjzkJg4Dad4h9OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894972;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C8mjm36iDdA0dTDrIAMEQInkn2rrmlsNbLzRuavYHpc=;
	b=UAwQ1Ys8/rRNRzzUxcWt5rQDNXCY6CQeMqqSaDz6MvAPw0bTfaOzYrfykPcBbvui3oJo
	 0PIQkJS3Ka1HSJpNpxZCGi2xvzq/GXjjJF70BYOoQmOhKClIZmwhMZ7Me7wsLX/0Tj5Tq
	 GdqU825Lcr43FBiBgJ5hIZfmTmMHENzuAwQ7NBOFbJ3KoHqe/rSIn9rsSSJgHXhGvJp7W
	 AHomPbA6p/zvsGyR24ciXfWPP3m3J8kge15xRvRqBbcu/YtIgjMWZt/pwRUE/Ws8dh64q
	 d0VLCju7j17EkXC2JHR3rBvHMPK4/2RmuIoEWFU3pOI14gruQqaxkZFaOAn8AfrXATA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbU7snGv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD426606A328
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbU7snGv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE951F00919;
	Thu,  5 Nov 2026 16:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894971;
	bh=C8mjm36iDdA0dTDrIAMEQInkn2rrmlsNbLzRuavYHpc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bbU7snGvyMj0OLVwzFimUlyG6LSWCfC1FNiOrdHE6nWfTkO/iT5PsTp//j6yL0hTw
	 hj5xQo7WkScuByINq6xehA60FethKDCy1IP32u1zg23juVIQMlr/CZxR33IB6MK1GV
	 yJrGpTR8oTEkt0Qf9sRKs39EEAIuOBa+KSnD23BFi+07ruLv2h8wutVmlr6zqLQIDB
	 oZmmHv+oQ9qEy5wrkGcAIstOZsL85v+NtSSoeovwKKzwJqxYV0I2msrVOhbuVAyevq
	 RyQwAskAPHwucYE1ott1nxCbkBfMH5r1zpxyHshuX7UniwW/+fztAve/pjvHWmijmR
	 Tb7Orvq4ke8Pw==
Message-ID: <sashiko-outbox-199424@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 02/15] net/xsc: add PCI core driver skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155653.37053-3-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155653.37053-3-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:30 +0000
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
- [Medium] net/xsc: endian-dependent bitfields in struct xsc_query_vport_st=
ate_out
--

commit b11d75eddf1256b25caffaed37629ef47a9f6953
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add PCI core driver skeleton

This commit adds the PCI core driver skeleton and common firmware interface
headers for Yunsilicon XSC controllers. It implements basic PCI device
probing, BAR mapping, DMA configuration, and core device resource allocatio=
n.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h b/drive=
rs/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
> new file mode 100644
> index 0000000000000..70dbf9782f318
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
[ ... ]
> +struct xsc_query_vport_state_out {
> +	struct xsc_outbox_hdr	hdr;
> +	u8			admin_state:4;
> +	u8			state:4;
> +};
> +
> +struct xsc_query_vport_state_in {
> +	struct xsc_inbox_hdr	hdr;
> +	__be32			data0;
> +#define XSC_QUERY_VPORT_OTHER_VPORT	BIT(0)
> +#define XSC_QUERY_VPORT_VPORT_NUM_MASK	GENMASK(16, 1)
> +};

[Severity: Medium]
In struct xsc_query_vport_state_out, admin_state and state are defined as
unguarded 4-bit C bitfields within a byte populated directly from the
firmware DMA response mailbox via xsc_core_query_vport_state() ->
xsc_cmd_exec() -> xsc_copy_from_rsp_msg().

On big-endian architectures, the compiler reverses the bit order of these
two 4-bit fields relative to little-endian architectures. When
xsc_core_query_vport_state() reads out.state, won't it read the admin_state
nibble instead of the operational vport state nibble on big-endian hosts?

Should struct xsc_query_vport_state_out use a plain u8 field with GENMASK()
and FIELD_GET(), similar to how struct xsc_query_vport_state_in defines
XSC_QUERY_VPORT_OTHER_VPORT and XSC_QUERY_VPORT_VPORT_NUM_MASK?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D2
