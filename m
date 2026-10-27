Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793091055;
	b=hnZ5N34/GRkjSZFFKOE7ry4sY7hoF3xWRGu33YVtjuVor2hA6bM6Em+m0sZExFmHZQqm
	 mDAv21QgqP3rWoMKL3yTv9C2VK2Iu35nmXiFsGZKUNrCJta1Tvg8l8YZG/WvQAa8AcmkR
	 nhERfk6pVrp0hyYIsr4+JjrUEacwxUWZf4dTKmdhmnCnP8bINXn5j1N588Jt1FlfzeygC
	 nTz9DEUumJsMxyCNtx6OowzoA68RdabWcOlg6W5ZDTiBN43gK6suN3cpeQKmvo7ChvWKl
	 JN1ucTXkDTIhoEkDlnBVrlX4bb/5Ol0FBACt/kK6pY24JxYW1IqVBbqZmIeujBlTjBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793091055;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=05pWYvdSFKuQTlIpLib2CW0D3AAIr02xLV3H0zVKlko=;
	b=NZOi28AO3N7DwkKK2Yuwpxq4n5oCePFWjhc0csaD5UO/tnOJ/UnaRT/CVVdX65q2ql4d
	 uheQFKo2PEjYNeQ9qma9VYL+1VCeQZ/AcnIZVx83t9e1tElU3w5U7MZWc77kpUz3BR4TT
	 RU/VL/eJG+Vi9UQ747aW5mK42WcDdlg7R6jsxy4sI4xEUu06xtIBwvHaiTyCyAvNT1FMb
	 QRF3TK4cMRFaX8IWyQQIKwKTLJGi2k1z5D8SzfmOWSSRD0mwGyAyJUYmv92aReTVN3lEZ
	 T63RjShyguhINwsbi2pOS1lB2QdEL0sQrSopWpfE8wzHq17OXua/uwAiXJT1l8IYktw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gPPVxLJ6;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=CKwtIhUT;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BCC606A324
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 08:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36BCC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gPPVxLJ6;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=CKwtIhUT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793091054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=05pWYvdSFKuQTlIpLib2CW0D3AAIr02xLV3H0zVKlko=;
	b=gPPVxLJ6c+CRgWkovs2Zlh4zhUtDA/a2FoOryt4QTF6NroS/YpKkTccjBfzfueo0s48Wj0
	jcE/16GhvVYKtSFFJB7YI1rM0VXgyFd5HJ8v+BWpWBD/Rli/vnqz71fIY+BdPG6X0R76FK
	USA3V24pKz37BKdPcVxxKilvBv+kbTM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-Mn51JOy-PsWWDbRCWmN6HA-1; Tue, 27 Oct 2026 04:50:50 -0400
X-MC-Unique: Mn51JOy-PsWWDbRCWmN6HA-1
X-Mimecast-MFC-AGG-ID: Mn51JOy-PsWWDbRCWmN6HA_1793091050
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48dfdc0f491so2139515f8f.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 01:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793091049; x=1793695849; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=05pWYvdSFKuQTlIpLib2CW0D3AAIr02xLV3H0zVKlko=;
        b=CKwtIhUT3e+evXhP8lwAOn/9H3MiC48E78f0NbBhlr9rid3UF26ldFUeh6V2tEULgm
         db2NE1a/zadHKbcWiTqOipEg0FZYfVslHjIyS5g+wy6jIaOnh+F/NDtKCUm4a/bi5fKF
         5edNWAhVvkuXJWDXimuf2zfVOElrQjYNvVJP165ujnwSipvhcRuWTb0RVp9AeopXj8fi
         TG2gM4kdUizHDheb6+bfuG558uT+oXHJpMZuVTnLhab+LFxtRq3rtE64kJ7k7dOQzLMH
         /9jnNL4tEq/sNJkZG3KkJMizvH9NbjaCuFGoGrQxdMPK0FReI9jzT5lvV2CrWfMxNWiJ
         mqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793091049; x=1793695849;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=05pWYvdSFKuQTlIpLib2CW0D3AAIr02xLV3H0zVKlko=;
        b=klD+RNKAA9gKWFQR6oQF8V8G1k10sUx8vv2CCnNpWbG9HOluceEThGIgrxPyzZ9AsP
         4K6xsDH+Al9h2wsOlYLrXu4uZGWJqB1c749gX5W2xiNk9OwGFOypsy3q1pArpK0CrR4b
         wL3s1LkmNxNdSI/SvxhiSdCSsDojNy82Z5d6v7mabvfELPdJ4XVJCNshvIGgVooYclXg
         78DdJAUT0cxS2uohSRC2C3dXYZ8OxcMncHC9jFX8m+kpapKrDjrgJceV6oOr50bmj9rU
         PkRVbxQk8cMA/8iO7dXww+YREvT63JIb+ixYEE1h2qzqZhU74C0AGqkuru+GjRVepfgy
         a0xQ==
X-Forwarded-Encrypted: i=1; AKwUvBw89BLdOkFiqujO19vgMnFcrPQXfppqJaGas/MBhYrrbZGjbSOQb7Nv0hiFpAQv2pjjHvCbptsJblAK@vger.kernel.org
X-Gm-Message-State: AFq9FYLzvlGtH2MHDuz+OJya1l2/H8JH7Sz55sVUXLZhstCj1njpIqxH
	I3WgEauTIbok5iLusJpq7A005/Todzhwc6fgrE3bwN6kJzMPTQnhR1H71vahCHlK5G+N3pkqjkT
	ZgX9Zt7chJS2XLpuFCTkbtEmHPQjuUiatjolvZ67HJ2haDVQ6oElcq6IziLlCt6M=
X-Gm-Gg: AYBFou2PjuoLbbWlfzKwv4nSVZDf7m6cmcBCyZ+6aB+ImqA/6WGTpBpYH29xxTRx2j8
	WT5tVwwxcxYx+MZA+h3lZoFMPU/Luc30x8b+0ssEe5onFsyszTKaZyuq2HzRVnAGxksI0HE1BPT
	FEL0sEpFQ3ENWUYxQgydnb5SaA9V4Sr918tDu5gjzNQJ0ABoqKzGF55HtIFG+2vAnI0RfhxJvKO
	JsIYF5ead44TZiEeIkTLHwJB3p6nnGk9IQcaP6hTtNQroKficYWpejA3lipgQJ21Go6+W/n5DOQ
	YRZb9B0cNMeoVl/tim5FAPnUMqJ3tpAxvV3EsC2tuOpuZPVVE0CJ+4bFzP69dh0/XZAEly/Z6FL
	qwhMsa6SuTMF0y5ZlzLoZi3sBDR0WnX93ImUcr9Ks2y8G+9tzShHXCc9iWrxxAMWO0/23LdGsWw
	==
X-Received: by 2002:a05:600c:8b86:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4a35acb17bfmr169457645e9.22.1793091049493;
        Tue, 27 Oct 2026 01:50:49 -0700 (PDT)
X-Received: by 2002:a05:600c:8b86:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4a35acb17bfmr169457205e9.22.1793091049010;
        Tue, 27 Oct 2026 01:50:49 -0700 (PDT)
Received: from [192.168.188.234] (ip174-129-192-82.pool-bba.aruba.it. [82.192.129.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e542ed998sm6698767f8f.13.2026.10.27.01.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 01:50:47 -0700 (PDT)
Message-ID: <7136e772-513c-4ee3-b802-a9666fb8bdba@redhat.com>
Date: Tue, 27 Oct 2026 09:50:45 +0100
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
Subject: Re: [PATCH net] net/mlx4: always create the eth and ib auxiliary
 devices
To: Peter Morrow <pdmorrow@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>, Yishai Hadas <yishaih@nvidia.com>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
 <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 regressions@lists.linux.dev, Leon Romanovsky <leon@kernel.org>
References: <20261020164239.3808903-1-pdmorrow@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261020164239.3808903-1-pdmorrow@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 18:42, Peter Morrow wrote:
> Since commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
> auxiliary bus"), mlx4_core creates the "ib" auxiliary device only for
> an IB port or a device that advertises IBoE. Before it, each mlx4
> interface was offered every device and decided in its own add callback.
> mlx4_ib_add() accepted Ethernet ports without IBoE and registered them
> for raw packet QPs only.
> 
> ConnectX-3 VFs on Azure have an Ethernet port and no IBoE, so since
> v6.6 they get no RDMA device. DPDK's mlx4 PMD, which needs only raw
> packet QPs, then cannot open them:
> 
>    net_mlx4: cannot access device, is mlx4_ib loaded?
> 
> Restore the old behaviour by creating both auxiliary devices for every
> device and letting mlx4_en and mlx4_ib decide in probe, as their add
> callbacks did. mlx4_ib_probe() returns -ENODEV when there are no usable
> ports, and mlx4_en_probe() binds a device without Ethernet ports but
> creates no netdevs, as mlx4_en_add() did.
> 
> Tested on 6.12.111 on an Azure VM with two ConnectX-3 VFs: each gets an
> eth and an ib auxiliary device, and DPDK attaches both VFs and passes
> traffic through them.
> 
> Fixes: 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the auxiliary bus")
> Closes: https://lore.kernel.org/r/20261014133951.3219055-1-pdmorrow@gmail.com
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Peter Morrow <pdmorrow@gmail.com>

@Tariq, to avoid stalemates: this is waiting for an explicit ack from you.

Thanks,

Paolo

