Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54E03093CB;
	Sun,  4 Oct 2026 16:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131701; cv=none; b=UwYmUKjIQZMWmclLtZ1rkcPX7nxHxfHH0HW+A2lP1rR2H1vjI4Cm/T/7CUN1iNAv+EukPJRQVM/dZcf74st6i4b1gDX1ykHqVE2IP/DW7BZbzvdIC8A4f4WWBPdn/KxOMgfjp0tbVR6B9WwONej9qZyPKkUeeX+TIQ02f/oiQPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131701; c=relaxed/simple;
	bh=f77vsx/NWMzwIav7G/S106cUu17rsimFxfh9DecTv18=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fO4DGN8VjlO8uJDaZhxmwkTLycSpSRbG5940kFJy2d55PnTVlKGrHA5VTOHSjj5LT+Ng65f7b/FrnkynyuIjNS4cl4CybS9k0KcZwfSAoTDcrBt0xOlCVCBzjvBKVh3Ml7p5dTYts42nSm9pVw+wsmsinmhYg0RicmheJBI0vSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEnIDuBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEnIDuBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1B11F00893;
	Sun,  4 Oct 2026 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131700;
	bh=TyFTddv09pLTHy6PO+EsKcwOkXCYYNtumv+K3bnWGhQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fEnIDuBNWM6+b28nFtOkBEpXOWynLB4H9JFmaGp/yAKC9P+dLpn8gDi879yCE2lvd
	 pzvv/txqI5LVR5BAEWP0zeZLNv09gGocfRQ85CJ0KGqxSVN9mb8tpz2ZHFcDlYlvlB
	 4Z5n69YYFE73J1V9Z44Z5ITjGYSvfae9wDttJPb6dJL8ZMgb2LRKDjfUWDTeujPvY0
	 IAaINi1xJcDbNHUakhvLPLxVu9nm3ieDCx2vE+KICNSIVEyjTCk+Nu8i0VKoiAB8s7
	 dre235JXfIxATCsUeTta1q51iTkAtbpneTLgVzNtHU+m9OgY68O6fiDs5+yTW1gpzw
	 MuEBOcYy53wxw==
Subject: Re: [PATCH net-next v8 04/13] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:34:59 +0000
Message-ID: <179113169947.434549.17756429596331380093@kernel.org>
In-Reply-To: <20261003163215.250253-5-achender@kernel.org>
References: <20261003163215.250253-5-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message of "net/rds: guard every work-requeueing site
  with rds_destroy_pending()" has no blank line between the last…

--

net/rds: guard every work-requeueing site with rds_destroy_pending()

This commit adds the rcu_read_lock() + rds_destroy_pending() guard to five
RDS sites that can re-arm path works: the IB send completion and credit
paths, the IB recv refill, the TCP accept path, and the multipath reconnect
in rds_sendmsg(). It prepares for a following patch that adds a
per-connection term to the predicate.

> With the predicate as it stands the guards cover the netns teardown and
> module unload cases; the following patch extends it to the destroy of a
> single connection.
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

[Severity: Low]
This isn't a bug, but there is no blank line between the last paragraph of
the body and the trailers. "single connection." is followed directly by the
Assisted-by: and Signed-off-by: lines.

git interpret-trailers and b4 treat the last paragraph as the trailer block.
In that paragraph, 2 of the 5 lines are trailers, which is over git's 25%
threshold. So the prose lines get counted as part of the trailer block too,
and any tags added later (Reviewed-by:, Link:, Cc: stable) would be appended
to that mixed paragraph.

Could a blank line be added before "Assisted-by:" when this is respun?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163215.250253-1-achender%40kernel.org
