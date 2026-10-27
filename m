Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093741;
	b=KqGMeVoFo9oTMboYGRnngzkw5WgCfCS0PMkaDFxrKSvH3yqDCzBMUCx8KAn7mvpxZi8z
	 Di5Wl5nEvj84tMQDbOXbEi+0LxikWfjfxZBLCg9W49e7CH88TkbKZoPWeEauWehS7mXDa
	 oZQ03tebG+Qn9/YDj67wyJRKt+aldT7EC7bDRXfDF59Cj7cIdAnYZWZJE88WxS1a4Fp2t
	 mBCsT7wRQWM3MFLacTD35aEY1EvBYSJSpFZjm3LL0xfMHqalLaby7yeM3FA71RJYW3znX
	 kZYPMxdV6KEPEIiDqBLGh79OHoVPCpkVsreJeqsiKxIDGi4uHikiD4z39FDVio8SI+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093741;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6mc3Jdt5AG6NONnxk/X+O/qa8e1UB97Lz/1TZqninPM=;
	b=axCqer7ks/A2hqAmoSgZiJ4/GHUEnO7HyW8M+wpLKPoQoC7Us7ZVKsPX3g44v37hyxzY
	 geGViwuLCP9qFqwJWTt/DdXr/ZuCKe+q1e8ehlooIDFcwji+/T+VKj8fB2r5vjBCBOQ+h
	 onf7dBt2ZIP6dJGKT6lloeB78hq7S/EEU6H4WznrQqyXtjRt8BqXwNBETpoCLKX5h2Q0L
	 ZpPan/ArPd5xdlGKf8RKBWeVs+RfxiWX8Y4YRwfK0TNv0YMGcgwd8LbIo4d+jK9mMA8g/
	 dHOFP9oVxaE0Aj8pYdCMwW25Y5OnJW/rnglD3YijM/pUVp6eMJ52fbbIeDbpct3X7nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Edgwma0/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24112606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 09:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Edgwma0/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00601F01829;
	Tue, 27 Oct 2026 09:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793093740;
	bh=6mc3Jdt5AG6NONnxk/X+O/qa8e1UB97Lz/1TZqninPM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Edgwma0/y24vZIdR5DnOZHm3TKbyOyOIsJlcweiEbOep3Z/+IXoL8fgiBlZLezobu
	 kiwuCg5vzarg5lAXeNuT1mzXVwuW435Oa37SeYX6A98Z2HPG8HICDzbISfovEbWSUh
	 aMLnH3NzI/LhM59LkekWdpG4J8mIDbawFCEftmsa+NleoDqeEuzUELwB11OgbnAX2s
	 O6pZ/rfpF1PA1AXI8W888eS1K4XYVOU043LQ8xIW6q0EozgkEcQvJL5B9Il1KeLKuY
	 LB+FPPRRPGJrjaYDSShpvNc7Ydu0AFsEI+mGVgCgw81mtsytHH3sjXxCFaqhSMwDKk
	 70IfJ/OyvWdpg==
Message-ID: <sashiko-outbox-186326@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next 2/3] RDMA/ionic: set the SQ WQE color bit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027092353.1961552-2-abhijit.gangurde@amd.com>
References: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
 <20261027092353.1961552-2-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 09:35:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Amit Kumar <a.k@amd.com>
>=20
> The NIC uses the WQE color bit to tell one pass of the send queue
> from the next. Userspace sets IONIC_V1_FLAG_COLOR and toggles it when
> prod wraps. Do the same for kernel send queues, and start again at
> the initial color when a QP reset returns prod to zero.
>=20
> Signed-off-by: Amit Kumar <a.k@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027092353.1961=
552-2-abhijit.gangurde@amd.com?part=3D1

