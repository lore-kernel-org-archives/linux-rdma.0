Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571909;
	b=eCRccd1Tk8Nc7YQ88T/Ul5T/C2dKqAWZOKhaypTyB8deRsc928JXoy5KrjNX+SfM550O
	 3Dj+OaYQXJUffuFvi0CUre2xyD0ggdtv5v8IJMZSfoVNpbAT6AJTamKHYf3lnc/Aki/PS
	 3z1FFa3NefLiwHDRGtQ6CQeMhsoLCldJWP8eyyKeoZy7vRxOpecqGTgNmVk+zyQWDAc18
	 g9A/vzBBzjS0M/J24z2Upm+nxOqG+Qrq7zNMh7zHvsKovvZ0ftRFgLV4UMRiDG7SekMrr
	 2qCUE+IR5ItOh0PdJoEhVJ7j9PYXUvhQ8bZrT7Ti3AaGTaLh3weL2HZCb91YZN4wzXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571909;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=efnN+vjdwzODKPHA9IZCXD52X2wkz8z0MwotasPDo5s=;
	b=MePEZl/xJ4GnN/ypnI5rmBQ5ToczTBUdChQ7Ie0QewJ22O1iuXBLJpipZ9/GE0hRP0Sf
	 mFIGzzqz9hNHfGhnrPk86oA72TJGGTArszb99x+6F4oMxyLIe2HB7RuLMSWqNncbpANN6
	 cQztPPSmh/nHBOu7odNA+26IrdYXNloLSA9N69PqzrpwGiePGcjVUWP+dG93S/NP0Y2p2
	 8SmU4mfv6t+XXnKOTs7FmzemLoU4B6mig9zQRYOEYuQcFaMxVwDvWE7BZTkQRXaSC4FqD
	 9dXM9GyzJT4XGsnLdjUFC4dWRX+SJGzbtU34nBpTtSkPqE48xlPVFnkSolCe9eeJsrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=qoiUyiAb;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3787606A327;
	Fri, 13 Nov 2026 12:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3787606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=qoiUyiAb
Received: from [10.26.7.43] (unknown [4.213.232.21])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5096620B7167;
	Fri, 13 Nov 2026 04:11:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5096620B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794571903;
	bh=efnN+vjdwzODKPHA9IZCXD52X2wkz8z0MwotasPDo5s=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=qoiUyiAb9ogcPQULCmFlF5bS7RfUK4+zSn0tqCw+wPVdVHs6nUs6TeuCrmUIvpNrH
	 vwNRipnWNvFvFAG4/ESDaqqgMqwFBvuHd1dw0H7Wv+PcPXq90CsgT8uGLeT2zI0nF7
	 JRSCiV4gcAyOGIx9zJf5AspwYn421WH2bQY2M8cg=
Message-ID: <08934876-5b05-45aa-adde-07f33d4e7379@linux.microsoft.com>
Date: Fri, 13 Nov 2026 17:41:43 +0530
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
Subject: Re: [PATCH net-next] net: mana: Add CQE polling as first-level TX
 timeout recovery
To: sashiko-reviews@lists.linux.dev, linux-hyperv@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
 <sashiko-outbox-212652@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <sashiko-outbox-212652@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13-11-2026 16:28, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Critical] net: mana: missing netdev_lock() in mana_detach() callers
>   [1]
> --
> 
> commit 6f4e15a96596e896188b6e028bb49a0d4c04269b
> Author: Sahil Chandna <sahilchandna@linux.microsoft.com>
> 
> net: mana: Add CQE polling as first-level TX timeout recovery
> 
> This commit adds a first-level TX timeout recovery mechanism that polls
> the stalled queue's TX CQ via napi_schedule() before escalating to a
> port-level queue reset.
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
>> index e6d494df22e4d..0d8c8b8fbc83f 100644
>> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
>> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
>> @@ -336,6 +336,9 @@ static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
>>  	if (err)
>>  		netdev_err(ndev, "mana_attach failed: %d\n", err);
>>  
>> +	/* Let the next TX timeout try a CQE poll recovery first */
>> +	WRITE_ONCE(apc->last_tx_timeout, 0);
> 
> [Severity: Critical]
> This problem wasn't introduced by this patch, but should
> mana_per_port_queue_reset_work_handler() (along with mana_remove(),
> mana_probe() on resume, and mana_xdp_set()) hold netdev_lock(ndev) around
> mana_detach() and mana_attach() [1]?
> 
> Because mana_devops sets .net_shaper_ops, netdev_need_ops_lock() is
> enabled on MANA net_device instances.  Queue teardown in mana_detach()
> calls napi_disable_locked() and netif_napi_del_locked() via
> mana_destroy_txq() and mana_destroy_rxq(), while mana_attach() calls
> netif_napi_add_locked(), netif_napi_add_weight_locked(), and
> napi_enable_locked().  Calling these under rtnl_lock() alone violates
> netdev_assert_locked(), leaves NAPI state unserialized against netdev-genl
> operations, and allows ops-locked ethtool callbacks (such as
> mana_get_ethtool_stats() or mana_set_coalesce()) running under
> netdev_lock() without rtnl_lock() to race with apc->rxqs and apc->tx_qp
> teardown, leading to a use-after-free or NULL pointer dereference.
> 
> [1] https://sashiko.dev/#/bug/linux-2946b7e7-6855-49c0-921d-a6daa482c10c
> 
Thanks or reporting this, the issue looks real and I will work on this
in a separate patch.
