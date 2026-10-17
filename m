Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60CE19D065
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208293; cv=none; b=BX61ihbAnyGJ3XvOcdUde85TdzJsMOFfaVfatjXhlCHCfckiZZpjjSCRW02eef08x4O/pOiv5D8aRnqaRybG2JLq+OkISMW8xH+Qw1hPJm4Ijrvgm0Le+gZMv3oylSKUE0p+raV+ljd5X4Jf16gdOd11KFAmLJTIqN5KyCLh9vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208293; c=relaxed/simple;
	bh=1C4VcHBLpfT/oUUccFywnn6cykKm86+K3t2ZBm50Iz0=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=qb9iW9rFDgBrkOE7jMUCVX/uv0msVmTrUuD7YQ8LJy2pgYLNIE9tcAkCLKfXkRsY0lF/jvwpdGUD642OADn/Wjy+7PYwX1BJNVxtzR39+TBD+hKHi2UaslASTw72s4koA5y3ZBQW5dX1gs4u2XooUpe324FcXrC4mPvqYynCRzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fj2GtNQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fj2GtNQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9551F000C4;
	Sat, 17 Oct 2026 03:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208292;
	bh=C3znXySaOBxLI6rv3F3DPAjKjHJiZH2gOHy+KU8CtgI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Fj2GtNQ0d+8HjE71yFxQDhhMo4bF0ZVbZKKQ00H1dvQ8FIyIGInmP/4JOPjA8vdXo
	 zGeI1POCglfsQnkcYNStWllMWZbEOsDohmndI7ngYNK0cgtvJ8ISRrzZjBHmVZM4xA
	 jHrypKjQdZ/cvzgKc0ijAAV3oKejN4HK+nHQTyUjn6fqlEP+lAuCRadW3H0hvY9Ii2
	 nLViJXiwmCadFIqoLFXOtbZ9+3fT4SUMON0F7sHoYlWaaGCRS0PNThFoGMvOl+GTlt
	 BCwrFIIcMX51b/s59u+M0CpsovPCNqPHJxUTq25Un0EhLcFIBv7EHKygdFDL5WuDqK
	 xnnJbj89XxTVw==
Message-ID: <sashiko-outbox-175253@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 01/13] net/rds: ib: don't enable interrupts
 in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-2-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:11 +0000
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
> Reported-by: syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc3741bb338b5c6d6a4aa
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D1

