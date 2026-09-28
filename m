Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B29E43E079
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576113; cv=none; b=pbhM558vvEuApa7ZVNI1e0QvFSAtZrVAcrYQCcUxxV+7HqFHvXEAIRpW2JPnknkpNvOg207UbpHC//PDhNC6Htwm/UA5x7iUUfyExUrEaHAErhGbX7sM7iO7+D2P1HF6oM3NyZINKzoEQAmn8i7b7v68XgoX59ANPjWR2xCyvBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576113; c=relaxed/simple;
	bh=BluTwLxI/CTYL3iPqBSXERr5x2ddXPI3lMxlk/NCKwE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t+4wOcKl48vETpZh1gmJinFT3Q/oKXVfi50Rljhm+2j3neubm331/CVOWFAu17n8oespucVxphlmE7EckDh+hbfxe34JS1IdQdgygjJ+vTDnjTh1o2b+u/K949rl27EhXNXpuY2WYSYlERn6yy7RJRWq0H4gLIYVSfooC2XTRuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWKDYDjN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWKDYDjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87E51F000FF;
	Mon, 28 Sep 2026 06:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576099;
	bh=4FpMH4bNQf8qBe7vtBbUmx0YpMiTy+lKPXn0BUCut7A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BWKDYDjNhb//m2MjPx7paV1A7RJVzBr/3RuvzC3tR7mYGGdzK6KBuc3a27Rr2qmd5
	 DuuSPytIfYgxHj8PUUWEPw8nb4AH2G0ZKg6Mmy04YJyONlpRl4uq8zijM+//7tqCR4
	 yYT37H8xrrRkaTEofRWdd21tVJ4RMWzq8/NzG6z8aWtrUzJadcMD1Mt3yRkkHs5hXh
	 T1zjC7nbkysBGdFiqDeA/4jIDRj2MbFAwc72wulq9MAV7q/WFyAE5d16I0wPvGQISj
	 BIzh5KsThhxP6D+WO4rPuIu+wqL2WdOqTTiUBrzSKUaIIBoHskTrq+RUBBIg6paNUx
	 2jp5XFPb4+xgQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 01/12] net/rds: ib: don't enable interrupts
 in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-2-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:14:59 +0000
Message-Id: <20260928061459.B87E51F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D1

