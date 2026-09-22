Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65893F23DF
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 04:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051674; cv=none; b=Rig5mpHevdbhZJHrgF9Vz+JxqYN/gL3lFsIwhblpGwnPNXKIdt5NItbe6NR68le879ggnDn1n4rm926gXvsKKPW/WElHsWT9cK0HcJfcLzPpkII3JA9idItYDGfAOGTdQXh6ejWa8aEx2M/9uiND1x3u+K0kTqlkuYmrVUoNqS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051674; c=relaxed/simple;
	bh=OiSLGtzZTTLvW48/dMcPUZcH9ddHzzPIKYQF9OxX/8Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WPcVO7EYBfWF5ND3kDeigX+DCMPcGfFh+H2/P83SKh0fCFVCNjOOfgZ/uWxYqwwBQXTLmMd4SKIafZmen8i4GYRDmUTv11dytlUz/hLmefJMhX5zY9ChdSAsr3COcocLQSPRg32MC+7mRaH0wHqtwe/962v88J129GeQP0bA13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1OZ9ofS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1OZ9ofS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B1A1F000FF;
	Tue, 22 Sep 2026 04:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790051669;
	bh=UQWysVtjcUXHJ5eHqd3k+rLcMp6OJFcsjMo8LX46O1Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k1OZ9ofSIqMP4hGaJUUNOmr6cPZFTvLjdMFj8wVKFZZ0baQ9tVVGxx8SMgxD0J4GK
	 mOik0l1aC4Fx0I3Ilc5SuLZY+EheSrgJfB055JVBEuLhVr2ORzNdQYh1HwdQqIDSMx
	 /SLzp8V2uBRreuo5GTAqiL2UdZrneG3ZvBCgLffGeBxEpY1sjdxIb4zb+cRkiiVzyM
	 r2IG34fRW8qZbDS2IIV9bYzdxlyU1HzAu3p8x8SWjWgEbpVB4puXVjJ6E3B8LoG8hu
	 u+PT8jTl8XeSHcOTZaqQoWJY+CE4S3OtQafAWNASBZSmFqjckLQeQLQYZoMP5+jgkP
	 FdK0tkzqkg6AQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rtrs-clt: Don't WARN on unexpected info-response
 opcode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Quanye Yang" <quanyeyang@proton.me>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921-rtrs-fix-rtrs-clt-info-rsp-done-v1-1-c64281ed97c0@proton.me>
References: <20260921-rtrs-fix-rtrs-clt-info-rsp-done-v1-1-c64281ed97c0@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:34:28 +0000
Message-Id: <20260922043429.34B1A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Quanye Yang <quanyeyang@proton.me>
>=20
> The info-response receive is posted for a SEND.  The completion
> opcode comes from the peer, so RDMA WRITE with Immediate is a
> legal WC on that WQE even though it violates the RTRS handshake.
>=20
> WARN_ON(wc->opcode !=3D IB_WC_RECV) treats that peer-controlled
> field as an internal invariant and panics with panic_on_warn.
> Treat a non-SEND completion as a handshake failure: log it and
> keep the existing CONNECTING_ERR cleanup.
>=20
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/linux-rdma/CA+0ovCge-K+hcGHXZ4R3Ww5+cg159ux=
HBeVbKeUSLBRSMT8OWA@mail.gmail.com
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921-rtrs-fix-r=
trs-clt-info-rsp-done-v1-1-c64281ed97c0@proton.me?part=3D1

