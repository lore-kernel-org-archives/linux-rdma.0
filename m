Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837254;
	b=gxYc88s4GF+6mFwebVFop7a6blVYvvWZyNAUnPnDmohXmCeWb1HktgOLod0YxgI8YDIR
	 Drzsa/FveGapK9C3y7a9J2epMVbcuqBihsyk+OcxX/bZcoYQuGltMpE+28X3IT9LmNiaS
	 bGfI0jJyH/CT3Tn9J6LzGLU4aqR46ArQjH3AxbHCP3680Dzg0HSn4EG8jCfO4S5ODnjVC
	 J7Mma6L4tEefowwkLFzaiCGs7EOYO4OahclbUCy2H77kYdoR063TZBPvDXHfyhlDyzh4U
	 K2IwxAJsd1GrO5rs+CvE1DYvI86VouoiJHD8DYUiWqfEKQ+0uJmu4Nm8atqKnNtgk3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837254;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=ggEENox9ykuBStIRdtPXv8VcH1VhT9OQMRHQGPIH8f0=;
	b=OyWeg6G1ODYoTSpqaTKgD/wQoGFWij159FB5dbqRGJmygp7ulrDYvwUDimWb2EofX+Ch
	 Fqe9YKGiAdgVlyDPtG5XqWcxM4fe2/Hi6h0UZiVTdXAdo6MXbknGXGuogtsipcw8KOf8v
	 WduDHengCZIS8i2tGjh7BqCPS9qp+Tg+TbqzIBlHUhjqWj/tzMTwhzwxnkessF3dIp+HG
	 K+a+ByrSDtXVh8TkmQZpRiRDHKF1sYts2jFFgMmJjE8/YOQaWCL1KW70SghXlhOZgAsBH
	 oJ6ApEVa7Dx/04j6Hd1ZuiVMMwdYMzA0LnaXTuRkMnzkwiyxTNc71VVsD/zrhOrrW2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eYMNpBvO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B30606A323;
	Mon, 16 Nov 2026 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eYMNpBvO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43BB1F000C4;
	Mon, 16 Nov 2026 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794837254;
	bh=ggEENox9ykuBStIRdtPXv8VcH1VhT9OQMRHQGPIH8f0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=eYMNpBvOVX2bbIeVpsRPSAlwQgRif3X0Lbx2rpYmN8vIPXuVYUYv1ex+EyuROJrWZ
	 jTAyfNB63sS5xpWc8WTTDcbVAQCrsSTjAg3I9ADeCTJ8SqlQCDwPvM2bTdMpLNu+e6
	 IPq39fO6MnCZygjEqhTHn4eg2baFXqDkIH2e57P01kmMW6Zm3AUYro21knzsUMInXv
	 i25z8tM0iZxFwc7n/6XuRs7w7T4REp1GlfgD77lHzcQ4jQEM2eBBP2rxGU5hqA5Ahf
	 pJzoSgd8AbJr7QkUptgARYv3olBhaZNamv2tsmznpnG4aTCG2jGinhmyz04pPs7zNH
	 NCvUkTf0KzF7Q==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, brett.creeley@amd.com, andrew+netdev@lunn.ch, 
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
 Eric Dumazet <edumazet@kernel.org>, 
 Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: allen.hubbe@amd.com, eric.joyner@amd.com, nikhil.agarwal@amd.com, 
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
References: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
Subject: Re: [for-next 0/4] RDMA/ionic: add DMA MR and v2 atomic WQE
Message-Id: <179483725120.1370069.1281061806227359539.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 08:54:11 -0500
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


On Sat, 07 Nov 2026 20:32:45 +0530, Abhijit Gangurde wrote:
> Add a generic RDMA capability word to the LIF identity and use it
> to allocate a PD-scoped DMA memory region. Use the v2 atomic send
> WQE on RDMA version 2. Also fix the v1 atomic WQE so the operands
> are not overwritten by the common payload.
> 
> Net changes pull request:
> The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:
> 
> [...]

Applied, thanks!

[1/4] net: ionic: add an RDMA capability word to the LIF identity
      https://git.kernel.org/rdma/rdma/c/26493e277218e4
[2/4] RDMA/ionic: preserve atomic operands in the send WQE
      https://git.kernel.org/rdma/rdma/c/70c30baa7b3f04
[3/4] RDMA/ionic: allocate a PD-scoped DMA MR
      https://git.kernel.org/rdma/rdma/c/e83ddee506e24b
[4/4] RDMA/ionic: use the v2 atomic send WQE layout
      https://git.kernel.org/rdma/rdma/c/586be88310461a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

