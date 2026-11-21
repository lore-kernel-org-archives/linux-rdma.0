Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795221458;
	b=gVuJr9KJNeHkA5U8TMmqd9JNdNy2pYlkTCZTtU/aKwxcx1h/pa2BByMemfD3ABMLGirp
	 iWZTpvTLLy/0PeB7Z82KIsiwCfGJ/Eq7D7uEQI0t65f2TKA7ch6a+x7oJIr/Lb05lHZRC
	 GmqZHtbHgRy+W5LtcVoypX73yx3cLOO8EEpKOvTTVd5ZVypnMJkVu/tdrlvobO03zGfGo
	 Zz77ga8913rrirBmXu+D+EqsDaIRAa7Y3YsGdNmVEv5fAe/tTA8f5zq+5eEPo+HQ6sYDH
	 8tcPiuSNG6f8qBLzw7rwj+rxQeXpOLxUcCSbAFLpm0r/civ2H6RZatU2Z7abRF+W9NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795221458;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=HglSa+HVG1CdmAqrwHc8qHzUvZ9E4XCWCFHhGsOghHQ=;
	b=nNvBBUUvvnkf5f+0E3iAKMR4/hCXk+9KYjVMCjGcvgLRC21X1MbjBlAMhCv0oNhn0twN
	 4izDviEnIvvYBRnuSmDxtXVTJyjrBBbypm3oIeakzw/zJTA37VPoK8bBptYCSeHsJ9Pg4
	 M70w4LrQR9EigY1u4Ux82l2XMi+5Zp1WDTrnCmGIy0hh98eIIbnhDKeHv475xqiyFlwoT
	 qQEg4WoBj5gvPDajve88H/n9kI34G4qngWdVArKkJchK57REZsmJlY5Iff4TDWJI0ppx2
	 SIujs8+SV+C9RqDxkmNuB4qlGyuUBO/DX3ohkJJ8UwoMjxLocU+IbH1nfATf6/SbTIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C228D606A6A3
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 00:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C228D606A6A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2CDB6732A; Sat, 21 Nov 2026 01:37:30 +0100 (CET)
Date: Sat, 21 Nov 2026 01:37:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	jgg@ziepe.ca, leon@kernel.org, asml.silence@gmail.com,
	nj.shetty@samsung.com, joshi.k@samsung.com, anuj1072538@gmail.com,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC 4/4] nvme-rdma: support dma-buf backed requests
Message-ID: <20261121003730.GB14598@lst.de>
References: <20261118103327.1788667-1-anuj20.g@samsung.com> <CGME20261118103457epcas5p17770752b910960b84cc259d007120965@epcas5p1.samsung.com> <20261118103327.1788667-5-anuj20.g@samsung.com>
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
In-Reply-To: <20261118103327.1788667-5-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

How does this work with rxe/siw or non-PCIe based HCAs?

