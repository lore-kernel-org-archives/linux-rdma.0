Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793870338;
	b=xXZ40dEscYcGCVzLuKQgAsHMl/Gqp0dt34FRljiWoqm68YbyZtFU0iu3JlGaIZA3HBrk
	 C32t/+2Mzs7EbmTG8DGoyDumjQYTUwIY7MBwY1crFg3QjsMWnGypIvBrkjr9ixsNeK1De
	 uLpzm1Xt0c3A3AlS/GAt2TBQvbwUtdHhUg22aPtlWmJY264RKUR3AuM9g+bpVmiCl+L0y
	 C57ervQBQ1pHB21QWCXf7cKCP192y9NKVL5OaPiaVGpTqhd1s1HPGFI2t6E70eydPbuRF
	 rvhr9JlJ+0jPRfYxYa0EXvs+ow9gxli7VKS8TXKKkQQFfl185uoEJkJ453lsXyCXOUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793870338;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=srnkzjaOG7BDN2bpeLlegl6CQK8Ql2ZPBafTe9mh37E=;
	b=XHa6YZq01SBpAs8FwiQiOyrY+wI2eWCPw4edRVsk83HZKZxIwDkvCFVzPM5CXrnhAazo
	 bsgNA1EyHmoiTeReOpNzsFsncv3i875S7s+it6dq4ECqPPylkDQ/T33EKX2Qj1nkUBQHq
	 ZRVEVVv4ybMreBa1yKjd1vS/msM7wEMNfSSYOORtYVNHebUF1mUR0MIT8lW1z4LuejQzm
	 s/VW187pAq/21rmMy7czhpem/CqIzhC5JL9r9w/PyQc9SIYxHmc0xRXbreqVELh/9L9Jn
	 bCpnEVBxJMwmYauVRqYNzCWI1gd9q9O9fhgVH+RfPzkFTeAaWun29+pCJ9LWo7nWuLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BzJo6rGM;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qfaIZpA+;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA62D606A326
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 09:18:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA62D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BzJo6rGM;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qfaIZpA+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793870336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=srnkzjaOG7BDN2bpeLlegl6CQK8Ql2ZPBafTe9mh37E=;
	b=BzJo6rGMIPyByDDkxPuYk4ik9mnbT2Fi0SbPNb53VlmlVGR4o+LMk9e7aKqFkrCMJAxKCv
	LC6Rno1V9d7yTkCYY2uSSvvQtMc7QXwb+WDrKemW65Gx2l1nlzq8IjWPNj0xhgUcXj8PLR
	90VXsebeXZsCwmWzF8pnPz8OjNVsa3I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-4Mt7xY3LMHiV5xVq9N08ug-1; Thu, 05 Nov 2026 04:18:55 -0500
X-MC-Unique: 4Mt7xY3LMHiV5xVq9N08ug-1
X-Mimecast-MFC-AGG-ID: 4Mt7xY3LMHiV5xVq9N08ug_1793870334
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-49205554e17so51449f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 01:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793870334; x=1794475134; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=srnkzjaOG7BDN2bpeLlegl6CQK8Ql2ZPBafTe9mh37E=;
        b=qfaIZpA+7xLqCsQxWZ5qFqIpLat51mVHlpsSoIu1/8YdTOXVzCw9LkgJSm2Bop4wIs
         5EYpPAm2moMyqlfNypDPKR1GpJlFkP9gb45622Sui5Z+yUQsbCEZ/FFdkIJqMLoNLBlr
         jDAfaZam5XmtdnGRVnrDJKweTmTAuIxGIB15cRU8lnoxwJkHcAtEzN9Zaupy/phsoWz6
         d+KgHwSXXhvTiqDwBnm1ikelKx15V/bsA2kjgUMvMYhClcX4JnpHQ1N9vvu/p12PV8qL
         eljcWU8JmC0ZbcryXTczuyYKkaLeUvBFXau505mTc4HoKpxvyT+pkvEvz+5lnFK6I5sW
         6tFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793870334; x=1794475134;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=srnkzjaOG7BDN2bpeLlegl6CQK8Ql2ZPBafTe9mh37E=;
        b=fLtCKn73ay3Nwe/kkz3uBFKXVdeOJeBt+HcO7GnxAitRYrTV3DeMdRScDO+44AgrTo
         JtdSQZNEOVI5tVXu+zizTekoDWE1GJoBynqPv6ltCwUtdxn6Xvzblz1XBMmQCIJn29mF
         o4HePE7URFmZWJn+0F3Ndgwi0RSMP5uxTGERA2eCv1H3c5VSBnKMwEbblpzBQznsy0Ha
         fQybRPnOwvmOsAes28/d1cddQDRH7eUL9Fcw/fgsaMNOQl+K5dfXIJqC8daUgsqB5na9
         KyNsThiTowmXfbcfiMvqhztmnEQd2WlKe73qp8vJw6H3Pmgzuabu6o4VJzW7Qp4eYlNu
         s2Cg==
X-Forwarded-Encrypted: i=1; AKwUvBxnwjqhs1p1nBg4DfnIXKUyrJ7xwyB7W5YBCQvL8vacrVIT/Fth6cYwrlee/tc5hXEEMwtQrvXnYLX7@vger.kernel.org
X-Gm-Message-State: APuU4Z/je0kg4AtAHA4D4DDtffN0kgsUZfz2mPVwUyYGggYM+f8zhFUH
	4jrMaZ162i0JlomyH9AVMxchZiHatTLjbg+XNERvDOVtjtqVppvrEbGaZ1hsdFAAjrkM2xmuBHh
	H9SwMU7LnEt5rYrMfHGUgCBIqwfsCfns9OH30Rnc+QhCQa8XH3yDyeZ3m1BuTIcc=
X-Gm-Gg: AYBFou1/N7+C20rKl1W2c3XXsrSBhY1BeZbeSFoizedOlQZe6/wkTCM9dzSImAHwN6P
	1LArUwrhGtdc+1rhQY6BRR6u3mgK18RjteLD+5/0QYZ24FGF8flzAaLeG+KZjus2dnMD97XJ1pO
	zCgCrUyiq1IJu7Utx6BZJn/HyQqBdE41hnbbVYXgoq0OMKKyJbihEsm+2nbHxh+ppfctLZA7Ik0
	TDpLSNC93pLqNNqO4GTtRpmer+/1eTCLFoSMlaoeaXum2if3tB3jLjroIaRs6rQboW4jwH+BELE
	YmULC5cxa7Q1d4HAIYR5J2SJmN8US2N4+JfaEad/qxLj1vY0BXR6wCoG//nvcuemdayKEEWm2JX
	iztghj26jkREJ1L+D0ob88JBzPOkZw4Hl2EHZREh8qIM0wGeTEYSDt4EmjX7Y7w5rpMHphIx5zU
	zMwXC+Bb1qsLzZJo7mdK9Nf6a6pMPeOSGrnU9f6moA0nY=
X-Received: by 2002:a05:6000:2904:b0:48d:b75d:30f6 with SMTP id ffacd0b85a97d-48e6e308d92mr41690808f8f.35.1793870334127;
        Thu, 05 Nov 2026 01:18:54 -0800 (PST)
X-Received: by 2002:a05:6000:2904:b0:48d:b75d:30f6 with SMTP id ffacd0b85a97d-48e6e308d92mr41690741f8f.35.1793870333456;
        Thu, 05 Nov 2026 01:18:53 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea18104bsm9317500f8f.6.2026.11.05.01.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:18:52 -0800 (PST)
Message-ID: <deb337e3-f7aa-447b-8227-fca872b8cbd7@redhat.com>
Date: Thu, 5 Nov 2026 10:18:51 +0100
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
Subject: Re: [PATCH net] net/mlx5e: TC, Fix double free of branch in failure
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
 Roi Dayan <roid@nvidia.com>,
 "open list:MELLANOX ETHERNET DRIVER (mlx5e)" <netdev@vger.kernel.org>,
 "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20261028145805.54595-3-fourier.thomas@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261028145805.54595-3-fourier.thomas@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 15:57, Thomas Fourier wrote:
> When allocating the false branch fails in parse_branch_ctrl(), the
> already allocated true branch is freed but attr->branch_true is left
> pointing to it. The caller parse_tc_actions() fails the flow, and
> free_flow_post_acts(), mlx5_free_flow_attr_actions() which calls again
> free_branch_attr() on attr->branch_true.
> 
> Clear the pointer after freeing it.
> 
> This bug is theoretical and was compile tested only.
> 
> Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Given the lack of H/W testing I would appreciate an explicit ack
from the mlx crew.

Thanks,

Paolo

