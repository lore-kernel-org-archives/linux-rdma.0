Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795701612;
	b=WWCkZR+vV+3bplyz5tg9CUeGOGt9mzeT4ZNebApXRYk/mCPn6buJWoxBD3uvcIck0DvJ
	 0me7EHODTNR27ag1UXEchpwXL+b+GWzd+xcrkdqOaGmsr0x5hAEQ6O87NdwzOsmhcxInh
	 6s2OnxU7scIu11JHRB5tBc8TWUHci4RRsDbhY6OyGPMB7ZK+w/mU4tSqkmAHcnx7U3Rjt
	 d82FXuLVMMnFLalBk2euFKXD97Bq2QbejAEd4yNOkMPMmxWuoPTmN+q6X/7B5R8rytNdz
	 DFd8VX9L+vEgsA6y4Hd/Qz9eCb1l/aORSwtwQQDWUauLqj49laiTvSJ0z5QKbuZEpLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795701612;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=afr0WWbPAo4uI6sGvyvDO8Ffgg+XtZm65AKUzb2v8GE=;
	b=K/fVYgAAaAynCGALqLvh5Nyhp0D402FLWiXXskguCnNFh9Q1GjjhOGZO1Xu5Aw9SkM0b
	 weEwpVqEsjSTBXvgQ7E4Gfi45nQTMsicKUFXioi7zlSx9BNsRO2fm/VSm7SaLSS1f/ROg
	 jyJocBqLtzNT1Pwh8SiRDCOdWs9aGhWoxJTxwFQ26uJjShQbbsjNktn9E8fxeTErGW6C/
	 I2q9fcB4El4ZAB2WU7ig1tyClD+0XxSmhAqGlJzm864rI3H1RQC4otoU8C4gsOUyEjdKV
	 xs2yTifqX0l68ZPGvdz2Y1JxtIn1uya29ZT3wM7QeIHVAYCR99eGJEmdFLxNDZpyu1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nO82qoad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B5C606A31E;
	Thu, 26 Nov 2026 14:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nO82qoad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C4C1F000C4;
	Thu, 26 Nov 2026 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795701611;
	bh=afr0WWbPAo4uI6sGvyvDO8Ffgg+XtZm65AKUzb2v8GE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nO82qoadSC+WyC80fAVIuxxT+ewJX18V5Jar6jSJ4aP6TjFlz5iI0UWNi0UShH6mK
	 7auI+YGNiKHJIWhfQdifNgT7UqHbuYR+af1SKRAhe4ZX9f9hq9yIH7smNULYxpCy4K
	 736bF9HM39huo+J3QxtJQV/es/+xDY0H7CYC5g+J5p6AqI9MyTpRK48mnPYG/3T+hH
	 W85FJ5yE4hTRQM4JW1tY/4Yi7D2gEUboG29ygaXGwcKwGcIX0EEMfAef5hU9pwqlCL
	 myudh7ajvw4hq3f3ozPHGQwjfWL08qOMOX8yzd9peQASnN4MgYccNJMoMNp+sh5Y54
	 IPFO0SXZxj0/g==
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>, 
 Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Andrew Boyer <andrew.boyer@amd.com>, "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
References: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
Subject: Re: [PATCH rdma-rc] RDMA/ionic: Wait the device command timeout
 for admin queue commands
Message-Id: <179570160885.1269533.5766510850700105572.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 09:00:08 -0500
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


On Wed, 18 Nov 2026 21:57:52 +0000, Nikhil P. Rao wrote:
> Commit ec8ee714736e ("ionic: stretch heartbeat detection") notes that
> firmware can take more than 2 seconds to service a device or admin
> queue request, and is only expected to complete it within the ionic
> command timeout of 5 seconds. The RDMA admin queue watchdog gives up
> after 2 seconds, and a timeout resets the RDMA LIF, after which every
> verb fails with -ENODEV. Wait 5 seconds, as ionic does for its own
> admin queue.
> 
> [...]

Applied, thanks!

[1/1] RDMA/ionic: Wait the device command timeout for admin queue commands
      https://git.kernel.org/rdma/rdma/c/58b15c7123d493

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

