Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC282BEC34
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717237; cv=none; b=L4nCpghCrLBJu4SF2df9yZwe20SUXcmrJA877cE/Oya23CLHVx8yw3CvmpKnTM++AUR8sAxHoAOVcNkYG+mJzZHstUVhEAVHSz7ZOPeaV9SqgtfKRPl0l1Tgs9NjpRQdjvgNwZTQG0pQMGPtQfq8q3z8twVvymspG2ulYUsjXac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717237; c=relaxed/simple;
	bh=yArcK4PspUeMjxCo1AE01+JGhM2B1qKz6qvHrOuxMRU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=drKBWQRQrCnSJIloV9KAH0LCX3phjJ+xxIHkq+iBXpvScFPnoD1n82/j4GUXaR3/r6PK2tWRU5E1oXa4JbLONmbwcxAtgLPiZopqyHbuCdNZO+XuH9wfGC23v770UvUyniJkFafB/YeR6bJTQ7AKPWWgSXD1Ie9g/psatN3O5gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAUUfCT3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAUUfCT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49F51F0089E;
	Fri, 18 Sep 2026 07:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717211;
	bh=J0z+DkiYZhc924YGvhRybz+6n7wXX3FW45YohY3wWWs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PAUUfCT3BzMNBgxrzCw0h4MBLhjLZGOVt6naQXjCcS5CCPqjf2nNSR0qu6aiWOL1j
	 MCFCGVpJqfhngfdTQWculIW+5qnLaYmXfF1HmhfyFAGAgnVr83BtePGKEWpvCj65nA
	 dlLCQS99NkPq15yB3g/uqdw9BGGXeqw8X6D6kcTMqF5W7Ny4GOYisQeUAEUELV6Rcs
	 ltgsynh38Rwou3bCXhPc0B6lv2+GsOcjh9WORKvGdqeDkoSC24ltqSldei/nVNy35s
	 6njH4tmLXd9FLVtvXy2X9zbQIMuqoBX/jxdw8GgecrNB0pMWZP9DfKJ1t6jHrR5RPH
	 opN5xVAvSyO+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 01/12] net/rds: ib: don't enable interrupts
 in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-2-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:11 +0000
Message-Id: <20260918074011.A49F51F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_ib_conn_free() unlinks the connection from its device or nodev
> list under spin_lock_irq()/spin_unlock_irq().  It is not only called
> from the rmmod path, though: __rds_conn_create() calls
> trans->conn_free() to undo a lost creation race while it still holds
> rds_conn_lock, taken with spin_lock_irqsave().  The unconditional
> spin_unlock_irq() then re-enables interrupts with rds_conn_lock held
> and leaves them enabled when the caller's spin_unlock_irqrestore()
> runs, defeating the irqsave the caller relied on.
>=20
> Use the irqsave/irqrestore pair, as rds_tcp_conn_free() and
> rds_loop_conn_free() already do.
>=20
> Fixes: 745cbccac3fe ("RDS: Rewrite connection cleanup, fixing oops on rmm=
od")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D1

