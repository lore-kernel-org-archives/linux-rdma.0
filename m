Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CA9476CFB
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153674; cv=none; b=LfA/gPwqmDZn+jPX5/r3F+nwB5IUOl4Jhnm3SF4DAkEBeAz2PW81IQQNy9Q7BHyXG57RlJsxgS5ESl9sWL2OzuWVNWqKqbE4+Qw1iI0ATTgmj5ysgQ4M1VAqcPsAH3vB8jjey3a/CJ+bwmKCDh91pQIWefvntoEtZil76JJ/69E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153674; c=relaxed/simple;
	bh=sZnbYGS+VguTiyYi/cFZfVG74EeIA8KtLJOq9196zJI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tO8/BiXGzxnNBHdTqaA6Epby1bfU7ZyhJRIljBlTdeY1XrzNF9vUXMjeBi82nUjHFiGaNxUXjRsq833phODKa7XyxbfamHvS6HrhSK1EbhtMW3dkpaasUdp67Um2wbIyrqtskA9O6ZBoOwrZ870mWmuNLnjZCCla9S1Lsr2yE34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heIkaAfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heIkaAfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816FA1F0089A;
	Wed, 23 Sep 2026 08:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153666;
	bh=FIH5c3w+sZy+2TS4d+TNKVUB92/CV5v6qjNgY+CP5Q4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=heIkaAfBBnNaN87ieqRPyQ7KQMdcCP9Q2PXqb6rDVIk23IETql7ivIHqrXxpBtbLA
	 rAX38Zre7HFdHR6qlq0U2aUJjrFHsFac1DR+EKHNDjUbarVIi+AVWWolmAPyr0P2AO
	 APXc6YlesHHLS1aLMp+X8ZbE4/9h7JJJHv59+EZIuVksbPwFavgFFznfVJpynYsrkR
	 yCVZPXpXMN/N3oD2/rR3tLog4MVkaikC1f2EdloK4WtrhDdtoIgNvtbst0X41uaqQf
	 vu/sSxXonrW95uUqJRbUD40TSrH7Q8IU8KOfA926j0RsIjHPlo9DI9PzeBXvpeZVVj
	 baNPUeW6Xhwcw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 06/12] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-7-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:26 +0000
Message-Id: <20260923085426.816FA1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Since connection free became asynchronous, rds_conn_destroy() only
> quiesces the connection; the actual free - including the transport's
> conn_free, which lives in the transport module - runs when the last
> reference is dropped.  The transports' exit paths destroy all of
> their connections and then proceed to unload, so a free that is still
> pending (a racing lookup-style holder, or simply the destroyer's own
> put not yet run when destroy was invoked from another context earlier)
> would execute transport module code after that module's text is gone.
>=20
> Count each transport's live connections in t_conn_count (incremented
> when a connection is published in __rds_conn_create(), decremented as
> the last step of rds_conn_destroy_fini()) and make the transport exit
> paths - rds_ib_exit(), rds_tcp_exit() and rds_loop_exit() - wait for
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D6

