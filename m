Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCE6407CDF;
	Tue, 13 Oct 2026 14:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902679; cv=none; b=ur6UE//exxkijZibucuvH6gwGZfcPTmJrM4WUnccaHmLmAUszlZ2VQkGefdjU/ZwylwExeqx4SFwmUAYJ9G1nBjY3hH15aSqmK8QoqGUJhbnEcF/vAwHwmFxvJzHClQpwTCpRuuWd1LiW++wjABijpwfstQDmYRB4eWIq+Dxrao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902679; c=relaxed/simple;
	bh=kakAktBn9n5jV79saE1AU9sbXIBRv+dGzXiZcYIHI8U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OXQEHqBmxfrv9puM4BQg2gR5xA502Qxg37N+jC/hi4+CnAykxhYkeqh9CyDIo/tRkwq5YaT3v+ADjDm5TiIFB/4dPi9AMx9eYyzm2wAlyPt/wUqhmUuD0+turxYXYizbeh1Qb5B0hww8c9uQwfb+E2brawxL6stqLd//uPhz4u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G67LPayE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G67LPayE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155CC1F000FF;
	Tue, 13 Oct 2026 14:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902678;
	bh=S5XZjEefQh4EdB8bPyGtES7lAp11auEruiseyw9G5YA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G67LPayEaPri6jX7U5aHSF1SoPf+InmeNCiNXfrvN6JmLfx/cThKUlw47VO475TOm
	 5AujQBlSTAePAMTMZF7yiBJF633Y6PyePVnEcLi/EEBMB8T5ptdGj/0HhhELA7XoB3
	 d6txSnyju2ccA6ICBkVPOs9xwrFub1e4Z5dwygC2S4dePYWGtal9bWQOxsO39e6FsY
	 8vEFBFKZuy7hSw9YImsrCi+qmqlkI4emnqAUbQDAx/TgZlXjx8z9GbG5rYQv7AJ/Nq
	 90AjfRnX2WMX4spgriJFjhOkwcoDakw1F00ny8fM7/caqQFEicyDIJopG1yqNxDtGu
	 um6rpmKSMRaCg==
Message-ID: <sashiko-outbox-169930@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 01/19] PCI/P2PDMA: Honor device-specific ACS
 redirection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-1-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-1-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:44:37 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] pci/p2pdma: deadlock in calc_map_type_and_dist() calling xa_store(=
) from softirq
--

commit 6120f97b22446453f3e4fa09135e1a44135ecfe8
Author: Leon Romanovsky <leon@kernel.org>

PCI/P2PDMA: Honor device-specific ACS redirection

This commit updates PCI P2PDMA to respect device-specific ACS redirection
quirks for switches and ports that redirect peer-to-peer traffic without a
standard ACS capability. It queries quirks to set Request and Completion
Redirect flags and modifies how affected ports are warned about.

> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 45260423dfb09..ba94b0f339285 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
[ ... ]
> @@ -782,15 +867,8 @@ calc_map_type_and_dist(struct pci_dev *provider, str=
uct pci_dev *client,
>  		goto done;
>  	}
> =20
> -	if (verbose) {
> -		/* Drop the final semicolon; the list is not empty here */
> -		if (!seq_buf_has_overflowed(&acs_list))
> -			acs_list.buffer[acs_list.len - 1] =3D '\0';
> -		pci_warn(client, "ACS redirect is set between the client and provider =
(%s)\n",
> -			 pci_name(provider));
> -		pci_warn(client, "to disable ACS redirect for this path, add the kerne=
l parameter: pci=3Ddisable_acs_redir=3D%s\n",
> -			 seq_buf_str(&acs_list));
> -	}
> +	if (verbose)
> +		pci_p2pdma_warn_redir(client, provider, &acs_list, &quirk_list);
> =20
>  map_through_host_bridge:
>  	if (!cpu_supports_p2pdma() &&

[Severity: High]
Does calling xa_store() further down in this function risk a deadlock?

The map_types xarray is initialized with a plain xa_init() (without
XA_FLAGS_LOCK_IRQ) in pcim_p2pdma_init(). This means its internal lock
operates as a simple process-context spin_lock.

Since calc_map_type_and_dist() can be called from softirq/hardirq context
during P2P DMA mapping (e.g., via dma_map_sg()), and xa_store() takes the
xarray lock without disabling interrupts, a process-context thread interrup=
ted
by a DMA mapping on the same CPU could cause a deadlock if they both try to
access this xarray:

drivers/pci/p2pdma.c:calc_map_type_and_dist() {
    ...
done:
	rcu_read_lock();
	p2pdma =3D rcu_dereference(provider->p2pdma);
	if (p2pdma)
		xa_store(&p2pdma->map_types, map_types_idx(client),
			 xa_mk_value(map_type), GFP_ATOMIC);
	rcu_read_unlock();
	return map_type;
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D1
