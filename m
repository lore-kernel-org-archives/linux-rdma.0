Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793619600;
	b=S124oQv9ONtJMecEtYJUxC6dmi43xKT9t1lUINswgeXDdR5/79cl3EnlbqOylV6FN9OU
	 H9/jwQwJTFiJoaNrMA7PTPsjtSb3VnyIq/kIzIBaXDc3lzYgpmnyC3hmrjmoHccrHVvgK
	 P0sK+qogHgiS1DWfBhkv1WhGAdAPXrKyq+mI63Rw0N0JEgpujcWzry36aRE4CHXUL698E
	 7QcEPFZRhLFQUO8HKWQWczYaer/X/2PJY281ZPwMr17GR0E2/lNanIsCbfIH1gk8ZjYxQ
	 cYqyq3yj0w8ixmuUIwEdidet3zObi6GsFPA/sihE3Ilub2WePTpOdEkstrJ3Nuh6lhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793619600;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=BVuyCsNuPDKfGswdTC+QFH5JQ3zW3jmol69S0GRJXKg=;
	b=j6/04pOAccK4+q7AdBhDYjUroPWeaI7EZ911p5MDQNWMG1bpB4+wVk4gxDwAw8lLB8xQ
	 oXjRKu+buZtxIHbFO98xK3wmG+4rBKDlF18gf8HJMG1SsPhUZXx5cs8exRW+jiDdeSm0s
	 L6hN2/JV+1pbjvoc0hfTHCl1t2at9GSZAf1Gu77EpjhzL1tSWJTLEtsAFczy3cL4f7VGZ
	 CB2NmxL4FqYPdTSmjeL6xoXwmsq8g0Qj6ErmiJnKhFOmxUfqmwdYr2+xS4ZvYBZLIwJet
	 VOlJXRMdsFkDIKs7T47d40Q2h5CYMWaHgMy+ZPOxyW3kQK5yjmty8BV6+4R4THqiJXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZM6LT10v;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=nEN0JHII;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A73D606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 11:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A73D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZM6LT10v;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=nEN0JHII
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793619599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BVuyCsNuPDKfGswdTC+QFH5JQ3zW3jmol69S0GRJXKg=;
	b=ZM6LT10vKq0TVbzxmugbDLhAYGd6wgKjaNYKWTYUuVpwHjtVjSvaZ/1VQVdeBy0uOxOK7I
	Eo9ey0eYqonkXgSMQSCbAn72AyicKHydGkpRPExIC2B/h+2vhQxQlQC96xPMdjJL9TSLtG
	dWWiWRN9/I0T4NXNNo+q3t8nV5gag2s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-IfgEElhbPji4f5sFjCwziw-1; Mon, 02 Nov 2026 06:39:58 -0500
X-MC-Unique: IfgEElhbPji4f5sFjCwziw-1
X-Mimecast-MFC-AGG-ID: IfgEElhbPji4f5sFjCwziw_1793619597
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a2065a2ef9so28063795e9.3
        for <linux-rdma@vger.kernel.org>; Mon, 02 Nov 2026 03:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793619597; x=1794224397; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BVuyCsNuPDKfGswdTC+QFH5JQ3zW3jmol69S0GRJXKg=;
        b=nEN0JHII4mPkqlER0y17oAezn9JUpYdUYZ0YQjlajHgjn13MgT2ny9hkkqSxMuNG1s
         PO7NsMYDsALDmvjGXZSUcag+Ene9nQwektWd8DzBtjxk8UeUrBr98wRcUSO/LCJmzydO
         oBHWefuu3VxGgsW3Ictk57IKTzJf30ZU9L4W6pbc7xo7fEvem5mHNJjod3RdipTWtdwW
         Qx1y7OaVUHCT+FT9f4/ts/CcDi6aF8Eb9OZZ2duPXp5Vg61hfnftpfJ/Be57Ca+5uP+S
         lxbPls6yb7i5ymBcyQI8HWq1eh2GCrk4uSA/1TX6QcKBzVatvBAKt8e07p9efKMpq8uC
         WVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793619597; x=1794224397;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BVuyCsNuPDKfGswdTC+QFH5JQ3zW3jmol69S0GRJXKg=;
        b=p+LuKgmpaHT3AgAXiAb4l7DQlIKe//I+71WWM1WGpHFirJU0oEo52t2gdYIl1rdyce
         x/q6vyImwQ8tDJxZgVE0/e8K9r4I+KZGA74QR5hnqTbm+yntZBbDG90l08xcSZ0g4tAG
         ni6P6d9Ys/sJer+4UAi7d0j0ZVFIlUxsJog2Eqmunk85UmT+YVX8SPWEH0XcjzKVivxB
         JQlYJhZeGN8qcKYeqbmCuFc/MK9XpwlRBqgwdtWQ5MP4iptFZuvNG62l87Ihnq8t203v
         CrO/9eotHfYlBxmA34ZCWgN68aOiZk4G3EfZ739FovN81tTTdtkLxnAT/bKmJgCCoFwY
         nwdw==
X-Forwarded-Encrypted: i=1; AKwUvByn700A6y+/7z9ExuN7hTbjXAuv9ZTB2xdr5lQzSXt3qM/6eJ+tqb8GeQddSDJJiJGevwxbuTh1PNfT@vger.kernel.org
X-Gm-Message-State: AFq9FYLKclH/vGz/qPmLMoazck3qnD5nwjVBFHK583Yr676AEOBGuyUf
	sBxgAyb+iq9TGjd5CYDu8Wn7YGy+/Kdr9ypqjw6P8eRniurw1tnei2qvVLbo9I0/X2nP9qqXBB/
	N647ZaCqbaIooFyhrM/TWqMIo7wFvYOM+1wRa3lDCv04tsM0jYsSs36HmYCbo2ek=
X-Gm-Gg: AYBFou0B1yc0HlwW99L5sUKSCfdxk7e1t0a9ShKqc8XTxwc1zM2r37GgKHWfZwP8Jey
	gzRkZLODuJbk6iR9e3UhvEgGp/VzPwTtF9NQ/3jCxeMiUY/hSDX/VWy3bLuOvLsOq1QXjrNtxWW
	d80euLISJZUDlb/DMvdplumGxhNZQ3TE9jX7l6IIjxc8XusRQl9oODAsENNtWCF6cWOiH7Phkik
	Dc4oRPxSdaM6nyejmBrvI6oecmsccbFwvqpOm5JwzKd/TnWY9Hhu3vHi+1mX2wi/1N1TYDthxHI
	hl9qhzzC0sMuwJ9punBdhiJjBitAYeeTD0k2+4+JPVoMx34mLPw+v2/oWzov6NrUTTkH71gW45i
	sQwQ8hszEGChRSuZHRDvr3qlgQQznUNRYlRjw73kGoEZgrRs7yC2p1qn0NnqlRQkU20V4T88NCG
	KuenMIk9sXvmb3pfAb0PCJQF+ywwFFjImxZ/m0IvLdJoM=
X-Received: by 2002:a05:600c:4715:b0:4a3:598e:e7a8 with SMTP id 5b1f17b1804b1-4ac150b28bamr228460005e9.4.1793619596759;
        Mon, 02 Nov 2026 03:39:56 -0800 (PST)
X-Received: by 2002:a05:600c:4715:b0:4a3:598e:e7a8 with SMTP id 5b1f17b1804b1-4ac150b28bamr228459035e9.4.1793619596015;
        Mon, 02 Nov 2026 03:39:56 -0800 (PST)
Received: from [192.168.88.29] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf5b27e46sm431693975e9.3.2026.11.02.03.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 03:39:55 -0800 (PST)
Message-ID: <c0021e03-2590-4aac-b4ee-9a8fdf26d520@redhat.com>
Date: Mon, 2 Nov 2026 12:39:54 +0100
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
Subject: Re: [PATCH net v2] net/mlx5: macsec: free struct mlx5_fs_id after an
 RCU grace period
To: Joas Antonio dos Santos <joasantonio108@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>
Cc: Cosmin Ratiu <cratiu@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <179313582625.87630.11382992904624255106@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <179313582625.87630.11382992904624255106@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/26 22:17, Joas Antonio dos Santos wrote:
> macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable with
> rhashtable_remove_fast() and then frees it with kfree() right away.
> 
> The TX (SCI) table is read locklessly from the transmit path:
> mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
> mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
> rhashtable_lookup() under rcu_read_lock() and then reads
> mlx5_fs_id->id. A transmit that looked the entry up just before it was
> removed reads freed memory.
> 
> Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
> device inside macsec steering") the SCI table held struct
> mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
> kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
> with the new struct mlx5_fs_id, but frees it with a plain kfree().
> 
> Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().
> 
> The same issue was flagged by the Sashiko AI review as a pre-existing
> problem while reviewing the HW-GRO for PSP series.
> 
> Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device inside macsec steering")
> Link: https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel.org/
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
Waiting for an explicit ack from Mellanox.

/P

