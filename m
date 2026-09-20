Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E013D953C
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884729; cv=none; b=V3jk35c1XH1c0jgyUL5d2Z6LiMqv77pNgmK/OeWJIA7qSxf2K4WfFMMUzBYw4f115CRLYFiww84STleZswQDhEy7Oyy69mfxjL5bQDiatqhC+ZYP50Lg2pDBaOo5lvlaEs3inb9Tl+Vmo4GD/l9qbY61zRsi1K9dWRbQQQ7ERYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884729; c=relaxed/simple;
	bh=Y2dPYETGreGb96cJzXp9E1x6lYlm5sZ7yLCoov/sEdg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T5lrnn8+5ggfxHz5CT993zRxtFnak5kMZevOR28jg0EAtMjbNqMbxPZ1jcW4MGIRMjL3UglsMKUk9p3iAYPMx7iMXOJdjjq651JZBYpdbeDaWIb3AiUb+nxLGj/BX+8H8P0HCYvP7gsIUlfJxo4goS2w5QyqKWSw2k8nXwcNpsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0YRkyz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0YRkyz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5495B1F0089A;
	Sun, 20 Sep 2026 06:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884726;
	bh=0qGmqWQ81Z/vFCfGtltxNMDvi5wWnIc1cyp0HGFdC6Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g0YRkyz+wygt0Sxym5OKVr2RQXn4Ahv7KZDGJe0y4pGDA68YL2vEsIiLD5M8/J2wd
	 e/Y69jYLgZF61rdF/W31ogBupdm1UeL4yLdDNubYsVWjzEgOPxuvgM/h0Qlwdb0kMe
	 g+QG1/bVAJqY0NA1J3tYWhkWwYFpS5cOwDcXepZFJbrP+dJC8ZzvrpijJcCapB2+lq
	 ZlHmwtME94iatTiivtRB8rjbQpJisG1JDUsVwL9bbU9KidH9Rd7/qmBy+Qgm/FiLba
	 zYA5icUz9O3UkizwcPpOM4b2BHuTO0n/uOBJcQLdeH2gTbxKyOebaFVJ0I8YyyISBV
	 Kp8ugIx9hHbMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 01/12] net/rds: ib: don't enable interrupts
 in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-2-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:05 +0000
Message-Id: <20260920061206.5495B1F0089A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D1

