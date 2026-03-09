Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60C3258EDA;
	Mon,  9 Mar 2026 14:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067901; cv=none; b=FaBpLpBsqWQ6hXLLW539ve4U6KGS7UpaUT32QLhVNaXrPuTXZbeK6xWT9URe6UMeVTEtpHmlLu94GMMUOurMnqV3GANlZFIQGrxQJVudOPPxWmnwbgod361cVeKrwF1S28nhGayXw/TRUC+WCfyH/LeZIgN3Bk3MU9k6MWFCGXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067901; c=relaxed/simple;
	bh=KGSyrULtCYQb9lllEUEC0LtqXkY/kFQ/AGD3XoX6jdI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Dz9j+pt2GXUWjPX81ZDXtgjk9iXsZPWgyaLIK2/6bzYxk11jn3zO9qBsZgOjZTARSYv8pFjVJii83SxJsnS+4IrpICXL/WgoOHlNeToAJQDrkvrxfjfOEQP7H1XJlv5tNH9MEAOMhk1n3ZDMcwYJ53l/AeMspylNhz0w9PZXHDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwcInBJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwcInBJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7B8C4CEF7;
	Mon,  9 Mar 2026 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773067901;
	bh=KGSyrULtCYQb9lllEUEC0LtqXkY/kFQ/AGD3XoX6jdI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jwcInBJr8GKugmDGut9GTXwgTEv/H43MX9aWKIOAE20IkqXsKykJIbxlf4kZBJ/tC
	 BtkyaJ8naw2vssi7XYblEpF226PKS1Avdu+0SKxv5JMIspxEnvoBxJouAAsJI2+f+7
	 SXMy3OaH1/6O7AcVHDTpN7PGSD9VuX6ocdsntYXYQHU4Xintb8MHQh/18iUbAwlAOB
	 acCvX0764jC8+rmcaMWhR/TCNuUOrrdiYj/Ag2EAavbNdY+zUTA2UUXESdHhTkoTH6
	 RwwtHof8C82HjyGqHP8VVAP6WiyUn8pnmokwQzarPgMcsYbepEFNY+fSMhbXKbWvgr
	 Wg+3ad0w5LtJg==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>,
 netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>, Jakub
 Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, Tariq
 Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Andrew Lunn
 <andrew+netdev@lunn.ch>
Cc: Andrew Lunn <andrew@lunn.ch>, Michael Chan <michael.chan@broadcom.com>,
 Hariprasad Kelam <hkelam@marvell.com>, Ido Schimmel <idosch@nvidia.com>,
 Danielle Ratson <danieller@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC net-next v2 2/6] ethtool: Add loopback GET/SET netlink
 implementation
In-Reply-To: <87eclth0qw.fsf@all.your.base.are.belong.to.us>
References: <20260308124016.3134012-1-bjorn@kernel.org>
 <20260308124016.3134012-3-bjorn@kernel.org>
 <19aa42c1-4e3c-4722-84bd-a21b53ad3993@bootlin.com>
 <87eclth0qw.fsf@all.your.base.are.belong.to.us>
Date: Mon, 09 Mar 2026 15:51:38 +0100
Message-ID: <87y0k1njid.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> writes:

> Maxime Chevallier <maxime.chevallier@bootlin.com> writes:
>
>> Hi Bj=C3=B6rn,
>>
>> On 08/03/2026 13:40, Bj=C3=B6rn T=C3=B6pel wrote:
>>> Add the kernel-side ETHTOOL_MSG_LOOPBACK_GET,
>>> ETHTOOL_MSG_LOOPBACK_SET, and ETHTOOL_MSG_LOOPBACK_NTF handlers using
>>> the standard ethnl_request_ops infrastructure.
>>>=20
>>> GET collects loopback entries from per-component helpers via
>>> loopback_get_entries(). SET parses the nested entry attributes,
>>> dispatches each to loopback_set_one(), and only sends a notification
>>> when the state is changed.
>>>=20
>>> No components are wired yet.
>>>=20
>>> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
>>
>> At a first glance, what I see is that you're using the GET ->doit method
>> to retrieve an array of loopback entries. The pefered approach in that
>> case is to use the GET ->dumpit command instead, issueing a netlink DUMP
>> request to list all available loopback entities on a given netdev.
>>
>> If you want some reference on that, take a look at the phy.c + the
>> 'perphy' helpers in net/ethtool/netlink.c
>>
>> The idea is that you can pass a netdev ifindex in the header of the DUMP
>> request, which you can use to dump all loopbacks the passed netdev.
>>
>> You can also check the ethtool code itself, you'll see that when you use
>> the "ethtool --show-phys eth0" command for example, it issues a DUMP
>> request to the kernel.
>
> Ah, got it! Thanks!

Thanks for pointing this out! I like how using this can get rid of the
fixed size array in struct ethtool_loopback_cfg, which had a bad smell
to me.

Thinking out loud -- Now, using a similar scheme for loopback requires
some thought around the sub-iterator: Loopback has "multiple"
sub-iterator: (component, [id], name)... or needs scheme to deal with
one sub-iter, and loopback can share a lot of code with the
perphy-functions.


Bj=C3=B6rn
