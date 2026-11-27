Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791488;
	b=IgZM/1t8y5E+iYkcbBvNpXGRQDgH54RQH1Ov2o/pS0YsdLDnyqzMV2emK7WSMgvYnZYg
	 nXCtic88EWD2JqnUCxniv9wi7Yb8lmYCVhQStC5vAmcBWw3b0ejNoclx815wOekthy5yU
	 zFf4LUWYxBVZJrdTrbihVL/XoxlhgZXJqowfl8y5DnDYblfB7tN+YUn2jUdJvk4coOTxi
	 yyexGS03t0iA7415W18cclz5r5ru8Gyb8SDw9MGXD+2UhwkREUSwqHIWrURgkx5qLTKzR
	 0omAR+rAds0KKm+iae2nRPH4RDcgVvzukBBbWfTr3myhT4Y7Ll2j9ksg2AIPwjug4aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791488;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ujhly1m/JpWhYMExjpit7+4UMiX2Pu3BtUVJk68kd7k=;
	b=p9toPN28z4gKokf5Sy5GTY+fBUcJhFlFxx3AYvUatw4U1K13V3soZQojm1RCmFtEjO8W
	 VEEGe9KbkFRLwgeYouaWiEL1C04O9111ULhdXBk1c9Vv8W6qxt1gET0R3paMmQ3zgjbSU
	 vKZE/M8e/ip+OCS/7J/XpQBA7ioJeIkY34sRyo8t07EEbyMqRdGY8Dk/nNREVmPQKYAR6
	 /i+xohWLoVYvMxAN6pupS5hKMpERM/ktnJtdBu9cR0IxgMwYBp+x4/9SSF9TSSVyyU2yD
	 a+jSGoX76W66Y8Cj+i610h+JRfEQImH/4K/A/8SfJoq5Z8KdQTJbupHZGr3/ms9Frfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsmgSexF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EC8606A324
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsmgSexF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F417A1F00899;
	Fri, 27 Nov 2026 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791488;
	bh=ujhly1m/JpWhYMExjpit7+4UMiX2Pu3BtUVJk68kd7k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gsmgSexFhDB96wYKsNljo9QX2h9wk4LckBbPCTNFL+eQUefvFYL2HVQ0znXBTSuFc
	 TcvNjvB/I3ot5AVuG5WEgy8U8feL+7c48LMbe2DTfFMbgRXDrrD0xRIDFz82nL00UX
	 MMUQxuXkR+U/5auAr6tnzJzmVOd6MEhlptJ1Ddevk+3OkMcKukN1MAu+WnPHkcF1nG
	 Q8Nj0veIwBn669K/3UPj6l2wi2l54IAt8cFl7S8TEBnpWDnWa6P8+bsf3d0wJTIH50
	 x3v2ijkUZjB7h0hPEL6h3z2Luh4vCIBtZfTTrjgKg11ErtHBaOlPurq56k8waI1lpi
	 dPwSIznZv7c/g==
Message-ID: <sashiko-outbox-237637@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/11] net/xsc: query HCA capabilities and reset
 function
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145721.70868-5-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145721.70868-5-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:07 +0000
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
- [Medium] net/xsc: missing in.hdr.ver initialization in
  xsc_cmd_query_hca_cap()
- [Low] net/xsc: wrapped commit subject line spilling into commit
  message body
--

commit f750ba7cb78453344d90f6c33acb7a3b7bad17b8
Author: Xin Tian <tianx@yunsilicon.com>

> net/xsc: query HCA capabilities and reset function
>=20
> resources
>=20
> Query the firmware HCA capabilities needed by the ethernet driver and
> reset the function resources during probe.
>=20
> Signed-off-by: Xin Tian <tianx@yunsilicon.com>

[Severity: Low]
The commit subject line appears to have been wrapped mid-phrase, leaving
"resources" as a standalone line at the top of the commit message body.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net=
/ethernet/yunsilicon/xsc/pci/main.c
> index 9b08580f52f38..42c5a1baed23b 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
> @@ -29,6 +29,63 @@ static int xsc_set_dma_caps(struct pci_dev *pdev)
>  	return err;
>  }
> =20
> +static int xsc_cmd_query_hca_cap(struct xsc_core_device *xdev,
> +				 struct xsc_caps *caps)
> +{
> +	struct xsc_cmd_query_hca_cap_mbox_out *out;
> +	struct xsc_cmd_query_hca_cap_mbox_in in;
> +	int err;
> +
> +	out =3D kzalloc_obj(*out, GFP_KERNEL);
> +	if (!out)
> +		return -ENOMEM;
> +
> +	memset(&in, 0, sizeof(in));
> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_QUERY_HCA_CAP);
> +	in.cpu_num =3D cpu_to_be16(num_online_cpus());
> +
> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
> +	if (err)
> +		goto err_free;

[ ... ]

> +	xdev->pcie_no =3D out->hca_cap.pcie_no;
> +	xdev->pf_id =3D out->hca_cap.pf_id;

[Severity: Medium]
Should in.hdr.ver be initialized to cpu_to_be16(XSC_CMD_QUERY_HCA_CAP_V1)
before calling xsc_cmd_exec()?

XSC_CMD_QUERY_HCA_CAP_V1 is defined in
drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h as the HCA capability
mailbox version, and xsc_cmd_query_hca_cap() reads out->hca_cap.pcie_no and
out->hca_cap.pf_id from the versioned extension section of struct
xsc_hca_cap.  Leaving in.hdr.ver at 0 could cause firmware that checks the
request version to reject the query or leave those fields unpopulated.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D4
