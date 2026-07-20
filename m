Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E20D421F18;
	Mon, 20 Jul 2026 18:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784573002; cv=none; b=Ij4yUu4ToI5M2ZjlrFaMbqQfTb1obvk6agKJxQLfTSNTh8tEbrZAPh9JrF00ELZHiNomcJQUgH7syXKNNu7j70L15QtMf+lfwZDmG/SvI5QQ99zu80Hh2ZQgmuAXGmziBvCLaIMSK24fhWMX5iFbVrMB8KQSieKcrrkApiRj2xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784573002; c=relaxed/simple;
	bh=ayzPU5TcsMBPQf3X2iyqylXARKQQmJBw8aj1nHxUJ8A=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=Q5vttzd7fqLDn3Yjrz8ZNp8pGcRccgtWNuoya3nDBu9T+bzzFgFZ+WSVUxs6mfktXotoIEMhaRHRg4eN9ATAqp6Hc5AXQ8YK2nKunLaSJflqtgrJrM6T4qDndA+27SwA8hzg87MMMkFS9Y/3B2QKvDJo+KX/fSfAy+ck4xVfxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=G78R0G4A; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="G78R0G4A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=YELh0b3QajkSD4msD1qE3xlvEfmbrtR4vMSO8zUFNP4=; b=G78R0G4ApJYfZi/9vAbiWuWhBT
	yw/nzVk23WLIDxAxG4p8fgkx8rE8TaNly1j1YYzp9MmCQmD6/RWuWBzYbnqTsTMtJzGYBKOoGWby+
	4SiaXgSFbifrGrkVFDWWqFSYfoLAAhIniOb3YLTfQ/mhFupBe+ASo7FyWIIN8AlHr4OljXgP6eDLZ
	ZzplaghNrp6Xw9vS7ZQUgHAAgVWAwO7MFIEoOSECgJEQk5WcUbXOJQlnQeIrPHt2hGm5+JRpqg28C
	ugA/Edsoo0QLXysrw65j4Sfe39CWGmpmmtuRxwM8liCCK6a4Qnt0KZy6m3GUjPmjP0+dB8Jxld5FH
	XAKLxcJg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wlsxK-0000000B7jc-1nFA;
	Mon, 20 Jul 2026 12:43:11 -0600
Message-ID: <b2c37f4f-79dd-428f-915a-2a862d20924c@deltatee.com>
Date: Mon, 20 Jul 2026 12:42:50 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mykola Marzhan <mykola@meshstor.io>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fygo.io>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Guoqing Jiang <guoqing.jiang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava
 <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-pci@vger.kernel.org
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-2-mykola@meshstor.io> <20260720144943.GA17375@lst.de>
 <CAPzsNDv6hUV3gHdaxuwjRcr4couUKq_M5DKObFNaYqCHnm7ZMw@mail.gmail.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CAPzsNDv6hUV3gHdaxuwjRcr4couUKq_M5DKObFNaYqCHnm7ZMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, hch@lst.de, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v2 1/7] blk-mq-dma: restore BLK_STS_TARGET for unsupported
 P2P transfers
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-20 11:30, Mykola Marzhan wrote:
> On Mon, Jul 20, 2026 at 4:49 PM Christoph Hellwig <hch@lst.de
>> This is a really weird writing style, and suggested to me you neither
>> understand the code nor the problem.  Please actually think yourself,
>> write the patches and commit logs yourself instdad of this garbage.
>> 
>> And please also explain how you even generate the I/O that fails this
>> way.
> - md mirrors the write: the copy to member 1 succeeds, the copy to far
> member fails as BLK_STS_INVAL.
> - md deliberately ignores BLK_STS_INVAL, so the write is counted as
> written and the mirror silently diverges.

Seeing I just reviewed this and answered it for myself I'll expand on
what's going on here:

The switch statement will take the default branch when
pci_p2pdma_state() returns PCI_P2PDMA_MAP_NOT_SUPPORTED. This indicates
the memory that's trying to be mapped in this way will not succeed
because it's going through an unsupported host bridge (or if the device
isn't a PCI device, etc, but this is rarer or perhaps not possible).
Returning BLK_STS_INVAL doesn't seem correct here, to me. (Arguably it
might have been clearer if the switch case explicitly stated
PCI_P2PDMA_MAP_NOT_SUPPORTED instead of relying on the default).

Returning -EREMOTEIO/BLK_STS_TARGET was the convention for this I had
originally set when I wrote some of this and differentiating the error
does seem important in Patch 6 in this series.

Logan
