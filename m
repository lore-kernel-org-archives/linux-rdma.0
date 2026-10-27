Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793091373;
	b=wX8gx9XZcGe/i6sMCzHQNldQ06SPjBtsY5hsvITK4DGIrz4xFfRLXmlQkpevctb5UplK
	 p9fHreoXs3znPnby0XgxoLc1kp70co50Mll6lSoa2rKOaU40+d3q0oGnVmmvbIcQUYEpz
	 4zZFaV+iYo75xkFoaJhSkFl+T/+b0/lZeeb7s3FP+6i5G1PkLhBxkFGwQrVAekZ/GYQgB
	 fGQtTwWuhzfgdXbGzxAnndiNTFHqIfrDJ2w7X2/qBbph2okwzLZEE9tzYJlvdz6UApPSc
	 G9awTNoBpG4Jc1HWlZgQWY0HIn3pkuC8vztzWqcmyz+Hx2GOggyZlxfxZ4QviRSzVbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793091373;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=HyrhFsYs+REFUgaFVShlaZ9e8ld3lHCKJ+hBUTNdVHw=;
	b=InnX6yzRo1wXPm1eNP8ZlgNjIvs5u6M4J3J1/SPgaPKquJI1e0M6D9Hcpj9EtYDhmzhW
	 3YPPyBHxSKd70dZyX0vP8Y2L2NSCpxbhzSWvmPa2tHdYP4Ul/ZQhfrq9arvSsHpbnZuF/
	 sNLVVLOPO925pr/Jg5/KoOPA4ACRPVqxa1hw3kLjpwpaxMOGVICOXygSmFZHSSNUDg8Hv
	 9uu07qkI+8XnEdplz0fVhOecgGkNXBQaMa+LpGCqio3iLzbmY6NKOSx/YTH5VaINqfR6H
	 8VIHH/l30EFE+XmPdTnZ8zovgrPBhYxlF4Fc8i3HFmYiIezHOmSrJL1g1hdNo2Z4STA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XVk4s9uZ;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=hVG4Z9Rz;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601C0606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 08:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 601C0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XVk4s9uZ;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=hVG4Z9Rz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793091371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HyrhFsYs+REFUgaFVShlaZ9e8ld3lHCKJ+hBUTNdVHw=;
	b=XVk4s9uZMvalsel9zIsIkXhztuP0qeiTnGFF1MpaiHK3eYxJ4pPHA3iWdBu3Q+aLWk47l3
	GDBpFZSekfJZu6hzGTgunFWkEJHCfNagTcqBjfxx5z22Isi+oo9uUXAWtFO9AHbARS2Mbe
	paGP0Rep85wLtTLxZtOQrpE9VMUN8qM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-xYcFGOplOiad9CJERdlIAw-1; Tue, 27 Oct 2026 04:56:09 -0400
X-MC-Unique: xYcFGOplOiad9CJERdlIAw-1
X-Mimecast-MFC-AGG-ID: xYcFGOplOiad9CJERdlIAw_1793091368
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1d1f26a63so38303915e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 01:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793091368; x=1793696168; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HyrhFsYs+REFUgaFVShlaZ9e8ld3lHCKJ+hBUTNdVHw=;
        b=hVG4Z9Rz1dB6d2izFFKRdGgemqvVFgxclc8HXtnYV2qslRbk5JEoRgmgyoDLQ3nVMk
         QaRuB06kOKz11LulRDJJakWKTgz4nNHX9I/FAjilMQh84UQq/8cWaecyRxnKBXpFQmUA
         yCSqToXeTLfUL7S/qHJQVeXcDi9WkcZgDezn7vgYdjEQUMEFFX+ai/+UaIG3CbhEBKeV
         ow7p18V+l46aMX+JF/DzBSPSaQVtzTGaK7hQ2pi/hrVkcXE+w+RycqbL+hVqqdpFR2pW
         328iUdS62GzahwKB2yvRmHPutBubbZJMoKTYwsAolWfYG1wy/EyJ3B5MMScmf+AZaF7k
         qjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793091368; x=1793696168;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HyrhFsYs+REFUgaFVShlaZ9e8ld3lHCKJ+hBUTNdVHw=;
        b=BzsjD2Xtm1ljB8wd9W+X2EaJtU//lNGhEjP/MxiJeUVMUDS9ULFTm/3yfbrBgCzndH
         VBrkJg6yctGgypHCj+iuxy4rTSXrFSPRD1fIbiJTGMj51Su9+1rWkIT3PGHPxPVkiUR5
         jajW3DLBCMFJ57/eHivZvjAlY0uIxR0/4lrWRVrw/k4+PUbAztgD3bV7HBQolrsV+cpH
         xFAnPmxjRaz10/JMJvch38itv+tpqAfOUvIc5asGfT8kx6a2P64UCNYg0feD7E6hwsbT
         NiZJNg7JGtcscS2aQZIS8eCeMGJovOwQ+i+Zgv7SpvWI3XUqFF+FB/EIzSAlyhbmeJ+5
         9QLA==
X-Forwarded-Encrypted: i=1; AKwUvBzbMzcqcXUINvzRcbvthcwcNMPeRPdGPlWlf3ueVQiXwulooiHriWdjTvrWpB6hHztqulirBykKtFaV@vger.kernel.org
X-Gm-Message-State: AFq9FYJFpAdc2mz9P5ilTUGTTA/9rzvxBoAcPgQf2B66ThrATGo18lwQ
	Jxvdqb87UTZucKCZ/2ggnBykQ+Z+ufM8EnPpzG83RLQ8c19ApusIEHrwxiHcSir6dOfRAS5IWQU
	CGa6CEwlGgQ+EYP5Zh3YcOp4VcVe7eg7oDHJ0O1hJuWdfiJwYRtuyyKYASjySl74=
X-Gm-Gg: AYBFou2EnKZy6ZJO6QsQ1wV/+lEE6ttIAgsFHxecmUhZq5y7JCpNe1um/MrJqFfUJ6a
	R/W2RaaZ/USSgtHfy25CQ/VEtlqR9tzU9cWdyIlda7R+eLJKA15ZfknHTT1iA2y+Jx+7ZFq/A+1
	7Sge5nodF+BHWft+UaTYkYD2Z+wohjIWGBsBpQP+cz/PaPFKl+F9m3GkkBN+kJV034hxujrHEEa
	2TppzTrCAlSGb6FWlQV1vhpBcFf4W1dP9wTf8hLQi1FpqSXSaaO+H4MjB0Gy2iqSp67ELrdYjLp
	yiNUlJ9VoaNlpKIkVYtT8Y4coA3xACw+5DgGi2SKpHb4P6El7vZZdVbJMs5GpB5SNGSndmaZXre
	dhZcggbPGzqTSaB6Pm4ZiwhwHRqrBjdRjFNjb3vsBoWMNpBXYXsypPocQrC64aH9fBXhqJBxpnQ
	==
X-Received: by 2002:a05:600c:8183:b0:4a1:e6c5:e44c with SMTP id 5b1f17b1804b1-4a35ac9d234mr149428835e9.10.1793091368541;
        Tue, 27 Oct 2026 01:56:08 -0700 (PDT)
X-Received: by 2002:a05:600c:8183:b0:4a1:e6c5:e44c with SMTP id 5b1f17b1804b1-4a35ac9d234mr149428265e9.10.1793091367861;
        Tue, 27 Oct 2026 01:56:07 -0700 (PDT)
Received: from [192.168.188.234] (ip174-129-192-82.pool-bba.aruba.it. [82.192.129.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a04ae28sm259883715e9.2.2026.10.27.01.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 01:56:07 -0700 (PDT)
Message-ID: <a3c08b59-7eae-4a1b-aa0f-042abe024525@redhat.com>
Date: Tue, 27 Oct 2026 09:56:05 +0100
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
Subject: Re: [PATCH net 3/3] net/mlx5: DR, Fix out-of-bounds write when sync
 to HW fails
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, acassen@corp.free.fr,
 valex@nvidia.com, erezsh@nvidia.com, gal@nvidia.com, igozlan@nvidia.com,
 kees@kernel.org, kees+treewide@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, prathameshdeshpande7@gmail.com, saeedm@nvidia.com,
 william@theesfeld.net, kliteyn@nvidia.com
References: <20261021074949.3471704-4-tariqt@nvidia.com>
 <179275275762.3134.7548579754182364985@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <179275275762.3134.7548579754182364985@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/23/26 12:52, netdev-bot+sashiko@kernel.org wrote:
> - [Medium] After a single SYNC_STEERING failure the pool latches into a
>    permanent error state while allocation stays open, so device SW ICM…

This one looks legit.

/P

