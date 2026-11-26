Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795680444;
	b=LZkmYcuGuX4WtAnDUy33zuxXFTEjFPrU98DDqOm+j04QzoB4jeVy4lndv6TtPGGwLcSr
	 MBlE9CrwKXlTh9w4xmX9Oz8DvkB5DUI8QWjDtduyzXskYoOHnzVDbIfHOsJRtsMTHVxeY
	 PReUxNdUJFpdFM8RGeEb7nkShxDHVAmk5PgcsKINqt9UHd3BE0Oo6n3Cvvb5cDFF7JBbS
	 rxUiAhE61UNB0agbjfKtZjOWKrDueVmPNyuaU/qNJWUpaMsPKDO4AzFPNFHWN7ILM7uD1
	 qwhBE/UFcefhApDWQcV8CZajnZZR1PUit5MEpQaU2TaGOMU1WeooQI8g7KXt2qVScAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795680444;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=x62XlloaN9nmv76+/+Ck3CfcKm7k2ARHB7Wp5ihPJ2A=;
	b=MDPNa6mdJu23xgyQWLqPSeIEmDtSaHSAKccY2zA78nPO3p2qD1EQZco8lZ4dyvwZntKb
	 VKa7jwqqddgi559P2B9ubnDg/eomL0bJHcvv10TtEmNN8N4E6HH5WMo9Qg2sB72nfBpzu
	 cmPbUSPp/4LFLw8y+O3IT5xiHn8HJ1nyA46b4MAd+bVxmLVaXA77Ba00UjdbjeQfhzgH4
	 N0GI1GAjWPaKC+DwDYphLXzFmZk21DnhHHa1cnYoMxQ41hjfzkoK46vu1Hh59S/bwZCk0
	 xjHLazcbZLU5ISfKaWTLpqUiVfjMKbVBRX5/yZ0pDtiDS56zSGpSPSm8dRXmOGgvHUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oHQSiotf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FE5606A321;
	Thu, 26 Nov 2026 08:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oHQSiotf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE6C1F00A00;
	Thu, 26 Nov 2026 08:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795680444;
	bh=x62XlloaN9nmv76+/+Ck3CfcKm7k2ARHB7Wp5ihPJ2A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=oHQSiotfqOKIUIR9YYMELt/o8WCmW3nb0NffavizFRA4U6eRBCHjzN0WMyKuPvKf8
	 qyVSolXyWTJhV6tNJGHXY62kTvYQAaphS1o86mA8e618tU4KnltVAFkT6ZWjLlBAJb
	 PmYPOI4OACMfo2Qs8/+t7VHOV8G8jmpwvgQUIFp0LU99ROdVbRHidpI4t5dYwVisdm
	 vW/FRjXJwjmKN4v/GnWVilWet2KMbD0ihp9o/xMF4QG0pKkxLADSTEgw6x7oPsYOK3
	 fAkRsMDruZ8pabcNzrnmr9YfDEYOVsZsd6L8ivLtlC29+sPH44YWVyVfUfZme4DI2X
	 muKGwuk2wlJ5w==
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120140552.62784-1-astellman@stellman-greene.com>
References: <20261120140552.62784-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-rc v2] RDMA/siw: Reject a zero length WRITE
 segment that announces more segments
Message-Id: <179568044105.1243286.9072255870172054700.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 03:07:21 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 20 Nov 2026 09:05:52 -0500, Andrew Stellman wrote:
> siw_proc_write() returns early for a zero length tagged segment, before
> it looks up the sink STag. If that first segment has the L bit clear,
> the next segment is handled as a continuation of the same message and
> siw reads mem->stag through rx_mem, which was never set. A remote peer
> on an established siw connection can trigger this, and it panics the
> host:
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Reject a zero length WRITE segment that announces more segments
      https://git.kernel.org/rdma/rdma/c/dba1616eadfbcd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

