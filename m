Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262FC3A05F2
	for <linux-rdma@vger.kernel.org>; Mon,  6 Jul 2026 23:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783380223; cv=none; b=C7jwSpniLHy5eV/2Oh1R/ILejJ2TVw266gmsVxqlXptxCPHK5FidUd86WiRO8f25IcUEzYGbYyF7Sv5Mx8FRtnZztNSswP3F3kARs6FQl6Z0+95F6FUq9/QEckF9Il6A8N/zJa0bdCBEXLLj52up2/KcVbQeHM0d7v3c8sGsU3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783380223; c=relaxed/simple;
	bh=1dkCcRzRd18KnTGB6yaBxvbYWMckLLYepEb/h4McykQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PpJSCuhvGTdOchsn2dePyimIDDtVFKALMQ5WSxT6roiws36twxuPxcxnGAnWCvUASnrDjgzt3rnWvp1YBXxKKz1kMHCEVhPkdexfVAB4SeJmBo+PG6kw7Xp01Dj2lvBc4tyiM006QvjIq7uUny4cFIMAzGo0BzqDP6hAFo8X1B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=esWLGkHS; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="esWLGkHS"
Message-ID: <5e449fbb-f48c-4acd-9f50-674c7834ed68@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783380210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KiaSNaQJqil735JVKLt1bpWnRFiwfKQXliA3r6pIik0=;
	b=esWLGkHSKH0tJ6fYC+mP/fILK6oYU90wixV2JHwy7gbBLP5CnFWGdCYmgtBCFFGd1gkN7t
	Fj+GamcnaqXrhrcHaYJweNCrwejIVxnbqww6lYB3k7i9MTGkI6ZAJKXN9pYdsRPNgyrlQN
	pXafCZWDRrELvNA344vcckguMri5IpQ=
Date: Mon, 6 Jul 2026 16:23:23 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/nldev: validate dynamic counter attribute length
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>,
 Michael Guralnik <michaelgur@nvidia.com>, Edward Srouji
 <edwards@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>,
 Edward Adam Davis <eadavis@qq.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260706091243.76784-1-pengpeng@iscas.ac.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <20260706091243.76784-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 7/6/26 2:12 AM, Pengpeng Hou wrote:
> From: Pengpeng <pengpeng@iscas.ac.cn>
> 
> nldev_stat_set_counter_dynamic_doit() iterates nested hardware counter
> attributes and reads each entry with nla_get_u32(). The nested container
> proof does not by itself prove that each child attribute carries a
> four-byte payload.
> 
> Reject hardware counter entries whose payload is shorter than a u32
> before reading the index.
> 
> Signed-off-by: Pengpeng <pengpeng@iscas.ac.cn>
> ---
>   drivers/infiniband/core/nldev.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 02a0a9c0a4a6..40b323131c7b 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -2133,6 +2133,11 @@ static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
>   
>   	nla_for_each_nested(entry_attr, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS],
>   			    rem) {
> +		if (nla_len(entry_attr) < sizeof(u32)) {

Maybe nla_len(entry_attr) > sizeof(u32) should also not be allowed?

As such, nla_len(entry_attr) != sizeof(u32) should be better?

Except the above, I am fine with this.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
>   		index = nla_get_u32(entry_attr);
>   		if ((index >= stats->num_counters) ||
>   		    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL)) {

