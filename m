Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793868142;
	b=DXpHvBQHlRW5chf7iS+5XeYzTnjhHNAluEKvBNvOZBT+zAbcrSQiObH4Lho6RfwniEDA
	 y3MaemOESzVxRfVoThKhrq9zFwsUCAXvETi6pPPkA4M2JKjI3hESKKCvq9f0fljYPK3U7
	 E+H+ySlcYW+eu/s0PDHSPS9TNTW231XJX7NenHfp5qbQRYGR4s3k9FvPvYV3JiacE2bIl
	 TlxEpxSFadhNYMRK0s/3iLN8JnqeTc0hfdETZa9jN1hGQ254Q0EvIU7+dT6es5r8X8CHF
	 oIGAXcIOJJB+FWfmOjXqLtIvgmV7c7n6YcPua7lPcOfpqDOYqpHYKTwrOkXl9FbluJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793868142;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=rvsdMBspxxqECpjbAI42lx5NbPMQgGmPQp0lLwZaU7I=;
	b=wg8kO/XShaVlRAy94BhAegIYCPYbnlUAWI7Q9c2MHeLRMy9jZAUPvJS7uV6OZl7yStCM
	 b3ShtkflGvtZK2dpX7mSg9UUG1k9TgvLdCcoSumNIvOeRyQetH1E7lfNq8x7ldc/IDfzG
	 ulUn1gYynnKbEW16Uw0V9B0pv7Ro/kgMhjzbOYd3FIujI1zMR8zX4csTNqNEJSSjSl9E5
	 Q+fLchvvhoApwf+67JB5llVGYtZrmFu8rFMt5tGAxiSBx2UvcvSSe/VRJaHSZTSdppesq
	 tmsabR5BJ6fguiexJQ9r5jKkpY+PQOmJyptf5PRQEIa/XHAaNoRqA8wtVMfp8djufOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="B41/EYZN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF3E606A32C;
	Thu,  5 Nov 2026 08:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B41/EYZN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173321F000C1;
	Thu,  5 Nov 2026 08:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868141;
	bh=rvsdMBspxxqECpjbAI42lx5NbPMQgGmPQp0lLwZaU7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B41/EYZNq0qVnbGM0+UPdI+TmVYCH8wdptnRHUogjpZEWiWsVErfrqXjQp06oVawG
	 XkincJ0pHFnuaEM4S79uEMbnoIXOr5JF0GT4VPqgOI9FQzCZoubKwAM24J8TfJAPfH
	 hUOncuyRHxk4c6EiPBa5rceqbp5ZPMasjapX/5VDsie96uWO/FxPDZcj16EjXolUUy
	 gzNzmnzhPNYVuHbTTmMDpFtrEpeZ1mSHeB1nbjfc2aZZEp+TAC3MLfd9fVf23UNflV
	 syv8SL/fn92MXH9/15ucH1ODMGO3+yC0lC2OMmXW22DreMHPBIj3rkjoUEDjPllA+I
	 6xcO7/dAsiVlA==
Date: Thu, 5 Nov 2026 10:42:17 +0200
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	media-ci@linuxtv.org
Subject: Re: [PATCH v12 15/19] PCI: Add KUnit coverage for ACS isolation
 checks
Message-ID: <20261105084217.GJ478286@unreal>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-15-912101f93517@nvidia.com>
 <sashiko-outbox-195118@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-195118@kernel.org>

On Tue, Nov 03, 2026 at 11:11:10AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] PCI: duplicated mock device setup in pci_acs_flags_enabled_test()
> --
> 
> commit cd21c328560f2b4befdb418098279304a429237f
> Author: Leon Romanovsky <leon@kernel.org>
> 
> PCI: Add KUnit coverage for ACS isolation checks
> 
> This commit exposes pci_acs_flags_enabled() when KUnit is enabled and adds
> KUnit tests in drivers/pci/pci_acs_test.c using mock config-space operations
> to verify ACS isolation checks, missing capabilities, and failed config reads.
> 
> > diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
> > index 18c697226762d..369444d2a04a0 100644
> > --- a/drivers/pci/pci_acs_test.c
> > +++ b/drivers/pci/pci_acs_test.c
> > @@ -103,10 +103,145 @@ static void pci_acs_p2pdma_completion_test(struct kunit *test)
> 
> [ ... ]
> 
> > +static void pci_acs_flags_enabled_test(struct kunit *test)
> > +{
> > +	const struct acs_isolation_case *c = test->param_value;
> > +	struct acs_ctrl_cfg cfg = {
> > +		.devfn = PCI_DEVFN(0, 0),
> > +		.cap = ACS_TEST_CAP,
> > +		.ctrl = c->ctrl,
> > +	};
> > +	struct pci_bus *bus = kunit_kzalloc(test, sizeof(*bus), GFP_KERNEL);
> > +	struct pci_dev *pdev = kunit_kzalloc(test, sizeof(*pdev), GFP_KERNEL);
> > +
> > +	KUNIT_ASSERT_NOT_NULL(test, bus);
> > +	KUNIT_ASSERT_NOT_NULL(test, pdev);
> > +
> > +	bus->ops = &acs_ctrl_ops;
> > +	bus->sysdata = &cfg;
> > +
> > +	pdev->bus = bus;
> > +	pdev->devfn = cfg.devfn;
> > +	pdev->acs_cap = ACS_TEST_CAP;
> > +	pdev->acs_capabilities = ACS_ALL_CAPS;
> > +
> > +	KUNIT_EXPECT_EQ(test, pci_acs_flags_enabled(pdev, c->req), c->expect);
> > +}
> > +
> > +static bool acs_isolated(struct kunit *test, struct acs_ctrl_cfg *cfg,
> > +			 u16 acs_cap, u16 acs_flags)
> > +{
> > +	struct pci_bus *bus = kunit_kzalloc(test, sizeof(*bus), GFP_KERNEL);
> > +	struct pci_dev *pdev = kunit_kzalloc(test, sizeof(*pdev), GFP_KERNEL);
> > +
> > +	KUNIT_ASSERT_NOT_NULL(test, bus);
> > +	KUNIT_ASSERT_NOT_NULL(test, pdev);
> > +
> > +	bus->ops = &acs_ctrl_ops;
> > +	bus->sysdata = cfg;
> > +
> > +	pdev->bus = bus;
> > +	pdev->devfn = cfg->devfn;
> > +	pdev->acs_cap = acs_cap;
> > +	pdev->acs_capabilities = ACS_ALL_CAPS;
> > +
> > +	return pci_acs_flags_enabled(pdev, acs_flags);
> > +}
> 
> [Severity: Low]
> This isn't a bug, but in drivers/pci/pci_acs_test.c,
> pci_acs_flags_enabled_test() open-codes the same mock struct pci_bus and
> struct pci_dev allocation and initialization that acs_isolated() performs
> immediately below it.
> 
> Also, struct acs_ctrl_cfg already carries the cap field, which every caller
> initializes to the same value passed as the separate acs_cap argument to
> acs_isolated().
> 
> Could acs_isolated() set pdev->acs_cap from cfg->cap directly, and could
> pci_acs_flags_enabled_test() call acs_isolated() to avoid duplicating the
> setup?

Yes, I can combine them.

Thanks

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com?part=15
