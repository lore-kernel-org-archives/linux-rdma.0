Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9262A442B12
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153684; cv=none; b=YBi8/oas6aTx9JdYkWsYQXDCcnnsH9/WeM0f7SM5U8cnqiOZqBYPmQOj987hDU+sVlGWZZqokUUxIDcBY4MHh1/1t13xcmjrw6tteGrSBZU8sRGGU7qx5Xz65xLzvewyzu7/E1iAstd0VWnUjzRBizZSDAbdkwcNQB4MT/sXdho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153684; c=relaxed/simple;
	bh=Lt2KRO2F7UQOVrrJCV1LucufcxQUcPo/OVPBRB7dYYI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J5qt0NK5WkmRsD9DemvCx2ZoJMfouP+0vTKOM7p/KFA3TioBxBxrPuUSXPd3wnZQ8ewR/N8edIuurZK1/gV1YYrQa+fSRjeeqLoh6OrHMSREhsanWSyjOGRwAgrEcK3+evSRS7p2taoqjK7oLvza284j0a5FaBc2b2xhUr1x+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtQJ38Ps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtQJ38Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67FD1F008BE;
	Wed, 23 Sep 2026 08:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153666;
	bh=WsrVMNZFY/+Z8w0nuO1qM9tnmzlnZn+s1XjYhuVKTMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XtQJ38PsT7jkIxrCCWl5dbB94clBGAiyDpTULQprYz8SpVmo79Lsk1T6Ye5d2gLLI
	 EHjHpJ0T/fPjRxKesxY3OKfoa5nztEOBfw+TOuEXKfBTzmHwmWzTY//bsFWtiFrk8V
	 OjqAHDzj+bhiwk5VE/Tc8Yc157rVAJWpPnk7a1ddpP4xlxLUDXvmWP59UI4Yitws5K
	 jIeQhnrPI68N6l8Bap/BN1kOtgaaGLsvBMCrpT8oioDB6lDHvM657kiyOrPoJMfcQ7
	 +7yaG6+jtNdD6ZrWJzvWyJ8Dgo9ZLRBQCZwhYTrZTtcwZmrGnzBHPTTRvyzz8e7dnP
	 I4T3HM+fnPMnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 01/12] net/rds: ib: don't enable interrupts
 in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-2-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:25 +0000
Message-Id: <20260923085425.D67FD1F008BE@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D1

