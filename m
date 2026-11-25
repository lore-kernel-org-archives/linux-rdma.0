Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795584861;
	b=yqkg8v4I0hSptUxWaNO9bSaDTlFc0Gr8hwPKOTY/V1MGosr/woCsPEpJ2zLHcM01JlA6
	 746/CljgaHrgMXknX6PkoMLy8fR2liCY71keULtdINJwzaN/vIoQ5Sn0cg+WFZQv6hdz7
	 w9duHooXRPsDGIWf7I058krtTOM55VfVxIhlP5nLcE6J3NlhmvXXRFe+bGKRhddes2d0l
	 RKJggfgjit4DKTh4MfMezHU0D1LpZDALwC5XnL/qzfcywnSmz7XYWh8LMHfjZkdpLLFHF
	 ZYSVcgtKjREOrwLsOFuW2hCZnB8QhGGdFBn8PQaMbFtt65s+StQB1OiHqUNsXAW17KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795584861;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=O6Ks90UOzjrAcrR9Y56o/keqAZb9C70ipG1oPffIQ5k=;
	b=J4GQwF33gi2Cb3upihSY/n3vawOgxHyEC1R3MhQCLov31K3kqs+04B3XTuCjuPYZx+TW
	 PncrrJRrvnqc79zNRga6glrbeCDblkpgNnFmovPY9zKo6ebLEjERD0MNJXjTzdy6vDBvg
	 aa8U9lgSNn80Doij6pnGWikBaWNU4JjOxki14gGuVXPKNNuRoUa5QuFSSN4zME8I9/bzH
	 L0Bz7xU59lf6GZipoz1v0KcVl4+Fp9YqdKeDadRA75UmRLSBoZT0I761HKLiXTWDMfzHT
	 aEzivwom7T1YOZasROWJxg4pys9vqlYSWCPw6ZFmc/5esS5EHjbMPimT4PEXo1vqnIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DBB606A31E
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 05:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84DBB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6BCD68AFE; Wed, 25 Nov 2026 06:34:16 +0100 (CET)
Date: Wed, 25 Nov 2026 06:34:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	kbusch@kernel.org, axboe@kernel.dk, sagi@grimberg.me, jgg@ziepe.ca,
	leon@kernel.org, asml.silence@gmail.com, joshi.k@samsung.com,
	anuj1072538@gmail.com, linux-nvme@lists.infradead.org,
	linux-rdma@vger.kernel.org
Subject: Re: [RFC 4/4] nvme-rdma: support dma-buf backed requests
Message-ID: <20261125053416.GB20407@lst.de>
References: <20261118103327.1788667-1-anuj20.g@samsung.com> <CGME20261118103457epcas5p17770752b910960b84cc259d007120965@epcas5p1.samsung.com> <20261118103327.1788667-5-anuj20.g@samsung.com> <20261121003730.GB14598@lst.de> <20261123111040.7b2q7fe2xd6k6777@green245.gost>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123111040.7b2q7fe2xd6k6777@green245.gost>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 23, 2026 at 04:46:55PM +0530, Nitesh Shetty wrote:
> On 21/11/26 01:37AM, Christoph Hellwig wrote:
>> How does this work with rxe/siw or non-PCIe based HCAs?
>>
> rxe/swi do not provide a DMA device, so registration fails with
> -EOPNOTSUPP (patch 3).
>
> For hardware HCAs, the dma-buf is attached to the DMA device of the
> ib_device. Nothing in the mapping path is PCI specific, and if P2P is
> not possible for non-PCI device, we expect the exporter's
> pci_p2pdma_distance() check to take care of it. We do not have access to
> non-PCI HCA setup, so that path is untested.

Ok.  Can you add comments?

