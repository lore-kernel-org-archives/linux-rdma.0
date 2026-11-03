Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704271;
	b=Wx0rc4jtxghCftA6xh/Vxs/aDcQzSExV/hBLwW/x9J5M50HV66nIJUdH3eqGCXW+1UTY
	 xY4disppScVbKo96NqEq0HYHBQt31g3KdTgIXqt7wxFNO8iF1EnEx+anTUfSBW5dFeibb
	 XGijw2H3CAFuiP5h+gBZqgs+HQ4ise46jIodgcgDrVrxsf7LlPWtDHk8kEEA8sErNQJnj
	 IVXQ/JRfjUSTz99GSgoWHF8FywBCTUCdawICFBMC7bKaEb+mzP+YuHPIi2Al5ZM00ThJs
	 /pca0+R9oHSNhSmZvEE6QWZsRWH35WX3hlXGHpodoMxNOdZ47iottm0FOz48/gXVVfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704271;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ywwUAKa1nCAbjT7Xu8wZ5Kot6vkSOvPDdhJKT7WlCes=;
	b=KQdgHaPU/k2nc69m8nnpi/D/C01xXQNPyHcolmV0gC9t0jBKDLlDP/1ptzyfnZkhAr0P
	 o+NNsmV9seZ+Fgaz+HI+9O2GYYhhMtPHmZoAF3f031kAT6Pzs+ch058xquynnZf+BgzKN
	 g4aovPNwjG2hC+H7WUN1gkgxnwYL5IQalPmOW5v3Z2yz24c/e9mgm+liMIPeYZPeZL4Ux
	 Wy3cRaUAPMiEUNVQLN36ABpE7C66c8ZTGqNVbeYzJGvTbM6weyvy8rhwHVdtjtYbNO1Ld
	 vy1Gw4cz2LDXH8X/4duOCAdXgeyZCXOp71dQ0aFnyXo/ZzZt4GKKi1o3AK8Hmv1gA0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=anqu3ch+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CBE606FAE9;
	Tue,  3 Nov 2026 11:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=anqu3ch+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2F01F00919;
	Tue,  3 Nov 2026 11:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793704271;
	bh=ywwUAKa1nCAbjT7Xu8wZ5Kot6vkSOvPDdhJKT7WlCes=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=anqu3ch+a+QVzGboMFM7Xbz+NlsiZjDpCKAaDxO9/ZnqJcfsvq22AFFh+InK24gnn
	 SoOrh8yoSmD5KSFYljB7JFEi+Gy3pcgbhA9jFwfRm/AIWeKz4XL4JuUp2wKNJ2KLz9
	 or0T8Pbl3Qm4Zca4Q4QORVp7Y5yIceIZnOvlmo0fSPIdAon0jx107nc2B0qh89d9Mo
	 ieZC1oMkZV5SwKjskyESCfsNjb6D5BuCJVcS6c/dKuhncVaviqCwSryZvIb/ftBiaZ
	 Zh8hhS1VcFEZBeUoHdDL/2XApkFNO2PO4yjEYmzDvpuIVh2SJ+p4MgifYOnjyn7Thk
	 XUEWsviA2P15A==
Message-ID: <sashiko-outbox-195118@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 15/19] PCI: Add KUnit coverage for ACS isolation
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-15-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-15-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:11:10 +0000
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
- [Low] PCI: duplicated mock device setup in pci_acs_flags_enabled_test()
--

commit cd21c328560f2b4befdb418098279304a429237f
Author: Leon Romanovsky <leon@kernel.org>

PCI: Add KUnit coverage for ACS isolation checks

This commit exposes pci_acs_flags_enabled() when KUnit is enabled and adds
KUnit tests in drivers/pci/pci_acs_test.c using mock config-space operations
to verify ACS isolation checks, missing capabilities, and failed config rea=
ds.

> diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
> index 18c697226762d..369444d2a04a0 100644
> --- a/drivers/pci/pci_acs_test.c
> +++ b/drivers/pci/pci_acs_test.c
> @@ -103,10 +103,145 @@ static void pci_acs_p2pdma_completion_test(struct =
kunit *test)

[ ... ]

> +static void pci_acs_flags_enabled_test(struct kunit *test)
> +{
> +	const struct acs_isolation_case *c =3D test->param_value;
> +	struct acs_ctrl_cfg cfg =3D {
> +		.devfn =3D PCI_DEVFN(0, 0),
> +		.cap =3D ACS_TEST_CAP,
> +		.ctrl =3D c->ctrl,
> +	};
> +	struct pci_bus *bus =3D kunit_kzalloc(test, sizeof(*bus), GFP_KERNEL);
> +	struct pci_dev *pdev =3D kunit_kzalloc(test, sizeof(*pdev), GFP_KERNEL);
> +
> +	KUNIT_ASSERT_NOT_NULL(test, bus);
> +	KUNIT_ASSERT_NOT_NULL(test, pdev);
> +
> +	bus->ops =3D &acs_ctrl_ops;
> +	bus->sysdata =3D &cfg;
> +
> +	pdev->bus =3D bus;
> +	pdev->devfn =3D cfg.devfn;
> +	pdev->acs_cap =3D ACS_TEST_CAP;
> +	pdev->acs_capabilities =3D ACS_ALL_CAPS;
> +
> +	KUNIT_EXPECT_EQ(test, pci_acs_flags_enabled(pdev, c->req), c->expect);
> +}
> +
> +static bool acs_isolated(struct kunit *test, struct acs_ctrl_cfg *cfg,
> +			 u16 acs_cap, u16 acs_flags)
> +{
> +	struct pci_bus *bus =3D kunit_kzalloc(test, sizeof(*bus), GFP_KERNEL);
> +	struct pci_dev *pdev =3D kunit_kzalloc(test, sizeof(*pdev), GFP_KERNEL);
> +
> +	KUNIT_ASSERT_NOT_NULL(test, bus);
> +	KUNIT_ASSERT_NOT_NULL(test, pdev);
> +
> +	bus->ops =3D &acs_ctrl_ops;
> +	bus->sysdata =3D cfg;
> +
> +	pdev->bus =3D bus;
> +	pdev->devfn =3D cfg->devfn;
> +	pdev->acs_cap =3D acs_cap;
> +	pdev->acs_capabilities =3D ACS_ALL_CAPS;
> +
> +	return pci_acs_flags_enabled(pdev, acs_flags);
> +}

[Severity: Low]
This isn't a bug, but in drivers/pci/pci_acs_test.c,
pci_acs_flags_enabled_test() open-codes the same mock struct pci_bus and
struct pci_dev allocation and initialization that acs_isolated() performs
immediately below it.

Also, struct acs_ctrl_cfg already carries the cap field, which every caller
initializes to the same value passed as the separate acs_cap argument to
acs_isolated().

Could acs_isolated() set pdev->acs_cap from cfg->cap directly, and could
pci_acs_flags_enabled_test() call acs_isolated() to avoid duplicating the
setup?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D15
