Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED63415F27
	for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 11:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786620823; cv=none; b=JDV9/eVH3Nz6+gyuwxpXKtPWa86WWg3CN8GFGLjDZoG/37f20tNehyZSSygk7LWBNZGsXrFunR7N2fYnMR8e2li8HSsEtI4RHA9u2AuwMvJpyFvHDc5C6fA8EJgQNy43/ioiDjs0KIjViezHhs65+O/qUlcJ5Wu9dB+JO3s0keE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786620823; c=relaxed/simple;
	bh=mIMg3GpGnjxCOF+x0X883SsbbzLGZeniRtVjG86VZ6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kKvLudI9Obm+8yWU8+WK1yhp0Qo3ysYFocUFJWoSXGikVhPXqdAXj+DbmXryim1RYVJRTdOLEYPIp6FqpPKCremN1TrnOvWhLAEuwbHEgw2KInPE59r36K7V7YE9HqiaTF+WoxyD66uh1Ps13ZavlHjMqRduZwcYv7kgEXvukLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SC3f+7Kx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n2dirSnU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SC3f+7Kx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n2dirSnU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786620820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J2FrrsRU5V1HJtH9l/0Gbv9BbbcK3/MMcp3Hv+XyxFk=;
	b=SC3f+7KxhIiwzOKgrfOUsa7jFqqXcCjeX6WO/0tXBcB0M0IonSlvj5MLKkMt6lGdEngYF0
	rnGJ15QZ4j89q/0Ld8kXhas5RWYhH/dSpwbXbi8UgT0j/BkdOejoW1h5+Hy2WWk3Ky6c1E
	QfcRbx6s2stRbCSF4Wg6WtJkUSDPDDo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-qLOU1rDTN7-kUasXjPUR7Q-1; Thu, 13 Aug 2026 07:33:39 -0400
X-MC-Unique: qLOU1rDTN7-kUasXjPUR7Q-1
X-Mimecast-MFC-AGG-ID: qLOU1rDTN7-kUasXjPUR7Q_1786620818
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48000d75326so483671f8f.2
        for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 04:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786620818; x=1787225618; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J2FrrsRU5V1HJtH9l/0Gbv9BbbcK3/MMcp3Hv+XyxFk=;
        b=n2dirSnUQoZRAqVWgErMaBqjxhlekJ4yLzIlPX5fClwg63uwZvGRebHGAkwNnAbRyq
         nwms+xp3O5rkBQwira3moxEHO49qe+rO2rZHKwkHhI4OO549YAGUKeaspJctKKXFAwmI
         PfHirYm3QAXVTTSy8VN+i8qbUYVFh0ApiZsMtFUwmGpJsvN9WgcWTBhvL6C8zOG08W3X
         xjFVgduzlXj84aFCIes/XcYZaHCb1GoorBF3bv1ijDjhzG7Z59AmgOETVy7ZRfy0pj3N
         xfx0fQ3fKL4uGoJPVXYc4mm+5ji8eqVhdiYjv2thqmVFJnadNxlQbJpDj4A6MMYAgIvs
         aO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786620818; x=1787225618;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J2FrrsRU5V1HJtH9l/0Gbv9BbbcK3/MMcp3Hv+XyxFk=;
        b=Ow/4Yo9ubGGfbfCRWLXQTnCBjZaUTOYbpf6GBGFvE4FSEjR47SbJEP8vkSGflvqGy+
         XI75oDCYhLVJBaWmewijD8XhAsUntVLrMr+phWllehAm4ROzksuPymrMklQweoItLBt+
         rBwltCotVN/DC5gR26S+6XhVGpeh1cEhN8eGmKMnQIbb7XhKf+pxPsYNMzCF1OkKd0zd
         r6WcEV2j2OIn8gK5gjqiE9/mKB4ghn+tQUONixd7OvY5DQzmWyFZwt+8d8xeMTfNLS50
         VkshIPfqmkFzq37lcK6dBW9X/TMAWwhleQ2z+VWxaRV6nfUOm03lHvoFA/PSMLwPUfp6
         RYMg==
X-Forwarded-Encrypted: i=1; AHgh+Ro3fNB4/ViD6CKOJwjYL0G6tlCh4f9DY+vj+/p9Pgwo82RviBZwVc5oUFzfAzAOw/p/2QAoYTjS49Ui@vger.kernel.org
X-Gm-Message-State: AOJu0YytQvclYVoyvzfLF0E1nOpYCxIS2/UjX1iEK9SDeqMazkkQxwnI
	CM7ODQVEsue3KUfkLqepi2Ok5LNnbkzwzyYdPjgH5VtMX3cUsoa9zZoxo015ayVtqocYySw0XFB
	+sQLmZF4J3C8Vo6OXf4Qf8B1+A92Aqq/3aO7sIiz9z31DekX2r4AUvg4gjKIfJU8=
X-Gm-Gg: AR+sD13eU8Sk67K7JvdwLgS8qSpoy8b7NFAhm/x4N8rDRl8JiTz3zcPARX23yQuEPIj
	x07eq36Uzh3HmUTBKu6VxoPun/lWVrFE/FUeXMPOCpiCH7Uu4oH92RBqN9tZ5HnsOP2yp22u6gu
	zcBSbe46pguPpVO0h//NyNBkkrgJzbpAxxKTqVQhdFFy1V/3l/7yvfmHUU69sw9zDJecFGicnP6
	wsmEyj0UUOh3z0dWE9pu/drbVoZBAPRBSLCBtEeNt9BR3yIBIxUcxVGCLUyQUmAmDuBUykq4qX3
	l7ofyvf0JEeYXEBYmOVsZDvTYMqE8EJ3n3187yzeb4WPTtaUlhTzB+DcIeTHqJU9kvpNq16Asi3
	Rg76JHUoWY8zjNkj/1z4gqJxGBUMf/UZ59y/8swS19s5qxm+WwpMcJcdpVxh9CRx5/BbtM1cKLk
	c=
X-Received: by 2002:a05:6000:29c3:b0:481:5048:1b78 with SMTP id ffacd0b85a97d-48159ca613bmr5523971f8f.5.1786620817752;
        Thu, 13 Aug 2026 04:33:37 -0700 (PDT)
X-Received: by 2002:a05:6000:29c3:b0:481:5048:1b78 with SMTP id ffacd0b85a97d-48159ca613bmr5523905f8f.5.1786620817287;
        Thu, 13 Aug 2026 04:33:37 -0700 (PDT)
Received: from [192.168.188.103] (ip239-44-231-195.pool-bba.aruba.it. [195.231.44.239])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af441sm6497140f8f.22.2026.08.13.04.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 04:33:36 -0700 (PDT)
Message-ID: <4659a101-904b-43a7-acc0-012020887088@redhat.com>
Date: Thu, 13 Aug 2026 13:33:34 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5: rsc_dump and hv_vhca return NULL on
 create error
To: Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Eran Ben Elisha <eranbe@nvidia.com>, Feng Liu <feliu@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Michael Guralnik <michaelgur@nvidia.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
References: <20260811061637.3195320-1-tariqt@nvidia.com>
 <20260813092655.GB196815@horms.kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260813092655.GB196815@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/26 11:26 AM, Simon Horman wrote:
>> @@ -63,9 +63,9 @@ static inline void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca)
>>  {
>>  }
>>  
>> -static inline int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
>> +static inline void mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
>>  {
>> -	return 0;
>> +	return;
>>  }
> 
> The AI-generated review on netdev-ai [1] points out that the
> return; line is unnecessary and inconsistent with surrounding code.

I'll remove the line when I'll apply the patch

/P

