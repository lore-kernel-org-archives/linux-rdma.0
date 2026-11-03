Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793707543;
	b=inedXraFtq27v01eNYLZYxkHDxq43i4kHSkhRY55yu+iCdC1s3s6/p7V/n5TyYp+pXwQ
	 u8xMPR3CK0AEr58rEKfnGC4rG06pHK/SvZx541b89rHJzFEdUjzXgjnmHXnyJa+TzrKai
	 2lafvt0AlGt2PyQA2veZJ+BRcUGjP/htCdD0NSxQLdcD6MM/lRV//fdZrvR0Mywy4VxBd
	 cNE6nyta1xVWm3PeRfFM6rM1dldMm0LXYvR0JAjExlByNyJS87Ikg6+redOyNA8tNO0zV
	 zwGKvYMwmYOQyWWSUrxbZnfpRCOygX08vQDgs/ySHKiND72CRR9jhczsFSigA4I5hiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793707543;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dCad/WNvnjhrjMBXES7ne6y+qjP6xtVG9UIsX5JrXNc=;
	b=2G36YkF1tR+gzVGv0hNThCPG+wS3UvZuNJeYCwxrmVX4yYY0Df5vpJ40Q9eKbf3zriO/
	 JOzfWPgfWEWEfG55CHspg4qQCzooZi3inZmZn2RnXNiGJQeBYeNJwCN2Wr4+NEtrOazoH
	 +9N9fbfh7eKM9doJkkwrouacUFqOhudWRL2BCnbKgEo58K58qAtW2efDdh4UUALpAWpyn
	 TrRVNlUgTCPc6QJOMWXfo+l7mzSIg4izjAm9utddfj9ykX6I0FmWMj6/Mn1tTXlVfs1dv
	 lKyUb7jNVso1QxAxDQgNBz2e9RYGVkgGV02OzO1xSxS0yeZn+xCMuhTLKJrLdzqwwVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="C4/d3RzG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFE3606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 12:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C4/d3RzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CB71F000C1;
	Tue,  3 Nov 2026 12:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793707542;
	bh=dCad/WNvnjhrjMBXES7ne6y+qjP6xtVG9UIsX5JrXNc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C4/d3RzGBRsoSLOtcwLzHKG7oFC1LNHMaMpy+nM42QEjypggbpw+7O6P7WmVbcsTX
	 8aG9ussPZNRjE+IYb9rTx0OFf8YUfFecw7+eR2U5Kva/EjoKhzJq0cYAaLgoCZvSRy
	 yZTkXOgLyRy53Y5oYQvj6S41vrJija88EgUJ2RA0us760zEyU5qxTbjdcaMfOTO/ig
	 bUUGd5neJpne3Kbs69lCX9X0MEjxtELP44wkxNanIwkijry7sen9KcrGzVSNN8S0+h
	 AZ+7bj3DXaczOx5vLUV3kP4+MHawtSWTde5Wd7HLRcYVDEAJD9mGPK6JZzurQF3X9y
	 GWWhlWbFI43pw==
Message-ID: <sashiko-outbox-195213@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Enable RDMA devices on the CDX
 bus
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103115032.736554-1-kotaranov@linux.microsoft.com>
References: <20261103115032.736554-1-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 12:05:41 +0000
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
- [High] RDMA/mana_ib: NULL dma_parms in mana_ib_probe() on CDX devices
--

commit 4f88c8811c923b9c16d7e0dbf8674249f05b4f08
Author: Zhiyue Qiu <zhiyueqiu@microsoft.com>

RDMA/mana_ib: Enable RDMA devices on the CDX bus

This commit enables MANA RDMA on the CDX bus by depending on the shared GDMA
core, matching CDX auxiliary devices, mapping non-PCI userspace doorbells
with pgprot_device(), and reporting the Microsoft vendor ID directly.

> diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/=
mana/device.c
> index 62c7803ca6c60..33e47490755f6 100644
> --- a/drivers/infiniband/hw/mana/device.c
> +++ b/drivers/infiniband/hw/mana/device.c
> @@ -257,6 +257,8 @@ static void mana_ib_remove(struct auxiliary_device *a=
dev)
>  static const struct auxiliary_device_id mana_id_table[] =3D {
>  	{ .name =3D "mana.rdma", },
>  	{ .name =3D "mana.eth", },
> +	{ .name =3D "mana_cdx.rdma", },
> +	{ .name =3D "mana_cdx.eth", },

[Severity: High]
When mana_ib_probe() binds to mana_cdx.rdma or mana_cdx.eth, does passing
gc->dev to ib_register_device() trigger a warning and fall back to a 64 KiB
DMA segment size limit because gc->dev->dma_parms is NULL?

In drivers/infiniband/hw/mana/device.c, mana_ib_probe() registers the IB
device with gc->dev as the dma_device:

	ret =3D ib_register_device(&dev->ib_dev, mana_ib_is_rnic(dev) ? "mana_%d" =
: "manae_%d",
				 gc->dev);

And in drivers/infiniband/core/device.c, ib_register_device() checks:

	WARN_ON(dma_device && !dma_device->dma_parms);
	device->dma_device =3D dma_device;

Unlike struct pci_dev, struct cdx_device does not attach a dma_parms
structure, which is noted in mana_cdx_setup_hwc_irqs() in
drivers/net/ethernet/microsoft/mana/gdma_cdx.c:

	/* The PCI path also calls dma_set_max_seg_size(), but that is
	 * deliberately omitted here: the CDX core does not attach a
	 * dma_parms to the device, so the helper would only WARN, and MANA
	 * never builds scatter-gather lists, so the limit is never read.
	 */

In addition to triggering the warning in ib_register_device() on probe,
mana_ib_create_queue() and mana_ib_reg_user_mr() build scatter-gather lists
via ib_umem_get_cq_buf_or_va() and ib_umem_get_va(), where
__ib_umem_get_va() calls ib_dma_max_seg_size() -> dma_get_max_seg_size() and
falls back to SZ_64K instead of UINT_MAX when dma_parms is NULL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103115032.7365=
54-1-kotaranov@linux.microsoft.com?part=3D1
