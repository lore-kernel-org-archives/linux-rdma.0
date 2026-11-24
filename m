Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521338;
	b=c/JBB4AI58lGPBReX77LACt9Q7587iHc0iPUqexFiHd+8kbozorRv8hyLGCQYaFWrTUm
	 Mg9fhp7+Q8c0/ZO/SoFcPPtxODLSRo5lCW+gcs1jL400MKi9hqZwvzGTZCzcALP5yZWzq
	 Llau8owKt5u8iB8tJQOQ8Rkmus2/MwGN0nQex/CpC+JTahVvsPgtDe0cn195sUkVDKXeW
	 XVpxkBWyyaO94SHUhV6QiE5/lvtn42jopzy2ZIYG7D3l/EFghL3KbxjZpbygmiRvLStGD
	 a01pzK8nvuVbnLu0HN1VgeKqkRYJZ3RKNR6r5RZo2S2g6a/wOs8rPJ4WNvGEbOwQLJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521338;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=NJA5c5ZGXj57m63UhcAXfZFX1tNh4F39d5fl+LApCNc=;
	b=rKUiWCjkqnG8RpZ1RuTkzi3nyF/aBBH/WpEhCIFy8CDGcoU6R7TXVrfKpoOe3d4QObKV
	 jygCeihbAqrK0SIaj0wVID3UQqlXZQdVjcx0iHVr6Os3uokSX7LINRItCfc6goA0QNTkA
	 KJzPrpIfmCLBDiE/Hk93RD9Q+k/jaEv7njsItuEmDw4YNKl79ORt7Lb7ORS58B7L9WO0p
	 arV3bumBqc33VFBoTpiY5hkJJRwDASRnvWuvFwnXDaPiqyR4Ynf0limlKrulEdbIMZpeM
	 X0ZYHPzLCPf5qGg+auSv7eNrsnON6tikxaU3368WKDah1XDDUFCacFYQrttvE7Zif1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="K6NyLWA/";
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Kvq7dxk7;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C35606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 11:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28C35606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=K6NyLWA/;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Kvq7dxk7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795521337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NJA5c5ZGXj57m63UhcAXfZFX1tNh4F39d5fl+LApCNc=;
	b=K6NyLWA/gPz4Bj2l4JpzlqqnvpwneUwX2RHu7cJ8EE+bqCbQLwmFHRskh7IvBa6HNHjijf
	PvOL777xH0vphitEMbiYnw/s/9cZe8SMl6BENk/x+PT0VtB7/eAPeh8DlcEUnLmM5XfRUP
	QGOcPCOq8TFcZjUpj4BD+vt6CvzXdjo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-VEyJmI0OP2ii_r03HuxZgA-1; Tue, 24 Nov 2026 11:55:35 +0000
X-MC-Unique: VEyJmI0OP2ii_r03HuxZgA-1
X-Mimecast-MFC-AGG-ID: VEyJmI0OP2ii_r03HuxZgA_1795521334
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-49090fde23aso2724211f8f.2
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 03:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795521334; x=1796126134; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NJA5c5ZGXj57m63UhcAXfZFX1tNh4F39d5fl+LApCNc=;
        b=Kvq7dxk7X8T1EMdfdKT6VB0yHXV3B1HPuXvFq4XUs9OqlElP83IfAzaYYD6c7lsUIu
         yYqBSV63+1mH5W9lNgSMpUXSaKLDom+sbJKD3Ic7Vedne7jWssogFP3oUolZEZit6xEW
         zjU2ga9RMWqzp6Q/PJ00oVeq6pp6Ev8Dv85Z7wjLY4eCiaESUJgvo8pXT+7sOyBY/8H4
         5vyfiWW+vHUfedP8rH7lZk5qvlN3ewe/54f5UYLOQ/XsrQEsmbV9OhoZe/GPRrMUvHYJ
         2MABKJ8tn6Bm4e53x+Z4DqpNvpQ6Hbv5tJCN42IDLt1UelekXWYFVFjFaoc09Pbqtpew
         2tEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795521334; x=1796126134;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NJA5c5ZGXj57m63UhcAXfZFX1tNh4F39d5fl+LApCNc=;
        b=e6fqy6CWwQBP8kFSvugzCNEJQuwF8xPmrAbcW3WmujwsLofXF2VDv5/O4mY/dsuiPo
         KkJ3Ai9Q0WyOncLH6W3blXBn6ihXrgS2/GsAQ7VlH8uvqG7CdXQObHh1G3ssDDX5x/Ey
         WrGylifKMyaLSMnp2RExczNzTHM6BVUt7h3bEsMaqFunB8010yE2fZafC4wcmYwpiMVJ
         XAYkVvbYWLHtOFD5+huWyOYwtUYagh9aKfanIGSyOv1g3nOGkgH6R5Ji7pP8/PLMZG3r
         4cvY0C8bUBTKhp6eC5w1FGInBTvVQpW6+ot03M+n23I0jnv4sJE8zPDXHpkOKWFrtF32
         AzOQ==
X-Forwarded-Encrypted: i=1; AL+hErECPGiSPsfH+Z7HjEnEka/LrWCcMN3e2Wtu+KPBgeJxiebUH95jeQ5NhIFGXht+cxECtRb/zfi0yYaO@vger.kernel.org
X-Gm-Message-State: APuU4Z98wbf/FjoQTClRsQy4qUMvG9JAaHVs8tod+UXpDokCE6aazFsW
	QZPmP81MU6a0ehAnUfbxqi8wN/J9r0D64F6RTCGWfaqoa2hEkDv1AX0pw/BvFQt2o5FyUlsPS7/
	krxlLbjGtNGRbYoRs4+mlRIBas9K8t0Hn0OOvtHPPTs2PvPmiVWh/2VaGio1eCAo=
X-Gm-Gg: AZFdTZfMmh6U9ED9uV5QC7TLXWqYndnR8YB1Nybz/bu+sE1L6q0CgyN55rPnqeiTH2z
	mczag8Xz3f90Oy3sBjTW2eFSMryAAJBUbI/ajFJ4c8jLCi5f/aQ+jY2/yiukM9YlnOtAmZodSza
	JjKOhMxb2vMsxiZt/kEk5IDZxXKg3FuwyhMEzdLEQwYDjoaSpaKopix50d+RTAyexcuHfTHC2Zp
	aDVAVpG/2Lh8HF1ZgVgiLqVAMCAs8ybzI3a22RlsGgZZXPYhOo0KrYOgFEo4+/EqLL/gtKYfjFz
	b/xiaUBMR+kXi6+7/eJsSBz6DePXJKE4R8xTU6i9ilg6bh5uPNWxw3x25u2rRMLh+KBW23H+rpT
	h9OmRvB3pb3QoWPMcCHLPSwGw6vQNqtqHM18vxa17BEjMAS8nj05H+XuDyCVE5a8aoSS4WL+FdM
	cfdCVQgRKIpjWXntSPPuENohtAAcLcBuTQ1J2P8bTD1SiU
X-Received: by 2002:adf:e19b:0:b0:49e:f905:4698 with SMTP id ffacd0b85a97d-4abab6de682mr27768344f8f.2.1795521333984;
        Tue, 24 Nov 2026 03:55:33 -0800 (PST)
X-Received: by 2002:adf:e19b:0:b0:49e:f905:4698 with SMTP id ffacd0b85a97d-4abab6de682mr27768303f8f.2.1795521333480;
        Tue, 24 Nov 2026 03:55:33 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b70c05b9desm3403202f8f.54.2026.11.24.03.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 03:55:32 -0800 (PST)
Message-ID: <9fb09021-bd62-4a96-9218-7c2e0739734e@redhat.com>
Date: Tue, 24 Nov 2026 12:55:31 +0100
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
Subject: Re: [PATCH net-next v2 4/5] net/mlx4: track whether a TX doorbell is
 pending
To: Mark Bloch <mbloch@nvidia.com>, Joe Damato <joe@dama.to>,
 netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 daniel.machon@microchip.com, linux-rdma@vger.kernel.org
References: <20261117155353.2250540-1-joe@dama.to>
 <20261117155353.2250540-5-joe@dama.to>
 <add5a54b-eaa7-4507-b089-6a6c330c39b6@nvidia.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <add5a54b-eaa7-4507-b089-6a6c330c39b6@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/26 11:46, Mark Bloch wrote:
> On 17/11/2026 17:53, Joe Damato wrote:
>> When the stack sets xmit_more, mlx4_en_xmit() skips the doorbell and
>> relies on a later call in the same batch to write it. Nothing records
>> that a doorbell is owed, so a path that ends the batch without writing
>> the doorbell leaves the WQEs posted before it unannounced to HW.
>>
>> Add ring->doorbell_pending, set when the doorbell is deferred and
>> cleared whenever a doorbell or a BlueFlame write is issued, so such a
>> path can flush the deferred doorbell.
>>
>> Place the flag in the cache line dirtied by mlx4_en_xmit(), next to
>> prod. That line has no room left, so move tx_dropped, which is only
>> written when an skb is dropped, to the end of the struct among the
>> fields not used in the fast path.
>>
>> Signed-off-by: Joe Damato <joe@dama.to>
>> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
>> ---
>> v2:
>>    - doorbell_pending moved to the area of the struct marked as cache line
>>      used and dirtied in mlx4_en_xmit. In exchange, tx_dropped is moved
>>      among fields not written in the fast path. It is only written for
>>      drops and is read for stats.
>>    - Update the commit message.
>>
>>   drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 9 +++++++--
>>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 3 ++-
>>   2 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> index 97f27e005810..123071a47bed 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> @@ -194,6 +194,7 @@ int mlx4_en_activate_tx_ring(struct mlx4_en_priv *priv,
>>   	ring->prod = 0;
>>   	ring->cons = 0xffffffff;
>>   	ring->last_nr_txbb = 1;
>> +	ring->doorbell_pending = false;
>>   	memset(ring->tx_info, 0, ring->size * sizeof(struct mlx4_en_tx_info));
>>   	memset(ring->buf, 0, ring->buf_size);
>>   	ring->free_tx_desc = mlx4_en_free_tx_desc;
>> @@ -757,6 +758,7 @@ void mlx4_en_xmit_doorbell(struct mlx4_en_tx_ring *ring)
>>   	iowrite32be(
>>   #endif
>>   		  (__force u32)ring->doorbell_qpn, ring->doorbell_address);
>> +	ring->doorbell_pending = false;
> 
> Can we keep this in mlx4_en_xmit()? XDP_TX calls this helper too, but
> tracks its pending doorbell in a local variable. If the XDP TX ring
> stays full for the whole poll, this store can dirty the producer cache
> line even though we didn't post a single WQE.

I guess you quote the wrong slice of code and that you are referring to
mlx4_en_tx_write_desc(), right?
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index c5d564e5a581..9d8a4ea473f1 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -1074,6 +1074,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>          send_doorbell = __netdev_tx_sent_queue(ring->tx_queue,
>                                                 tx_info->nr_bytes,
>                                                 netdev_xmit_more());
> +       ring->doorbell_pending = !send_doorbell;
> 
>          real_size = (real_size / 16) & 0x3f;

AFAICS, preserving the state across poll() invocation is needed
for correctness. To avoid writing the cacheline in the XDP case,
mlx4_en_tx_write_desc() could return the new ring->doorbell_pending
value.

/P

