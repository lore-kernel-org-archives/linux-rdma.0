Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793564808;
	b=lsCDZDJaAmMvZ2hMMQ8RvwAUX7mi9+2KvkbtycVUaUNZNNWiwMhJOwmPCCU4LSMjjiY0
	 NSXL8e10IeLSBeLsiSP0quBncm1uP8WvutHc1QcDaM6ZWEQ6u4KP0mr065yAVnCG8YKZR
	 3gof6Mao6TSlbllkaTJ1A5S6Aq1LFjolK/KpzwCHJPn/X/EAWl1v1hvjNL+GiKoJHXj+0
	 Rt8wk0mWyT1nZc2oOZclSrcRjFVoy6k+YXgPuYM0CoBf70cXWyzii2MjhhXDo+H0uXaTz
	 UsBUrQlVMf4+LCGTDOiYel2VAaQmaCE0AojOpl4GSZv1NkO8fq+8VMmOVRKPWH+g/BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793564808;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=TZTclBM2Rc74lAXSIjJcSZwH1U5B8657jxGK0J7gMB0=;
	b=AbJO/ydEdJHj6UMDOOqVdUZ5zfmJSvwKQdAefxhEtWqHSKcafKFAX/lY7TzOTWy0U0E/
	 +seSyaywlNSty9+7REuiFv8w97mO2njaMq3bqyiZtcMbgihd5l8ITeSGa+L/H5KQdQxDl
	 1I6rtglGJtyUuFTjN8xzIxJvtMn/wKResimlVADhH0aeH3m4Ms4pHtbEaFoHInf9TtkVU
	 eG1FcnYASf23t56sRwTU/fdiDud/3uodMwsN2z/jULsNHpk8evwz9v3VRlpJ8ZYao7z2K
	 o8ZtVb/z9WGjweUWCVSnyOhcCf8LEK/cfgDNMVhViig0135KdbV8Z73CGZf3Prv/Pyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dl47iK8C;
	arc=none smtp.remote-ip=91.218.175.58
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781A3606A324
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 20:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 781A3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dl47iK8C
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BiW9W2LRzF4ZdW9KoJHA1R7S7b9EP70fCKyOtVqjN5Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793564804; v=1; x=1794169604;
 b=dl47iK8CiQjkULbr31BebNC1rutAC3Gqsb6Ui8Wb005JEgng2kb/6azUYINS9b4E7d+DMFWl
 5aK//0Bg/aQxRACx436j69o31gyqjPEmGyt9zOlbfm+4y1oVHKaXuYBakpf0GGGyFlVcwhtx8Lg
 fMZkdXEgOLhK2Y7qgioTXfeE=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5ce2a615c38b8cee;
	Sun, 01 Nov 2026 20:26:44 +0000
X-Mizu-Trace-ID: 5ce2a615c38b8cee
X-Migadu-Flow: FLOW_OUT
Message-ID: <577128ea-4d44-45cd-8b3e-5f103e530d98@linux.dev>
Date: Sun, 1 Nov 2026 12:26:38 -0800
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
Subject: Re: [PATCH] RDMA/cma: Don't warn when device removal races with
 rdma_resolve_addr()
To: Deepanshu Kartikey <kartikey406@gmail.com>, jgg@ziepe.ca,
 leon@kernel.org, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: metze@samba.org, stfrench@microsoft.com, xiongweimin@kylinos.cn,
 ammrat13@gmail.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
References: <20261101105615.20253-1-kartikey406@gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261101105615.20253-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/11/1 2:56, Deepanshu Kartikey 写道:
> rdma_resolve_addr() on an unbound ID (RDMA_CM_IDLE) first binds it with
> cma_bind_addr() and then moves it from RDMA_CM_ADDR_BOUND to
> RDMA_CM_ADDR_QUERY with a second cma_comp_exch(). These are two
> separate steps. Once the ID is bound it is attached to the device, so
> cma_send_device_removal_put() can find it and set RDMA_CM_DEVICE_REMOVAL
> before the second step runs. The exchange then fails and hits the
> WARN_ON() added by the commit below.
>
> syzbot triggers this with RDS over rxe, where rds_connect_worker()
> calls rdma_resolve_addr() while the rxe device is being deleted:
>
>    WARNING: drivers/infiniband/core/cma.c:4120 at resolve_prepare_src
>    Call Trace:
>     rdma_resolve_addr
>     rds_ib_conn_path_connect
>     rds_connect_worker
>
> This is a valid race and not a kernel bug. If removal wins before the
> bind, cma_bind_addr() already fails and the error is returned to the
> caller, and err_state in the same function already ignores a failed
> state exchange. The caller gets -EINVAL, and RDS destroys the ID on any
> error from rdma_resolve_addr(), so nothing is leaked.
>
> Drop the WARN_ON() and keep returning -EINVAL, and document in a comment
> that the state may change because of device removal.

Resend this becase some error occurred.

For this specific case, we can consider this behavior expected rather 
than an error and remove the WARN_ON().

However, I'm not sure whether the WARN_ON() is still necessary for other 
test cases.

Yanjun Zhu
>
> Reported-by: syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6699995b421c8ec7d2fe
> Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
> Tested-by: syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>   drivers/infiniband/core/cma.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 337a49d1acf7..46741c1fd34b 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -4117,8 +4117,8 @@ static int resolve_prepare_src(struct rdma_id_private *id_priv,
>   		ret = cma_bind_addr(&id_priv->id, src_addr, dst_addr);
>   		if (ret)
>   			return ret;
> -		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
> -					   RDMA_CM_ADDR_QUERY)))
> +		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
> +				   RDMA_CM_ADDR_QUERY))
>   			return -EINVAL;
>   
>   	} else {

-- 
Best Regards,
Yanjun.Zhu

