Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047850;
	b=bk3rmBTWwl1g1AAadAlqrT/dApSGiqztEPszVifcjLrw8nJ6joYEqT4UJ3vQkFPSDqgK
	 W4eoEcxS9EZ30xhepIu9+aCNO+3y7k+ZVWBxCmAXFBpG0esCQabgDZ+mtEfS5WOeR916H
	 5HVLko9bhUihQ5GUlD9BDXp2tZz+lQRsFEBxU5FvN138abqsxRO3DHs+2ksm+Bq5ZRhCt
	 teh0O19gqy8qRgTleeOF1yjhs7lxss3n0Na/Wxz6i/KzyBqes+5q+don1hw7SfBfFN3XC
	 NdCLSUhJhlo1CKEEPV0Z4LBhQHAaJj/NDtNGmji771uYOK/qo18t8iyDVbfcT2pi4+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047850;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=5DQIoQAMdc3RoK4joLEe9HZU6OJSgtoLLYIzh8nns8E=;
	b=yNyPRp7WcGXgb8MjJRwEx/W2doEpIoDSDoq/kyjzqiz79L+uHnAg9/FsahsvnwaDnYOs
	 vKseg/dN9wTXOiJRF4ZLrlq4MBQahN0AnQH0vaSoIpLeCmB5dVRPiXRZWCz1vgKMp7bU0
	 YsQyMbNxGKU468KS3/6VX8nhEoGnEjN5aBpdYoo8phuSSK5ibK84xQCl7CDSorqJWrUj9
	 IvIvjZ2vMKAn77ZcVFKc9zFlOm2vbSX+FwbVsVvd/Uu5mNmTaysEgJQVSe0W+BdADd421
	 ksGAnqHHOG07wfNLRTfJ8GXAm1xUFYmf8TPBLfLfQx6NLt0BSY3XR3PI+wet96Y6AEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nT+ML7jQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A2606A325;
	Thu, 19 Nov 2026 00:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nT+ML7jQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678FB1F000C4;
	Thu, 19 Nov 2026 00:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795047850;
	bh=5DQIoQAMdc3RoK4joLEe9HZU6OJSgtoLLYIzh8nns8E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nT+ML7jQKOF1QZ7zXpvnawOOf13xFe8ENu06cSU/2Z5sLmVgTFtO9KSqPcaDMbkjj
	 Gvn8DNg0oPkWVuFN0zgxDwORXVCq/i6pig1BU9F1cOSmujWBwbeGeuSGrArcDE+LCb
	 QZESMJyeNYQCBuXk1jOL3SCjzfkO4zfhJW9Y4rTioUC8BnH0nyvQPCTZGiAGpqvYf7
	 McH01KHSAcksKsvvaYTDJRLydi/N6ujvnTNve5YkwhSkK61kvTBTCgKUMvV3TRNJAL
	 N5sNEjLG81FeG3kogg7fmXK4wtmbsULOh36wERv/MULQfcF0Y8JegfQuNIJRURnG/e
	 DWQR2RTsoIegw==
Date: Wed, 18 Nov 2026 16:24:08 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, Alexandra Winter
 <wintera@linux.ibm.com>, "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>,
 hexlabsecurity@proton.me, Dust Li <dust.li@linux.alibaba.com>, "David S.
 Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric
 Dumazet <edumazet@kernel.org>, Sidraya Jayagond <sidraya@linux.ibm.com>,
 Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Simon Horman
 <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu
 <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, Wenjia Zhang
 <wenjia@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH net v2 0/2] net/smc: do not reuse the DMB of a nocopy
 device
Message-ID: <20261118162408.215ca3d1@kernel.org>
In-Reply-To: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 14 Nov 2026 14:09:27 -0500 Bryam Vargas via B4 Relay wrote:
> With DMB nocopy (the dibs loopback device) a peer writes into the other
> end's RMB through its own attachment. smc_buf_unuse() puts that DMB back
> in the link group's pool with its token still registered, IOW the old
> peer can still send its CDCs to it. The next connection that takes the
> DMB gets those CDCs, and a peer that attaches after the other end gave
> up lands in another connection's DMB. 2/2 stops pooling DMBs on nocopy
> devices. This is the reused-DMB case that the v6 cover of the CDC
> receive ordering series [1] lists as not fixed; Sashiko flagged it on
> v5 2/2 [2].

SNC, DIBS maintainers, could you review this slop?
