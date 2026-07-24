Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E1141D215;
	Fri, 24 Jul 2026 10:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.38.247.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784888505; cv=none; b=Ai2oYUHUikQS7YZf+FldHoZF4xY1Ew+napx5csRCUlLORDu1TwvC0RtriYbFJRM6Kkrh8YfSdySejHnfBTEZTD2bD1C3QjjFEr1l3c8MVT+i7HBHfSqCICXj1bnjwOmbdsHbEFasAKXZGiNIXQjwIQVyR/ozyz8MHz5E9qdFfuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784888505; c=relaxed/simple;
	bh=o1i6BGbHsXA2S1cnmSyWtCQB/tcY7gOoTS0f9ZPd+gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dx93C9dcitEh4mCMyRhTYeNPlPrO8BvPnHt75mbi7m4ROhXpiTMoOjfadDPQTYB/o8LFXw+x1z8DWaLgUQuHh3+s4tjPE8qRm1P/OI/V7N4OWKVdnkOmohs2Us5Mv32AHbG60aYENbaloD0/FbOYBImedllXysp/AzGAwvRJhTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=OhU8R58Q; arc=none smtp.client-ip=46.38.247.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="OhU8R58Q"
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4h63tj5HkRz8L7H;
	Fri, 24 Jul 2026 12:21:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1784888493;
	bh=o1i6BGbHsXA2S1cnmSyWtCQB/tcY7gOoTS0f9ZPd+gw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OhU8R58QE2v8FnEHmf0IhAkFnRUuHit96VHskuy0c3JPF1BGKgCXqzPr2+mRaGFrW
	 25ztoWyqndgjKpnp8dZOfBnZ7RLHAWpwD40klhqzrmQNymveo2M3PEH7GmUPm/J0pI
	 hcJeQIaWflrRB5MPwxYKbL/DVvZDX4MljnWrEN1DnjnKuem3XavSdGp3bPp7DRLS3+
	 XtvpCCPpXUt+B2RV4ShIi0UVyvkgPl54eVp/jBAyzng+0qiUKVpiMCmrdzvO0J4brH
	 APWAqi+TQHpdM25cnoQ1jkxKabAVocNi6TH4dhWefm5syPRvKW9TGdkskDAEIXP0hl
	 aOPyBDTylUrAA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4h63tj4Wrsz4xJK;
	Fri, 24 Jul 2026 12:21:33 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4h63tg5329z8tH7;
	Fri, 24 Jul 2026 12:21:31 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 666925F9DB;
	Fri, 24 Jul 2026 12:21:30 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <c969f48f-833c-4a0d-8e3c-c7e88f9a052d@leemhuis.info>
Date: Fri, 24 Jul 2026 12:21:29 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/10] block,md,nvme: correct handling of unsupported
 P2PDMA transfers
To: Mykola Marzhan <mykola@meshstor.io>,
 Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Jens Axboe <axboe@kernel.dk>
Cc: Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Song Liu <song@kernel.org>, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
 Guoqing Jiang <guoqing.jiang@linux.dev>, linux-raid@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava
 <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>, Yu Kuai <yukuai@fygo.io>,
 Keith Busch <kbusch@kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20260723204206.76930-1-mykola@meshstor.io>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <20260723204206.76930-1-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178488849128.3023183.9483321544575683507@mxe9fb.netcup.net>
X-NC-CID: bgfn6WwD6tNqsJl92qX4PPcCQ3rLaKDwr3eppdgdbpQWarfWVJI=

On 7/23/26 22:41, Mykola Marzhan wrote:
> md treats an unsupported P2PDMA transfer to a member as success, and
> nvme-rdma retries one forever.  Whether peer memory can be DMA-mapped
> depends on the PCIe topology between the two devices, and since v6.17
> the failure completes as BLK_STS_INVAL: retryable for multipath and
> deliberately ignored by md for member failures, so mirrors silently
> diverge.
> [...]
> Routing: patch 1 block, 2-8 md, 9-10 nvme; 7, 8 and 10 use the new
> status.  Patch 1 alone stops the divergence and the dm-multipath
> requeue loop; the nvme-rdma loop also needs 9-10; everything else
> refines the fallout, so the series bisects safely.  The md patches
> fix a v7.2-rc1 regression (02666132403a), except 3 (older bug,
> stable) and 5 (refactor).
This landed on my radar due to the word "regression" here. Given the
complexity of this patch-set and that we are at v5 please allow me to ask:

Should 02666132403aec ("md: propagate BLK_FEAT_PCI_P2PDMA from member
devices to RAID device") [v7.2-rc1] maybe be removed for now and
reapplied later once this was sorted out? Or is that for some reason
unneeded? Note, no need for a long explanation needed in the latter
case, a brief statement from long-term developer will suffice.

Ciao, Thorsten
