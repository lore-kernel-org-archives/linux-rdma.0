Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F136212B94;
	Wed, 14 Oct 2026 08:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965187; cv=none; b=cXeXumN3J55wW2OfXTxvO3UF4J2qvuMtQdY0Ih8q5K7/gtqAgv4eke+8PEiXPLGYmr9kYStY/AjDnDuNwTvAWminIfLUbG8zB3TwO6lGq/jeAd0o4PkHRyUxj6iBnI4Wd473ids6vuzRcoqprjexQVLxxZK5Sj/cyiVcj2B8T+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965187; c=relaxed/simple;
	bh=RgdOHD2V/uQJS1E61Re8eKmQidli/SYJEDJQyvGLMTY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bZRstm4elCV39OezRZWnpWFSlGeS5VmjCmVixhcLbBaYCw4bU6Ff+slV7jH6TC9F8+k9It5ntlwHf5p/FVLpljE7OTxlX7a3Lch747Db9cdn0CrGkLohuETccX8gXahaFKinYzMS2QnBDGUw4HwfKWsS0PuAh4vF0UD0h5mQQw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9KtEr85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9KtEr85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564CE1F00893;
	Wed, 14 Oct 2026 08:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965185;
	bh=t3kNU9krp23yZPtKov9FMIdYlXcG0Z30qrXbSZG6LCA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B9KtEr85MpMUWgsmoNvAk+aBcuKwB1QXX32YsjY7stlUHCt3N43alY4/cm0mpS5Ka
	 MejrG0vgxPf/32bEUPpHhbKWPfIeLEe1Hnwja4IIn/52YBMa88JG9SbTAzqMj969+q
	 bbLuoIZqaCHuZYvYlxB9Wt1+upojhIftKhZAn9By19LBa5la2iWTIjKge/IPQFBTvt
	 LZBxeOMWlLdLwpEcrkhEPPyz5ESGuApslisVgwbpKkQ/UeKaMjJb/iM8VTxxDXjkww
	 5sPGCpM0bPuFDCT3kp/fWGoyRRHSbaXSJhWIhV96d/y5QT7EG+2RRheuHih+VT3T83
	 0+DFfVDLieiaw==
Message-ID: <sashiko-outbox-170991@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 3/4] net: mana: support concurrent HWC
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <08f833983788be99fc73b856dd4822826b5876f7.1791561995.git.weh@linux.microsoft.com>
References: <cover.1791561995.git.weh@linux.microsoft.com>
 <08f833983788be99fc73b856dd4822826b5876f7.1791561995.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 08:06:24 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: mana: out-of-bounds read on unvalidated hardware msg_id
--

commit 9775f43816d83151fa521309768c62ad04b477da
Author: Long Li <longli@microsoft.com>

net: mana: support concurrent HWC requests

This commit replaces the depth-one timeout latch with per-slot sender and
response ownership. It synchronizes timeout updates, implements runtime
teardown logic, and splits HWC request paths into structured helpers to
support concurrent hardware channel requests.

Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/n=
et/ethernet/microsoft/mana/hw_channel.c
> index 89b6e30863dae..9fdd84ccba653 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -97,40 +162,54 @@ static void mana_hwc_handle_resp(struct hw_channel_c=
ontext *hwc, u32 resp_len,
>  				 struct hwc_work_request *rx_req, u16 msg_id)
>  {
>  	const struct gdma_resp_hdr *resp_msg =3D rx_req->buf_va;
> +	struct gdma_resource *r =3D &hwc->inflight_msg_res;
>  	struct hwc_caller_ctx *ctx;
> +	bool release;
>  	int err;
> =20
> -	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
> +	spin_lock(&r->lock);
> +	if (!test_bit(msg_id, r->map)) {
> +		spin_unlock(&r->lock);
>  		dev_err(hwc->dev, "hwc_rx: invalid msg_id =3D %u\n", msg_id);
>  		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
>  		return;
>  	}
> =20
>  	ctx =3D hwc->caller_ctx + msg_id;

[Severity: High]
Can this result in an out-of-bounds memory access if the hardware returns an
invalid msg_id?

The msg_id value originates from the hardware completion structure. In
mana_hwc_handle_resp(), it is used directly in test_bit(msg_id, r->map) and
as an array offset for hwc->caller_ctx without any bounds verification.

If the hardware provides a malformed msg_id (e.g., larger than r->size),
test_bit() will perform an out-of-bounds read, and the array indexing will
result in out-of-bounds pointer arithmetic. This can subsequently lead to
memory corruption when the code acquires ctx->lock and copies data into
ctx->output_buf.

Should there be a bounds check against r->size or hwc->num_inflight_msg
before msg_id is used here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791561995.gi=
t.weh@linux.microsoft.com?part=3D3
