Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4213A3E92B7
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 09:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784281662; cv=none; b=jqGSpZxN9u9EWHTVX+3qT7fMvcATwHy5hfuJpOMD0lN2GhIu1xGSPl71pmzHlsMaOYadnsge6WpTST8/kIAzoPX4jwuCskVxqWTs/COvhag7ryh3XZ3ndjOMBYORXc3FFWqZl7yKT8+nS94ROawjwajQvyEA9lIwGGM9HIDVH+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784281662; c=relaxed/simple;
	bh=SA1xMJwP+nvYyGy44ETv4g2iY2c92GT627gCU7j/mvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sEPiRV5piRDyr7gH99HFqDHaY3pRGNAGKujzpMLKewTxxbRtNQPRgnjWUHBr89VNDE4gGOfOFTiNStR10ZPH0Rc9TRAQHQ3JoZSw8IvyW7gMvivrW2PgwjMnxAbQlXPsFWo7ddIVeRYkXSTawpPgp5ztXoajjGM7Gxs2mTgsgeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UU7k55Gb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=itb+PeJS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UU7k55Gb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="itb+PeJS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784281658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9UfOzvi3ApW9raJzhRo6rILl0ALfG4yRcSmV5u5K+uI=;
	b=UU7k55GbCcSkwBq5uFBCnKdeGSmiqvR6lew60/LXquZdfA59qwPQRi8PGY2l2etTvNMjbY
	y2akSSbghmrEn8yn177ChV45PfTFAGpjHrwVktKugfeqKqt+JZn/EnZdRT4XgcxdiNvAJ5
	Aevjkb/xrUqR9au4dQ1C9s5rfy2NqK8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-02-JOSjXMlSUdWUWc-rKig-1; Fri, 17 Jul 2026 05:47:36 -0400
X-MC-Unique: 02-JOSjXMlSUdWUWc-rKig-1
X-Mimecast-MFC-AGG-ID: 02-JOSjXMlSUdWUWc-rKig_1784281656
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4729d2a64efso817210f8f.0
        for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 02:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784281655; x=1784886455; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9UfOzvi3ApW9raJzhRo6rILl0ALfG4yRcSmV5u5K+uI=;
        b=itb+PeJSzc6EZjwvg/qhcMyQ0i1CtsU6aXAZNGj1z5fB6qiMdxz8y893yYzTxgokoL
         g9OMYcRFMNCnsyVTTXVHRSsf254/J1JW1uFVGyRpZ9KQnH+abAiVfQZhcrtWhm/cipfX
         sSYzdUMEmzxM32TXpUu10CcGBmpTGYbPbAvG0I0DL2ZO7pOoIVbhsMfsgm5qngFxPhea
         4AFddnfu1QW5A7CgsgdZcOMXyyt6ORY+Ie7g0qk8ZsEFP1+pmAjzzppa/YRp2oPBa9DF
         +U4Dwigs19DXAtIRRoidbdQSBK1JBoPamZ3EO9xNJdyvh4TiZ4XFWKqLbInVSDj3aEjw
         rQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784281655; x=1784886455;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9UfOzvi3ApW9raJzhRo6rILl0ALfG4yRcSmV5u5K+uI=;
        b=FT7K1fZ5TvrtiOTlj0Pds6DfyhyipP81SJX7dVy96GicEPNnHh6fJi+TWXWts5u0up
         9RTDpSa5SCj/20TYoPWjUMYFlaKnYhYCJUyMPyXx88eq4x/ZAg7YUJm88YPT2nuyRgs8
         XLDqjUm6bc8Q2cHvh3CVDDXocFDc6OVnKJGMVDxqdY0neGSNKdNYl3FRO3Z0d4e1rFkr
         71ur1e8FSyTtsULDpbc78C+WtXhvMtQx4x6V3CG+P+XZRWK/G2mTedh7Yy9wgxBH6y0A
         r4952Y4g4gRYBRNb7iMvcTh9DNgJTKCPor0wO2slbgUBPwx7+R5UzTMyv/PRFMJqB6HE
         lFKA==
X-Forwarded-Encrypted: i=1; AHgh+Rrky+d8a/ChCCiGmK3WO8gLIwtij+kI9kAzB+CQOLIv4ofFxeuzx+VyQzCivbuQn2k7XzNDb1uRnqt5@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr2a20CAyp58K9K/VKgT0zJHQzQ8rg36c/duo46OVqc4t/4pr5
	uSYmXqWJEVLt8uLBUc7+Fd4EiqInqjj9uywUN73RDzRgxAMHbn7PBlSTcGE/m7VazmRfv0QPlHw
	I3QNMhCnQhmvYjkmB8sNSkHZMVXccb9hW41/RrNrnxPEtU+lX6R91ij8v+0HGvmQ=
X-Gm-Gg: AfdE7cnqaL8fq/9c5hHzQalyP3ZXO+PA434D6ZVp3Zez/VrjhQZtM/aEvV4gQf2zHee
	WF2Ulq9Dk4qHJl6LbLK6jG8JF/Apd2Oc3fVemBuYjmNNDkzj46QhwDTw7rYzectGfsCLO/+smmg
	bFCn45ic9NEA/ZDMkCCXEvzRGIVKqJefyAA7AucXTHAtWOj5LBde0811+PPCBlO0LJQoNfyKj7Q
	izHcU/NFkEgR5o4Ljiy1wOxF5X1NmSfzs2402ASTK93H2ni3VXGCWATiUw3F6NhjQ8PVsNUwBKm
	8/Z8zhJPVfljqQf368D1gQVfYH+UiXQ5lxhhDPzg5PWIcxQSpRpMXpxHeYJH338YaZtNjyN/5Tv
	tmd0TDI8MHoLcqxsdwgeO+5ttveZ5tExYAPtGgiP0O1JVDjuOKetFqpwMe9sc8IcR8aWsei9jkH
	qLyA==
X-Received: by 2002:a05:600c:35d1:b0:495:3a52:71b1 with SMTP id 5b1f17b1804b1-4954aa1a34fmr16278975e9.5.1784281655572;
        Fri, 17 Jul 2026 02:47:35 -0700 (PDT)
X-Received: by 2002:a05:600c:35d1:b0:495:3a52:71b1 with SMTP id 5b1f17b1804b1-4954aa1a34fmr16278655e9.5.1784281655105;
        Fri, 17 Jul 2026 02:47:35 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2edbe4sm35888375e9.12.2026.07.17.02.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 02:47:34 -0700 (PDT)
Message-ID: <62b9c471-e6a0-472b-a549-81128cb9a8ac@redhat.com>
Date: Fri, 17 Jul 2026 11:47:33 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5: free mlx5_st_idx_data on final dealloc
To: Leon Romanovsky <leon@kernel.org>
Cc: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Saeed Mahameed Michael <saeedm@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Michael Guralnik <michaelgur@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260702222507.1234467-1-zhipingz@meta.com>
 <9e4e455b-c10b-447e-9fe6-80672f26fd8a@redhat.com>
 <20260713080816.GA327832@unreal>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260713080816.GA327832@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/13/26 10:08 AM, Leon Romanovsky wrote:
> On Fri, Jul 10, 2026 at 01:25:45PM +0200, Paolo Abeni wrote:
>> On 7/3/26 12:24 AM, Zhiping Zhang wrote:
>>> Workloads that repeatedly allocate and release mkeys carrying TPH
>>> steering-tag hints (e.g. churning RDMA MRs) leak one
>>> struct mlx5_st_idx_data per cycle; kmemleak flags it as unreferenced
>>> and the kmalloc slab grows over time.
>>>
>>> When the last reference to an ST table entry is dropped,
>>> mlx5_st_dealloc_index() removed the entry from idx_xa but the backing
>>> mlx5_st_idx_data allocation was never freed.
>>>
>>> Free idx_data after the xa_erase() so the lifetime of the bookkeeping
>>> struct matches the lifetime of the ST entry it tracks.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 888a7776f4fb ("net/mlx5: Add support for device steering tag")
>>> Reviewed-by: Michael Gur <michaelgur@nvidia.com>
>>> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
>> @Leon, @Saeed, @Tariq: just in case this fell under the radar, it's
>> waiting for your ack.
> 
> Tariq and I completed this on Jul 5 and Jul 6.
> 
> https://lore.kernel.org/linux-rdma/20260705141920.GI15188@unreal/
> https://lore.kernel.org/linux-rdma/0bb37f75-c94a-4a10-b115-186b71daf14f@nvidia.com/
Thank you for pointing out and for the review. PW lost track of it,
likely because there are multiple copies of the same patch/revision and
only one of them landed on the netdev ML.

Applying right now.

/P

