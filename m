Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3E537B3FE;
	Mon, 12 Oct 2026 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811635; cv=none; b=kghaH623Rnw8rP5aOabh8A0p1L0iMKZqdi4+HCvzX+Xs+U5d1q0KJWJINc3su/CNTBgmSbzF4w7s5EDs4MvAKlop3HNLmD0I50CmQ438Dow55tQ732m+5vd0OmaShOtEbdOygEzM2kH+20QxhBrWnTMasKT9ly22Ma53iok7tpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811635; c=relaxed/simple;
	bh=MMDEc6cGxIi4uPDI3z+nQp8d47pU1L6D+IA03HsHMUo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jOM5nUrUPFIb52nrko9d/Df4bZXb+kLqrHlzKvqvLSY3VkFTrxFb1m9r+wfDuZhrX90qOvKJZbSl8rrmU7K8B9utL5/IQyK3OL7NKefK6Cvi3EsCDoR6bhWZ0UQjPksVSMAZxDBxnUYyWNPSFtpxhSqszsXtYL9l1OUkaFzHG6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bAYBjPpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAYBjPpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5061F0089C;
	Mon, 12 Oct 2026 13:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811633;
	bh=2a8IY6ihrF/gTQ2fXArY+120l2A5nACvHhB7AIt2Bvs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bAYBjPppzrnzYJm/VDfb+Fl/rAzi2aynaH8l1Bex6+tEYUhnTmRvusx5PXPtwMWzP
	 VUIBD+xFfqbRYkClqlIeMGiO2AetzdZNdPTGvmxOzIZMHhIomLwhLgVgnQimT5gIS+
	 9Ql3wEFEMk99RTfrAKL4fcJ25msm8zMKBZb4Si6J/Z/DqMzOexzg3FeS1+Rh7dEVfc
	 2UOcvBHuWhaq/KMkMlOXBh/wqufWd0A1N8JdMoNMwVG+AyslTrfuaFamj2zJc96Fn5
	 XsarEJh883niEH0P0kH8OXVjj3Tf4JgmNsb7sSTItsU4eDhOAip3O64KBGYcYjv9hD
	 hdwi1FKa8Q9KQ==
Message-ID: <sashiko-outbox-168177@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 17/18] PCI/P2PDMA: Evaluate the ATS path for clients
 with ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: media-ci@linuxtv.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-17-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-17-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:27:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] pci: pci_p2pdma_distance_many() evaluates compatibility without ap=
plying client ATS constraints
--

commit 254b102fe424913edc3d5f94f8d41bc5d0de2b20
Author: Leon Romanovsky <leon@kernel.org>

PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled

P2PDMA assumes every client issues Untranslated Requests. A device with
ATS enabled may translate any address it is handed, including a bus
address, and Translation Blocking can reject its Translated Requests on
a route the Untranslated answer called usable.

> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index e38081f797611..a5fc622e3114f 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c

[ ... ]

> @@ -1660,10 +1706,10 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *p=
rovider, struct device *dev,
>  		 pci_p2pdma_map_type_name(type), type, provider_state);
> =20
>  	if (type =3D=3D PCI_P2PDMA_MAP_UNKNOWN)
> -		return calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
> +		type =3D calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
>  					      true);
> =20
> -	return type;
> +	return pci_p2pdma_client_map_type(pdev, client, per_mapping, type);
>  }

[Severity: High]
Does pci_p2pdma_distance_many() also need to apply these new ATS constraint=
s?

While this patch successfully updates pci_p2pdma_map_type_tlp() to evaluate=
 ATS
routing constraints for P2PDMA clients, pci_p2pdma_distance_many() continues
to evaluate mapping compatibility without them:

drivers/pci/p2pdma.c:pci_p2pdma_distance_many() {
    ...
		pci_client =3D find_parent_pci_dev(clients[i]);
		if (!pci_client) {
    ...
		map =3D calc_map_type_and_dist(provider, pci_client, &distance, 0,
					     verbose);
    ...
}

If a client has ATS enabled and its Untranslated route is usable but its
Translated route is blocked by Translation Blocking (or lacks a whitelisted
host bridge), pci_p2pdma_distance_many() evaluates the Untranslated mapping
with tlp_flags=3D0, and incorrectly returns success.=20

When the driver subsequently attempts to map memory, the ATS-aware mapping
logic will return PCI_P2PDMA_MAP_NOT_SUPPORTED and fail unexpectedly at
runtime, breaking the API contract of the distance validation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D17
