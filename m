Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEA03B14AD
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 10:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785236024; cv=none; b=FYPty7dmGYi7nOIzdpsKpZEEl7CupCur609xm5Ko3rFtDB3K9N39vXlWY2HAt8klPn+e7hALIkum66T8qgUFbVkxDnV9bTfc5RsV75LdmUgdqFNX83HWnBR90kvjaTQPu8k7LcxFkvkAcQCWzrjZ7hK0N9WeM9QIboDLkcoWYaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785236024; c=relaxed/simple;
	bh=GuqMBdPv/dcGRcpyFr3E9rAhM1G7tEFvC/D9g2VY98k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MiXfzcJbDlk8LeoFAnpuudP5JSZlfyTSGptCJck1EHSmyQjMJ3pDh8Uo1Il6gY4u4gIeGR8S3lsRw2HEj3GDdrECNyw9VhAyi+mTXnBkZ7mNZ7ZUxm8A6UebcsYLcZ7FA9HueD4pORs327NgYSWRy2GTZ2EsePLibDSUOTFl0jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hpYFS9Xt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWFGXvL4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hpYFS9Xt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWFGXvL4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785236012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rqNWKW0/xNBqkwbPCbxUHyYvyyfc0iM4zqIDc7x2VYk=;
	b=hpYFS9Xtv+P0NycpJsKkqWEDbGYYPki+Y1BfThy8KfU/r0IBSEk534K3nK+xQ/2ykZJM2B
	aiDSKItDU2kUS6Ju7RoYnpUJo1KKM06ZzX/8T9NmEYsdOQGnRbiJqiPyRru3p7dyr8W2z1
	UKRdtyfx1RNTK/VMQelt4bI17EDkaLI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-7vuS7pFtMeuS6bOh6eT7zw-1; Tue, 28 Jul 2026 06:53:31 -0400
X-MC-Unique: 7vuS7pFtMeuS6bOh6eT7zw-1
X-Mimecast-MFC-AGG-ID: 7vuS7pFtMeuS6bOh6eT7zw_1785236010
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495689bfcc8so28388465e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 03:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785236010; x=1785840810; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rqNWKW0/xNBqkwbPCbxUHyYvyyfc0iM4zqIDc7x2VYk=;
        b=PWFGXvL4tEuQ0ZAIGjh9mJqjRuPZHDrpjHWZB+ivzbHCpsmBrsrzjxdUb+0s4BJ3Hp
         pk49f15t1gPgRZJ4Yl1Mne6Rl/e9k2LzQoLcd/EFbcdEgWqSkURdMaSZ4NcEO9qybIOv
         7S78Fo0RazykWfi1a1tGUolX+alpjoi+t2mdXYLpTVjQ+eEI5CBt8TOeKb6ElYRWcqIL
         as/FJylwPCI62zl3W2V7Unnnth/81BoC0cYHJI4WZQlqQPJrxgMjJQFbf5p6Livtkjr9
         GLv538KU0syN8B4VLE+O+IZAx9a6sT/D5EKH20aygKrmuH7GYTOpii26CZuMinuQ+8Nc
         1pdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785236010; x=1785840810;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rqNWKW0/xNBqkwbPCbxUHyYvyyfc0iM4zqIDc7x2VYk=;
        b=i/8Gt7wBTp/R+5cnkfyPM4veHivvnJDmToLw92LrDjBnNqNBrt68yTVJcKNryvR9Hd
         KvT7mYT/9+uh9klhqsdop3EHYoXsfDDeNuIZBu71yhsS+On2En1wDIO2fhOxRuvU5TA+
         M5n2aMQj2ov28Ra/PNdLnlyxlctQ1KuLLMVT101Na0HZpUXBGqO7tMDOTOxrj78/TPAj
         cL8egQMhHsoYf0ViWdpf+mr3bPuJGJSwuEMmjGI+0d2vNXWX19Nk9Ujso9O3DKPAkwi/
         ekPGZKW4E3VHksapG4NxUbnZi7GAnz+yErkN9V+KOMcJEFpFLPs76EGmhtSw8lFU3OD6
         M/CQ==
X-Forwarded-Encrypted: i=1; AHgh+RoQzTLF99WjPWQZYZJaHlNuk+jh1U/7IoMtD6fGsW8ocz0PQv3ewVDEIkvuS15h30OhwuTRqg9NU+oX@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwu5glEFBxFYbHeLLbJDj4bq67xOF/y7wbOSa5u7OvLzB+Wkob
	LWyPbUhxU2ItzjxSdlO0evvJWhTTBo2K5k2XhjH9Yl6fYkpFsa7vvbTOyTKC4lPl6WTgIP4b4hZ
	quJVpXokIx2+3VcMk5S0xefixEAwOHrpt0naIT4NjpFyiaaOKkKft3lqXpM9xaLU=
X-Gm-Gg: AR+sD11/yPEwKrAe2Z2bLFQ38UbskmXLW2wFrrWei+pjBymk7jFDEW3bdQOr2Xl+bwt
	YR7X+xoLUgFGlzYeLlcrAiAd1Hc42RiYTibCffDWoPvqFGQ9kgsCqAcnGt5pwTTYvK/9mQgp4ru
	PkJJ1OWo6h/jldpVm+jCKDpqs2z0zh/DSz9WgK21gRN6Zovr9j3oDhitLZeb0NEYkP7fyqf7sDE
	oE7ukj/nr83xnKCA3LoqQ0caiF65hCsP9uwD56JehKHGcO7pKzo84qKSZf8QPSBuNx16kDo5jqZ
	aQZpAluWnMZrLmpYjJO/VtzEDgZWuIZfA2BHpgUJ+wjV8BwLiKA98zKObwGvvHrBdMpTYO2Yua8
	/uns9IBqWGcf+xBIXLTHd5JyXF+LaKodRAqnRQcb3zGmSJWz8Sndw8u/Qow651Nz5hlxGH3FRTr
	Qbrg==
X-Received: by 2002:a05:600c:81c8:b0:495:401d:9f4f with SMTP id 5b1f17b1804b1-496c65764e0mr19520475e9.25.1785236009994;
        Tue, 28 Jul 2026 03:53:29 -0700 (PDT)
X-Received: by 2002:a05:600c:81c8:b0:495:401d:9f4f with SMTP id 5b1f17b1804b1-496c65764e0mr19520135e9.25.1785236009517;
        Tue, 28 Jul 2026 03:53:29 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957bffc501sm244172845e9.4.2026.07.28.03.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 03:53:29 -0700 (PDT)
Message-ID: <7108c005-6b8d-4dda-82cc-e665cbe3b6a4@redhat.com>
Date: Tue, 28 Jul 2026 12:53:26 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 0/7] net: mana: harden the HWC and add dynamic
 queue depth
To: Long Li <longli@microsoft.com>,
 Konstantin Taranov <kotaranov@microsoft.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Haiyang Zhang <haiyangz@microsoft.com>,
 "K . Y . Srinivasan" <kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, shradhagupta@linux.microsoft.com,
 Simon Horman <horms@kernel.org>, ernis@linux.microsoft.com,
 stephen@networkplumber.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260721234339.1476932-1-longli@microsoft.com>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260721234339.1476932-1-longli@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/22/26 1:43 AM, Long Li wrote:
> This series hardens the MANA Hardware Channel (HWC) control-plane path
> and then builds on that to support a dynamic HWC queue depth.
> 
> The HWC is the command channel the driver uses to talk to the device.
> Today it is created at a fixed depth of one outstanding request, and
> several of its lookup and teardown paths predate the RCU and DMA-lifetime
> rules they now need to follow.  Raising the queue depth and allowing
> concurrent commands makes those latent races reachable, so the fixes come
> first and the feature builds on them.
> 
> Patches 1-5 are fixes for pre-existing HWC bugs, each with a Fixes: tag:
> 
>   1: cq_table was a plain pointer array freed with no grace period while
>      the EQ interrupt handler dereferenced it; put it under RCU.
>   2: the HWC RQ and SQ were sized with each other's message size, so a
>      response could overflow the RQ buffer and the RX slot stride was
>      computed with the wrong size.
>   3: comp_buf was freed before the EQ was destroyed, so a late completion
>      handler could touch freed memory.
>   4: the RX path consumed device-supplied lengths and indices without
>      validation; validate them before use (this matters for confidential
>      VMs, where the DMA buffer is shared with the host).
>   5: a failed mana_hwc_establish_channel() could leave live MST entries
>      while the driver freed the queue buffers, and destroy_channel() freed
>      the TXQ/RXQ before the EQ was quiesced; add a setup_active teardown
>      gate and destroy the CQ first.

Fixes should go via the net tree. Targeting net-next to avoid waiting
the merge to post the dependant features is not a valid reason.

Also both sashikos agrees pcie_fpr() in patch 5 is not the correct
function to be used there.

Also please note the expectations WRT LLMs feedback, commit c82ff94592fb.

/P

