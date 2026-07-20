Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B8541736B;
	Mon, 20 Jul 2026 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784563149; cv=none; b=iSWQ+5U8njuT0ZPT9QKrXtivZnlIl8Vm9i7F05+uYi+CLMP85WeIllASlPtTP852a3qGjSz+SBevsbPnkPXofj5cSIqehhSH2nzBainV8rzO2mW9QIEeFJaXv7jyV2xtkAV/+UNwU4Wehb5DxWLyAxeBAs5JpUIfe2r0/L4Nk8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784563149; c=relaxed/simple;
	bh=cQJcbivB06LUeR8fEVZ640cFExN3f0ofPOWFG+trce4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=SVkXNevYKLUFYcaW0BDywWPO3HZtqdK9Cag/nWwRB8cFLoZGvj90XYe1NagUptVDhJIlsPEsV8P5nc94R/cLcsbLArVBoTodkiE8VOIxHJZQeiFFFvIueDQTDD39ob0lfiO4iJbjJQugnUF3DO74bWwzGXybjwtW+Jmm6DiqpG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=nznyCqQe; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="nznyCqQe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=cQJcbivB06LUeR8fEVZ640cFExN3f0ofPOWFG+trce4=; b=nznyCqQe109737/c013kSuon6G
	oJtENCeICPQ703VOz3VGz16PIL2sFqY3vx4wsPJvsQ8kP8ToTuH4hArmC21fm0T9qGFWTdyuSaY8C
	09dZbBnX7H47XjthYepcAW544lcAyPtyAo5NI47t3G28q0oXDOEguq3w3DGWGabjRt5qLPtjDSAbW
	i5diWFZrHzkDww6r1RdKT8IsCGes1kxI021uL7nEDPQtZg+ZWdSt/VRzOb5tujotWydtCzC8f1ZDS
	FwYP9Vfhy4ojAVDN5o87R1/W/yjXZPKR2xRagVFguNy76R78FHcs2lZvJVg7M13qV+UbVRGAUMK4N
	b3SFwc3w==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wlqOS-0000000B5xA-0AZp;
	Mon, 20 Jul 2026 09:59:00 -0600
Message-ID: <426e56e7-0248-4b85-bb59-2da6816443ab@deltatee.com>
Date: Mon, 20 Jul 2026 09:58:45 -0600
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
 Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava
 <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-pci@vger.kernel.org
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260718162547.448892-2-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260718162547.448892-2-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, leonro@nvidia.com, jgg@nvidia.com, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH 1/6] blk-mq-dma: restore BLK_STS_TARGET for unsupported
 P2P transfers
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-18 10:25, Mykola Marzhan wrote:
> Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
> Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_map")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>


Looks correct to me, thanks!

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
