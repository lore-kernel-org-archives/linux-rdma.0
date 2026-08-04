Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9E71C861D
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 02:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809870; cv=none; b=cmSBwhp/6trI2Csjfx4rqqfWbLJEsssfzX5MjOzcquNkwKGMBDgWslxMb9lu+AKklkuJ31vWGNwhNwBMDAM7NQHxqJ7G14mJj2xjsLrPz2tFdocB2KudTICi/Gn0sT6qxkzJeiQ+cDIF1MMpGIYfMcszJ1STpH7di1de4M8eFaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809870; c=relaxed/simple;
	bh=vRJ5iXwNgeswcAgFf74VjQh4DfD/Vv9t45FE2sv6VOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YxveGJdTWo3U1R3FuqCnYM7Fbq+RlukFmvGCtCQkCpuU7kwH9+bm7hasSEGJ9UKAd0L63NQOBN9yr7zjtWXvEdzACMrtA+9gKdUBu4f5Fx8IULy0ycbof4zn9a2OymJhYmmuuMMrcHwq59NZPDE40UjAiH6mJe0Qn2nTj8PfU+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D4Jvmpip; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D4Jvmpip"
Message-ID: <9daf85d5-e12d-4498-86e6-aa6180a91df5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785809865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ku0vFpu8WPvXRIM/wyhguPGVryiII3x78I1j9EgOzPE=;
	b=D4JvmpipGlAH+KiRlzMWCBy/lDJFgw388JztJ/8kKhDLAgvtEat+bhAZkbODRT/sSYteSX
	eg9qfBHDgS6XznmLA+08yunk1tH91rGGfqTvR7Wp6P7FCmLOjhJG1zONJwDWpHKsZLiEBw
	N9mcZ4X7q5WkZKiFJlWqvXbpBLNUFv0=
Date: Mon, 3 Aug 2026 19:17:36 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net 2/2] DO-NOT-MERGE: selftest: add rxe mr_check_range()
 overflow reproducer
To: gang.yan@linux.dev, Zhu Yanjun <yanjun.zhu@linux.dev>,
 zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, Gang Yan <yangang@kylinos.cn>
References: <20260728091128.9116-1-gang.yan@linux.dev>
 <20260728091128.9116-3-gang.yan@linux.dev>
 <c93089b8-bb9f-4aac-a644-36b6cc9b5d59@linux.dev>
 <36d31c1e-aebe-4a48-ab44-4447c0a75a33@linux.dev>
 <393f97fc5e5c042d5bd62231f96fae0b527a58d0@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <393f97fc5e5c042d5bd62231f96fae0b527a58d0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/8/2 18:49, gang.yan@linux.dev 写道:
> August 3, 2026 at 6:28 AM, "Zhu Yanjun" <yanjun.zhu@linux.dev mailto:yanjun.zhu@linux.dev?to=%22Zhu%20Yanjun%22%20%3Cyanjun.zhu%40linux.dev%3E > wrote:
>
>
>>>   Thanks a lot. When I run rdma selftests. I got the following:
>>>   "
>>>   # Warning: file rxe_mr_overflow.sh is not executable
>>>   "
>>>   You need to make rxe_mr_overflow.sh executable.
>>>
>> After this testcase is run, please remove this bin file rxe_mr_overflow in tools/testing/selftests/rdma.
>>
>> Thanks a lot.
> Hi Yanjun,
>
> Thank you for your reply.
>
> Regarding the selftest patch, my initial thought was that the selftest does not need to cover this particular
> issue separately, which is why I added the DO-NOT-MERGE tag.
>
> However, after reading your feedback, I would like to clarify your suggestion: do you mean that I should
> integrate the attached rxe_mr_overflow.c into the selftest suite? Or is there a different way you would
> recommend?  If you fell OK, I would prefer to drop this selftest patch entirely.
>
> Please let me know your preferred approach. I'm happy to adjust it. Thanks again for your guidance!
>
> Best regards,


Thank you for the clarification.

I agree that we can drop the selftest patch. My original suggestion was 
mainly to make sure we have proper coverage for this issue, but after 
considering your explanation, I think adding a standalone selftest for 
this particular case may not be necessary.

The bug fix itself is the important part, and keeping the selftest out 
will also avoid adding a test case that may not provide much long-term 
value.

Please feel free to remove the selftest patch and keep the fix patch only.

Thanks again for your work and for discussing this with me.

Best regards,
Zhu Yanjun


> Gang
>
>> Zhu Yanjun
>>
-- 
Best Regards,
Yanjun.Zhu

