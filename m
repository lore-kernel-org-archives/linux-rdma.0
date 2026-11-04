Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801622;
	b=euJbZ3t+QYr6hgR8ncf3QrRSoWv6/us2G5GeDLls4xAxsU635fSse1fIW2CtOzgaEfel
	 1OVoG0kBud9xUPhqGXLlD4j86AT+zz9/JRzI2D5zH6iqcP0T7s9ZFsZIXLvhCbUAWxJ/T
	 hwJFJGAJrAtmyNpkfPNs06xefXqH+bjzOMYV7v14An0A/Se3yjqEAkDl/1CeXDEj9xyt4
	 pd9B5nNE7Vrs3Ys2q7o+aSRLgtx2NUj0NC+FMps7csWsfPpj3ztL6q04EG4HobVwB5P2B
	 3d0V/wXwguh5DBMeARot4+EOkOkmHS489MmzDPzWIVWQiHHOz/KV1Sn2ecXGU21/H9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801622;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=C39tlu6xlshMWq2hwsMtOj8GLZZ3XOveWxHL0ZGLUl8=;
	b=aO+gPk6A6N7UHnHGFWFRsWoY/Vhay34QJMsP1vXQtIT97yo9b/mrLvf7uymUjriQok0V
	 jGT46l2sIPYfSrZ0aVckfBQgQIdPYQS9KIrbNdZmU97F7rZCtJDKXbShU3LxpVUaGNvU8
	 SXPbEcmF+NzKtZlHYpgBE9HWCI4E742mcq33Qwnc+kaih1bNUDE3tJo/LW5FpGwUaiZvw
	 x/DL2ciCqfRzm83g5gpUqLE9ay/eprDzUpHXFzpusZfHTIBzduqLTDdZYoJBevZPH4CwJ
	 e6GrQwGHlQ2WdB5J6TbffyVymPEnJIECKZE5l5DFxxJvOl13JaEtrQHnQbydcLyY0KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PxNRKQfV;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=mmqt+Q1j;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A7A6082BE8
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 14:13:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27A7A6082BE8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PxNRKQfV;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=mmqt+Q1j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793801621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C39tlu6xlshMWq2hwsMtOj8GLZZ3XOveWxHL0ZGLUl8=;
	b=PxNRKQfV4OjX8TeeGFNfQUapcOITxfErTAIv8eK3cgVXVPJ2TaEiMUgLc3G18ohtZj7E9q
	d0lUvy0fvVbI4VsYC8Ee479Yw0qxVxWGMDV/CxYOmncaRIec/Yg+nl8ENr7lGmzNsqWyLC
	R3Fei/gXUJz49gYhWBRcFCzUhirQ5iE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-B2CV7l0MN5SIftpMERPYQA-1; Wed, 04 Nov 2026 09:13:38 -0500
X-MC-Unique: B2CV7l0MN5SIftpMERPYQA-1
X-Mimecast-MFC-AGG-ID: B2CV7l0MN5SIftpMERPYQA_1793801617
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48b027578a4so631869f8f.3
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 06:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793801617; x=1794406417; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C39tlu6xlshMWq2hwsMtOj8GLZZ3XOveWxHL0ZGLUl8=;
        b=mmqt+Q1jLBJ5qfdX9Trw0Nt9nJEV2+9qd3k9y4/cbx+4mJlCsizDVidStqFpBHHdmv
         ZOhfM1LLFqA+wFzCyrlsE4MdyHYwBVVLrXrxbtOm28xzqn+oe/G3gytRxO6ql8cGL68m
         lvKUBEHIyO8vhWQjF/cnG2ChO4jATV0cLpbF5Gu33rwi1Fo8B/O+RaNXru+YJm6fkgcm
         WYqG0RGbNz4VoszIVQKkZA9RMejtfLHb8Y7EBEApw2eC5ZTuId8BO/JwKD8dy5NO+7OV
         3QdMSwAb6ZEkxZd4+BNcg+llu4p+hVBSfT+V1xUJydBLPOblgixaVyyvCPbLKSUSE+8V
         zesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801617; x=1794406417;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C39tlu6xlshMWq2hwsMtOj8GLZZ3XOveWxHL0ZGLUl8=;
        b=hSS4CyOm6yjE80n3Cj8FqeAfddAloBb0C+J9WGhHc/0l5bCSg2EUWHsarPVvjEx+fb
         B2ACR1g9RFNuGMtDP6tXiB9FQJTg9qpkUcP2erOM0Nq4D6K7TaH2QX8H6jvQUC7AMCXY
         mb9VIYYWXlBbWWUMA0770Gs2aANSyHwO6Cgi4+lZs4iX3cX/GOFpaR7UkU7tzbydI1eQ
         8pI5HWq3EoDYoejSkrEE7jw2Ar+fIymlDrx+LsK+1QpHl8f7bx4CSAg0u7W3HiiBneRe
         bbNy/PZLur1hsMubu+NK0991DIL3chPDJHfMA5CdT1wWnGuwfX8JInMctKQrzY0aW792
         JF0Q==
X-Forwarded-Encrypted: i=1; AKwUvBypnB7/EMPnWzUz95110VhqFaqKHf/65/vBZ8jlBxN57FP5VPAOYXeGV1v4ret715dqHWaqjYhkSJrI@vger.kernel.org
X-Gm-Message-State: APuU4Z8e5b7Z13/R7yXWTDRcAhtPTVQqGaVQbe/PA2k0YR2LG4oZLSEg
	1v2k5wuS7+eCISy4WLWkasQl4T9E+7em0iURNRAAbcQtwa1Es7ttaj7dK4qm1QsYBArjUneHMM9
	Jgm1yH7Z4RDWmkcFvKy8fGDvivxFMAGXX+GNMe85+NwezutRikebMI9alLW5RaiI=
X-Gm-Gg: AYBFou2olZJtNdayOsE5S9cOMaHVDMFn4YfCFJWbvb7otC8t0AoJsT4cHLa6l9ATZEX
	m/vTTQH5THVqvazZCya0oNJ3BG5SSuSsdr3r6lJwik5NpjyQx6uya9q043VbPQjVZnNYoFxRu0o
	Bj3ZjsOiqB1ZhfI2MuVH4X2K9WtJT5DfTabiMPFh6zw4dvQcVQ9iVSDXRlpQELnNTzICu2o4Y6n
	49L2oEfzLZPqNYNow31JkiSE+n8q9XQkOD7UoPIYdn7FPEU//weGffmODMVcs+Uj9KC0L8ERatl
	jWxhjeAs6Q62s734kW/3aM2NFkb8sTF95drsyaYtGvsI24LN167+/yL7mAzNE8BeVmrNPTqrW2m
	ueCkeOB8pUrOmcdc59I4m1Pc+l1nxqPPu9ZLSHyWZyHW6x/k6VtrcEpZJMg4zojpfMdTyjZx78Y
	muOTX5F8IOmsXKmvs85Hl47mCwqydiHtLeZS42A8suchI=
X-Received: by 2002:a05:6000:2313:b0:488:7d08:edbc with SMTP id ffacd0b85a97d-48e6e30ba6fmr37096702f8f.24.1793801616628;
        Wed, 04 Nov 2026 06:13:36 -0800 (PST)
X-Received: by 2002:a05:6000:2313:b0:488:7d08:edbc with SMTP id ffacd0b85a97d-48e6e30ba6fmr37096644f8f.24.1793801616114;
        Wed, 04 Nov 2026 06:13:36 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fe7189883sm4443181f8f.0.2026.11.04.06.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 06:13:35 -0800 (PST)
Message-ID: <b5187890-a0df-45c9-aeed-3b1fefba57ab@redhat.com>
Date: Wed, 4 Nov 2026 15:13:33 +0100
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
To: Tariq Toukan <tariqt@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 "joasantonio108@gmail.com" <joasantonio108@gmail.com>,
 Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 "leon@kernel.org" <leon@kernel.org>
Cc: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
 "edumazet@kernel.org" <edumazet@kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "sd@queasysnail.net" <sd@queasysnail.net>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "horms@kernel.org" <horms@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
 Boris Pismenny <borisp@nvidia.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <179313582625.87630.11382992904624255106@gmail.com>
 <e91e786d3bf20ed981ab2d214ae3358d137d597e.camel@nvidia.com>
 <94dfe8e7-5eaf-45be-94f5-7d2e2b38fdb2@nvidia.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <94dfe8e7-5eaf-45be-94f5-7d2e2b38fdb2@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/4/26 13:49, Tariq Toukan wrote:
> On 04/11/2026 13:20, Cosmin Ratiu wrote:
>> On Tue, 2026-10-27 at 18:17 -0300, Joas Antonio dos Santos wrote:
>>> macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable
>>> with
>>> rhashtable_remove_fast() and then frees it with kfree() right away.
>>>
>>> The TX (SCI) table is read locklessly from the transmit path:
>>> mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
>>> mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
>>> rhashtable_lookup() under rcu_read_lock() and then reads
>>> mlx5_fs_id->id. A transmit that looked the entry up just before it
>>> was
>>> removed reads freed memory.
>>>
>>> Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per
>>> MACsec
>>> device inside macsec steering") the SCI table held struct
>>> mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
>>> kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
>>> with the new struct mlx5_fs_id, but frees it with a plain kfree().
>>>
>>> Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().
>>>
>>> The same issue was flagged by the Sashiko AI review as a pre-existing
>>> problem while reviewing the HW-GRO for PSP series.
>>>
>>> Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
>>> device inside macsec steering")
>>> Link:
>>> https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel.org/
>>> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
>>> Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
>>> ---
>>> v2:
>>> - Drop the macsec.c hunk: the sc_xarray_element free was already
>>> fixed
>>>    by ad17ad50b8dc ("net: mlx5e: Fix use-after-free of the MACsec
>>> xarray
>>>    entry on RX SC deletion"). (Simon)
>>> - Embed an rcu_head and use kfree_rcu() instead of
>>>    kvfree_rcu_mightsleep(). (Simon)
>>> - Fixes: now points at the commit that introduced the kfree().
>>> - v1:
>>> https://lore.kernel.org/all/179285888829.90275.17386097105525068016@gmail.com/
>>>
>>> Testing: compile-tested only (arm64, W=1, CONFIG_MLX5_MACSEC=y, no
>>> new
>>> warnings). I do not have
>>> MACsec-capable ConnectX hardware, so this was not run on a device.
>>>
>>>   drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
>>> b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
>>> @@ -94,6 +94,7 @@ struct mlx5_fs_id {
>>>       refcount_t refcnt;
>>>       sci_t sci;
>>>       struct rhash_head hash;
>>> +    struct rcu_head rcu;
>>>   };
>>>
>>>   struct mlx5_macsec_device {
>>> @@ -684,7 +685,7 @@ static void macsec_fs_id_del(struct list_head
>>> *macsec_devices_list, u32 fs_id,
>>>
>>>       xa_erase(fs_id_xa, fs_id);
>>>
>>> -    kfree(fs_id_found);
>>> +    kfree_rcu(fs_id_found, rcu);
>>>
>>>       if (macsec_fs_is_macsec_device_empty(macsec_device)) {
>>>           list_del(&macsec_device->macsec_devices_list_entry);
>>> -- 
>>> 2.39.5
>>
>> Thank you for the fix, it looks good.
>>
>> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> 
> Acked-by: Tariq Toukan <tariqt@nvidia.com>

While I have your attention, there is another mlx patch pending:

https://lore.kernel.org/all/20261028145805.54595-3-fourier.thomas@gmail.com/

/P

