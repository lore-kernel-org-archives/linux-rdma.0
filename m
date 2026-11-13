Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794597477;
	b=d4Q7O6FcpJ4Mm5cNkTHF+DSJN095/JYyhD02ggvx/HNL8m4E511QE1eMuCSjbZqJfWui
	 MCC/g71kTAjta7q4eW7Wy5Q4VDgx/rhJ7cb2ySYBhpy+kdK5jE3hBOLktq4ccATcLV5hR
	 u1ZPd5A5Bv1Y/y786WUEtAfDWG9yMNWKszzMAQYL3IpNNQhuOVKHJ63yFTv1I83TUrGN/
	 riHeVXJQ2q9FCuuBLnUb0Uk9sSujk0OdCY501U7dvLU0yoDhdLUPkJ1MyR2pBYO4RMjxm
	 etcX+iKXqrePruclQlLuo2tJiftfoiMG+JBgPGw6fuejtlsj1t8emglV/0eAMdAAaIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=oSDUsO/1wD8U0kqfSar9Du3k30vW4MBgXquR47o9s2XwhnaZlRbkCUBBRP7e190PGJvV
	 zt/h4l4MflK/uAQiaNBamVnRm0/TyytREhCu9rFFZclLIiuG7lG65TNyAYDH7zBM46KyU
	 Ai8NYny6z9W51W6ac89s9XyO2i56jAtBpLV6/tLq09jODr3PmMMcfueioMucFMGFgmBAM
	 89OO1aGI8NHBT+7ybtE9G7BknLgN5BZ+Ac/0E712zDcrpHiWWt76MroxD+uB8daVAxekL
	 /R8D5G+eD3tRCq+wLn6d0fCZF/g4PtpU2cs/2d9XWfMGk33zDezIGPXYIqvYeaZo9fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIDWnctw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E3C606A32E;
	Fri, 13 Nov 2026 19:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIDWnctw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0275A1F000C4;
	Fri, 13 Nov 2026 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597476;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIDWnctwMOxz+UKHvuoNnVkL1d1VnOXuDlLth2b+S8TDvGuX42NiQtR9xSIMTFmly
	 jYojNEqX3MFFPES9qHBb4tBuYCFM/aI9ZgwLvjOR/HK5xihmmGIAgbYpGSx5Y6FYoa
	 0b2ddnHaKGMdeFgMG+NYKbISXOhVYWkiq6ukV6hPjwqyUzI7z0FnCC4OcXuP3QWS+1
	 JM/zL18Pw3ZRCQGXBnmSRieyakMFflDHIGXaCexqKut5tKNz+F5Yd9Uq6PX5hFJSGf
	 9t41keV1EPZHpmxwG3EDWZ+lDyrIohQRV+azP59Rqm6I5OkihzPtHYeB024XM/KiCg
	 I8coML9bkaAJQ==
From: netdev-bot+sinfo@kernel.org
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Eric Dumazet <edumazet@kernel.org>,
 Sidraya Jayagond <sidraya@linux.ibm.com>, Dust Li <dust.li@linux.alibaba.com>,
 "D. Wythe" <alibuda@linux.alibaba.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org,
 Wen Gu <guwen@linux.alibaba.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tony Lu <tonylu@linux.alibaba.com>
Subject: Re: [PATCH net] net/smc: check every link before skipping the RMB
 registration
Date: Fri, 13 Nov 2026 19:17:55 +0000
Message-ID: <179459747549.2168702.12984461097488923860@kernel.org>
In-Reply-To: <20261113-b4-disp-08835f86-v1-1-b2ee1b9b94e2@proton.me>
References: <20261113-b4-disp-08835f86-v1-1-b2ee1b9b94e2@proton.me>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
