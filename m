Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701327;
	b=4tAFsXkVDkqdRY9e8nQJjW0P/uOXrVQWCr6T8lSJJ/mx5thTIb9e0opByOlj7Z0JHhNz
	 hSoH3qKyC4T5npcEnKliZZVujzdFfnuf314iM6+0yCGwOdUeTIGN9SZhhDBb9Q/6umCXe
	 VXEc4A0KBR2+dtMz5S4pc83ZeHr4tWoQLa1eETGTY8sUsAhOW5Zu8fiiC9QBOwtREi0wH
	 Y+ygGxIHruneRxHgsepERsh18WB7Uio+ilkJ3NZ0XhlxihviOkvgPPK8tLhdquzlLQSmW
	 YpHBB/k9oBJ3s18Th1PnQTa9tQtxrwiq71MWAqBJe8azTFrm0WbQa+Nu/XDZCgBpx+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701327;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=UFZrl8Gqjh0zbtPSbe7UBmuFSffWEbXhNMJ/JvbVAN8=;
	b=mlLJ1k4vWjm2m3BtWYwnNUpf+QU05RRrnq1oSyJYeYXhBW1+l6c9Uwx8JgZamaJ2qY2t
	 yUGBve7Xa+14S/lglr0OG8+ZafEuxXbxn/XUrSsyAzPHJ19lT/WX9HyPOPx9vK1Rrrv9f
	 3EDjCAjClYNkQIhHa1VHMgut6AgfZSldMGpX/VF1oPPy+pjj9byWh6mPimwVS3iRWm5l5
	 ILiXHWcZn1bxehSont5vOymVxboRlYgJNYeRNFXpfYFNHb5ymB6arKLDpA9e+pceaGTRy
	 qAlp8iGBSSlk1UTzFSWwXlhJWCZ6ZIsJFE/ybS1N0eLvnhIu/jz4NRH36dvyxrZCcwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=temperror header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UM1TOyql;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=jYIQepxw;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781A4606EE8E
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 10:22:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 781A4606EE8E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UM1TOyql;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=jYIQepxw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793701325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UFZrl8Gqjh0zbtPSbe7UBmuFSffWEbXhNMJ/JvbVAN8=;
	b=UM1TOyqlocBaUTmEXF41uKr1iZWdgdewvuH7z3ARWlnjM6T6yaOjzqeK5tMA3Ib3NDzVzx
	eR6T7nuyxBqr1Oo9rNtfd9uoWoci4CHQq85MUmrrsDLhEk6oIHQL2C3i0ZeBUELJ5/5Xkl
	b9vbwgOP+W/JYZoqFD/6tvTQdD/FQps=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-f4_vi9msPdW1G59ehmBVNg-1; Tue, 03 Nov 2026 05:22:04 -0500
X-MC-Unique: f4_vi9msPdW1G59ehmBVNg-1
X-Mimecast-MFC-AGG-ID: f4_vi9msPdW1G59ehmBVNg_1793701323
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e011829easo2756277f8f.3
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 02:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793701323; x=1794306123; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UFZrl8Gqjh0zbtPSbe7UBmuFSffWEbXhNMJ/JvbVAN8=;
        b=jYIQepxw5jpnE/O/Q+sT96141cHnoCYT7ktbI905uuCcQiuHZvhQz9xQI5Q6XLYLWk
         ydgMp9p2bhDlP1OyE5F6q1FBjIakzIsFJOI5KLWlE4205bkD1SnjkgYWdj/e4zT5bWUK
         y57Zl+kTN8DsWMdfW54S4i/s1ix6OJCYsoEqezWZvoaKpdTcIwVNAKZwz7yYUhnbD7oX
         YvbrYFXulXIrz1+oD9xV15ZQ3Txp4/0g7HAetCE4y17op4DxJbTtXkRp1c0wpTADOwfH
         LLvfbxM35+I85+l6sUeZbr2GiJUs4PcYip0u2feXEbBCQUZSdBI9fSeCEHBlwfZi7CVn
         7UgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701323; x=1794306123;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UFZrl8Gqjh0zbtPSbe7UBmuFSffWEbXhNMJ/JvbVAN8=;
        b=cK7OpGBM+oVb4NdyIBdw0ePqlUAzHigzSD6kXZ+Ns+SZTWKy4TZwV76AZgjNKjd2JZ
         4hqXQIqfa7Az+vsHdt/YA5myTVVlI6soknSFV/T0l7ieq6gL3j7SLRxGMRP0/aCUhoFB
         ztp+B9bhUtQga7luYDzH/gSj4/AeZw1+2VOk8pZhUkhTqcr0lZ3tIQh/67ysvKJVdWu2
         izyFD60tM1k3n3Bh90HxRp/VzqGakjA0JCiteLB58sLwEObErqBB+tx8Dg15d5k4usqM
         TSTYxeFZ6r2jfrFHtr8Poy+olOilver97vpBL9VQMhRilQmNG+Wqrx+WXB0Z93jl46tw
         AQgA==
X-Forwarded-Encrypted: i=1; AKwUvBxsn1j1M53o+tzBlTh7KN6dFYcH5trFPwzweLex5HeC9vMu0edmD1WhtA+LamuKDLU9l4nAKvpA/+xI@vger.kernel.org
X-Gm-Message-State: APuU4Z+1RKk8KdCYiipHZqIToyFNRxVBP4yGSqGP4RUnUzCrC+wl3YLt
	PlOb1AuDislon3E7l2IIH43vARjOonDgt4nEDZE6bl81iTSDS8l2nJ1mDRxjeRcbj1WfZhuGD+/
	/xgxCXmqVM3JMg5ste4YOhXP6UZxNmjKr0PebXz3+lx8vk7fnosfcvsRSm5pHUGI=
X-Gm-Gg: AYBFou1Gxe34Momi5zqPhYtwkNO+Td3gLuX0rrruqskQKtwRvcag7Uj51dUWkSTOQm1
	LbHcpy6q0Wa5SNdurFeUW5CQUBBBL0S9qZiOc8kIkx8rKLfnGGUmpWrJ/bP0hocWds/K6l/aOXO
	2hlAYONspI9+7/1u0sUCqG+6zjke0ojMS+jyBoJBx3AmxDRTvIfmDUT9We/GmO+nmk7fqilB5zO
	GEW2YQ6l+wqvGV091kTnD958HXiHJSJT1spjPKTySMXa4GbdTkgvCAkMEO0IzJzvC6MwKmzr/+i
	5eqARv3ojBtRI4MiUqVgORaP8gxoyYfp2FbUv4CQmcWd0BpJBXa+ATZx9ugiPX/9otGbtLHVZUC
	JsLhpDmvOHU1HgaRAq/iM+hBj6Cc62v/qhE6GIQzfLk7y2EQ0mSy5hvr0YGRftRwSu/K4sMYOrJ
	Rj+q7171hnQ30BtMi/4hUxuRNo6BL28Z73VOrjbdqh8p0=
X-Received: by 2002:a05:600c:e41a:b0:4b2:406b:f3bd with SMTP id 5b1f17b1804b1-4b2406bf3d2mr59717605e9.23.1793701323087;
        Tue, 03 Nov 2026 02:22:03 -0800 (PST)
X-Received: by 2002:a05:600c:e41a:b0:4b2:406b:f3bd with SMTP id 5b1f17b1804b1-4b2406bf3d2mr59717075e9.23.1793701322587;
        Tue, 03 Nov 2026 02:22:02 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abe7700c3bsm293753565e9.0.2026.11.03.02.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 02:22:01 -0800 (PST)
Message-ID: <fc454b46-b66c-4a16-aa1c-3ea0c2e91d15@redhat.com>
Date: Tue, 3 Nov 2026 11:22:00 +0100
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
Subject: Re: [PATCH net v8 4/4] net/smc: bound the link failover cursor
 advance to the send buffer
To: netdev-bot+sashiko@kernel.org, hexlabsecurity@proton.me
Cc: sidraya@linux.ibm.com, kuba@kernel.org, mjambigi@linux.ibm.com,
 alibuda@linux.alibaba.com, davem@davemloft.net, edumazet@kernel.org,
 guangguan.wang@linux.alibaba.com, ubraun@linux.ibm.com, raspl@linux.ibm.com,
 linux-s390@vger.kernel.org, guwen@linux.alibaba.com,
 linux-kernel@vger.kernel.org, hidayath@linux.ibm.com, horms@kernel.org,
 wenjia@linux.ibm.com, tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, dust.li@linux.alibaba.com
References: <20261029-b4-disp-33001ace-v8-4-f9bb96e17827@proton.me>
 <179364387382.3131.13471253186660322977@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <179364387382.3131.13471253186660322977@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/2/26 19:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 (2) · Medium: 2 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The patch adds a cons.count < peer_rmbe_size gate to
>    smc_switch_cursor().
> - [Medium] The new bound in smc_switch_cursor(), diff <=
>    smc_curs_diff(len, &tx_curs_sent, &prep), is computed from a snapshot…
I think the above are the last 2 comments standing that need to be addressed,
(the high one in patch 1 is addressed by patch 2, the high one in patch 2 is
addressed by a separate patch).

Also patch 2 and 4 still lack review from the smc crew.

/P

