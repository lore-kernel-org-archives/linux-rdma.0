Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793702095;
	b=LhOEhYVcn3HxW4L4h+KqcRrf9Q3RRLhvScIpsocjtsFp16MHQ5MxMcNAgGY5moL/tSas
	 2qw7kjmrQZpvjtz1K1eYV9F9TwCPyAUhn6tkua742kWtD1Ee9PuifVAoM74JPKsvsHQtT
	 bWRel4XJrR1ftJUicrrI3fShKO4Wiounggn8HA9FemH+FtjmAc1JZpWPyZCl3Ad3rNo8a
	 qgvQ6Nl1ve+YDyEfpm+X8QLny5WNPSdeA9nLzpQdpbr7+ja7Q1o/DVNKOfTOmecG3Quim
	 41nK7NLSftrGUx8B1AQkSov2I7sbDndko9JaeTV8U9YVsrFT0pN5MNED6QBPKW3BplQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793702095;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ukxvASRQHPXLmCBtFGTm4r2/mUdWWRyPzw9bZSdLupc=;
	b=qNawMgpsW+HBFQbfguIcxJyfOB0hOIbX/uox3O7839yKLTqvBJ96ypBjrFJZkV7n6zVk
	 U+/lcONZKfloNpdD862OFBFNFo2jP3CHx2ieCm4+xT6PG5Lz7CPTqn5gLlSbGzbS4+dKY
	 krThdCOyViTFUp83mGyI45I56vR3M77O+LTWo6psmxpujTc1zJVQZUXxgeEtW0tPQVPhI
	 Tc64Yh+XVWM1wNY/76TBbgjLEiqQ6UKHtk+WRvOZ5kxRkViged1QjOedYdUKEDGqby3kj
	 CNDSzxOAez4xLJlLy+PZ7ywhzaBwN4whIgMSROQ5Y5Q1YgPeuzloe3pW5bqh9vdb17g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PU8IZPSG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99993607379D;
	Tue,  3 Nov 2026 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PU8IZPSG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CEE1F0093A;
	Tue,  3 Nov 2026 10:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793702095;
	bh=ukxvASRQHPXLmCBtFGTm4r2/mUdWWRyPzw9bZSdLupc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PU8IZPSGt48klsHyuHjT7L1E2JvLVmsEQ6PK0DqG4rF/WsF7i6K8VIfUhkjjLlD12
	 pEda7JdJaQhDXlZpEsUj035g5MbG4Og8GuSiMLaibizZc3S4iGeriU4d3lMxgyu+ZW
	 wQL6eN7ok3I0WhTcU/W5oNpSMyofRZYrPVYOXUEIw5bLt40vWC6ZSlCoekl2l42u3H
	 l48AoNe4PHEJqCTHHRJ1ThfWuY+6xmUu3k24iHi3h3hlqqBQWA6Lfr7GUwqQReJ+h9
	 +tzJFhoPHu+Tl2mk9sNHtzGCECAYPcErIrWOsJalpI9jWKQVeKnRpdkdgmCK4ES05O
	 m+ZP6GiADl+Ag==
Message-ID: <sashiko-outbox-195058@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 10/19] PCI/P2PDMA: Reject Translated Requests
 blocked by Translation Blocking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-10-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-10-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 10:34:54 +0000
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
- [Medium] PCI/P2PDMA: missing Intel SPT PCH ACS Control offset check for P=
CI_ACS_TB
--

commit b8a9e833dab26624045a5e241b8edb8d281747c8
Author: Leon Romanovsky <leon@kernel.org>

PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking

This commit teaches P2PDMA to check ACS Translation Blocking across the
ports traversed by a peer-to-peer route and reject Translated Requests
when any port along the path blocks them.

> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 785e4668a2af5..fc4dea28c8606 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
[ ... ]
> @@ -678,6 +691,39 @@ pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev=
 *common)
>  	return NULL;
>  }
> =20
> +/*
> + * Report whether any port between @client and @common rejects Translated
> + * addresses. If @common is NULL, every port up to the host bridge is wa=
lked.
> + * A port whose ACS Control cannot be read counts as blocking, which wit=
hdraws
> + * only the Translated classes because an Untranslated Request is routed=
 by the
> + * redirect controls instead.
> + */
> +static bool pci_p2pdma_path_blocks_translation(struct pci_dev *client,
> +					       struct pci_dev *common)
> +{
> +	struct pci_dev *pdev;
> +	u16 ctrl;
> +
> +	/*
> +	 * @common is @client itself when the provider is the client or sits
> +	 * below it. The Request never travels upstream then, so no port sees
> +	 * it and none can reject its Address Type.
> +	 */
> +	if (client =3D=3D common)
> +		return false;
> +
> +	for (pdev =3D pci_upstream_bridge(client); pdev && pdev !=3D common;
> +	     pdev =3D pci_upstream_bridge(pdev)) {
> +		if (!pci_acs_p2pdma_ctrl(pdev, &ctrl))
> +			return true;
> +
> +		if (ctrl & PCI_ACS_TB)
> +			return true;
> +	}

[Severity: Medium]
When calc_map_type_and_dist() calls pci_p2pdma_path_blocks_translation()
with common set to NULL (either when path.no_common_bridge is true or
when checking path.tb_above_divergence from b_child up to the root bus),
this loop walks all the way up to the Root Port.

On Intel Sunrise Point, Union Point, and 7th/8th Gen Mobile PCH Root
Ports matched by pci_quirk_intel_spt_pch_acs_match(), pdev->acs_cap is
non-zero, but due to hardware errata the ACS Capability and Control
registers are 32-bit dwords rather than 16-bit words. As a result,
pci_quirk_enable_intel_spt_pch_acs() programs PCI_ACS_TB into
pos + INTEL_SPT_ACS_CTRL (offset 8):

drivers/pci/quirks.c:pci_quirk_enable_intel_spt_pch_acs() {
	...
	pci_read_config_dword(dev, pos + PCI_ACS_CAP, &cap);
	pci_read_config_dword(dev, pos + INTEL_SPT_ACS_CTRL, &ctrl);
	...
	if (pci_ats_disabled() || dev->external_facing || dev->untrusted)
		ctrl |=3D (cap & PCI_ACS_TB);

	pci_write_config_dword(dev, pos + INTEL_SPT_ACS_CTRL, ctrl);
	...
}

However, pci_acs_p2pdma_ctrl() reads the 16-bit word at pos + PCI_ACS_CTRL
(offset 6), which on these Root Ports is the upper 16 bits of the 32-bit
ACS Capability register (reading as 0):

drivers/pci/p2pdma.c:pci_acs_p2pdma_ctrl() {
	...
	if (pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl) ||
	    PCI_POSSIBLE_ERROR(*ctrl))
		return false;

	*ctrl =3D pci_acs_p2pdma_quirk_redirect(pdev, *ctrl);
	return true;
}

Unlike pci_acs_p2pdma_no_upstream_forwarding(), which consults
pci_dev_specific_acs_enabled() when walking to the Root Port,
pci_p2pdma_path_blocks_translation() only inspects ctrl from
pci_acs_p2pdma_ctrl().

Won't pci_p2pdma_path_blocks_translation() miss PCI_ACS_TB on these
Intel PCH Root Ports and allow calc_map_type_and_dist() to return
PCI_P2PDMA_MAP_THRU_HOST_BRIDGE instead of
PCI_P2PDMA_MAP_NOT_SUPPORTED for Translated Requests that the Root Port
will reject?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D10
