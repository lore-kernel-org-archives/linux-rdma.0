Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBF842900A;
	Fri, 11 Sep 2026 10:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123507; cv=none; b=LM69GJa+TGADntR/qPoG/d4PWocdOLZEPtyr3EJQr+oH68PBjnS3+Cv9HN8b+O0lQn1oN1IJKX2QXlltDt+0pRv2PAtH7lLOB4D6Si1PSXTd5T78G9CWKgqO2qiRR/TY/4VvOuiDZpf7urusMcXahNvY45sMqyOb/9WbyGnDx8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123507; c=relaxed/simple;
	bh=fbVf/lHHuFIoM0TRklxLJMmEeVlltnO+3HFK+CDwwn0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mpMo7WktelBimNZg4a2vjzZEuCqF4xe/Ef+AF5c6a9tsrz7fP3EewioJ7yNJnP1TK31tXK56f8G1plUUArcW6bV7E/bA1hhsE+1N5+/OY/6YMD16V+Axqp4Q6UbfPl1asSDC/zmNW7gGE6k1oM/XCzHqbtwifZ59RozqujFRY1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gr1kSOig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gr1kSOig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC421F000FF;
	Fri, 11 Sep 2026 10:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789123505;
	bh=fbVf/lHHuFIoM0TRklxLJMmEeVlltnO+3HFK+CDwwn0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gr1kSOigVRCcL08wmjYMt2e9XoNzp6iVsD8CpMLsptxhOYCF7dzCtqCFWlhuRsD6v
	 nUghBjbzWnn0sdx7AdhRT4mR4ldQsoWgYsoPkZn3Q1Uxpe3O09Xj5q1LpviTSedH0m
	 ZpL1Us6E/beUC9ojaczMeMIK8Z9OakWlzks94O/utbGCAq3MZelzvIdN8E0h4IGy8s
	 Iq/yq47Axh1YnLggAgm6z789kKf+MtQFtbEGnzXjULidKiOf/rQ7r9z3M6k1QYAgAV
	 y5WfvFPA6AdLAMzJiPMMuR4xXWdADyhzCqws7KLqmW4M/roPPvJ7xGA9QXcrQqeZUx
	 s5rchqePDw6bQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/2] net/smc: reduce TX slot contention with
 exclusive wait
Reply-To: sashiko-reviews@lists.linux.dev
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260910104446.41423-3-alibuda@linux.alibaba.com>
References: <20260910104446.41423-1-alibuda@linux.alibaba.com>
 <20260910104446.41423-3-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 10:45:05 +0000
Message-Id: <20260911104505.8CC421F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smc_wr_tx_get_free_slot() waits for a free TX slot with
> wait_event_interruptible_timeout(). Since the wait_event family
> enqueues waiters as non-exclusive, wake_up() may wake multiple
> waiters even though only one can use the slot, causing
> thundering-herd contention when slots are scarce.
>=20
> Use an exclusive wait loop with prepare_to_wait_exclusive() so
> wake_up() wakes only one waiter per freed slot.
> smc_wr_wakeup_tx_wait() still uses wake_up_all() during link
> teardown, so teardown behavior is unchanged.
>=20
> This also corrects the return value on a pending signal: the previous
> wait_event_interruptible_timeout() path fell through to the "no free
> slot" case and returned -EPIPE, masking the signal as a connection
> error. The open-coded loop now returns -ERESTARTSYS, matching the
> [ ... ]
> So the change does not regress the uncontended case, and recovers most
> of the throughput lost to thundering-herd wakeups once slots become
> scarce.
>=20
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910104446.4142=
3-1-alibuda@linux.alibaba.com?part=3D2

