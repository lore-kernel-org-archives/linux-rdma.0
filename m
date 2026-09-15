Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4912E41E6CE
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443459; cv=none; b=te0Nsf6VA65qI8mH99UALhYT86U/MiFM9VxE6SY/MmW0p3Vzl8/Xk7047N2+pEdEk7fZu2q7Dr2M9FuLfSh79+Szw7CWyGBqYx1ij0Z0NMph0rvCBwOvd6gO1IIMVXjspVQKvlA67ysolf0HMSLJI53AgUR+j+AOcZLUvd/2sRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443459; c=relaxed/simple;
	bh=fx2JUUGfdfZsiLwanqGDai6jZ93ziz4eEGzlKrPP4cc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BuuU0t0MuL4g5AfFYgimUUDKbWX/1v6fWvOhOmgmbGlHhZb4jEY8EPV7Ot7ODCaJ/VV2cuXFmxBnJ+sTSPTlgfEYEYzIrykfz/9AM9QQ5HM4Es5uRoAFO0dflPEEn4dfq16eHQzRoI41FiwskDLk6cZPEpZYXAUc35bBZxo9fz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzOmA9cO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzOmA9cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153F21F000FF;
	Tue, 15 Sep 2026 03:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443456;
	bh=e7I9BQbwYKVW2gAbDotHN4tg7TUQ7isVX3Y1CaAY29k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FzOmA9cOWkGAPELiNIka9m8pH4Aq9qBMjr253+3vTaLE6S8t9g84LHHeWl1JF3uky
	 fhKpVG1B1tJ0IB82ZOzmsAsLGHbtwXBTQp4h+1cdXuSSL4cqT5l29YAVElfWHv8n9u
	 b77uDGAdDj+LsAFD0rKiRoP+d691zlYYRY0JPrI6o7/5jTE9j939CRFAlf5Y5q8xkv
	 taGt7qNiJXYIECqWrv3cIH52vhYNNa0V+AwwmvcVr2Wua6fPttP45NT1JYYiYBk2tl
	 iZQGxc1yWGHCSMxLJRao7e107EOO6+U4Qf5eIC5Dpf7hgodheUIT/b2HgWFoHu8jDA
	 bghgYOemugDUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 01/13] net/rds: ib: don't enable interrupts
 in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-2-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:35 +0000
Message-Id: <20260915033736.153F21F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D1

