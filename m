Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F381383983;
	Mon, 20 Jul 2026 16:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784566154; cv=none; b=bvWUzolhU+WrAgw6cW0wAnvq5FZKRaqbzwtXqEmjxqZHt0xObx5Iwcj4hfMBRIyfLDulA26CVExNkemv2xhxMmT4yWyNL/FihjUv1qyiOGLaupmJub5aQG0x19snWAiLPnbaWG8+ymzw2nrR+N764wGbMHysJ/SW4+YrCkuZ+oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784566154; c=relaxed/simple;
	bh=SHo+dz0Ue/2d8c2Zthacq5yVOF7GekXFdbk0EEM/MEo=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=N8IfPmepgHv0rdoFuDzLcWz86SdUJKVgCdwnJ1Z5b3s585G8yap1UE7BThdOmKVrilDmw35gNvVlTVs92pUat2TFTF2FdE/ZfvvoM0CXftR2yg25A7HE6/HnPLHZxWOtOUthWG6zqxdTzi8yHGf9suupKFZXVpH4biICzBdDfbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=lUrb8QGA; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="lUrb8QGA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=YYL05epQu09BiBSr5PNusLFDqwuNDaosRFFB/h9tybo=; b=lUrb8QGAIKHH8XNsAn4DH31GNb
	7pJSLAJ+N2/ga/ONySFdI6oDNwO8URdhxhAm6ZNuQa26FXOsO2znTZkY00e2aH22cCAMuVle9ks2Y
	Jr04yHux6mPAh+g1sezb74gocr26o+tUenFYzOGV4C+DaIEcN+uAOE3Cq4sop5niXyY06EQoU1u9J
	c/0pPGEMLPjZrQKaRx/UGUGgwedzCqf/0oV49O2oaAtNe7NMCYayNPy9R80kaDuSmONndf/rwSTcX
	J8lTc3kqqITZ1jaCi92f5gnRAAuR0TrGD7bB02G7r5qWnjJyHSaRJM4mozl6wb/RLibcfS4on2/TH
	DVH/wUig==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wlrAv-0000000B6Zd-40ka;
	Mon, 20 Jul 2026 10:49:06 -0600
Message-ID: <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com>
Date: Mon, 20 Jul 2026 10:49:03 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mykola Marzhan <mykola@meshstor.io>, Jens Axboe <axboe@kernel.dk>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Guoqing Jiang <guoqing.jiang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava
 <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-pci@vger.kernel.org
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-7-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260719105327.864949-7-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-19 04:53, Mykola Marzhan wrote:
>  drivers/md/raid1.c  | 56 +++++++++++++++++++++++++++++++-----
>  drivers/md/raid1.h  |  2 ++
>  drivers/md/raid10.c | 69 ++++++++++++++++++++++++++++++++++++++-------
>  drivers/md/raid10.h |  2 ++

This is an intimidating and massive patch to review. I gotta second the
verbosity of the AI commit messages comment from Keith.

My eyes glazed over a bit. But one point is that maybe this could be
split into multiple patches: one patch introduces R1BIO_P2PDMA, one
patch for raid1 and another patch for raid10? That might make it a bit
more manageable.

Also, I'm not sure if it's possible without digging deeper but, instead
of adding a !p2pdma_unmappable check to every if() statement in the
raid*_end_write_request() functions, might it be possible to factor out
a helper function and return early from it? Maybe the helper could be
shared between raid10 and raid1 as they look very similar. The
differences between the two are minimal -- there might be a bug fix that
was applied to one that should be applied to both?

Thanks!

Logan
