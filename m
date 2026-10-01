Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26424390990;
	Thu,  1 Oct 2026 12:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856486; cv=none; b=mFl7/0K2nOH9TWIoyGkJU93xvFlGqjgdYx203qJU82MBjf7EEHweOpikjUl/HfW+QozomjcjfBQehB7dYddu+PP4lb6iIP1K+GOJqrOsqoqhtkPSPIT5AJ53LQ5LRr7wN/AmYOXpggZFL1qG1U9Gn5zzZIo6D2yzSmtcVi41m+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856486; c=relaxed/simple;
	bh=Ppj+WkVpKz+5vaqC5iV64XZxdA2bha8tmma1KwxaE7M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vFCYiykHkrwnJcuPqLYcwq9roGclIaG3hIPNJmLIBJOnoTLeWba+qllZnUIiWfm98HL2an8QexvPkxX27t0cB+hHI9gZU1IJqQktY10ozjFI70ZmgqEt9sANZWKQE4WdYLu7IxUoPUG9dHrVxEDyXOcZjDth2xPRAv9P7yECc/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1W4jpNc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1W4jpNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CC41F000FF;
	Thu,  1 Oct 2026 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856477;
	bh=P/vh2O1JHT/zL+P+wbyaER1CNS1KF4hkMqfHF3EqlQ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c1W4jpNcfy/JA2w5swtJ+CByrGH+cQiw9SZS+nWAz9WGbZYVwXXMSe1ayVpnCI/KI
	 YS818zgwNOEXTZk++9e6k5utYXcg5AD3nQ8JUxTeP1CYQJwRa45Ixmzyiw5qPqO7fE
	 ayskiSfLojEsORG/RGXvYunlzJuO9R0yAVVeobwyxkc6OQYGDbND4K6sAydWamXr8V
	 swHQrpv5xhI5Pe/uq8tRfkV64XixlOGFa4A0qaEw8UyYQ7UcRFxuf2fNR6MTPp4Dby
	 dJ1x7YaZQ+u2IU4Y5uortRheSMqB12RGZYv3Cf2utK+NlX6gFeF4xTAtkK2r9FCo64
	 2uhHbN7LQmDXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 17/18] PCI/P2PDMA: Evaluate the ATS path for clients
 with ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: media-ci@linuxtv.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-17-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-17-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:07:56 +0000
Message-Id: <20261001120756.A5CC41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] pci/p2pdma: pcim_p2pdma_set_ats_per_mapping() silently fails for p=
ure clients
--

commit 39432dea495f68fb0a21d0daa1f31ba24e130b39
Author: Leon Romanovsky <leon@kernel.org>

PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled

P2PDMA assumes every client issues Untranslated Requests. A device with
ATS enabled may translate any address it is handed, including a bus
address, and Translation Blocking can reject its Translated Requests on
a route the Untranslated answer called usable. This commit takes the
Address Type from its ATS Enable bit and avoids handing such a client
bus addresses unless the client declared per-mapping ATS.

> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 6a63901c65fb6..9c0943fdb3e36 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
[ ... ]
> @@ -1633,6 +1674,9 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *pro=
vider, struct device *dev,
>  	cache_index =3D map_types_idx(client);
> =20
>  	rcu_read_lock();
> +	/* The declaration belongs to the client, the cache to the provider. */
> +	p2pdma =3D rcu_dereference(client->p2pdma);
> +	per_mapping =3D p2pdma && p2pdma->ats_per_mapping;

[Severity: High]
Does this code handle pure P2PDMA clients correctly?

Since pure clients (devices initiating P2P transfers but not providing memo=
ry)
have no mechanism or reason to call pcim_p2pdma_init(), client->p2pdma will
be NULL for them.

This means when they call pcim_p2pdma_set_ats_per_mapping(), it silently re=
turns
and drops the configuration:

drivers/pci/p2pdma.c:pcim_p2pdma_set_ats_per_mapping() {
    ...
	p2p =3D rcu_dereference_protected(pdev->p2pdma, 1);
	if (!p2p)
		/*
		 * ats_per_mapping is a performance optimization,
		 ...
		 */
		return;

	p2p->ats_per_mapping =3D true;
}

Because client->p2pdma is NULL, per_mapping will always evaluate to false
here in pci_p2pdma_map_type_tlp(). This leads to pci_p2pdma_client_map_type=
()
incorrectly overriding the map type, which could return
PCI_P2PDMA_MAP_NOT_SUPPORTED and break P2P transfers that should have been
permitted.

How should pure clients register their ATS per-mapping capability if they
do not initialize pdev->p2pdma?

>  	p2pdma =3D rcu_dereference(pdev->p2pdma);
> =20
>  	if (p2pdma)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D17
