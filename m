Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794505548;
	b=j3hipvy5x2TEA/zVVQp1Hj3mvfIEz5lT7ca+PySj8rXMVLVkk66iariAVS/dXr0N6pKm
	 FfYOoCAuzBofCU8oUXBdxR47C01/hPMX6W6CaBnVxWwA2sgd9tAcLBwMCBhERXxoGJ9Gj
	 PyhvSPv35nULtaxzQz/SjsZpFWmSUXOpWZdNFiOiAtvntaJjrti6S+pyy/T7kWczyquGy
	 rjWhg6hNGYW0SIiqZOmtuUfqM4Qr4nfO5rN2DzRrHg9m+H2d7tuULb6TlaBF00SZ7uSgL
	 vZZgVxbPVNYAV7gGOlqTuAFRubv3e7wRUJYZ2dexF2YmLKYnkmFonZClHdlEOWs3X9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794505548;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=czdhaGFv7cIrx8yTbMDRh9Bkh0lnaUBxN3R0u1dkKDY=;
	b=aHU5pC/NS4Few2pQq+DPHHCvjTsKwTEHeQ7Zel1GmdjIDANH7up9+FrRKCjaOXivNpzh
	 5VhzNhivvEUXSeXpzl8Q3NhENITk+5TvP+SHxIZ8TwSpETz0WJ9az9ufR2qJPYEvvNWGC
	 lzd+muix9W2jyXB0hyrxPN79wixMkZj2pvbDBSSAWE1j0sLGkyNognn7lHzilc1JwHWzE
	 gdRuGPGbObZhDp6KzKlofatJno7gk7CdzQMGzXPFStZ+VH5dve3w3v9UQGr/SZNYmXOgk
	 09PYeKpkBYEiJMYlIABzO7yK0qHNpNPmYYQkz4OpMZyO7WR/vr+Ba87tYtuAUjzaS8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z9NmTDM2;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7E7606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 17:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB7E7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z9NmTDM2
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36e99cf7bb3so180873eec.0
        for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 09:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794505547; x=1795110347; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=czdhaGFv7cIrx8yTbMDRh9Bkh0lnaUBxN3R0u1dkKDY=;
        b=z9NmTDM2KEtrOPsMIPA0GyJhqok0T9B5pAXcyqyXKBM9waVNRE6kC9mExqfl+luOde
         y3nAspNsgUy5LXpTcKx8bRerd4pTwLrv6wHUY3R4Uu8PFKJBYxW7iTfpsfw+u19StEyW
         XwL3reU+PZv+eLY2jndOz48VQPfhuBjl8ARlL6aqBLlQZPqBqE0D7V7gVskV5nRKXark
         Yx/lZKwvs8NvHn/SWSA9RAMKr9AwGQxVK64/lr4tanTQ/EA6mJVsPIa9ova4al5m9PFz
         COwXU8rwGEH9kwu/I9rmAiNDOk37QkBQP77k6YHrDslCNSNk3uaMo2VYoCnHzODfhc9E
         OFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794505547; x=1795110347;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=czdhaGFv7cIrx8yTbMDRh9Bkh0lnaUBxN3R0u1dkKDY=;
        b=y63frSCtx3P2jJVwnsOp7kZJQhXRU5+m4ISjLhMcguHsIlglCzWY9Ob/PYCGGahoaZ
         fhIZfXhy7cydBOS559qYWYA6lrPvciJAYovgD7VEE71kbk9bQ89fpT7z33XFJypR10No
         XElhx+3r0hgJ6ugvK6FrDuccbmaYV/SzhYnwlb6zT1CuvHoULy9WmOyclWaNDD4EarC5
         8t8Hp82PCWjKPhPCvxXjnyxu8B1VSirZ4ndxvwkITn0zbie6IRxpy6o3pR0TmLzECBhD
         UwrgEmjjW5hoYhADdm+o/mNd7VdryT6IBQVpOnUtIQitCBUHZyLZkWlRlGfEQEQSdCaN
         qBrA==
X-Gm-Message-State: APuU4Z+oSgS+KXdGABH3PlmMzY1nWhcnzE7lHez/oPtGbQBt+MpL4UzL
	TcVsscLPZ7qEVUQPYiLvOYUE1Iabk/EMOJEojmnEvBapVG6UtWoOoJkIZpzkZA==
X-Gm-Gg: AYBFou3liLbNBeNcyBaXsTPsO2MrlNlukBdNaW1J8GqG9fmeVufcEmiiBK5DJ+G9Xhw
	o041vCGfWcQr82o5QYP82L85znwWhFyjRkgs0zZ2Sd14HJAMAmoEFu9zAR2D0NJq056QRkUETpz
	EglQpcZhIMskZDTRQGF+e4IMu6YRyvINVh5WJQSSYw/imk6pyew8diqw1YdzFqQCZQJXiBgAn78
	usc/COIKfed0pEytFDo1GaDWt1/tgf7V5LFI+DL+yEW+f51LGCDRDRZLN3RcFn5BXPzn3A6nHi8
	ZSw5ZGRMXDPdNgFX6Kcm09J6QL49fUVNlOp7Pye2KPBCNVbL1yNwz4XElg8n0kOfTkyfJacc6de
	4oSYPagckUQr6rbZfbr43n8X5tFuUyu1C4/hIO8+6PO5vs8SygdL/WpIPQU8qLRhRU9PFZgDUOB
	j+M3Aboe2uh5IgG0h2MyZ6Ma1I3mv9ZHp4cS1jjOvic8A4/fPi5ofyjIOEwSi+cXmQuB0a/hDHt
	v9Wmotw3z7a4/IhTSdiLtW3J6yUkvILEvZ/Hbj8A5TJ2rOcaV4jeHbkOzObrPopgGMeB3+ATyzr
	HZHKqa656Zfxtv84P6HRDl/4SYKxgrvLx9yCXSX8cDAeutMWbgvCqqC6ysstn3CHODNIgPpjXDu
	Cn6BPSBQUMoA4UOrGrKZiqK/E1Sm5mrZMNv0/gg==
X-Received: by 2002:a05:7300:23d2:b0:36e:800a:71fe with SMTP id 5a478bee46e88-37683861491mr6399782eec.1.1794505546344;
        Thu, 12 Nov 2026 09:45:46 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:c24:4ad9:f660:1904? ([2620:10d:c090:500::6:db98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bad6casm59005eec.26.2026.11.12.09.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 09:45:45 -0800 (PST)
Message-ID: <b1df2930-2bb5-484d-b134-de842762ce89@gmail.com>
Date: Thu, 12 Nov 2026 09:45:44 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4] net/mlx5e: advertise tcp-data-split support
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
 <sashiko-outbox-211565@kernel.org>
Content-Language: en-US
From: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>
In-Reply-To: <sashiko-outbox-211565@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/12/26 9:06 AM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] net/mlx5e: missing HW-GRO cap check in
>   mlx5e_ethtool_set_tcp_data_split()
> - [Low] net/mlx5e: missing Fixes trailer for commit 46bcce5dfd33
> --
> 
> commit 10e87fc2f39f7859cabd43f8c342a731e4043353
> Author: Dimitri Daskalakis <daskald@meta.com>
> 
>> net/mlx5e: advertise tcp-data-split support
>>
>> Since commit 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split
>> settings"), mlx5 no longer reports tcp-data-split from
>> mlx5e_ethtool_get_ringparam() and the reply carries only the stored
>> config. With the default config (auto) the attribute is omitted, so the
>> device looks like it does not support tcp-data-split, even while HW-GRO
>> is on and SHAMPO is splitting headers.
>>
>> On mlx5, header-data split is performed by SHAMPO, which is used only
>> when HW-GRO is enabled. The driver already keeps HW-GRO on while
>> tcp-data-split is enabled, but nothing enforces the other direction.
>> A user can disable tcp-data-split and then enable rx-gro-hw, leaving
>> the device splitting while the config says it is off.
>>
>> To make the feature handling consistent, report tcp-data-split as on
>> when SHAMPO is active and off otherwise. Only allow disabling
>> tcp-data-split while HW-GRO is off, and keep HW-GRO off in
>> mlx5e_fix_features() when tcp-data-split is already disabled.
>>
>> Signed-off-by: Dimitri Daskalakis <daskald@meta.com>
> 
> [Severity: Low]
> As reported by Björn Töpel on v3 [1], should this include a Fixes tag for
> stable backports:
> 
>   Fixes: 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split settings")
> 

The fix was for updating netdev features after a successful ring param
change. That was sent here [1].

As for the rest of this patch, it's more of a user behavior change than a
fix. The HW splitting capability still works when GRO is enabled, it's just
reporting to the stack/user that gets corrected.

[1]
https://lore.kernel.org/all/20261017005401.1582755-1-dimitri.daskalakis1@gmail.com/

>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>> index 1f534051cdfe4..8e7c748caf2d2 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>> @@ -388,6 +388,13 @@ static void mlx5e_get_ringparam(struct net_device *dev,
>>  	struct mlx5e_priv *priv = netdev_priv(dev);
>>  
>>  	mlx5e_ethtool_get_ringparam(priv, param, kernel_param);
>> +
>> +	if (dev->hw_features & NETIF_F_GRO_HW)
>> +		kernel_param->tcp_data_split =
>> +			priv->channels.params.packet_merge.type ==
>> +			MLX5E_PACKET_MERGE_SHAMPO ?
>> +			ETHTOOL_TCP_DATA_SPLIT_ENABLED :
>> +			ETHTOOL_TCP_DATA_SPLIT_DISABLED;
>>  }
>>  
>>  static bool mlx5e_ethtool_set_tcp_data_split(struct mlx5e_priv *priv,
>> @@ -399,7 +406,14 @@ static bool mlx5e_ethtool_set_tcp_data_split(struct mlx5e_priv *priv,
>>  	if (tcp_data_split == ETHTOOL_TCP_DATA_SPLIT_ENABLED &&
>>  	    !(dev->features & NETIF_F_GRO_HW)) {
>>  		NL_SET_ERR_MSG_MOD(extack,
>> -				   "TCP-data-split is not supported when GRO HW is disabled");
>> +				   "TCP-data-split can not be enabled without HW-GRO, set it to 'auto' and enable HW-GRO first");
>> +		return false;
>> +	}
>> +
>> +	if (tcp_data_split == ETHTOOL_TCP_DATA_SPLIT_DISABLED &&
>> +	    dev->features & NETIF_F_GRO_HW) {
>> +		NL_SET_ERR_MSG_MOD(extack,
>> +				   "TCP-data-split can not be disabled while HW-GRO is on, set it to 'auto' and disable HW-GRO first");
>>  		return false;
>>  	}
> 
> [Severity: Medium]
> Does mlx5e_ethtool_set_tcp_data_split() allow setting
> ETHTOOL_TCP_DATA_SPLIT_DISABLED on devices that do not support
> NETIF_F_GRO_HW?
> 
> On hardware without SHAMPO support, dev->features & NETIF_F_GRO_HW is
> always 0, so requesting ETHTOOL_TCP_DATA_SPLIT_DISABLED succeeds and saves
> that value in dev->cfg->hds_config.  Because rings_prepare_data() copies
> dev->cfg->hds_config into kernel_ringparam.tcp_data_split before calling
> mlx5e_get_ringparam(), and mlx5e_get_ringparam() leaves tcp_data_split
> untouched when NETIF_F_GRO_HW is not in dev->hw_features, subsequent
> ETHTOOL_MSG_RINGS_GET queries will report tcp-data-split as supported and
> disabled on unsupported hardware.  Requesting ETHTOOL_TCP_DATA_SPLIT_ENABLED
> on such devices also returns an extack telling the user to enable HW-GRO
> first when the device cannot support it.
> 
> Rejecting non-ETHTOOL_TCP_DATA_SPLIT_UNKNOWN values in
> mlx5e_ethtool_set_tcp_data_split() when !(dev->hw_features & NETIF_F_GRO_HW)
> would prevent this.
>

I don't think it's worth the extra code. Presumably these devices cannot
split anyway, so it's fine for a user to disable the feature.

> [1] https://lore.kernel.org/r/87a4ons7dd.fsf@all.your.base.are.belong.to.us
> 

