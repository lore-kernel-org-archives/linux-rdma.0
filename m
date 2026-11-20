Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163444;
	b=hfQcnHrROw8AKe6JI9MEFGBp1ZkWQ5KdUWRDBunvwOd57/GW+cYic2PTqKUBtMJYI4Ka
	 j2IvkgylUlUjsHCm5d/QW3yS5LI11MKHx/ZatcxbSuZnpRThrbSUHaPXnlS9BtgBBA+OQ
	 PGu4f453Hk+PEAYs28Vp4Fhv0s2zcU1gikalMSfMHnQfwOk4icWOyEO64rJU2ooruppJX
	 HVFk0l8tVoIEflpekXaBDy6lFywgBIJVdZSjgQnrxNgXySs2dgzlQdcgqaOY12ynN+hJh
	 Ghry7HLy9JanbC7c8htiwO5XQZURcaEOnwaJBpG8MJjqKyf++j6iMK+8PM9jj8Mx81w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163444;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rq1gbDc7hDF1BspLDzHEQ0BElqg9dVJ/erolJDygU4Y=;
	b=ZYlckMFSpEE5yHy9/C07cn4EBYC9Lc/KOhGigjZnr/DXyurcQPHiEJTBGmDZBbd/ziay
	 KinE4gKGGTIJnNuyPTtsGFE2bdsgwVIy7pHHrpMSzHZBpQg2jpA6oSkGZzlFHEXM6lXiR
	 aoev+e/Mr8k+NU8XBrSwnIOZnRfR/wvc8TVvRydMEzGGh1o24uGqm4ohZUI/YizXZ1kq1
	 2Xw859JZKMeuBaPnAHIBkIVte7f5GFVjnNHpi3kgl+FxaFEBI9DHFYxszFJ539P0WQsJl
	 hTivcG4g3e43kTTIaSppuFM6mQ24v4WygmdVvQGy8MCoYnfsi0VQfAFneWUzAstTB5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlF4DISz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E74606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 08:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlF4DISz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7AF1F000C4;
	Fri, 20 Nov 2026 08:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795163443;
	bh=rq1gbDc7hDF1BspLDzHEQ0BElqg9dVJ/erolJDygU4Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LlF4DISzgeI9OfOgVU1xzvboXBDMjI4Q1eDyXXRPdpIZdbsFQcrJQssC4OhXB36mZ
	 P/j9gvgiaSu8vvyXEtpNXAR3criJbsxYsrmO4ss5Tn7AYO2wkcsWgzVd3ksONQdt/x
	 IqtNTYgDSp7jVje86Dyb86ZL229bzAizN/ka2rKaSOjo0EiHaaJCmLN+W6qro50xPG
	 0gfQhc9YowHlnqEIFV/2CkFUyAGFoW81oKbgux61+fTJQswLKrvN0kyTXyNYOhtLlL
	 VBSqb3ew6jU0qm7OKBx4FjEcVNJgB3Kl/AzW2NDsN/hLSuzXbtz9xIEqy1I/TYmDHT
	 sXck1mU5E1pyA==
Message-ID: <sashiko-outbox-224736@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/2] net/mlx5: Declare no DMA segment boundary
 restriction
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120081819.2538191-2-tariqt@nvidia.com>
References: <20261120081819.2538191-1-tariqt@nvidia.com>
 <20261120081819.2538191-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 08:30:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yishai Hadas <yishaih@nvidia.com>
>=20
> The PCI core initialises every PCI device with a DMA segment boundary
> mask of 0xffffffff in pci_device_add(), which forbids any segment from
> crossing a 4GB-aligned address regardless of its length. mlx5_core
> raises the default maximum segment size to 2GB but never overrides the
> boundary, although the device has no such limitation.
>=20
> Consumers such as ib_umem_get() coalesce physically contiguous pages up
> to the maximum segment size without consulting the boundary mask.
> Registering a large MR can therefore produce a segment that crosses a
> 4GB-aligned address, which the DMA API debug checker reports:
>=20
>   DMA-API: mlx5_core 0000:08:00.0: mapping sg segment across boundary
>   [start=3D0x00000002ffe27000] [end=3D0x000000030020efff]
>   [boundary=3D0x00000000ffffffff]
>=20
> The segment is about 4MB long, well below the 2GB maximum, but it spans
> the 12GB (0x300000000) boundary: the upper halves of start and end are
> 0x2 and 0x3.
>=20
> Set the segment boundary mask to ULONG_MAX so the DMA constraints
> declared for the device match what the hardware supports.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120081819.2538=
191-1-tariqt@nvidia.com?part=3D1

