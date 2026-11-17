Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904508;
	b=I07n80fR8kg2O9PLvgeQqeMPxgG6enWJ7GRtbO1HQZvvel5cZdb+2DnvgWI0J3uah8VM
	 /l7+hmf03S0T3Pfn/tuzgIAXqTNOURBrFozUb4i47BZR7lO7nSGHItgaAtJyOMCXFYhDx
	 6CieWnt0G6+KyKe9scJ2PWZjh0E9XPaRsKjHX4u+hrR2zuO5NzAg467NJ46WzBfrHrmRc
	 Fmu6v1+dgXy2OIhwWQDWTfA9EHZngVR8nu7c/cf7ZNlmM7RKQ+3ClTIw0Zzi3bhL1Nyyb
	 /UsHVr0lcBfQ/nEwGTHRWYISFaQqkhjawjfk8VXNKY4h7M6NtRVR1jq0WmNr+ehoByQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904508;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=9KAZFpOa4tylOS5Nw5xzUePTPvnbB87FGC6zFO/XDbM=;
	b=bsdaw499CN3E9n/ayTeBbL/LGvbr4Gp9T7zHN87859r5VRjB8967oVCmEHyOCnK+eZGn
	 8zg2WyMsTsIrDhJZWj/D4o+s/skkZkBh1q6linrsZm2XYqijjY3WxFxsAsCLTKHALPM8v
	 ee6ppase9MtNPkwD5rrhgUL1lxmGkv4AnEd7PbxbDMxbomt3ACLc13DZCgilRCIvfWGA+
	 SaEeJ8bnGvow2ZMB/UJr4OOgvHPrjNdBRtvI71OKkYbJ4mGfxsWiUy9EizNohVHJC4WHr
	 4wZHqmkpX5M1Qg6VSNAzGSH5a7JewVPY/ZUBCcOh5MtDpqmgAG98S28EtByXNJEK6jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n55I3HJr;
	arc=none smtp.remote-ip=91.218.175.18
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D3E606A88E
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 08:35:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82D3E606A88E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n55I3HJr
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hC1qvaPQfrqhp9FLOrn21Z0mMkfjkKTnJp1S1GHAOrY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794904500; v=1; x=1795509300;
 b=n55I3HJr2fMsajjR5X2DWFC3tDjhbtZnHlI/N4gevn5V11c2y7J0wzzBJoxsvX88VG2n1Bvg
 ZMKh4Fu+RqGVAlIalIWQ9Nj03Z0/sllq0P6mzVRhYZ1sZairwcAS0L2JzoVT9DXGP2eMM8N13nY
 JulW+PXb6aUQA6LoD88pPRhI=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 055bea7900dda262;
	Tue, 17 Nov 2026 08:35:00 +0000
X-Mizu-Trace-ID: 055bea7900dda262
X-Migadu-Flow: FLOW_OUT
Message-ID: <51c8a888-c0e7-4045-8395-380cda03ee2c@linux.dev>
Date: Tue, 17 Nov 2026 17:34:45 +0900
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
Subject: Re: [PATCH net-next] net/mlx5e: kTLS, Simplify error unwind in
 mlx5e_ktls_set_feature_rx()
To: Tariq Toukan <tariqt@nvidia.com>
Cc: horms@kernel.org, saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com,
 borisp@nvidia.com, witu@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Xuanqiang Luo <luoxuanqiang@kylinos.cn>, netdev@vger.kernel.org
References: <20261116110830.2850785-1-xuanqiang.luo@linux.dev>
 <b0f73ee2-fdff-4b5f-b8d0-43cd293d3058@nvidia.com>
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
In-Reply-To: <b0f73ee2-fdff-4b5f-b8d0-43cd293d3058@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/11/17 at 6:27 Tariq Toukan wrote:
> 
> 
> On 16/11/2026 13:08, Xuanqiang Luo wrote:
>> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>>
>> mlx5e_ktls_set_feature_rx() has become harder to follow: the error
>> handling is nested in the conditions and the main flow is conditional.
>>
>> Handle the error cases in conditionals, keep the main flow
>> unconditional, and destroy the accel TCP flow tables in a single
>> place. Use goto to unlock on the early return.
>>
>> No functional change intended.
>>
> 
> Thanks for following up on this.
> The change is correct, I see no functional change.
> 
> However, we can simplify the code further.
> See below suggestion where code is flat, the same size, and leaves the 
> enable argument alone.
> 

Thanks, that's cleaner.

I'll send v2 with this form.

Thanks!
Xuanqiang

>> Suggested-by: Simon Horman <horms@kernel.org>
>> Link: https://lore.kernel.org/ 
>> all/20261029134019.GG257209@horms.kernel.org/
>> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>> ---
>> Only compile-tested on top of net-next 7ccc5e05043b (arm64, W=1). I do
>> not have a crypto-enabled ConnectX NIC to run it on.
>>
>>   .../mellanox/mlx5/core/en_accel/ktls.c        | 23 +++++++++++--------
>>   1 file changed, 13 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
>> index 3cc1213c2f68..0f5dcd1b822e 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
>> @@ -137,19 +137,22 @@ int mlx5e_ktls_set_feature_rx(struct net_device 
>> *netdev, bool enable)
>>       mutex_lock(&priv->state_lock);
>>       if (enable) {
>>           err = mlx5e_accel_fs_tcp_create(priv->fs);
>> -        if (!err && !priv->ktls_rx_was_enabled) {
>> -            priv->ktls_rx_was_enabled = true;
>> -            err = mlx5e_safe_reopen_channels(priv);
>> -            if (err) {
>> -                priv->ktls_rx_was_enabled = false;
>> -                mlx5e_accel_fs_tcp_destroy(priv->fs);
>> -            }
>> +        if (err || priv->ktls_rx_was_enabled)
>> +            goto out_unlock;
>> +
>> +        priv->ktls_rx_was_enabled = true;
>> +        err = mlx5e_safe_reopen_channels(priv);
>> +        if (err) {
>> +            priv->ktls_rx_was_enabled = false;
>> +            enable = false;
>>           }
>> -    } else {
>> -        mlx5e_accel_fs_tcp_destroy(priv->fs);
>>       }
>> -    mutex_unlock(&priv->state_lock);
>> +    if (!enable)
>> +        mlx5e_accel_fs_tcp_destroy(priv->fs);
>> +
>> +out_unlock:
>> +    mutex_unlock(&priv->state_lock);
>>       return err;
>>   }
> 
> Suggestion:
> 
>      mutex_lock(&priv->state_lock);
>      if (!enable) {
>          mlx5e_accel_fs_tcp_destroy(priv->fs);
>          goto out_unlock;
>      }
> 
>      err = mlx5e_accel_fs_tcp_create(priv->fs);
>      if (err || priv->ktls_rx_was_enabled)
>          goto out_unlock;
> 
>      priv->ktls_rx_was_enabled = true;
>      err = mlx5e_safe_reopen_channels(priv);
>      if (err) {
>          priv->ktls_rx_was_enabled = false;
>          mlx5e_accel_fs_tcp_destroy(priv->fs);
>      }
> 
> out_unlock:
>      mutex_unlock(&priv->state_lock);
>      return err;

