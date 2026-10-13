Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929354EE85F
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891187; cv=none; b=b8kOkpPs3EgQZOdPxIEQAe8b+aYqSDiZ5bYymCH4b73L77FJdVjfq3Vqb48d92SPB5zSHMF0UzSVVVhL+tGRo1Rrs8CGCOAUg9SME9NiQWh7tKyTzuGwWLjrbpmS8few4qUisqrxyyWCBqyy5NuKzMxuy3Fjjwhr0L+nCQCV0PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891187; c=relaxed/simple;
	bh=Dyt5vMpr0stZOUUiRBwCWhlSpsziyIQGipCkD2GiSEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZHqZyEbdNPFAbP/bvRafCAEnENhEhoa/jmjOUVnjPIzdltepcxK1pIlJ/egC4E31hDRL5PB6GdCWGlJ9Na8lOAYJ+yJ9m+BP0nLK7+8SKdRDNKqZJJaPGDHVp6Zo/snPKgHYrOiFlu9b+ZE62hl+QUUqWN3c1PrVpYDJMdOKfMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hwsGlsai; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahk/3uNF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hwsGlsai";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahk/3uNF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791891185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BJZS7SNjtTyCzYl0fCzkLKDPQ9VWav3NaJT+Z7d7V7w=;
	b=hwsGlsait2xAMV7zu+26hqpL8zkZBANJDcyJ3NfiBiu5qVbS7CZw7YQF6WlVeNXoBgRwLU
	AaqKRJdYkdg5UdAGW5c1g4z7XUElYUV6GfV/APRppNZuFOy86Vln7nBhLMeAkpAtACXTfR
	i8yRrlp8LuqRRj1AHoUefpQW4koJj0k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-m9K3SAWgMdq07Hi6C_vdzA-1; Tue, 13 Oct 2026 11:33:04 +0000
X-MC-Unique: m9K3SAWgMdq07Hi6C_vdzA-1
X-Mimecast-MFC-AGG-ID: m9K3SAWgMdq07Hi6C_vdzA_1791891183
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48af5a07314so1711164f8f.2
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 04:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791891183; x=1792495983; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BJZS7SNjtTyCzYl0fCzkLKDPQ9VWav3NaJT+Z7d7V7w=;
        b=ahk/3uNF9u3E0JJi2UXIlgtCAE1uPc+yqbKm0TfXlKW4BjodHwHFGpQC3+Hl7e7E/k
         ZYJlacamLHMFxfiF2FHvtyuZjeKNBJke0jnWER3gYRHjwIFnCl1jOe6KkdxD72vY2cg9
         N/6D23V9NCESfyTZz9ad9FSwC+S7gNfuNQ1J0c8xO1a73mfNNvWSgoMQIlykaXlHYn/C
         rYl4lqdUVOv0BKxSR6q1CERNkbo7QV3LoMR8o+7U5+vElWqldLnV59evV9zSgqNnYqzH
         b0Mr/I1E8p+pehIjMrKQuoDh0hpkCCHFLpEwwThAqH1xJq+DvxxEmYoDJGzwq49TzpC1
         M/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791891183; x=1792495983;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BJZS7SNjtTyCzYl0fCzkLKDPQ9VWav3NaJT+Z7d7V7w=;
        b=HpOX8+Q0vT60DAvK8V35oR8ZBY4GjBuD5HoA75l7qewWfvTrq+rJa+hCdLEAkXLEFh
         6Pvzq0wSz40h5d/Btf0yjJ5ffJLcF5EknPNC8M+gOtP/1FjGAtPO8UutzW+RtWIj6LVK
         6ZnRwMA0NKdJ8HWeRAuNTYoQStRBZolnHrypENckgJMgiXEjJUK2Cat+UoksjLPuEEPz
         W3OGxXJW8CO3qEiiGw76Ybsjgbv7QmUaDV472ZLpHG9YIxFaY1vQ1Qik2orwhcU9oqlz
         Y2Yg2PR/SHFGpFddhhp/5bUW0YBYgw647WY2vU6Y9cV6yAQwZSy8bYHBFOhWSAGlyQFX
         qg+g==
X-Forwarded-Encrypted: i=1; AKwUvBxSO0jXa5C0uJVlWiEfLxspElVJIlZ/qyZUVeTai3RriELjRj0dzUmDccnDmLLRDscEoe+GTHhgDz/W@vger.kernel.org
X-Gm-Message-State: AFq9FYKaIwV3lqmq2yzNklLOS9LBmyCKbPO45eBJyV8DeH6e551V8T5E
	lA9aCzzyDYdZjLy5jVUzKIWfVapyLK95b/wyEscXBgsbxKJwiQ5686ZNuMJU5RlpwFrSqiSuD66
	le11NXBzPfku2gy/fhz9TmyjZzAgaDnGo9LG1NdBqZcOd8AZNScLMlsds4wbFyQk=
X-Gm-Gg: AYBFou0Uhd4RN9s0T/pOizh7b1Z4Lsxee/UjZTghkFIprQ+J3tGUNhHAub5QpLb1Pdm
	kfaQVriZM9zMkYtxozlXIPs1z+yg4iepNu/v2Le51pRsheCCV7KQEzVaXVULA0uGT5iOdbw+0LU
	EXuaNuW7SLvd8H1Ej4fWAnDr3VmsUT6rT8N/QtW2iYcG+ScZ55auKAArfCO6ukOBy+BjIEuf7pf
	ubkEAwXUmLn4j32xlNC8/Y2uPoRnLa09/DsQjdUJ0Y0lNUAwt+UAvqCu7IXt2d0Ca6wb688Uvku
	OWinK1JtF5HGmXHKY5I1X6MlObgFjnLkIrE6MUKgFcBNya7m3ELIum1WAFu/UzveADcqK8ulj9v
	3mrRuQ++EVZvzv1Nh57M/+mQ2qvYqPmvsnbLaVTX0QpUoMTB5wSP7qwfNDShUatOmZVksibe2HQ
	==
X-Received: by 2002:a05:600c:8518:b0:49f:cbf3:551c with SMTP id 5b1f17b1804b1-4a18e4a8ca6mr221725415e9.12.1791891183031;
        Tue, 13 Oct 2026 04:33:03 -0700 (PDT)
X-Received: by 2002:a05:600c:8518:b0:49f:cbf3:551c with SMTP id 5b1f17b1804b1-4a18e4a8ca6mr221724855e9.12.1791891182594;
        Tue, 13 Oct 2026 04:33:02 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a19f318c31sm133053675e9.3.2026.10.13.04.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 04:33:02 -0700 (PDT)
Message-ID: <4758dc6b-001c-4106-9258-f7d902fb01c7@redhat.com>
Date: Tue, 13 Oct 2026 13:33:00 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2] net/mlx5: Lag, reset vport speed on MPESW teardown
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
References: <20261006112415.259157-1-tariqt@nvidia.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261006112415.259157-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/6/26 13:24, Tariq Toukan wrote:
> From: Or Har-Toov <ohartoov@nvidia.com>
> 
> mlx5_lag_disable_mpesw() never called mlx5_lag_reset_vports_speed(),
> unlike regular LAG teardown in mlx5_do_bond(), leaving stale cached and
> FW-configured speeds after MPESW is torn down.
> 
> Call it from mlx5_lag_disable_mpesw() as well, so the reset is paired
> with mlx5_lag_set_vports_agg_speed() on the MPESW path too.
> 
> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
The AI reported feedback looks like a pre-existing problem with
mlx5_lag_reset_vports_speed(), but AFAICS it makes also the fix
(partially) ineffective. I think this late in the cycle it's
preferable to avoid partial fixes.

/P

