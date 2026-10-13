Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D60389104
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791890625; cv=none; b=a8pVdHXRYJ2qXi3a4a3cEdLeub0mFDDsMoOVPUEiARutEPEuu72rHMWLnEoB8hkVGdqMvjSOEVsKscPnk4IiFhkEKZtKzrN2K4WAQjFa0K8Xh3QCtxClFX/xxXLM+l0PFpqhLFPRy3Qkn1Wbv2V3cmth/4tv6vUNj38vRv00JOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791890625; c=relaxed/simple;
	bh=OAiwtZU5lLsZFm4lU/ObgFuPYWMbbn0X6/o2OFhuq3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C5YthYazlKfkTuTzHLAdY/RDW653ZlFw7ToR5NSpmdnWMz/ol2mUBf2m0ghISDwiPr/lxJrp+5xnF408cIV1tCOf7x6SArGkDWMmtDq4kYKfTnsLbOmfbGeB3ER+zRnFqb4BfBm5XWy6XAtnvZLjtIzbSnxpcRTAM3vWdBMIqkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bwNmBlFb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QR2ORACv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bwNmBlFb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QR2ORACv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791890622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=726Kbi3ZQ5SGlJ93iqUEhDyhLP3woij09STW5L6+pXY=;
	b=bwNmBlFbm4jzsaIl6XB+Jelh9hEEWzaxo8eeN2chtEjDrBe8iGXua0brVrYM3gUZODPXPA
	l3o3QR+wP3aVQLOStHULQ9s9Br4fu12TDW650bp0bxX6tBMlMJbnqwNjwnpfafZddgnPdz
	hJbxHfv/kevG2/7F0zMHvx2QCBy2lk8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-YlqfDlf7MSaBqEIyIoKDuw-1; Tue, 13 Oct 2026 11:23:40 +0000
X-MC-Unique: YlqfDlf7MSaBqEIyIoKDuw-1
X-Mimecast-MFC-AGG-ID: YlqfDlf7MSaBqEIyIoKDuw_1791890620
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48c6a1d4034so2461483f8f.0
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 04:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791890619; x=1792495419; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=726Kbi3ZQ5SGlJ93iqUEhDyhLP3woij09STW5L6+pXY=;
        b=QR2ORACvR9y+CIO5JNS2+beERm9m8FGeT4srckIz60mYcffvL3yGUJYu5EfI46PafP
         IiWhiV2I8GXhY54esUTRhTAOGabzj+GJ/h7V2SiE6fWslWPpQFJe0D8nWvpNz3Wwq51J
         jJZt3uCUD3wpxZk5Lhyewgf4nriCMJivx4EQ1wRh5fcYtOMqHYCwRqt9tVwcUx5Sz6lA
         56pWFv+fMaTp7cJ6viBR0yXdqULVP7njnGsrlNvHa3sgHBYYCgFyxMh5ezluA00DeacT
         cxSLY61CN6PguHGr8LiB2UmG/ZcdfJkLi86XWWESEC++UOSoBkJhHd9x72DM4gVtserY
         qHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791890619; x=1792495419;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=726Kbi3ZQ5SGlJ93iqUEhDyhLP3woij09STW5L6+pXY=;
        b=MTwM3zGCrsaNmKPdYOfQmivfDshwDhHF0hbx36asqK+GiVZtnbVGV0LD8THejPSFzs
         Q/VECke6Sm/pkYTeAEQMydi2KVA8xVGjQrXiZMsMKd1hcH0lP/KuexI0wH6lZcnyZcq2
         FfW9pyz+tvp5yqCb5SqIx8UtwSEfX6wlelOPuOJ2pv9hl98IBcSfBlyCsuS7PwOWIZ+y
         7UOKWv7+qqt1m4jrp+ya6neEcRUR9w7leUemiHeKLceqTzh2eDNZWPKL5ZtvL8YLP86v
         KOAWM2bWcL1J1MNFKU021UEKauTrrZ23cMSHFEZ7QiPstfb2uWSN+GOt4qVHaj/GTxHy
         ew8Q==
X-Forwarded-Encrypted: i=1; AKwUvBw8XJKSQNJMZGcdYZeWppRQliArFZYXeMuw0l8FV1B+bjMALcshM0rutD5AlDJmpHFwd1eMIZVJSl+Z@vger.kernel.org
X-Gm-Message-State: AFq9FYIW8qYFlXW2BXcP0QCQDAa10iFfsHR712gC6UmrihwdBi/hPEhn
	m72RdDT2wrYJWAEAAYuikk4cBvik6ZecttBzRYg8k3bvCH2K2nAPgc43fd8ZzwoWXKA/H84CAPx
	BAMMR4S/GAMZdgsWW5KP0kJPWVvuClF665y0/ivvSTUtCxE5B449+OM9Jxk/6auY=
X-Gm-Gg: AYBFou0unMBs2n/6IJMmBIYlelZAYwRol4dk/+5TOUb+xF7TybB8f52oT391gPka7B8
	FGKAl3usNgLlS5qTswOcARJuCqkM1MoJ+8Df0zzD3VJW7gnTeki6oDmSMihVljdWF9FwWj7FfMm
	EgcHvwel/qlZjxe3Wr1dwzbpN8/RFoG8MftCOmtteWXqZeNQOqT5UZrxEWOY9y0adTjqTLHZKDb
	gtCTYnS4CWZe9Sl/ExcJvY/nNf1UO+/sQ+MQ1aDdyt6UhueQqs8u0a3596C5EI8yP7ZtQhFQQRG
	3B8DeHSSrXRgb4LPyHFWRC4t9WULkLsOHskd6xvvvlGjjvmlkrBmIY8RxN9w313Qe7ViqRsT6VM
	8MCEqAwBwouRCpzVl5FrF2alq3RVcadLz9HdZykOaCI514WQHckn8ZdZFrvI3zHAarhWWwSEXlA
	==
X-Received: by 2002:a5d:5f87:0:b0:487:aff:9952 with SMTP id ffacd0b85a97d-48dbaadd0b4mr23455638f8f.16.1791890619503;
        Tue, 13 Oct 2026 04:23:39 -0700 (PDT)
X-Received: by 2002:a5d:5f87:0:b0:487:aff:9952 with SMTP id ffacd0b85a97d-48dbaadd0b4mr23455576f8f.16.1791890618944;
        Tue, 13 Oct 2026 04:23:38 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc6b82sm4628216f8f.51.2026.10.13.04.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 04:23:38 -0700 (PDT)
Message-ID: <6bd52b02-e701-4589-824b-87c1475bc4cf@redhat.com>
Date: Tue, 13 Oct 2026 13:23:36 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Attach late uplink netdev to loaded
 representors
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jianbo Liu <jianbol@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
References: <20261006110219.257714-1-tariqt@nvidia.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261006110219.257714-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/6/26 13:02, Tariq Toukan wrote:
> From: Jianbo Liu <jianbol@nvidia.com>
> 
> mlx5e_vport_uplink_rep_load() returns success when the uplink netdev is
> missing, so the ETH rep is marked loaded with a NULL netdev, the IB rep
> copies that NULL association, and nothing repairs it later. Unbind
> mlx5_core.eth.<N> in legacy mode, enter switchdev, bind it again, and
> rdma link show still reports no netdev on the uplink port. The netdev
> also keeps the NIC profile instead of the uplink rep profile.
> 
> Add an attach_uplink_netdev rep op, run from the existing reload-reps
> work once mlx5_core_uplink_netdev_set() reports a netdev. ETH re-runs
> the uplink load, switching profile and setting rpriv->netdev; IB redoes
> ib_device_set_netdev(). Deferring to the work keeps the devlink lock
> out of probe context.
> 
> Fixes: 6b4be64fd9fe ("net/mlx5e: Harden uplink netdev access against device unbind")
> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
The AI feedback looks relevant, also this looks quite too big/dangerous
for net at this point of the cycle.

/P

