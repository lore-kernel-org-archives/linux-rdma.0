Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D078282F3A;
	Mon, 28 Sep 2026 12:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790599397; cv=none; b=bcEwaIwqAAJWADpCXEQkH4EAihrIoTapA+8V5qEGc6G2o/OGEIwjLLkn2p06sSag5e+oayhSNa8P9fcwHV6NPnhKWou/AlrJ8+NuzlQUqriF6HfWDfujap90RxihOhd60t3LQR/L0LnvTF7hF02R43sFfyR56XOv1v+IsYCA0KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790599397; c=relaxed/simple;
	bh=uS5sHY5MX3ZPHyYMSIICO/B13TTbXXhRdzWlpalGKQE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fkUDKyQkCraj4KTxMucHPFdNckBTCFnM0jM5MsjXVRJVjR8/wh/meOvWrC27YZTmTtTZSO4dedpq/Op1JyEkGt/xu9EYdmyhOFli2k/3u/zMYqoWt2UdKc6zWitvLymiCEL9UoNUZxJkbx1UZD6y0ZWKu3OwdbRgGYrwJm1FDOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SMFUUz26; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SMFUUz26"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790599396; x=1822135396;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uS5sHY5MX3ZPHyYMSIICO/B13TTbXXhRdzWlpalGKQE=;
  b=SMFUUz26v2/bp0xz3ISswj8HdR6ajyvj3q9wOPjHVWUKz1gHWe2i3hUl
   Jl7+uA92p0gYEkFJksnlzbZa8rnbJjBSUwePi7bKNwHYHZUSYICcG9MIY
   QgoiszAwMxfe9WzUfWuFChMb3vVCpkxm8wQ1wEoEz3OxA/BKF12hJwEFT
   pSkLFDjMYGEGPd48LgliD3umAEHEZjoYiEr2Y6hq0e/TxW+Q8su6mRcUD
   KycLdcKFEkl8A7uB0kw/Uj0t6RXkLe167b4yk8/ofr4FQJ0JfZOL5oUG/
   UFI1ndD7OhsC3QrwoO3uLhT6tJ/Uvr+o9Y6TciZdsWI+YVPVSpy1ITswZ
   w==;
X-CSE-ConnectionGUID: gzWKs0yiSnmkODRaCtvN2g==
X-CSE-MsgGUID: rs2errR+SqKUhYv1MeLIKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11918"; a="102667965"
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="102667965"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 05:43:15 -0700
X-CSE-ConnectionGUID: 20PQfys1R52FHVq7fn5Zww==
X-CSE-MsgGUID: j1oCOuChRhKcEgFtD8WvhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="312958792"
Received: from conormcd-mobl2.ger.corp.intel.com (HELO [10.245.244.73]) ([10.245.244.73])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 05:43:08 -0700
Message-ID: <e61fcc1552447e628b7ec938ac7e4e36555ebec2.camel@linux.intel.com>
Subject: Re: [PATCH v8 22/23] PCI/P2PDMA: Evaluate the ATS path for clients
 with ATS enabled
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>,  Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, iommu@lists.linux.dev, Tushar Dave
 <tdave@nvidia.com>, 	linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, 	linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org,  Chaitanya Kulkarni	
 <kch@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens
 Axboe	 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>, Ankit Agrawal
	 <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan	
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Sumit
 Semwal	 <sumit.semwal@linaro.org>
Date: Mon, 28 Sep 2026 14:43:06 +0200
In-Reply-To: <20260928-fix-p2p-acs-v4-0-v8-22-404453b9c435@nvidia.com>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
	 <20260928-fix-p2p-acs-v4-0-v8-22-404453b9c435@nvidia.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-09-28 at 14:19 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> P2PDMA assumes every client issues Untranslated Requests. A device
> with
> ATS enabled may translate any address it is handed, including a bus
> address, and Translation Blocking can reject its Translated Requests
> on
> a route the Untranslated answer called usable.
>=20
> Unless the client declared per-mapping ATS, take the Address Type
> from
> its ATS Enable bit. Never hand such a client bus addresses: only an
> IOVA
> survives translation, and whatever it issues untranslated goes
> through
> the host bridge, whose route must therefore be usable. Apply this
> after
> the cache, which keeps holding answers that depend only on the
> topology.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>

> ---
> =C2=A0Documentation/driver-api/pci/p2pdma.rst |=C2=A0 8 ++++++
> =C2=A0drivers/pci/p2pdma.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 50
> +++++++++++++++++++++++++++++++--
> =C2=A0include/linux/pci-p2pdma.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +-
> =C2=A03 files changed, 58 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/driver-api/pci/p2pdma.rst
> b/Documentation/driver-api/pci/p2pdma.rst
> index 7a7f29f455b0..bf9f96c07b58 100644
> --- a/Documentation/driver-api/pci/p2pdma.rst
> +++ b/Documentation/driver-api/pci/p2pdma.rst
> @@ -40,6 +40,14 @@ A client therefore describes its traffic with
> ``enum pci_p2pdma_tlp_flags``
> =C2=A0and asks ``pci_p2pdma_map_type_tlp()``. ``pci_p2pdma_map_type()``
> answers for
> =C2=A0the default: strictly ordered Requests carrying an Untranslated
> address.
> =C2=A0
> +The PCIe ATS Enable bit covers the whole device, and most devices
> translate
> +any address they are handed once it is set. Unless a driver has
> declared with
> +``pcim_p2pdma_set_ats_per_mapping()`` that its device chooses ATS
> per mapping,
> +that bit rather than the flags decides the Address Type, and a
> client with ATS
> +enabled is never handed a bus address, which it would translate as
> though it
> +were an IOVA. Its Translated Requests may still route directly, but
> anything
> +it issues untranslated reaches the host bridge, so that route has to
> work too.
> +
> =C2=A0The two directions are decided independently. Translation Blocking
> (TB),
> =C2=A0Direct Translated P2P (DT), Request Redirect (RR) and Egress Contro=
l
> (EC) on
> =C2=A0the client-side port decide the Request:
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index ae676509f9f3..ca79af2e64c7 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -1595,6 +1595,41 @@ void pcim_p2pdma_set_ats_per_mapping(struct
> pci_dev *pdev)
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
> =C2=A0
> +static unsigned int pci_p2pdma_client_tlp_flags(struct pci_dev
> *client,
> +						unsigned int
> tlp_flags)
> +{
> +	if (client->ats_enabled)
> +		return tlp_flags | PCI_P2PDMA_TLP_TRANSLATED;
> +
> +	return tlp_flags & ~PCI_P2PDMA_TLP_TRANSLATED;
> +}
> +
> +/*
> + * A client that translates every address it is handed cannot be
> handed a bus
> + * address, which it would translate as though it were an IOVA. Its
> Translated
> + * Requests may still route directly, but a Request it issues
> without a
> + * translation carries the IOVA to the host bridge, so that route
> has to work
> + * as well.
> + */
> +static enum pci_p2pdma_map_type
> +pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev
> *client,
> +			=C2=A0=C2=A0 bool per_mapping, enum
> pci_p2pdma_map_type type)
> +{
> +	if (per_mapping || !client->ats_enabled ||
> +	=C2=A0=C2=A0=C2=A0 type !=3D PCI_P2PDMA_MAP_BUS_ADDR)
> +		return type;
> +
> +	pci_dbg(client,
> +		"P2PDMA ACS: provider=3D%s bus address withheld; ATS
> is enabled for the whole client\n",
> +		 pci_name(provider));
> +
> +	if (cpu_supports_p2pdma() ||
> +	=C2=A0=C2=A0=C2=A0 host_bridge_whitelist(provider, client, false))
> +		return PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
> +
> +	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +}
> +
> =C2=A0/**
> =C2=A0 * pci_p2pdma_map_type_tlp - Determine the mapping type for P2PDMA
> transfers
> =C2=A0 * @provider: P2PDMA provider structure
> @@ -1609,6 +1644,11 @@
> EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
> =C2=A0 * ACS routes a peer-to-peer transaction by the attributes its TLPs
> carry, so
> =C2=A0 * the answer depends on @tlp_flags. A caller that passes flags its
> traffic
> =C2=A0 * does not match gets a mapping the fabric will not deliver.
> + *
> + * Only a client whose driver called
> pcim_p2pdma_set_ats_per_mapping() takes
> + * the Address Type from @tlp_flags. For any other client its ATS
> Enable bit
> + * decides, and a client that translates every address it is handed
> never gets
> + * %PCI_P2PDMA_MAP_BUS_ADDR.
> =C2=A0 */
> =C2=A0enum pci_p2pdma_map_type
> =C2=A0pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct
> device *dev,
> @@ -1620,6 +1660,7 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider
> *provider, struct device *dev,
> =C2=A0	struct pci_p2pdma *p2pdma;
> =C2=A0	struct pci_dev *client;
> =C2=A0	bool provider_state;
> +	bool per_mapping;
> =C2=A0	int dist;
> =C2=A0
> =C2=A0	if (!pdev->p2pdma) {
> @@ -1639,6 +1680,9 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider
> *provider, struct device *dev,
> =C2=A0	cache_index =3D map_types_idx(client);
> =C2=A0
> =C2=A0	rcu_read_lock();
> +	/* The declaration belongs to the client, the cache to the
> provider. */
> +	p2pdma =3D rcu_dereference(client->p2pdma);
> +	per_mapping =3D p2pdma && p2pdma->ats_per_mapping;
> =C2=A0	p2pdma =3D rcu_dereference(pdev->p2pdma);
> =C2=A0
> =C2=A0	if (p2pdma)
> @@ -1646,6 +1690,8 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider
> *provider, struct device *dev,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0 cache_index));
> =C2=A0	provider_state =3D !!p2pdma;
> =C2=A0	rcu_read_unlock();
> +	if (!per_mapping)
> +		tlp_flags =3D pci_p2pdma_client_tlp_flags(client,
> tlp_flags);
> =C2=A0	type =3D pci_p2pdma_map_types_unpack(cached, tlp_flags);
> =C2=A0	pci_dbg(client,
> =C2=A0		 "P2PDMA ACS: map lookup provider=3D%s index=3D%#lx tlp-
> flags=3D%#x cached=3D%s(%d) provider-state=3D%u\n",
> @@ -1653,10 +1699,10 @@ pci_p2pdma_map_type_tlp(struct
> p2pdma_provider *provider, struct device *dev,
> =C2=A0		 pci_p2pdma_map_type_name(type), type,
> provider_state);
> =C2=A0
> =C2=A0	if (type =3D=3D PCI_P2PDMA_MAP_UNKNOWN)
> -		return calc_map_type_and_dist(pdev, client, &dist,
> tlp_flags,
> +		type =3D calc_map_type_and_dist(pdev, client, &dist,
> tlp_flags,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 true);
> =C2=A0
> -	return type;
> +	return pci_p2pdma_client_map_type(pdev, client, per_mapping,
> type);
> =C2=A0}
> =C2=A0
> =C2=A0void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index 543a09426a11..8d96659df9df 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -207,7 +207,8 @@ static inline struct pci_dev
> *pci_p2pmem_find(struct device *client)
> =C2=A0 * @dev: Client device that initiates the transfer
> =C2=A0 *
> =C2=A0 * Same as pci_p2pdma_map_type_tlp() for a client issuing strictly
> ordered
> - * Requests that carry an Untranslated address.
> + * Requests. Their Address Type is Untranslated unless the client
> enables ATS
> + * for the whole device.
> =C2=A0 */
> =C2=A0static inline enum pci_p2pdma_map_type
> =C2=A0pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device
> *dev)
