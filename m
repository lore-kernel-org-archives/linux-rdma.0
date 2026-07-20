Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21E93B9DA4;
	Mon, 20 Jul 2026 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565126; cv=none; b=XWfeuAYN8qVD5joJ51qmls/XDz2G8fde7eaTnkZUVhqneWRyunZIC0ZY2hAeVgFZwIl+VasWeTp4nAtLAI6vaYkG3zQ4dUnz8IEofSKaPR2eAiP7Y/fBURFWJ26nPXEP2D+GY+GVmYIgLhItCWDk/Gbggl6X5ybfPfQ0p8/GLOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565126; c=relaxed/simple;
	bh=Cao5QjP6I3mRmpJh7B6L0fAsxbxCfWZAM3YG2f1OR/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qo1dzhLsHXymsLzjjjGH/li+fjNhmcjU8sfzpLIpP6t86/TMQQ6ALt4sJJeC7g7HcKNHNqs/iK2uerUyIunl07avxlWre3KtGR8aE8qQb57TM1odP8qvGdO3WT69s4ILiTYtlD0vtZYNmqgOgunLVUj/1TRjujsdoqi6X8+OnG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bGk3bsd+; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bGk3bsd+"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h3mJ41tbJz1XM5kt;
	Mon, 20 Jul 2026 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784565120; x=1787157121; bh=D0NipGl3diV8adlTQW+lpXtX
	x3pdPHuDF8yVgAQnJWU=; b=bGk3bsd+hm//uA/TVdn4MxETkVQUFuNhdcavfCPz
	QbOB25qW7U6y05QgyWibMqNLppdujYNNErm+Rfu/TrAfQcMbToHSFjq9GeDZTCus
	1oIgXbk8hWu93CRVKw+Q0WBfUctf89Tv6/rVondN07TuBHVyB4Zcpdrh4ef6M5CA
	4t7vNjG7pl41lAjisL4kIN0QkS8QJoRG5iXeppqcQcn6TZR3XgS5gUU0wPeNj9iw
	8H5ednHnSQbgBONp7V2G21n8Ynv8Yzgw7+16yFy2OM+mumzTSht+56Q5hfW25urp
	dcH+p7WDZxqFoXU/wNioSAxDAK6u1q2T/bCI5F7Fcj2Pzw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FLd0CByooM6v; Mon, 20 Jul 2026 16:32:00 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h3mHz14R0z1XM5kW;
	Mon, 20 Jul 2026 16:31:58 +0000 (UTC)
Message-ID: <e5c8e258-8c57-40c8-88a9-04173392e9ae@acm.org>
Date: Mon, 20 Jul 2026 09:31:58 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srpt: fix NULL deref when sending BUSY before
 target_init_cmd()
To: kensanya@163.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, TanZheng <tanzheng@kylinos.cn>
References: <20260720025941.69809-1-kensanya@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260720025941.69809-1-kensanya@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/26 7:59 PM, kensanya@163.com wrote:
> +	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
> +			     scsilun_to_int(&srp_cmd->lun), 0 /* data_len */,
> +			     TCM_SIMPLE_TAG, DMA_NONE, TARGET_SCF_ACK_KREF);
> +	if (rc != 0) {
> +		pr_debug("target_init_cmd() returned %d for tag %#llx\n", rc,
> +			 srp_cmd->tag);
> +		goto busy;
> +	}

This will cause target_send_busy() to be called on an uninitialized 
command and that isn't allowed, isn't it?

Thanks,

Bart.
