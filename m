Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CA63368BD;
	Tue,  7 Apr 2026 05:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775539483; cv=none; b=DwZJdOMHDgAqPzFqiPBiFx8eyZbXOvuuNdQbvYY5BdqMK+wyfMKvPI1pA56XTpLzN1nXLM1+TtDDlx8nC+l3h5kTHvuerKZtdftpmM1h7XY3HAq9k/FcMKJMenEgFHbliVJvN3qdwDvjLSPAkkvBAHBuimTp9zQujMWhnE2Tkt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775539483; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m+uJeSs6ItILZzSoNPOj3Tde4L50U87XQgSsy4XqqU/h95UX2IKA120v5MeKbitpHQSDK7AMk4i+WscTkn5zqzIn6si5niDGIVWGx4Fx8i4s1tTuGQabiMSy5154ifhka2DinOGXhYWB0xYRdhhbm1JoMYrG0DYoIk4+x8UtUUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD31568C4E; Tue,  7 Apr 2026 07:24:37 +0200 (CEST)
Date: Tue, 7 Apr 2026 07:24:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shivaji Kant <shivajikant@google.com>
Cc: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	henrique.carvalho@suse.com, linux-nvme@lists.infradead.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pranjal Shrivastava <praan@google.com>
Subject: Re: [PATCH v3] nvme: enable PCI P2PDMA support for RDMA transport
Message-ID: <20260407052437.GB6089@lst.de>
References: <20260406092132.1333458-1-shivajikant@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406092132.1333458-1-shivajikant@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
