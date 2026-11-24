Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795516138;
	b=mFp97mWdm6fTpqgXzOZYv+DzYIHmff30inMHeYSdgEkwFF+dNpVt8E4skS3SUEcZQv5Y
	 JxKXI8WJtP9hEFOnBbF4D0tk06oBST4B4f4z6XngygwjD47QWb+NltT1RETUj+58379Qv
	 BurWB2argzZ8mCcsfhqiIAH1oQwXEJuEq/6Rd6fuIbva5eJkNqcLsAydwFA/zJT5jJbQ7
	 /BhZHMZmbhR217K9aEsWFqur8rwzYD+TKPysuzS3rvcoMxhgfCZBFIGcY0DJqVmssxPPs
	 2LzADy15KzijOPWFloljZsRF5qkZnurVEwblynSn4nDJo3bSHuPiNLoE5g8pXYNxzuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795516138;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YvVos/w2bO5cHdAxwgGtEk1DQ0vvOaudIAzQaAlwIIk=;
	b=4M1A4uqeC8EfoHn6XMpytzYcN14tKARc3YrNxwT3r5xSmom8ouJr4ovgjP5EHzorCUxx
	 PH6tDROEQ27q9rr1XatV7ukLYRylSGNYeg92EyoykJbZicvQnKbNXZyVnK31TWWX/cqc4
	 73xmyYkJIzrcvWfv+5rF4Y1YnIRpFkQgfPO0sflGV4SzXrck9QiXu699v925rbRtqWSmI
	 g4jXMda9x9AjvtJ+vjKUc06Q1EnqzdH7ED2SRxn5jW5yofmu6k7szRnleG12pxJoYm587
	 C6gXpLqbj8baZ9cpb5aKYHp0KI7zrZfBy/J2VCimzXiXoo6SrRXKXMApxpMjUa4R7hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a+tMchAc;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YI2xnQ12;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279C8606A327
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 10:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 279C8606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a+tMchAc;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YI2xnQ12
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795516137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YvVos/w2bO5cHdAxwgGtEk1DQ0vvOaudIAzQaAlwIIk=;
	b=a+tMchAcclDRfjHXzTQxN1cpU+E8Z5aV0bQ4YOAK7SssU/K5pvPenenr/f5qxvUcNddBSt
	vyXMxdPCFdquRRNl7kF95TMyw7ev9U1epEsDOd19KYg8jseQIHVroGMCQ/Pl9JxwgtiZFc
	Q7FHoLD5UayZfcB3Cfkkg7o2eVfG5Ag=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-z7PmiVspPpOez0sSKj3uNA-1; Tue, 24 Nov 2026 10:28:54 +0000
X-MC-Unique: z7PmiVspPpOez0sSKj3uNA-1
X-Mimecast-MFC-AGG-ID: z7PmiVspPpOez0sSKj3uNA_1795516133
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-49034831bb3so2671645f8f.1
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 02:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795516133; x=1796120933; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YvVos/w2bO5cHdAxwgGtEk1DQ0vvOaudIAzQaAlwIIk=;
        b=YI2xnQ12auOqt+7nCCBXb8APJLJPOGIevpGDrGSOfQPMA4zXIiZNYtu8tJkmV1j9GU
         4tavdjFfV9wckOv4540cxESkynrrdrzIMI5ShDWMZbi06jSiM7qx9wRobcuAIECAuYjv
         aHTBHc7um6S58scG9vhv03QLrENSGYWjtWj+6C8OmBvWQ7Aby7HqKKVstLoaauZFkmOG
         AyzIVZNp7OEmJP18HsEeG/B3kWmY6UHMgmeyyZhfqXkjUgQdl/7HeSnL0RIIgLCuaZ13
         WuGBqnP/BjAz3Aza7btOoc+IhNJo6d7WbIkBPhcACRaTdNio/E0ZQlxBo0jPQHj+Gj2C
         z7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795516133; x=1796120933;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YvVos/w2bO5cHdAxwgGtEk1DQ0vvOaudIAzQaAlwIIk=;
        b=0x6PyfvGfvJK+6aYVic2Mo2fMc0uLPbwWQ8k7JxidTnni4NKT4TDRa8I4BLOyQ/ZOF
         Jd2nap8o3+Ev4oRqDzz7ubI2l+rrudHy2xs8ZlkJuaVns0eNu6AXntCA5F3FoQ5t6p7+
         IBZ+dJyIboLt61fbNaR8NJ2Rv49HNFAGd2b1y64PtgkmoHJPQ94RdJwWy5/D7TU2NrFk
         qetWzXtlT3yaM6Ncxri5apBpC+sQWbNie9hO5CzbILOwuJS9s0eLpahTX7Zgq039utk0
         NLWjMj3//Zncez4SBSMupbxEKV4fi9RMo6wYrdY5it2QpxcSnafNKISKMNgMyPWJVI2D
         DQaQ==
X-Forwarded-Encrypted: i=1; AL+hErEdCMzxNu6vhdWPAI16xW/6JdqLnD1yoVTFsMlJUZPPjX5zNPL4fAsi6bTEu63IllCSgBuxEKpBthge@vger.kernel.org
X-Gm-Message-State: APuU4Z8jjUpkv5SSegJ+uKo5TLN9MieP6keVnvBKAloOSkHsblg1407W
	IYZ3lP2W9f80SSxE4rJPBOiVxv3YMO9TvGxi2WokClVhsofS/f91Fz4VhQ5oB094zh2KaavwzMy
	2TxlrBMMCaBOvZ/ZN2Km/WqT4gCJsgZpVXr5txDQ7BK8cgNFkGk3j0oUG9GYwkXI=
X-Gm-Gg: AZFdTZd9YbMvRNupRR6t1j0JI4Jlv9eSa/5bblCt2BcUtwoHPwblyCT2mvI74l+qLa+
	gqgs/9aGGN48IVRTOQuovJEZWLkyGtgX5j+v9CcCrMQfDJL1Rje/Sro1AnwUytUCK8GQ/XZwMSW
	kEWXIQYqoucp2FHAPfBuO3tXNFH8EFpd+/D3D9p1Esc+lqaNxYfvo6JNTfTO/i+89Opmh5AeXQU
	SuGgyaGe2LwTWmtnH1TT24WvsqpNDHpTmjsTUzMX5Y/8LELfrxBa6NeQRf4VUqTLNpau5FAVCzI
	HGpmtZeHwlaPQSArfnXLdmyb464DIJFKpn29jU1QW+aHorxzSdghApcw2Yic5vX0FiBdmKQxnFX
	84yiPRE71RbpX+05Jt6ka9Hl7SOJ8Gujtu2wwgApUsmyC2cDJA+cassgWg3DexGoJLZ0G3THtLK
	Zuh30tcZ/qfiGCH6OMmm0kuCV53sgcJld6GGAD2YNGlwv7
X-Received: by 2002:a05:6000:490f:b0:492:a72:9303 with SMTP id ffacd0b85a97d-4abb47b242fmr27035654f8f.22.1795516133361;
        Tue, 24 Nov 2026 02:28:53 -0800 (PST)
X-Received: by 2002:a05:6000:490f:b0:492:a72:9303 with SMTP id ffacd0b85a97d-4abb47b242fmr27035607f8f.22.1795516133023;
        Tue, 24 Nov 2026 02:28:53 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d55sm27405743f8f.5.2026.11.24.02.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 02:28:52 -0800 (PST)
Message-ID: <ca4c7d17-681a-4d28-a4a4-eea6f123fd9d@redhat.com>
Date: Tue, 24 Nov 2026 11:28:51 +0100
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
Subject: Re: [pull-request] mlx5-next updates 2026-11-19
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Chris Mi <cmi@nvidia.com>, Edward Srouji <edwards@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
 Mark Bloch <mbloch@nvidia.com>, Michael Gur <michaelgur@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Parav Pandit <parav@nvidia.com>,
 Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drori <shayd@nvidia.com>, Yishai Hadas <yishaih@mellanox.com>
References: <20261119121123.2211400-1-tariqt@nvidia.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261119121123.2211400-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 13:11, Tariq Toukan wrote:
> The following pull-request contains common mlx5 updates
> for your *net-next* tree.
> Please pull and let me know of any problem.
Next time please co-post the whole patches with the PR, so that the series
can go though clashiko.

I manually run my local instance on this PR, and it looks sane, but this is
really a one-off thing.

/P

