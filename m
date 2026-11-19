Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048927;
	b=fXTEk311HUaarTC37I9i6XpjqOpcZNVNTrA6yxxAIat3rfrO2idbHk4UOLEQ3yyQsp3v
	 J+PIsLKUOa97eoFpALuV6yh72n6C/fVA84OookR6I8QFIY3zSzkmPj0PNRlVfXlZIqg+1
	 xHEs6taB5bpYS029stSKNw4EfXlqAChct6UWfWozkOjvRti7wCLoSa0B+i7NMMCghq0vl
	 yh0khbvnCse2YWrEejuZ3igeUW9SieVPzLaRRZtT61HCWKhoMen5XyEXDdoo+QBUOIlaM
	 0lefIswop+yvhlWB3FD4RdOa5z5Z3tXfxH7NJ6ZmXSoFpcg56kRa7sxHHQFbL3aHOIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048927;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Rgsk+DHEPihc5GPQ+7cau4nXxzZfQPC+12VCN5jHe7Q=;
	b=10xuP1g6Bp5BSop7oOFSwouDku7YJgAoyk+tIUntfBkhXx0PmkUlFZcSpvdcSvzJdSSf
	 LN9QA9Rh6bgHL9SeXrW1y55TQgzTNhPmUmnamfVJ95XQI39YD0UCuq1iZJjYv/SaWpjaM
	 EYpIX3+aAVk2Y5m0JzlUN5c/+CfF8InRnNy8pMkhMc6VISaNHIq3ExDtfNYDRZii0hWU7
	 9EYFJ5YLIhIgg0qg7Fcc/S35yXcvWFW1vVc3GRa1nGZYq//cBKomyr/1Roa7r5bI2YmDP
	 7/QULRvOfJCaCAcYQK+0gnWUPeYMZxkU/krmYtWY3oMJM2OYQP9Lm309Iee+1nfLejA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D18fNYgv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F240A606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 00:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D18fNYgv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8664A1F000C5;
	Thu, 19 Nov 2026 00:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795048926;
	bh=Rgsk+DHEPihc5GPQ+7cau4nXxzZfQPC+12VCN5jHe7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D18fNYgvZAqJOAdZRDzx7jvwOq7jP/JIRGUgnaJklsdzr2e61fknVCR5vI2x52Ryf
	 v/jNLBnByuztwpxSLcntxaCtMH3oTMb2DFAPFDZOwEaMf3O4V2jQ/tXNvnL3VOaALj
	 j2jKgxs//y/r0DirAAkIG6k0IpZQnA91dFIqgSPCp5o2BxTxPi1G/GajEXS3480bb1
	 MpRb5//FuWs1dWTyG5+O8Wx15Svwt1+sc+2WON1DLRGmH5qyRisNlumpAEs8448kke
	 lLCD57ma82xsPr1/MxYcbgZpBypNKX/1i6n+t+OWU/FTr2eeTDXIsnWdEDQhIvFVUN
	 JuFNUR/O+HcBg==
Message-ID: <sashiko-outbox-222258@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 2/3] RDMA/ionic: Use the ionic command
 timeout for the admin queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119-b4-ionic-cmd-timeout-v3-2-2cdb8fca15fd@amd.com>
References: <20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd@amd.com>
 <20261119-b4-ionic-cmd-timeout-v3-2-2cdb8fca15fd@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 00:42:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
>=20
> Commit ec8ee714736e ("ionic: stretch heartbeat detection") notes that
> firmware can take more than 2 seconds to service a device or admin
> queue request, and is only expected to complete it within the ionic
> command timeout. The RDMA admin queue watchdog still uses 2 seconds,
> and when it fires it resets the RDMA LIF and every later verb fails
> with -ENODEV. Use the ionic command timeout, 5 seconds, instead. The
> AH create/destroy busy-wait keeps its fixed 2 second bound.
>=20
> Signed-off-by: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
> Reviewed-by: Brett Creeley <brett.creeley@amd.com>
> Acked-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-b4-ionic-c=
md-timeout-v3-0-2cdb8fca15fd@amd.com?part=3D2

