Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793261191;
	b=R1Su0hgDcbm67xQOfWbP49csgdso95oFf4CSmmY1ptKbqYIMqEDbjUB9qMHrFgWZPPsq
	 UctBSDpZBsmuSDhQABneUoMvQocPDrTwbbwoPOXjUTC6n89YaPKj4S+TLOmC7lTVMevAr
	 dlgEFsUz1WUWDXPzAtDAEsWZ3nAY4KEsy+wlIb2uVpX8Iq0/lZoYy4sVVTn4FvkB68uiC
	 NnHAN7wcfNW8vBLBMrgn011VNe161sl94OAE/6XU1niTejqcB7zaWHhXxRaKIbuTLLUAW
	 MRRxOltYBZ4OTOm/1oS26kogPzorjsR70mUZuEWaFoA/iy/XgVZl8sOac1axpEVYqsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=hpJyJozukwakSRO9rcIcJouiZUMp1dijXc7l+rkqIwI1Lj3NaoF6rSPBEjYEQaqLojq6
	 nC9PlOzhW/MzejTCzTYC1+hkpDqJoyoYEFzUV1qnj/jKlle9Ur1c3vslwupNfIyvCTQql
	 VTjiY5OCuSqOMTlguebcP0ZEbF0K0pGdZ/UdvTKcCDY5yibBOZCyBrDHAuMbCnx56QFpm
	 31h12+jFnETXYbsofkEy2bqARn8U9F0eFUGcoQwMi7EIca/IrBPhL622FY28Mx17U/4Hv
	 MlHJAVIQJPHt7h7HGvXfT9QW0tIUUyxfuu6/Wv5RzHAUjcOseaWqF5VJr8ko7fpEZuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J0DNtpmB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F01606A31C;
	Thu, 29 Oct 2026 08:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J0DNtpmB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6802A1F01825;
	Thu, 29 Oct 2026 08:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261190;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0DNtpmBrA4en7NAIWc241u3fePb402oQ5nHQW08eVVstfF5a9ivGnZ2HWVMnME4J
	 +/4jtfuWnIbkAnxUhfDbGT61TUI8EbEiMcOoLo9ahTrq6CX2mB+VorPhioCkZka4DB
	 LXMm1ApwkmBI8+BUaPbk5PfZWSCfUTfFiJ3sy4j+/Ec7E8zO0ey2S055ZgnYmH69il
	 tYZX0Zjke9lMkxFyljuNBtqGVmLGcwPmovPwIGp5vQzEGq8tSvDVEs8uI+XG4ARjX0
	 h/1wIrePFF55PI3wbJZWFBGwT7LQuWbYl700db+mUfY6uvzKPdHV0BjiBr7Vg5Xpos
	 ss+RRt1ayajOQ==
From: netdev-bot+sinfo@kernel.org
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Dust Li <dust.li@linux.alibaba.com>,
 "D. Wythe" <alibuda@linux.alibaba.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Sidraya Jayagond <sidraya@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
 linux-s390@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
 linux-rdma@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, netdev@vger.kernel.org,
 Stefan Raspl <raspl@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>,
 Simon Horman <horms@kernel.org>, Ursula Braun <ubraun@linux.ibm.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: don't spin in smc_rx_recvmsg() while a
 pipe holds spliced data
Date: Thu, 29 Oct 2026 08:06:28 +0000
Message-ID: <179326118891.3327.14846127126264077878@kernel.org>
In-Reply-To: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
References: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
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
