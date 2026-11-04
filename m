Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793800767;
	b=P/O6LA2+AdeGPRQyBPmn+7PsiENT693sf460Ymc+ZTExHkcGQXJgYPpFA0x7sq5NlpOT
	 MuIqGq+EO6uprD8Ce+twbDm9ZyfngkmAhvSQDLI4AQ6hGIsRGCuixmQCwArJUa3GKR6Jm
	 8MNJz2wSo/k/NHuV6dL2ppVLHY3BV13aNGpXuxcNQz4uZN3e5KYiy+VyYbkRuA30Rgdo3
	 XdfnPWfGH2dqC4E6zV6L0Vqk2oH7AqWUU4qs5Z8WcXNtFeyL0eQmT81qXlumUbFciOlwE
	 vdVFNU/5CAj8I64N9wF0zLTCSnfbfoO9hcudDiD/LHAEB3LHWr1btYiFogc7FxZo/Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793800767;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 From:To:Cc:References:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=VitNQKxHFPSqCciOhPtQD8YBHIUjMmipC+sy8DGH1Vw=;
	b=UduLsfy9nqKeMV6uBnIsBCTodaDcX38PAD4hwTiJeJJz0VS6Zp8W6uoZqLySsYJrKcuh
	 T2OYRzOFMqj+wY9M6gnAOUh8MKflAB0O5ke253ZJndoywUzYzACKaLzl2VjmxLCTYzClK
	 jVwNyvaW06NpYya/8BcRihe9EDT8aVxiFxP4nzhFfQfqlTSJ9D+fZn41v1KlhYJnHQVOL
	 NF+UKlLWGX/urL5GmKJOiBykFzZQEBR+r1EwAE488ICKAS+2nTnYp/64tBTUu6SRf8vII
	 GVU8WJqHRJOta9NjT1oRsT/EYmGT6JKWT3uEpjgBiNkVQnR8W8rmliix0ePQxdVe6Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=K3ABB+6V;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=kiFgX3ZP;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8C8606A326
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 13:59:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F8C8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=K3ABB+6V;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=kiFgX3ZP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793800765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VitNQKxHFPSqCciOhPtQD8YBHIUjMmipC+sy8DGH1Vw=;
	b=K3ABB+6VsNi6s+CBcYdDLjrP2ty8PmHqrmAvdwh+qICUPud6UfmKyAn5+VWRU0YbjaYOoU
	zqG7QQOYSD3OKlREqsKGdK9oX4QulYP3Z/DEncL8SEo8+se4dzOsUAL9HZ/oVcPE1ycLLj
	rzeTQcmn2tLy+OA9/iJwNT/k4VdcDrQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-21ka2meYO7e1RTrEbs2EHQ-1; Wed, 04 Nov 2026 08:59:24 -0500
X-MC-Unique: 21ka2meYO7e1RTrEbs2EHQ-1
X-Mimecast-MFC-AGG-ID: 21ka2meYO7e1RTrEbs2EHQ_1793800763
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a20e41008cso6851165e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 05:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793800763; x=1794405563; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VitNQKxHFPSqCciOhPtQD8YBHIUjMmipC+sy8DGH1Vw=;
        b=kiFgX3ZPwleCiXANgJQF52HNkTjpwqD45mhBHeACrXNLq67VC1XEeJlYEKK+LrmPKz
         /5oPjO4x6Gicj6JAdjPvykT32qaNgCJSOMTcU+SQQS64a02Bef3SHScZPT8G153Kf5fn
         P7jhcZXwyyPALYXCrFlkmW4T9/s3H+zj78GigsNc6E7hFHj6qNta7/10UaRCPgz2YUnk
         xom5rV2FcCi1vp/EyR3OhPakymWd1/5nhZFe2LdhDO4PXp+Q7CturvyN1/jrGzdLCfEp
         jolsL9UZkVIYfl1FcMqPRiC/xxFkN5hcFOUtIz5OJD9iMG3tEGu6HmqUB9BvFySKEHgt
         PhQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793800763; x=1794405563;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VitNQKxHFPSqCciOhPtQD8YBHIUjMmipC+sy8DGH1Vw=;
        b=A8nMkxcXVZWeDkKlR0qNj+JisJq7Jy8M48gwj8HZDQ/GMH/0K8GyVAejtj9ypfGEBp
         JN2gT2W653vpBO/kFQ94d/pQ61epGhodXHwqDCaSsukH7BvCnaJdaFBYXI6cNdOIK8ua
         utNOR51wTRmYYs2PLxt+cyP7hZ4SYT9EDFBAn4ZmqZrJKpAInEpO5vhqz7whGiq6Gd3S
         9pGA+3CX01ldJLmrUGIiVVt8aFzU/GKbXGC6ePLlv2ospuTzQbIb/8d++KMpfCu+EMyj
         aJEeR7S0b9d+cJoWBGqlK+kZoyp05BG+4H0GbexCrsmonT2raTaDY2JsIivv3dpsZJvP
         gX6g==
X-Forwarded-Encrypted: i=1; AKwUvBz5lFaJjX5hP3eWYiMxr05hNv1nIRpx3IhDkAj3Jpd4EMcQ98qun7hroofVblhHbNwdp+jWPjOTuMzc@vger.kernel.org
X-Gm-Message-State: APuU4Z+oBMbM6g6BgEQ+9Mchw3Eao4Xk8ZBXVfLTXai8rw/gEpv0KDzJ
	Uu0AmLfZ3cBoGUOWykTsbz8nc1bIgNJqQqB5+pNoIPzUiNHLMbyihsl0+LVRNh2g5bXAqiTLwk4
	HKDW9Nu6YYWOY51EaZumb//fzlmjz6pPIgj+KOoZmRV7MvCeuwSKB/6GtOe+DwH0=
X-Gm-Gg: AYBFou2LpLxzte4atiMVBpxo+n7HY+YVA6H/o52mNrxqWLequUsgGGFPpQwX4owfI9k
	KLYRijpEvH9llEy6mx3zJxb2O9wyOs9PZO/MW8LETMjfeEDK+2orxVjs8edh1lOZ71oJAeRKjjl
	b187QU2G1o52VkLzU+utdS7iEOULz6muLpqAbAEGRvwZLFcZv+bAtOuz/z1MO3DtZtjSFPSxYF4
	uvePs/smZevnHoCnwKBP2G9+B2z7Dq4Q/alCzOPZXaHQN7jkC49qDz0AWpBtH5taNaCaAGDRWQU
	FZ25ipFI4unTwBXqGy4+K279wOd+nzVzUp6BKzc44PZhLJ4xsc9iJrCQTxr2OUrIMn9V9uUiykS
	z1V0d+GbDMnyx3Sg/peAKwOjPPdw1N9vdgoZX0PwqErqunlUnGycTkbYeI/ovZHsn250qfmAj+a
	EFQyv6uXqqxRJlX+Fr826nWkWrCIllqTJksx9t6zyAq3s=
X-Received: by 2002:a05:600c:3b0e:b0:4a7:7d22:c50c with SMTP id 5b1f17b1804b1-4ac150b2243mr401889315e9.2.1793800763043;
        Wed, 04 Nov 2026 05:59:23 -0800 (PST)
X-Received: by 2002:a05:600c:3b0e:b0:4a7:7d22:c50c with SMTP id 5b1f17b1804b1-4ac150b2243mr401888685e9.2.1793800762336;
        Wed, 04 Nov 2026 05:59:22 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fece99a5dsm3927057f8f.21.2026.11.04.05.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 05:59:21 -0800 (PST)
Message-ID: <95dbd8ec-c31e-4410-a12a-e504fac36fce@redhat.com>
Date: Wed, 4 Nov 2026 14:59:20 +0100
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
From: Paolo Abeni <pabeni@redhat.com>
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
 <c0021e03-2590-4aac-b4ee-9a8fdf26d520@redhat.com>
Content-Language: en-US
In-Reply-To: <c0021e03-2590-4aac-b4ee-9a8fdf26d520@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/2/26 12:39, Paolo Abeni wrote:
> On 10/27/26 22:17, Joas Antonio dos Santos wrote:
>> macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable with
>> rhashtable_remove_fast() and then frees it with kfree() right away.
>>
>> The TX (SCI) table is read locklessly from the transmit path:
>> mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
>> mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
>> rhashtable_lookup() under rcu_read_lock() and then reads
>> mlx5_fs_id->id. A transmit that looked the entry up just before it was
>> removed reads freed memory.
>>
>> Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
>> device inside macsec steering") the SCI table held struct
>> mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
>> kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
>> with the new struct mlx5_fs_id, but frees it with a plain kfree().
>>
>> Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().
>>
>> The same issue was flagged by the Sashiko AI review as a pre-existing
>> problem while reviewing the HW-GRO for PSP series.
>>
>> Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device inside macsec steering")
>> Link: https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel.org/
>> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
>> Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
> Waiting for an explicit ack from Mellanox.
Actually Dave already applied this one, but the bot did not catch-up.

Sorry for the noise.

/P

