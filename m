Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D4636728F;
	Sat, 10 Oct 2026 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643325; cv=none; b=nfo7+prdzfCaEUPR+BLBblns4+DbRNjecFLrSC5Um1YKYEqUoasti3qbbapm+3l7cfv83MdCs/Y+z7xlYe5GADQ7qVR1IC1wD8DZN3U2QJDKkxcoYJQIaB2f9GNVydz9NqHemBgO6MRovsmQ4C5OZnKcJVM14+Rb86V4rgY3V2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643325; c=relaxed/simple;
	bh=ggonEXIVf2R5Ua/3fNil6QASowhosyD0Y9RrCIW53Os=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZGQFmi0ShC/s1MltVDCSA+vW/E30ZL/49NnbUwmUEwNtgZzi+fP4N2muKoeRy8TqlRa7nYxeyN3JAIVoeWIKPAY2OKHvsnkvBFa6sZN8VoHh1vGPf8z2UQLFSdDmwjfMM8LVBQg72JYI7oepjBeNgYWxrDjMzF5YjbOUC+AKzCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npKpECbX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npKpECbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E041F000FF;
	Sat, 10 Oct 2026 14:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643324;
	bh=sFyT7GeIaFnP2x2tjpTf1NqSd0kxaewdgQiy+pWpjM8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=npKpECbXyr2JyCNeZKbcNs1Nfc4yPmwH8afpmyUN8qGkVjI6VyaXusPMZ5+raSl0b
	 utzUrl2uaQ4vDHD6/fRh6kqiOOEd597YkICHaTfQ/1cZSjschAlswuOf9nEaBdDwVE
	 w9h0udfiX6INKuoC4WFxTxnxuTh8yKlCcDgesruUBgG7kkM+nJqySB9vohAbmallnb
	 MoMjdLPu9oqjfgIiTdu16z+funGSinBNrsksMJa3g5uW9F5uLOZhdyb/7zy+CoWHbe
	 JacZUCcmq0Rt8pPBYmkixmSIGpkQG2ztS7y9xWKrwKdWr7aKtvJPlb12sQ2Ntn01XS
	 N9Mh7o2mBNB6g==
Message-ID: <sashiko-outbox-166658@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 02/13] net: mana: share the EQ pool across a
 queue-set swap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <5e46da0c96a1dd7c39ae856deccc82cd98ac1af5.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <5e46da0c96a1dd7c39ae856deccc82cd98ac1af5.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net: mana: leak of DMA region handle in mana_gd_create_mana_eq()=
 error path
--

commit 1d0366c5b44b66d602e9a488b5674896e64e1285
Author: Long Li <longli@microsoft.com>
net: mana: share the EQ pool across a queue-set swap

This commit makes the EQ pool port-owned so that overlapping queue sets
can share EQs instead of requiring allocations of new vectors. It
allocates max_queues slots and tracks populated entries, growing the
pool before creating replacement CQs.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> +/* Grow the shared EQ pool without replacing live entries. */
> +static int mana_grow_eqs(struct mana_port_context *apc, unsigned int nee=
d)
> +{

[ ... ]

> +	for (i =3D apc->num_eqs; i < need; i++) {
> +		msi =3D (i + 1) % gc->num_msix_usable;
> +
> +		gic =3D mana_gd_get_gic(gc, !gc->msi_sharing, &msi);
> +		if (IS_ERR(gic)) {
> +			err =3D PTR_ERR(gic);
> +			goto out;
> +		}
> +		spec.eq.msix_index =3D msi;
> +
> +		err =3D mana_gd_create_mana_eq(gd, &spec, &apc->eqs[i].eq);

[Severity: Medium]
Does this code leak the DMA region handle when queue creation fails?=20

The new mana_grow_eqs() function iteratively loops and relies on
mana_gd_create_mana_eq(), but looking at the error path inside
mana_gd_create_mana_eq():

mana_gd_create_mana_eq() {
    ...
    err =3D mana_gd_create_dma_region(gd, gmi);
    if (err)
        goto out;
    ...
    err =3D mana_gd_create_eq(gd, spec, true, queue);
    if (err)
        goto out;
    ...
out:
    dev_err(gc->dev, "Failed to create queue type %d of size: %u, err: %d\n=
",
            spec->type, spec->queue_size, err);
    mana_gd_free_memory(gmi);
free_q:
    kfree(queue);
    return err;
}

If mana_gd_create_eq() fails, execution jumps to the out label, which
calls mana_gd_free_memory() and kfree() but entirely omits calling
mana_gd_destroy_dma_region() for the successfully allocated DMA region.
Since mana_gd_destroy_eq() does not destroy the DMA region either, the
handle mapping remains persistently leaked.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D2
