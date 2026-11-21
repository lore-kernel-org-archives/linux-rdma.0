Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795221311;
	b=a04zPC1x66pxtyO9DzA04FNsEXeplludagW2B+bgwPF86ToLIOuYVZQHJStir3Z/ie00
	 PrBZzf6Xzvhaw0K+v5xGVnsP7jF42xVLpCLDgXn5dGP1jOqkU3psUfm5t31SgSEiRlHO1
	 bxYdtZVbuadcJn/BOL1CvQgVm2eEg8S4cwp4G6yfuSpovgSpKDAF2JF0ZMkfUm98Nm56Q
	 zbcaPAQmoLSIn3+YQlHy/x790xST5Q9qKVcvdwMZXYXPsoLhHkHeEwDeLoYp9M4ssCOsb
	 Jc6aHNxW+CbuuaMwOhqSHZKMyyVEPzsbW9jDk+lD3qwgv8KzYZbDn90wre91nCIVkdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795221311;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=1Mn3sygacR9HaDdeSW907zuRmmxCOUWzJsVDl3cMKt4I0FHHOd5KSOzmDBthm07Jte5b
	 Pe3nmr2DiK32UGhBV3LFdXJq/+4WuB/xVynwifwHPU3bE5Jl1kfOmaAZU+fG0fDTI6m3l
	 TDQLGLSsRfr44tpSIYSE+gchR8GhR5BVM5TzYBIvPRnAXvJfv1lzhDvJs8E2Yv2d654ED
	 M7yjemuTBdywGwFGlYlzR7G/BaOaP4eMaP/NFdNFeNahMEePRJDrCK3iHtAYGiO5cbYPs
	 siqhI9Hr2WQl624Ts+q9RjoktUwbPXokm+eAQbiHAIBCppKrJDJ1yhsy7Bx7MHAJZWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00148606A6A2
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 00:35:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00148606A6A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0B4306732A; Sat, 21 Nov 2026 01:35:01 +0100 (CET)
Date: Sat, 21 Nov 2026 01:35:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	jgg@ziepe.ca, leon@kernel.org, asml.silence@gmail.com,
	nj.shetty@samsung.com, joshi.k@samsung.com, anuj1072538@gmail.com,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC 1/4] nvme: move dma-buf I/O context handling to nvme-core
Message-ID: <20261121003500.GA14598@lst.de>
References: <20261118103327.1788667-1-anuj20.g@samsung.com> <CGME20261118103450epcas5p1163c0878f3f2da3357146301143047a0@epcas5p1.samsung.com> <20261118103327.1788667-2-anuj20.g@samsung.com>
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
In-Reply-To: <20261118103327.1788667-2-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

