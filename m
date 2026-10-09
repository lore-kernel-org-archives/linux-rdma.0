Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70233C819C
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 23:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791590070; cv=pass; b=L0UturH9cGWxzDgQ6pImHkzbs3bWYFWm5NYzh8syIZ2kLMH8d/7i62bcXfuNS6/MIfgwR33lBblahHhpgPFiiCp8jNI/T4cG2oQHzJa5EOCKsApxN0FFaOP0WnAEp0E8YK/Dq7xc84wc8Pnh96gfOn89DQv9YVIlxuPEACOY08o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791590070; c=relaxed/simple;
	bh=6BbAOFR5ozv9YI2gjZqVkZoLPCjlp6tmsusKEhB3G6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S0s9hFmDDEb+ZZlzrWliXSvRhl2M+QTpdMxNuiOhITnFSI4qTj0C9oKJzLu/5h+GU9/6Y8H0QkM29nmkyNHQd6l54QfCOW1eBJH3Cg6/WKnQeF5LGtAb9B4/14P6EIP0D2+tPmrJoQ8xZPbgHYX56+ijyHObi4XGB331r7Io+Ks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qXmx/vWV; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qXmx/vWV"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso283a12.1
        for <linux-rdma@vger.kernel.org>; Fri, 09 Oct 2026 16:54:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791590067; cv=none;
        d=google.com; s=arc-20260327;
        b=kLmBl/FLaAr/ug7PNnoVnetk7svnR8HfEps3itZjq0iqgVFX6rU1f9D6qhaCjC5Wzp
         eEM5aKShZe1c0THyKdrWyarh55AkVHmrgc4n1fpxRTTmdInkx3l2qb9bS5Xc04VFa0Ou
         RptDeMx7OQLW+bYqUxUY8IWtmeZEn9JxMdEmxdrKRvNBMfy8GLMui7m1mh2bIOXNcmtI
         GUW4eSyuv1qdXQ+cGOxX2t6kRW+Cil596jIIIqs5ovRhb76s26oNDAn0aObEkZu5RuC1
         IkcS/scx0B72jOTouJH03M1vWZDz2I4ffqnHcifTprm+Px6EtL9SR4ZODI8NOlkQIQl4
         eONQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6BbAOFR5ozv9YI2gjZqVkZoLPCjlp6tmsusKEhB3G6Y=;
        fh=Mo2vn0COP7Cu0UO+FAN6G68k7E9J9/c/2dzEgwDSrg4=;
        b=XLDe/Debml2sJiwoCyiUKvWrt+hXpPPh1PQp5oy52NT1G9yAgHwwR+OAv9bMKWLF+z
         iySRp+isjWaVOnBB+yMNH/dClt45Ky8pzfdJGzvs7NcBheoS/zxXH/+rWJSQQvn0XXzK
         gC8RyucNAHhFoPwkJbwe0E6ozXCQ2PJxU3TcBBha4i0JdgSftvI+7OIbXyakq5bGm7zy
         60fs1OV0ftG0l5g5LOl1a4PxSRpqd0GTx6WXQ/1+FF5yBCHT+BirP75ColXZqhjoRtwy
         QkvrVuV3tSCiCs++CO7zHwfgkl3hXLDluVKX8RG/8SLFoY5pahdlww/G03KBfdIbIXNX
         Lk6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791590067; x=1792194867; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6BbAOFR5ozv9YI2gjZqVkZoLPCjlp6tmsusKEhB3G6Y=;
        b=qXmx/vWV0JJ5vLM3ox63kUAd6fadJkJAAwe2nPT3Rf5U0A4Q4Jw4YeABgEL5+euiOd
         dZs6rFvAd1+S4vPSdl28nKc+wMCqCvaImodHgr636n7a3UuA33QuqdcldgvGp2wCWbIf
         zBB8MviyksypDmJV1C+6V76SBNby1CcBvTY47GPFJb6jSkEGm0iTcCyB7JKaR/u3W0e1
         S+39FEuvIImesddZZPBVOjLGub96lPi5LDNYRxYHFnytz5woC81bc5P1QeJY7gsHR/ts
         orDd7Vh/eE7SIxPzqpvy4YU7xGpvqBIUJWFQFlL80SqDsmqYULnVZsPVPCm3X5EUrg6M
         FYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791590067; x=1792194867;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6BbAOFR5ozv9YI2gjZqVkZoLPCjlp6tmsusKEhB3G6Y=;
        b=uCpbzlwUJeI9/evGecB/jQhkxojUlHGSWJHPqj+1QjaRnctA+I+eRqY2wz2EcKVDz/
         LXphyxHbUZppqAbHstH7rZr2Pge6DnAgitQrMRKakH+g7t+m3I3rHKedWn9iB46dl3Hu
         mhGv4FT7kkULqKRS19lpRzYk+PmmDmINSbMC1UvOTtDs9+lKVF8+1yGOa/sIGyAHVgAS
         k/6ztOOKwHGewhluuAZO6WRJXMoHUupv18bZTcosTYwhZWob/4Mdt+C6zE5QYLOf7hzV
         QeQDYxrMJDibkl45KBfZ12BxPnXI6HEBMmaTEMYUvIapCBB6+7gYbMppjtW4j0vTOcaO
         Hhdg==
X-Forwarded-Encrypted: i=1; AKwUvBz27pemnVeCBq84hm7MeO0JfneHxfeU8K3/Pb9DdP8iOycJTH8kVr8o4DWdZP8yctkvTPxUqcERbmMU@vger.kernel.org
X-Gm-Message-State: AFq9FYIkm2xDo6o4gqFlTdLWUo1t37wPP3375dgXawzHym07EESa8Gks
	DEC9JmnMnr6B3Qmo+oXDlv6m1oBYAWyZr9AcNfmklhH8cUaXtnC8DC6vKWJEV3je2sIpRXviyax
	eVkrJ4vmCy/esFwrWuIK4StR6JwVXcZoD9YrbC2Yi
X-Gm-Gg: AYBFou15Nk03fULdnBp8QtBWdCasmTDikJn6gGXn9nQErM+s0TcVbPWd5udNBccrJW2
	Hvzoyb0wY9cNrr6lKKsShEjN820zxwv9gI7J2iXbU1soZeE831PgYae91REYaXL4RvkUOHddhAb
	1sAkDJUk2UouqDm25rzzJBLUEmu3eF1DHu1eqj7ULFDXcZqZ6JLlZzYzJG91mb6OwUWAURsok9Z
	5TY7Wb8BRlHYIGNiZ5aGuQYvWn7Z0S6w77PfPHNIKpxq0dacjxxrQl9BmK0IDTWZI3C/lAhzhuc
	fq3PsgFK3kFqBwqZXA6+f5c7dnJKNBH4sf4MujZ9uryqDInAZoxiraTcBurWqs+W
X-Received: by 2002:a05:6402:1492:b0:6af:afce:184f with SMTP id
 4fb4d7f45d1cf-6b1988f1271mr5875a12.3.1791590066657; Fri, 09 Oct 2026 16:54:26
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008132815.654147-1-tariqt@nvidia.com> <CAHS8izNSo4YzXxD3C6c2HohdOfH2GK1M=51biuevLUk3vz5k4g@mail.gmail.com>
In-Reply-To: <CAHS8izNSo4YzXxD3C6c2HohdOfH2GK1M=51biuevLUk3vz5k4g@mail.gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 9 Oct 2026 16:54:15 -0700
X-Gm-Features: AclHuK_ZzbZd-uX5EqoDdsPJuuPhovZF16107otVMYSWFJ0lAZEAV_UPEgtn00I
Message-ID: <CAHS8izMKNeEmJM0wOgtoz9_3WRLUOqP0PEDMn5SZ+hXTKTwSyw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/10] net/mlx5e: Add netdev support for data direct
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>, 
	Byungchul Park <byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, 
	Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>, 
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Matt Fleming <mfleming@cloudflare.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, 
	Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>, 
	Yue Haibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 9:42=E2=80=AFAM Mina Almasry <almasrymina@google.com=
> wrote:
>
> On Thu, Oct 8, 2026 at 6:28=E2=80=AFAM Tariq Toukan <tariqt@nvidia.com> w=
rote:
> >
> > Hi,
> >
> > This patch series by Dragos adds data direct support for netdev devices=
,
> > allowing a mlx5 netdev to issue DMA commands through multiple paths.
> > This feature is critical for improving performance and reaching line
> > rate in certain environments where issuing PCI transactions over one
> > path may be significantly faster than over another. These differences
> > can arise from various PCI generations in the system or the specific
> > system topology.
> >
> > Data direct for netdev will work with devmem by returning the data
> > direct DMA device instead of the DMA device of the NIC. Each PF netdev
> > registers its own data direct device and support for RX and TX datapath
> > is added. The feature is selected through a new data direct priv flag.
> >
> > The feature is enabled though a ethtool private flag. When this flag
> > is enabled, the driver will return the data direct device in the
> > ndo_queue_get_dma_dev op.
> >
> > During data_direct device unbind, a re-creation of the channels is
> > triggered.
> >
> > A note about the unbind: it does not does not tear down dmabuf bindings
> > attached to the data direct device; the recreated channels will still
> > pick up the binding via rxq->mp_params and post DMA addresses from the
> > data direct IOMMU domain to the PF, causing IOMMU faults. A devmem
> > revoke hook is needed to close those bindings before the switch. This i=
s
> > out of scope for this series.
> >
>
> Elaborate on this please. Are you referring to the fact that on
> page_pool_scrub we unmap the netmems dma-mapped by the page-pool, but
> we don't unmap the netmems dma-mapped by the memory provider?
>
> What's the impact of leaving this unfixed? Is the machine going to
> crash if the device goes away but we don't unmap the dmabuf?

Oh, you're referring to an even different bug than the one I had in
mind. (I'll see if I can submit a fix for the bug I had in mind).

But in general I think not addressing the issue you're referring to is
way too messy. I think we do indeed need to unbind the dma-buf if the
dma-dev is going away. The invariant should be that the
binding->attachment->dev should not change at all during the entire
lifetime of the binding. We already 'revoke' the dma-buf binding if
the netdev is going away, sorta (there is a bug there I need to fix.
The uninstall function in the provider doesn't actually unmap the
dma-buf :sad face:).

I've worked with my LLM to suggest some changes that (we think) make
this work, but you may disagree. I'll post the suggestions. But please
I think this should be handled one way or another.

--=20
Thanks,
Mina
