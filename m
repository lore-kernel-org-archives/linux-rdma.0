Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B56A4477E9
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 13:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785246614; cv=none; b=Lgo+eg6Po5iLfiOcNKioSByA7B/UKkRWwc6o3Jmsc/0Af/XLLBYmDd3fI2l+hAOesMLvh/wBJalPZtfFG9ZLQxEe10Dt7kEZf9U25Xsq23MEYDZJwk0KbG/3XAwQMeECKzWydawrNitBAMQB91Kvxs5SoCb+YKuA+8CIbsYzuGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785246614; c=relaxed/simple;
	bh=cYyqhGbOtch0OMgoH5rHeZBCWMljU1zPnzPnNokH5T0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=azwjkBxEZGfThVPoFcWfdoLvLMoQnXGKuiojUyOWtHW3rMPECzJxEq6o97LuDNSELCh1o6iUg+PzMTZZ2HSvYqnR37ePfUT5B9N2ZRkUQcnXLnjHgXQT7OGPGeheY2DK+C+3byLOaD/jc0urdNIALN7CmawGdK6wAvXhvMLD8a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NKly///z; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PizWuvOd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NKly///z";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PizWuvOd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785246612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WVLPzsih7jHwttgXCjqiYK0PPNx9XxtuzrfSgVm0vvg=;
	b=NKly///zSg8QgZMqD8uQzsvEqvuHllwPqDYKa94NpzjV+ck/NHheTwYiJhH+oqV0SetcIb
	98WhIaVXkfhJWP9DhzZ9BCg8rI8hsIaxpiUiGnz7sc771vFQJlcBcRqJfY/saXqZ5FT8Ft
	IVftwGjqbDDQAE1N/EdYCbHwMyF9LWw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-GzV_fE2aPMyLUr9Traxyvg-1; Tue, 28 Jul 2026 09:50:08 -0400
X-MC-Unique: GzV_fE2aPMyLUr9Traxyvg-1
X-Mimecast-MFC-AGG-ID: GzV_fE2aPMyLUr9Traxyvg_1785246607
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955843c6cdso42347715e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 06:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785246607; x=1785851407; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WVLPzsih7jHwttgXCjqiYK0PPNx9XxtuzrfSgVm0vvg=;
        b=PizWuvOdheSc5rwXr8t8xxI+fS1te9cVrH6jc3dR/WIPyYugjI0JDYz2QLbSQFPe3f
         VgiSB5HhsqERNEMurziLnRrDr22LiRuFr2z8kAZu9tRLWETNd7JXZ6WTO8QKSmJR5vU5
         82w38dHJ4MgSiss9PE66xg9ZP8i8hSwV34SA9SEv+sdXZ+TIHU8HHy0OiihW38fsK+tV
         B5/qPAtvZ+AdfvsF2Z0jmQFDzy+Ep4hPoPjKeUnxfaQZz1e61IiC/0PvgdagTWV5kPGu
         2I6XmbcS7B0amW3iDDG/aywpi9iLrAFRc5tKjM5kJek4loo2dRiJ/b6KeelBC5FQPj4g
         Zm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785246607; x=1785851407;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WVLPzsih7jHwttgXCjqiYK0PPNx9XxtuzrfSgVm0vvg=;
        b=KXd2cC+1jkXA4V4yVA0lebwHSUvbBb9ig2QzVP4NRn+UIftbYKex4jG5/+zhfcvvxW
         Fq2+qZK6qSst2HUov9Cv74/d2wU77W2O8zyMDwErPWOEy4VyBubtgksVHMfXzO27z5KI
         s5QQCjPoqgWiX+prUeLBnUBo+fP40Be+lLBh3xtxlINP24rjrQ/p+m/sKgunEvw6L+wo
         1VYx7YUM6V5IkhRJCfOZh+6TxOIcm9fwxaz6Aqk61b9/9pWhjBJkJCqDfByHfpECfdVj
         vEOoSUUUm7/aPlWX/yKvjmi39rCwAczWn8gQlaAIg70mhy90VAeUv+R8nwEE4AkFbZN5
         At+A==
X-Forwarded-Encrypted: i=1; AHgh+Rot9PtwxK48CHagxgXPhYmbacGmQztP/WyEbQwgrTmXP0Da587XOoWaG0DuxyZaXCeEkbTbA0QxYCZS@vger.kernel.org
X-Gm-Message-State: AOJu0YyX9S6mq42D6JvjJR/zbyvldA3b/8vftoPDH2zv9ySJG9UB/ZfU
	xJeSP0VCMHWKvZeJLwcI6SKtwpnbGD41mEm+2Zwk6pffG47hXkvq6dwZB0pxnvZ7b0rTAgOapv2
	YQ2a/iccWp+UOkBpQUwbrkTGQOft/OYIi1jGZevMzMKKwMoL7o5zk2DDb4s1O5do=
X-Gm-Gg: AR+sD13yHhtNXJmmoW8qu2nMEGcGXz06UGcueuQJCmN6LPp2LegaNJ7UAf0rAVwKKd1
	VzKoqtvYX4NszC1PgG56TQrAFZ1Mx0kpd2RnqkTt8ASAKDO86KDSFgaOMst+zHS2lBYiwFVlKg7
	bMGh8s21FYrpQAgqrOKwkPgwHH8nXHhR4dAh/ZxWHX2aQArkJTmiTKjH0zTIRtk+EDWANWYN+6t
	USDv5/7zVPENRKvs28hJOfD4CMzQxeSH1ZoF6Y09lbvld2X/P2H4ASR19eW1wZZILOq01/W3FWi
	M9Dqt6xNRFEAuN4+kY/bYEPubxcLNeTikrtgP+x4gpFZs4T2pAz1FFM8oENxP0u+mGTERzj3lCN
	m30UNhzhiMqioyz1JpHVHTXwZ7kDx6TrwI6RMJnpYovQFHq4KGN+7pWOcLaF8eR/C1tDCUximXm
	HacQ==
X-Received: by 2002:a05:600c:46d5:b0:495:4a22:d684 with SMTP id 5b1f17b1804b1-496c6439428mr31470145e9.10.1785246606585;
        Tue, 28 Jul 2026 06:50:06 -0700 (PDT)
X-Received: by 2002:a05:600c:46d5:b0:495:4a22:d684 with SMTP id 5b1f17b1804b1-496c6439428mr31468965e9.10.1785246605194;
        Tue, 28 Jul 2026 06:50:05 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45c297dsm76861475e9.7.2026.07.28.06.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 06:50:04 -0700 (PDT)
Message-ID: <4b5f67a2-5624-4adb-812a-bd87d99416ed@redhat.com>
Date: Tue, 28 Jul 2026 15:50:02 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v5 1/3] net/smc: bound the wire-controlled producer
 cursor to the RMB
To: hexlabsecurity@proton.me, Sidraya Jayagond <sidraya@linux.ibm.com>,
 Jakub Kicinski <kuba@kernel.org>, "D. Wythe" <alibuda@linux.alibaba.com>,
 "David S. Miller" <davem@davemloft.net>, Wen Gu <guwen@linux.alibaba.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, Eric Dumazet <edumazet@google.com>,
 Tony Lu <tonylu@linux.alibaba.com>, Mahanta Jambigi
 <mjambigi@linux.ibm.com>, Dust Li <dust.li@linux.alibaba.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
 Ursula Braun <ubraun@linux.ibm.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
 Simon Horman <horms@kernel.org>
References: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
 <20260723-b4-disp-0d07164f-v5-1-6a9e235dbc4e@proton.me>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260723-b4-disp-0d07164f-v5-1-6a9e235dbc4e@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/26 2:23 AM, Bryam Vargas via B4 Relay wrote:
> @@ -246,8 +256,13 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
>  	local->len = peer->len;
>  	local->seqno = ntohs(peer->seqno);
>  	local->token = ntohl(peer->token);
> -	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
> -	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
> +	/* bound the wire-controlled producer cursor to our RMB (used as a raw
> +	 * index by the urgent path); leave the consumer cursor unbounded -- it
> +	 * indexes the peer's RMB and is bounded by peer_rmbe_size.
> +	 */
> +	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
> +			       conn->rmb_desc->len);

Sashiko gemini suspects the above may cause a Null ptr dereference:

https://sashiko.dev/#/patchset/20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e%40proton.me

/P

