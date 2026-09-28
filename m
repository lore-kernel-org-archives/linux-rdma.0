Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4151730566F
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 12:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597781; cv=none; b=L21kU3QhTQlpzA+QdbsjVm2XUGD3yXfqFxq8JcwjS8NMtHV8pr7cVpTpjzg8V8leTGux/gDzl6oOpCpbU08vVhevmul12Rk4UUUcbfMy/X/PecIcSflDB4Eaccx/6Y+lv3jNpbLTrNQqTxlSWkcvAsBKG1kB1IpeTTAz+gFCt8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597781; c=relaxed/simple;
	bh=SBXZxQa4kJjRlY2WnPdMcAzS3W7SnPaDjqV3vwwL7D4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JgQZfKKSeKj3E3UP8cc4H1h7FHugNBhsERfzixHIgQsNVp3g8MQq2KBKi+ci4HusEhizSapIguXYcG06sxLtDmoE5TaBNP7xDnE+dUAKUT+33DNRbpSoarBsFI+ni9saI5mJ3DPSZsx+iG+nDQeJB2123h87hV0wk77zKU12m6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rOciz2Z1; arc=none smtp.client-ip=91.218.175.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rOciz2Z1"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SBXZxQa4kJjRlY2WnPdMcAzS3W7SnPaDjqV3vwwL7D4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790597777; v=1; x=1791202577;
 b=rOciz2Z1sXS7Z09WXa/wUaLyGb2DtPVrs7yY6AqTX9Rg31NJ4k28KRw5oPfKkAOBYgfjBMAd
 /Z9u6AtLgJ3aMSc3Th5EU9pRXBuS6D3COfROeElLDHbQI75i6lMrALjADqfKy3ktJgGDenuG0pN
 2KX+FLY8SmlE7b5xslbvNV0Y=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 15cbac2d8a85bc92;
	Mon, 28 Sep 2026 12:16:17 +0000
X-Mizu-Trace-ID: 15cbac2d8a85bc92
X-Migadu-Flow: FLOW_OUT
Message-ID: <dc059bbf-4897-4800-8468-961e6da95964@linux.dev>
Date: Mon, 28 Sep 2026 14:16:08 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] RDMA/siw: Fix new_cep use-after-free in
 siw_accept_newconn()
To: Leon Romanovsky <leon@kernel.org>, Wentao Liang <vulab@iscas.ac.cn>
Cc: jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org
References: <20260916184109.2092928-1-vulab@iscas.ac.cn>
 <20260923080801.GL563127@unreal>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260923080801.GL563127@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.09.2026 10:08, Leon Romanovsky wrote:
> On Wed, Sep 16, 2026 at 06:41:09PM +0000, Wentao Liang wrote:
>> On the error path the listening endpoint reference of new_cep is
>> dropped before the accepted socket is disassociated.  When only the
>> socket's reference remains, siw_socket_disassoc() drops that last
>> reference and frees the endpoint, leaving the subsequent
>> 'new_cep->sock = NULL' writing into freed memory.
>>
>> Tear the accepted socket down first and put the endpoint last.
>>
>> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
>> ---
>>   drivers/infiniband/sw/siw/siw_cm.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> I think this patch is supposed to fix it:
> https://patch.msgid.link/r/20260604160808.30948-1-bernard.metzler@linux.dev
> 
> Thanks

I agree with Leon.

Thanks,
Bernard.>
> 
>>
>> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
>> index f7ac81c0f267..1b93963cb191 100644
>> --- a/drivers/infiniband/sw/siw/siw_cm.c
>> +++ b/drivers/infiniband/sw/siw/siw_cm.c
>> @@ -1044,14 +1044,16 @@ static void siw_accept_newconn(struct siw_cep *cep)
>>   	return;
>>   
>>   error:
>> -	if (new_cep)
>> -		siw_cep_put(new_cep);
>> -
>>   	if (new_s) {
>>   		siw_socket_disassoc(new_s);
>>   		sock_release(new_s);
>> -		new_cep->sock = NULL;
>> +		if (new_cep)
>> +			new_cep->sock = NULL;
>>   	}
>> +
>> +	if (new_cep)
>> +		siw_cep_put(new_cep);
>> +
>>   	siw_dbg_cep(cep, "error %d\n", rv);
>>   }
>>   
>> -- 
>> 2.34.1
>>

