Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5E13D7D60;
	Mon,  9 Mar 2026 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773068401; cv=none; b=LR4d9QtRNnAp3NOmuDmVQbDAWPb3kbyLPBMB3t7EmYcKG73kkGOu5UwM1ll1wx98k1YXJZPC5d9qa+CgcrMHcuaF3wgPZrTyUAu/FzTY8i2+9SE9yDH9lIjFIYJ6m8vdkxlA3nD/0NcS2r0ais0MlNgU6724BFi6DlVZu2om3nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773068401; c=relaxed/simple;
	bh=eLeeL1XoeqhGBGreUQ/wFMHEb+Wyqd2jhKKWbT3t58U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aitO23AGZJ6VYYgfHb7C8j/W8IRjZk5+HM6vs0U8vikeIWX3DiALOyrYdjAVKZFnLX645hqOrQ6UQpxLHWt6ETwl5ozwK18YCKJQKzS2Ol5SC8oZEMaH1sse6lp8neo/T6F+7FI5OL7Jsn+qkEZnc1gj3Gy44c76xJqm93hRUcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFQqlKje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFQqlKje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEE6C4CEF7;
	Mon,  9 Mar 2026 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773068401;
	bh=eLeeL1XoeqhGBGreUQ/wFMHEb+Wyqd2jhKKWbT3t58U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=EFQqlKjenF2LlD2EiAnO7KknvzHcGyy5fNfZpXKhcuGlkmhJLIypLqzfjrXyyGUGt
	 3dv2lHgRUQ/Y6fRMJJ+tl9KEO+cY3oo5ToRA8zvQ4mxSXDO+2sKhC4gjpsQcJ2wKLP
	 54Ti3AL1AiPff2zj/nmhyvxAepjsJCkLtwdI1icEuduJ3BbSDWuHIpjuXDzcyTLVEm
	 qhXnmzVkcxo13EH8ATuetjAbWDHA3my4pWNCJqtC/ELN17cjyTgcGZP5/OTcOPBBFt
	 UubDnNG6+TqgPWej349XIQTAHCV2jzUkIijY6Pq874XHwzDxyhHo5B6kmaFfLhBhiU
	 /EcfKjK6Eq9Cg==
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
Subject: Re: [RFC net-next v2 1/6] ethtool: Add loopback netlink UAPI
 definitions
In-Reply-To: <456697d6-c0d8-4edf-abd2-85062f4b25ab@bootlin.com>
References: <20260308124016.3134012-1-bjorn@kernel.org>
 <20260308124016.3134012-2-bjorn@kernel.org>
 <456697d6-c0d8-4edf-abd2-85062f4b25ab@bootlin.com>
Date: Mon, 09 Mar 2026 15:59:58 +0100
Message-ID: <87o6kxnj4h.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Maxime Chevallier <maxime.chevallier@bootlin.com> writes:

>> diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/ne=
tlink/specs/ethtool.yaml
>> index 4707063af3b4..05ebad6ae4e0 100644
>> --- a/Documentation/netlink/specs/ethtool.yaml
>> +++ b/Documentation/netlink/specs/ethtool.yaml
>> @@ -211,6 +211,39 @@ definitions:
>>          name: discard
>>          value: 31
>>=20=20
>> +  -
>> +    name: loopback-component
>> +    type: enum
>> +    doc: |
>> +      Loopback component. Identifies where in the network path the
>> +      loopback is applied.
>> +    entries:
>> +      -
>> +        name: mac
>> +        doc: MAC loopback
>> +      -
>> +        name: pcs
>> +        doc: PCS loopback
>> +      -
>> +        name: phy
>> +        doc: PHY loopback
>> +      -
>> +        name: module
>> +        doc: Pluggable module (e.g. CMIS (Q)SFP) loopback
>
> Should we also add "serdes" ?

Good question! I've asked Naveen in another reply...

>> @@ -1903,6 +1936,60 @@ attribute-sets:
>>          name: link
>>          type: nest
>>          nested-attributes: mse-snapshot
>> +  -
>> +    name: loopback-entry
>> +    doc: Per-component loopback configuration entry.
>> +    attr-cnt-name: __ethtool-a-loopback-entry-cnt
>> +    attributes:
>> +      -
>> +        name: unspec
>> +        type: unused
>> +        value: 0
>> +      -
>> +        name: component
>> +        type: u32
>> +        enum: loopback-component
>> +        doc: Loopback component
>> +      -
>> +        name: id
>> +        type: u32
>> +        doc: |
>> +          Optional component instance identifier. Required for PHY,
>> +          optional for MODULE, omitted for MAC and PCS.
>
> it doesn't have to be required for PHY. The current idea is that if you
> don't pass any PHY index when issueing a PHY-targetting command, then it
> means you're targetting net_device->phydev, that is the PHY device
> attached to the netdev (if any).
>
> I think we can keep that behaviour, as systems with multiple PHYs are
> not very common.

Got it! I'll update the wording! Thanks for the clarification!

>> +      -
>> +        name: name
>> +        type: string
>> +        doc: |
>> +          Subsystem-specific name for the loopback point within the
>> +          component.
>
> We'll need to be careful about keeping this subsystem-specific and not
> driver-specific :)
>
>> +      -
>> +        name: supported
>> +        type: u32
>> +        enum: loopback-direction
>> +        enum-as-flags: true
>> +        doc: Bitmask of supported loopback directions
>> +      -
>> +        name: direction
>> +        type: u32
>> +        enum: loopback-direction
>> +        doc: Current loopback direction, 0 means disabled
>
> no need for an u32 for 3 different values I think :)

ACK! ...or maybe uint (which will use as least 32, but shows that we
don't care)?


Bj=C3=B6rn
