Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FC12D23A5
	for <linux-rdma@vger.kernel.org>; Mon,  9 Mar 2026 07:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773041675; cv=none; b=dqfaP0oJj5XWULV+EZTNT9YEqr+FzF31Z5b8ZElYxGev0U+kWLkjD7ugV/wul77Dox3o2wsbaT2im10iMpf5xzTLF4Q6pUje6wddSBVKQ2qvbBr0UjayjpjrfrrgTpWEQ0WRyxEYHU64qCOtUkgA8MtGNxKopSncwEAXgROUEUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773041675; c=relaxed/simple;
	bh=R2b3GT16yuRWLURpppoxZ2/BomPiRrUP05I1F+TgX5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZrXgSkdyaj61Ly92ScZIDx4TvFymjhkueI0CvTbkXtAA2mGNa0QjtWBd5b/ZGtHfm1zDulXKBMcst/lHl+WKR/n4peLMFIIWbjZsMxuI7q9JaEV/X9PG7EU4Eb+N6vO0vgShVDaPUa0/oNGxyRSbu5rahY6GJwwKTUK7Nov5hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=KpInZ88z; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="KpInZ88z"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 976951A2D3B;
	Mon,  9 Mar 2026 07:34:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 633F45FFB8;
	Mon,  9 Mar 2026 07:34:25 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9BE0910369AA1;
	Mon,  9 Mar 2026 08:34:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1773041664; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=57MDzh0byafJX1r5KvR9O6Bb41FrwPESxzx8+oF42bg=;
	b=KpInZ88zT0C/m9wEsGqcZTgd/wme9ICKOw/x8mxOZfj3zD93K/y5rv9vdzov/zSPdhyTH/
	OdOLhho0dxYdFb56RFgxhN/dlWVlo9l9DaUuXk08i5juRzcD9SYLl45J3yMACAwYsXdj7X
	4o1KunCQIp7FFnWmSwCrxGvQnRWYYmVrOY73s/REAIrZvEeAEa42yQNjZFEBbfPo9buM4O
	eBnOZqroRgTptzHfeLfT/dRGU2m+heHKYN3xoYsGf4DYLkV46emYgi13Hbgv8jOvSBOfGy
	Go4upMe496Z/45jlE/JKI+r/4pi9Fa3f3br9a8llw+vDiDZtPFLDJOuOekLQzw==
Message-ID: <19aa42c1-4e3c-4722-84bd-a21b53ad3993@bootlin.com>
Date: Mon, 9 Mar 2026 08:34:17 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC net-next v2 2/6] ethtool: Add loopback GET/SET netlink
 implementation
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Andrew Lunn <andrew@lunn.ch>, Michael Chan <michael.chan@broadcom.com>,
 Hariprasad Kelam <hkelam@marvell.com>, Ido Schimmel <idosch@nvidia.com>,
 Danielle Ratson <danieller@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20260308124016.3134012-1-bjorn@kernel.org>
 <20260308124016.3134012-3-bjorn@kernel.org>
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Content-Language: en-US
In-Reply-To: <20260308124016.3134012-3-bjorn@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Björn,

On 08/03/2026 13:40, Björn Töpel wrote:
> Add the kernel-side ETHTOOL_MSG_LOOPBACK_GET,
> ETHTOOL_MSG_LOOPBACK_SET, and ETHTOOL_MSG_LOOPBACK_NTF handlers using
> the standard ethnl_request_ops infrastructure.
> 
> GET collects loopback entries from per-component helpers via
> loopback_get_entries(). SET parses the nested entry attributes,
> dispatches each to loopback_set_one(), and only sends a notification
> when the state is changed.
> 
> No components are wired yet.
> 
> Signed-off-by: Björn Töpel <bjorn@kernel.org>

At a first glance, what I see is that you're using the GET ->doit method
to retrieve an array of loopback entries. The pefered approach in that
case is to use the GET ->dumpit command instead, issueing a netlink DUMP
request to list all available loopback entities on a given netdev.

If you want some reference on that, take a look at the phy.c + the
'perphy' helpers in net/ethtool/netlink.c

The idea is that you can pass a netdev ifindex in the header of the DUMP
request, which you can use to dump all loopbacks the passed netdev.

You can also check the ethtool code itself, you'll see that when you use
the "ethtool --show-phys eth0" command for example, it issues a DUMP
request to the kernel.

I'll continue the review w.r.t the actual content of the messages :)

Maxime

