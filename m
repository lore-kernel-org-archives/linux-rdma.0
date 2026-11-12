Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794494996;
	b=BzX08f0JN/AXi7AEXmeMRSDfpJTrdIr5n5okBfHAznSE1wEvvMiEjK4NudqHWMasAE4w
	 40t4uIL3SH3MgCM9lPxgSeNwU83/HNAWzCfAesryuKruvjS+TeckSeZPcJWh/SXohnC4h
	 y2tyhzZgpnrKFxEbUjixsL+j3P/UMw9l+X1vQtZOS0GsUpZQGEAF1hRlZvhmiwoGYZ5e3
	 1jOfy8Ur14LUWQU/+MZ9Hbwd+vjZqVY7bzFip/5zctn2P+9tz70/PJJ2HtSxVSvxlsURy
	 XSa5a6Uf4MwajntWlRHSyDyF0cBGMxUpNi+RuO5qpDmieDLY8F7A7ckI4HOFQuAEqQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794494996;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=vfNdgyP+NRKLkAfEjNEeqH/mZDeg/vBSn9uePnv4O7Q=;
	b=LdNwpZmXr0jnMxJWBjM7VdmccarNDGzq+u2egoKycgnNaJW6CLH26LaFEEk/rMHsHZiq
	 w5rpiFr5HUNF1sY39bJ7VKBML2DbLqFCHonZQKCLnqHRodi9Od/d4C/3RBoDzelE4ar0G
	 0nYDgNLI0Xzbm1PLl6zUfJdZTWnhlnLXn7F0dr4D29C1PmnOQohcK2/2P0QBoCgZw4+Ph
	 jpw8BEXrRZ1FtPitoIEGMyPxKygViOQjhcqr1FeuHcoy8ofscZjWdh1K0K9Au4GqASL8l
	 yvYTQcbv90UGRUU19eXP3z9F6UBRumvMg3RCsF7i3QN88hO9QOuvKcCEzES/QRUlrXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DFRUeeaZ;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=d36m5nSx;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAF5606A327
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 14:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFAF5606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DFRUeeaZ;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=d36m5nSx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794494994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vfNdgyP+NRKLkAfEjNEeqH/mZDeg/vBSn9uePnv4O7Q=;
	b=DFRUeeaZ7PukFq0E2zU6kQkUyhWnE7OCKXlOMhuO7y9on1VxO7Lm6Qx4yRkDeBXOz/DyM9
	VMeC0F/8++wR2SgbJDGdjf+9TSTHN+/Li7QoUmAU+YdhzKylg5W++5mKvoBCfSuRB52toH
	J/tT4jqZwBYN1wxH7MDGWb8VLyAc5Kk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-G8Q3INArPTSkw8A5T--F3Q-1; Thu, 12 Nov 2026 09:49:53 -0500
X-MC-Unique: G8Q3INArPTSkw8A5T--F3Q-1
X-Mimecast-MFC-AGG-ID: G8Q3INArPTSkw8A5T--F3Q_1794494989
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49953abe51fso31826225e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 06:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794494989; x=1795099789; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vfNdgyP+NRKLkAfEjNEeqH/mZDeg/vBSn9uePnv4O7Q=;
        b=d36m5nSxoDWdvyYtLqnat3194iJTv5RdLjF8A0cLiDThlGMtUpCYJPUhOr+doqiE47
         SCZNGYTmAilxtj0XcaFk97qT1Zkp0AODjD0FiQd4xlqtdHRJNs5RVOMwhjwOXTk6B2Ot
         x+Mtm4olGs7EyjoH1yE4d7X0dxfs++EXzuH3u8+OU+5P9KQBC1fgxbjlf8/k3jFTdm+s
         cRzGbvNcN10o8dgvCCXKWQ5L7ZdDGFMlmlKCN9XCvf1RjXteKe0+cypskqqHJs/cu4oq
         c/xWT7BVJu1q5tISQ/1tlVUUZcVhx8hQ0HoqfgcgILFrkq+32bZdLEFoM5muSmA3RvaI
         cxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794494989; x=1795099789;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vfNdgyP+NRKLkAfEjNEeqH/mZDeg/vBSn9uePnv4O7Q=;
        b=jWFLCHCDfJoFaV58Sp5XBnpaZ+2W7tve2u+38g6pUvrUq1/mA0YkYBhDKtYGZo6FZc
         ljRv6rEWXw4EXjHZrDsQju3rmrrAwPP27q3H3HePunZh/L3/LrS5f3L0YUrtmkRLQREU
         K1GAOwa9xsOc980xg4F9a4LnEHfXPkW4I5A5HcHJ66Ly+RK5dV7VvShElFpxNgN2npfI
         mXRzZXObJkRg8/x/WOFGbu/M5hHcxGjYkeiADTlzz15ibbitzeKTvR53D17ofAJ0RLoc
         AYZV+8Qvoov+xkAIVwIAvRXKCoMjtS83kRyXuR9+FBF6obwbTZpWT23FUb5o008aM3lI
         oMvg==
X-Forwarded-Encrypted: i=1; AL+hErG3a3eTrFsobs8sesLzzm2MbQjoFjv3M8koGIeOnqFsJx+mfDXzEvxgB6WslEfpRIzd7QkNvcKn2zrb@vger.kernel.org
X-Gm-Message-State: APuU4Z+K6F3wNCqtZ77eCoCr/YjtH+xuHFyj7EyZnapJDeht/etumTE4
	9EsepszTYnl2kqULmKgahUSl+Llop4czMdwQaQPc2vObaPn2Pv8zvi1qHXNNetWhYMIQ/k+jJpi
	eALURjuGlNzW3dpmY11N3blTD3BniB2cfIOpnOuNQ0NiUgbdj+4m9OJwPdkH9cT8=
X-Gm-Gg: AYBFou34+VbPOCt9RPLQ6YilSbhaubWY08+bY6VKgXWgoo0iz1I+jyGwFrG1hEKbEvg
	9LZWKjXpLRzcuUXSx3TzEaiix+mVS2tfQq1ENN/ygwiipnKbHiF4ocO8fQwvJifqAEXkrxKYyCI
	onJ9suZtweO7NDiGrK8QbGFSzYY++xJLcpapBB/w6kgu2DKpDWxyWewIOkwFOSybzXujHhZgOob
	J3byFpJ4i+JdduCu1fgjp/mB6nByVg03S+XnfHBK2GAriUtIFw/tN+jp0c+dqh2aaJk3ho1/dPN
	iZ4KWfjc5WdkHHHb6wOSKwnf3t48JyvEB5YCqcPvy3vZExHLqEvgQWOGg8rDrDZD5+drv7vOf+/
	fEVZqcWwWIkO+hFT/r+Z6m1SlQvHrepTUqGBou5v8Avtr7H8VT3jkB45f2LxSl4e86VwTqx5UiQ
	eKgD5mKPv2tytC2Zwr+mtzc9CoCJmmQgPmdDSbYMatRNmd
X-Received: by 2002:a05:600c:4ecb:b0:4b9:ff69:19ac with SMTP id 5b1f17b1804b1-4ba093811d3mr106230355e9.11.1794494989326;
        Thu, 12 Nov 2026 06:49:49 -0800 (PST)
X-Received: by 2002:a05:600c:4ecb:b0:4b9:ff69:19ac with SMTP id 5b1f17b1804b1-4ba093811d3mr106229855e9.11.1794494988926;
        Thu, 12 Nov 2026 06:49:48 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2969e7sm66879205e9.10.2026.11.12.06.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 06:49:48 -0800 (PST)
Message-ID: <c4910aa4-a477-4b0b-b875-52703fc8bcc2@redhat.com>
Date: Thu, 12 Nov 2026 15:49:47 +0100
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
Subject: Re: [PATCH net-next 5/5] net/mlx4: flush pending doorbell when
 dropping a TX skb
To: Daniel Machon <daniel.machon@microchip.com>, Joe Damato <joe@dama.to>
Cc: netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, edumazet@google.com, horms@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-6-joe@dama.to>
 <20261112134346.zvctvknj4mc5s2pm@DEN-DL-M70577>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261112134346.zvctvknj4mc5s2pm@DEN-DL-M70577>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/26 14:43, Daniel Machon wrote:
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> index 123071a47bed..3166837711be 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> @@ -1135,6 +1135,9 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>>   
>>   tx_drop_count:
>>   	ring->tx_dropped++;
>> +	/* an earlier skb in this batch may have deferred the doorbell */
>> +	if (ring->doorbell_pending)
> 
> I think checking !netdev_xmit_more() here would let you ditch the new ring
> state, but it seems bnxt does it the same way, so fine by me.
I don't think checking `!netdev_xmit_more()` would work, as
`__netdev_tx_sent_queue()` adds more logic to it.

Still I think that the cacheline alignment comment by sashiko
on patch 4 is relevant:

https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110231304.1859217-1-joe@dama.to

I think a better binary layout for `struct mlx4_en_tx_ring` is needed.

Thanks,

Paolo

