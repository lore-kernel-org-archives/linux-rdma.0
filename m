Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61985346AE5;
	Tue, 10 Mar 2026 10:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138241; cv=none; b=SijJEHaMjhqQG9MTiMBJOqbg94Ezlde3lYltHS38nctO7+VBo1wWy/hLxaJ+oB+xSrRQqsciFZdqz3r+oVG0/RS5Fe45uTIazeTumohAQt8rqytg9r6oQ1z56csCChLIhUcJQILus+Aa8wP5IfH3Oi9yS4o75V+YCtHoqh+bquo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138241; c=relaxed/simple;
	bh=V4nAKKOrlsJnLVSfpQtB7ZrgidRhEAiRET1TW0NC+Uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IEuL5Ay2lTeZcXqS75dtYV2akHg+ETLLMy3++c1eVMAT47aK+QddOiZQxCsO8O9t+hUTToajUpALXOeyqnf3nuFPGnmgIe5+3Eu+w0DkZWHsxTaeDFdeYWC5RX3sv5rzi3hm6pnZB5fDMXZuCn2cgeqA9ezazI/H93nLGhfFZvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=zK7PTUb1; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="zK7PTUb1"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 7450EC40683;
	Tue, 10 Mar 2026 10:24:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id AB05060002;
	Tue, 10 Mar 2026 10:23:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C548310369AAA;
	Tue, 10 Mar 2026 11:23:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1773138236; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=dG33aSjLs5/R1+ox7HGy2GkcqJJZcFyv8oCLXkVVO4w=;
	b=zK7PTUb1s9XSnqHU6HDC+Ezw/Qs9eHAkITmOHNSaQqdFvp9Pnc0Zm857kdzbWUFhLV2ocZ
	bvPdL5bqeKEaE2zlcdG9j55prr4u6R0aeRrBRqG+aQ8CT9T3O6uF7B5BwnpZtfozxm1a0X
	7/HzbcfSdPQiaZOJTLGmqSK6jhjrILMV718y+Y13nn1Frsgwf5n+lhXeJm6jwQ6Z7DIaBP
	BZdBLGmvX3kZBxAomTS73hB9dUqX+ptoIJlfVhcYz9C18cw80HF0f/r1uuveJ2/OqkMlCr
	7yt/Sy01ddWzu7riuNBYUDRLkSVl/Aor4lUEEbF+CJZ2e9SdSfBYlGV1ILWAEQ==
Message-ID: <2ed52f3c-ce2b-4ac9-baf5-224fd3e946f1@bootlin.com>
Date: Tue, 10 Mar 2026 11:23:48 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC net-next v2 1/6] ethtool: Add loopback netlink UAPI
 definitions
To: Andrew Lunn <andrew@lunn.ch>
Cc: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Michael Chan
 <michael.chan@broadcom.com>, Hariprasad Kelam <hkelam@marvell.com>,
 Ido Schimmel <idosch@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>
References: <20260308124016.3134012-1-bjorn@kernel.org>
 <20260308124016.3134012-2-bjorn@kernel.org>
 <456697d6-c0d8-4edf-abd2-85062f4b25ab@bootlin.com>
 <e138acb9-f2ab-4d76-a9b1-fa7299b1260f@lunn.ch>
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Content-Language: en-US
In-Reply-To: <e138acb9-f2ab-4d76-a9b1-fa7299b1260f@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3



On 09/03/2026 17:45, Andrew Lunn wrote:
>>> +    doc: |
>>> +      Loopback component. Identifies where in the network path the
>>> +      loopback is applied.
>>> +    entries:
>>> +      -
>>> +        name: mac
>>> +        doc: MAC loopback
>>> +      -
>>> +        name: pcs
>>> +        doc: PCS loopback
>>> +      -
>>> +        name: phy
>>> +        doc: PHY loopback
>>> +      -
>>> +        name: module
>>> +        doc: Pluggable module (e.g. CMIS (Q)SFP) loopback
>>
>> Should we also add "serdes" ?
> 
> What is the difference between SERDES and PCS?

By Serdes I mean "generic PHY", but as you state below I don't really
want to use the word "PHY" as it's very prone to confusion with Ethernet
PHYs.

> 
> Maybe we should also make it clear PHY means Ethernet PHY. The Marvell
> Generic PHYs have
> 
> phy-mvebu-a3700-comphy.c:#define COMPHY_DIG_LOOPBACK_EN		0x23
> phy-mvebu-cp110-comphy.c:#define MVEBU_COMPHY_LOOPBACK(n)		(0x88c + (n) * 0x1000)
> 
> which suggests it can also do loopback. We don't want PHY meaning two
> different things.

Agreed,

Maxime
