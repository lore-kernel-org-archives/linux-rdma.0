Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5038F3DD505;
	Wed, 11 Mar 2026 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773243364; cv=none; b=sk0tJSu+Wb7sVBR/MZA4LYbrg3QRBuaTvCncxc11oPg8CHH3glom0bj40JXxGYfxQbbF+DXMmxZsAtUk2QwFmJ00kgnN73Fhbw4EXBafOZ56XA/uefcLpSA7nkErLMvbmaeXVaW2r/MdDwo8zHthTtDe06VxizCeF8jUS3pWaz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773243364; c=relaxed/simple;
	bh=aIFDm+wj1MnwWVi8m/zngqc8LcZmSluMDGXGFs5i+Pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E8sA5g8Mfd+p5Nz4n1wneiM3yd95P3nMT+5UuIBTYLZe3MBwvaw3WgjoegPXo2EZvOrRLmF6ooSCMHeAxuLStUfiHW07hoQU0P8cmE6X/XUcZgjhbnkeuQr6rj3ut6FaHQyteV3nYqKnPre0jkfw/aUCepb4njMbHq4ymAAMzY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=na0bOpVr; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="na0bOpVr"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id DD29AC41584;
	Wed, 11 Mar 2026 15:36:22 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 61BF660004;
	Wed, 11 Mar 2026 15:36:01 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 644B710368F58;
	Wed, 11 Mar 2026 16:35:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1773243359; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=MCaWQJMEcm+4uX5U+lNfbT4AOEoWdHPd6YnrMl3k3Ws=;
	b=na0bOpVrbOe9TNUDMGm6PM7G9p+7LJbK3L7uPQQV1yS5ksJ7K65B/YzjLOjXy54mpB43go
	F6M76IVfu5xF0wANGSqZFHxsyvdndZqsNq+VoIOv0ZybhIUS0DC62IOyBZSgpPeiJ+l3eZ
	NeA2dUPNprOc6YckYPy2AxsDEErBa96jrW8lA6nVbq1+u26ycyrbt/cVzo91EimUYFR+Ja
	7gWoR/o/XbgslPPSAB3T6j9s9f/p5lPDa1W3Bxg/h0ByeHeOqQDRdWnoXqnd3U3ZyAj56R
	L7+lZCfIVh3moBPtNtXA7SvW66zOjlsTfE7XB5Sm/WKG+zO2JRUEJXRYWhXJTw==
Message-ID: <085bb0a9-85d3-4d62-9ac4-3461b61da5f3@bootlin.com>
Date: Wed, 11 Mar 2026 16:35:51 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 02/11] ethtool: Add loopback netlink UAPI
 definitions
To: Andrew Lunn <andrew@lunn.ch>
Cc: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Donald Hunter
 <donald.hunter@gmail.com>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Naveen Mamindlapalli
 <naveenm@marvell.com>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Danielle Ratson <danieller@nvidia.com>,
 Hariprasad Kelam <hkelam@marvell.com>, Ido Schimmel <idosch@nvidia.com>,
 Kory Maincent <kory.maincent@bootlin.com>, Leon Romanovsky
 <leon@kernel.org>, Michael Chan <michael.chan@broadcom.com>,
 Oleksij Rempel <o.rempel@pengutronix.de>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>,
 Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260310104743.907818-1-bjorn@kernel.org>
 <20260310104743.907818-3-bjorn@kernel.org>
 <580debbb-8f6c-4b60-95ef-22c68480ded1@bootlin.com>
 <b3825c0d-02e5-4625-831f-4346ce4eabd2@lunn.ch>
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Content-Language: en-US
In-Reply-To: <b3825c0d-02e5-4625-831f-4346ce4eabd2@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3



On 11/03/2026 16:22, Andrew Lunn wrote:
>> If we take an example with a 10G PHY, we may have :
>>
>> +----SoC-----+
>> |            |
>> |  MAC       |- drivers/net/ethernet
>> |   |        |
>> | Base-R PCS |- could be in drivers/net/pcs, or directly
>> |   |        | in the MAC driver
>> |   |        |
>> |  SerDes    |- May be in drivers/phy, maybe handled by firmware,
>> |   |        |  maybe by the MAC driver, maybe by the PCS driver ?
>> +---|--------+
>>     |
>>     | 10GBase-R
>>     |
>> +---|-PHY+
>> |   |    |
>> | SerDes | \
>> |   |    | |
>> |  PCS   | |
>> |   |    |  > All of that handled by the drivers/net/phy PHY driver
>> |  PMA   | |
>> |   |    | |
>> |  PMD   | /
>> +---|----+
>>     |
>>     v 10GBaseT
> 
> We should also keep in mind this is a "simple" PHY. If you have a PHY
> which does rate adaptation it looks more like:
> 
> +---|-PHY+
> |   |    |
> | SerDes |
> |   |    |
> |  PCS   |
> |   |    |
> |  MAC   |
> |   |    |
> | packet |
> | buffer |
> |   |    |
> |  MAC   |
> |   |    |
> |  PCS   |
> |   |    |
> |  PMA   |
> |   |    |
> |  PMD   |
> +---|----+
>     |
>     v 10GBaseT
> 
> So there is potentially 5 more loopback points?

Good point indeed

> 
> Jakub proposal had the concept of 'depth'. Maybe we need that to
> handle having the same block repeated a few times as you go towards
> the media?

So, the same name + depth ?

 +---|-PHY+
 |   |    |
 | SerDes |
 |   |    |
 |  PCS   | component = PHY, name = "pcs", depth = 0
 |   |    |
 |  MAC   |
 |   |    |
 | packet |
 | buffer |
 |   |    |
 |  MAC   |
 |   |    |
 |  PCS   | component = PHY, name = "pcs", depth = 1
 |   |    |
 |  PMA   |
 |   |    |
 |  PMD   |
 +---|----+
     |
     v 10GBaseT

I think I like this idea of depth + name, as we can consider omitting
the depth information when it's not needed (e.g. simple PHY with 1 PCS),
to keep the API simple.

To continue with your example, with combo-port PHYs we may get multiple
PMA/PMD instances, one per port, that's even more loopback points.

We could potentially associate these with phy_port though ?

> We should also think about when we have a PHY acting as a MII
> converter. You see the Marvell PHY placed between the MAC and the SFP
> cage. That has a collection of blocks which can do loopback. And then
> we could have either a Base-T module/PHY in the cage, with more of the
> same blocks, or a fibre modules with loopback.

For that we have what we need with phy_link_topology, as each PHY has
its index, we should be good to go in that regard hopefully :)

Maxime
