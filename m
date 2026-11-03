Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718849;
	b=AuL2VZLyrsR5IZhg6xZ4WxGpyVZYRKJAkNFzFiSG2L4si5JT7pFuZBmvjZTr0hEVwSOx
	 5VCpLpDIsmn3Z7mj4y4k9a283D5Ct+6H5q3TZPU2vnVaJQLJfPQn+Bn/OlnvL6OvSNBM9
	 CCYJmP1d6dBa0XcLvtJWw97VNQ22EmR5yfh6Hq3PHJmg+a6/kTMAeVq9uSWScXLOegF8v
	 DdsNu6nGvjq3swKPcsiKHveZ9oy7cCH48pHbdqVyAEU/o8ydsC5vTievkVAPRbAqzBfJT
	 S0LQRRZ9uUmluRDRSfieA3SHpA/otzLwfAYW8+YiuKKq+KqgjLHemTtb3W4ghXI4fVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718849;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=gIPVaeh7OGOIxM9c8130uyikZ9KG6PSwVrFvNBU6H2E=;
	b=35Ptd3LezTA++7C8HLyyUCVnmKybJ/SHqktdb4grKp/eh+TXqJdhHm5NooLYRM0fGEky
	 GVvJFNNoMJLzoT165Vg6y+9th8tuwQtRCRK9CT34KnYOtu12wDe8tuGusdeYnqtwMbcl7
	 LYHUNLqEM7FkMVvqqO60kiktOoMndTMycMUbmo1HJT3ZW+lTah9QAfmljfJ2kIP3TdmG5
	 DTSgutYK0HNOlazfQb1BskYNaPtC35sBKiIwlbzRtOlzfbM/xUlISjU9Qwp/A1DGuSaQX
	 n0dnV56RGRGlHkD5ItHI+y3FokBnDsSJY7AnCFPfCPPsYBcSn6hv9Gqybx4AlXDU7Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YiHzgaZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22855606BA28;
	Tue,  3 Nov 2026 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YiHzgaZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EC11F0093A;
	Tue,  3 Nov 2026 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718848;
	bh=gIPVaeh7OGOIxM9c8130uyikZ9KG6PSwVrFvNBU6H2E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=YiHzgaZEYQwKmvKhvh1PmOnfx7XVNQQGEM29KaHyMr7bhiOYW2uzBl8/ExjV0T7BU
	 0CM0L9wm09pGPyjjs21NsmKYY+GQi/rAyafNeSnaRqVCEy/sZjYmQpaj4kW34Fpzho
	 WRTZxqG5o+nh70TqfutS0aBrfzA6lWlVUEZrWs3yGMQ/dcwkayAw7j2G/zUqhADi7S
	 5BAF9C+5vrlG9q+6IQ9wBgCvltOdR1J/BqxQ19cQlgFAY2rPY567ei17ojHOI8FmTG
	 D+v6DgEMkTijz0S7N66bI5uZ6zsqprOFdKN66a19/5QLbFUmEMKvf4x4EAMqWEFC8S
	 F/PnfJjfoacsg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261101141521.2426198-1-nickgarlis@gmail.com>
References: <20261101141521.2426198-1-nickgarlis@gmail.com>
Subject: Re: [PATCH 0/2] RDMA/nldev: Reply with the command of the request
Message-Id: <179371884574.1731026.7626779271793695711.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 10:14:05 -0500
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


On Sun, 01 Nov 2026 15:15:19 +0100, Nikolaos Gkarlis wrote:
> Two doit handlers reply with another command's message type:
> RDMA_NLDEV_CMD_PORT_GET with RDMA_NLDEV_CMD_GET, and RDMA_NLDEV_CMD_STAT_DEL
> with RDMA_NLDEV_CMD_STAT_SET. A client that decodes replies based on their
> type mis-decodes them. AFAIK iproute2 igores the reply type and rdma-core
> does not use these commands. I spotted these when writing an RDMA netlink
> client for Go.
> 
> [...]

Applied, thanks!

[1/2] RDMA/nldev: Reply to RDMA_NLDEV_CMD_PORT_GET with its own command
      https://git.kernel.org/rdma/rdma/c/8cf5406b86249a
[2/2] RDMA/nldev: Reply to RDMA_NLDEV_CMD_STAT_DEL with its own command
      https://git.kernel.org/rdma/rdma/c/f3980f8abd2d11

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

