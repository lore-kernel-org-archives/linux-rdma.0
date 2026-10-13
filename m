Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3BC519933;
	Tue, 13 Oct 2026 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902947; cv=none; b=RHLM2NvsWWJpy9RWPDgXEnDb/8Tgaj+0Ca+mMNXDz389v4pCxBOMAS/zodEJE8tcUQN70Ns/IOKoMxOjbjhe9AHnbQ2a60z8iEsEBBBbMma9aAWyslZVO76DhgNAgiyGCRcdI0NnIcNZiABADzzYvFQhLZ2o5/shpXBiVD17QDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902947; c=relaxed/simple;
	bh=XFj36snZ9m66uU/1UVWS62IvY5m6xkqcPnXJJX5Lm5Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rgxH2zzpEgQplyX7CTOP2TzcZRZ8sRnM/sFnlvZpjq1hLe5tcSo03aoYlCm4lN63+r7i8QxxybW1h6FqwDDSuQ1eKAhqQ+U1VbQ0ncPV77zxgyV2MEKN22bH6fVLuAWWYbbR2EsorE9CnQxHhFY3AasFHF3RpmdvZiU2GoS3tAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnj49b4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnj49b4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336321F000FF;
	Tue, 13 Oct 2026 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902946;
	bh=YeatyE4qMiqeOmOYF1GTQE2N5EM+utj3egUlVJvVLOI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nnj49b4T1cLbjzrLSfCfMjKuexzh7LMSysh/jQJ/MgpNqJduunGAhVbiH750pwYWX
	 dJwWGd01OTwnw2wll0TL1I8yoOEqdjgsjQLvPjA3O7kbUUgJIDeWkL9g4cugo5DXeL
	 ibMG0SkgN0aWNIuZnqxNp3Dzx1l8nPRcSBqARA8sACMg41yooLva/ObbiSRfLcETTK
	 mLSTZ6i+ytpU9hwaDHG9lgCOqLxlQOWYCifPqKwnWFu04oX2pSC/qAKmFTp1L9jpbs
	 B6aAce0FuQtrDX4F+UsO1NwTp8oK3i4f98xz1RxMVhA8S2zIPmGQrAVUtvuUdbs8nn
	 fs1Mo+tqSt4dw==
Message-ID: <sashiko-outbox-169939@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 10/19] PCI/P2PDMA: Reject Translated Requests
 blocked by Translation Blocking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-10-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-10-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:49:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] pci/p2pdma: deadlock in calc_map_type_and_dist() due to non-IRQ-sa=
fe xa_store()
--

commit f019da119f00a99a75cbfe2deec0db131a89232d
Author: Leon Romanovsky <leon@kernel.org>

PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
   =20
ACS Translation Blocking rejects upstream Memory Requests with a Translated
address before any peer-routing controls apply, per PCIe r7.0 sec 6.12.1.1.
P2PDMA ignores that bit and can report a route whose ports reject the
Requester's address type.
   =20
Add PCI_ACS_P2PDMA_BLOCKED and scan the ports traversed by each route. A
direct route passes only ports below the divergence; a host-bridge route
also passes the common port and its ancestors. Reject the affected class
without falling back to another route, and preserve blocking precedence
over internal-route restrictions.

> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 785e4668a2af5..fc4dea28c8606 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
[ ... ]
> @@ -1162,6 +1252,11 @@ calc_map_type_and_dist(struct pci_dev *provider, s=
truct pci_dev *client,
>  		}
>  	}
> =20
> +	path.tb_on_path =3D pci_p2pdma_path_blocks_translation(client, a);
> +	if (b_child)
> +		path.tb_above_divergence =3D
> +			pci_p2pdma_path_blocks_translation(b_child, NULL);
> +
>  	/*
>  	 * The walk and the config reads above serve every class; only the
>  	 * decision below depends on the kind of TLP being routed.

[Severity: High]
Does xa_store() use an IRQ-safe lock here?

The calc_map_type_and_dist() function caches routing results by calling
xa_store() later in this function:

	xa_store(&p2pdma->map_types, map_types_idx(client),
		 xa_mk_value(pci_p2pdma_map_types_pack(map_type)),
		 GFP_ATOMIC);

xa_store() implicitly acquires xa->xa_lock using a plain spin_lock(), which
does not disable hardware or software interrupts.

Since calc_map_type_and_dist() is reachable from process context
(e.g., during target configuration via pci_p2pmem_find_many()), what happens
if a P2PDMA IO mapping request is processed in softirq or hardirq
(e.g., dma_map_sg -> pci_p2pdma_map_type_tlp during an NVMe-oF RDMA
completion) on the same CPU and experiences a cache miss?

It seems it will interrupt the process context, re-enter
calc_map_type_and_dist(), and attempt to acquire the same xa->xa_lock via
xa_store().

Could this result in a hard deadlock since the lock is already held by the
interrupted thread on the same CPU?

Additionally, the XArray appears to be initialized without XA_FLAGS_LOCK_IRQ
in pcim_p2pdma_init():

	xa_init(&p2p->map_types);

To safely update the XArray from contexts that include interrupts, should t=
he
driver acquire the lock with IRQs disabled (e.g., using
xa_lock_irqsave(&p2pdma->map_types, flags); __xa_store(...);
xa_unlock_irqrestore(...))?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D10
