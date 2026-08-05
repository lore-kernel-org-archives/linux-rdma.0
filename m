Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73095361DDA
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785945433; cv=none; b=YPhCwZX2FXvVFfSnh3Cx3mAB4lNPznDByKNoIR+0oj75tay/Nwr6j9NdaOcjWcmU9dXiMJjERRT//CfM3j8muefrMQXEthDPOBiEexY5AlzpLivjMdhpdtRt2GB5imHxMHx6V6CEd1Gots4Yx1EQ1X4DboosULMpfe0ha4cZ8BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785945433; c=relaxed/simple;
	bh=CMyvMFSUMbs78SYl2DUCOtduRjG1CUTbiniU89sIDSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MkvvZXwBQmImqup9PTDgak35F2A7IOMn19EpIF0Y95v/2AwOgGH/E4EuSuvo0dFPxKdhaGNEu/VZ0u3jNeJjOlt34k/tUXmjsygWbniB08sG6M/gi5YgZYV0/GnDpK396U2+L+7PQVyBkxhfas+QURAgAPKAd0BN4aDyV683dco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IxqPqv+e; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IxqPqv+e"
Message-ID: <79542318-04be-44f0-947d-7a02e093665f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785945429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Xb9e2J2pRxPTPN8UaaD6EaiSrJkKgi0xmqt85/KEcw=;
	b=IxqPqv+e/5iOshZvjwSdUfRNlcxAdg0NLMxcQqd+fPbspXSr4Pogllul8p1uX8k9O4tDsH
	7FKFS+6ckliqPZPLV+4SU2OwMmKnUT5rcp2k2F36OSnlt6iB7X2MccZQlkKBuEgC3MniIx
	nMpP/MA//Jvh6xZYNJNXNURHMvH1rMg=
Date: Wed, 5 Aug 2026 08:56:30 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net 2/2] DO-NOT-MERGE: selftest: add rxe mr_check_range()
 overflow reproducer
To: gang.yan@linux.dev, zyjzyj2000@gmail.com,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, Gang Yan <yangang@kylinos.cn>
References: <20260728091128.9116-1-gang.yan@linux.dev>
 <20260728091128.9116-3-gang.yan@linux.dev>
 <c93089b8-bb9f-4aac-a644-36b6cc9b5d59@linux.dev>
 <36d31c1e-aebe-4a48-ab44-4447c0a75a33@linux.dev>
 <393f97fc5e5c042d5bd62231f96fae0b527a58d0@linux.dev>
 <9daf85d5-e12d-4498-86e6-aa6180a91df5@linux.dev>
 <9e00be256dee0ad1d163ed0e26d2c15b238efc68@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <9e00be256dee0ad1d163ed0e26d2c15b238efc68@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/8/5 0:47, gang.yan@linux.dev 写道:
>> Thank you for the clarification.
>>
>> I agree that we can drop the selftest patch. My original suggestion was mainly to make sure we have proper coverage for this issue, but after considering your explanation, I think adding a standalone selftest for this particular case may not be necessary.
>>
>> The bug fix itself is the important part, and keeping the selftest out will also avoid adding a test case that may not provide much long-term value.
> Hi Yanjun,
>
> Thank you for your feedback.
>
> No offense at all.
>
> Regarding Patch 1 (the actual fix), I noticed that it hasn't received a Reviewed-by
> or any further comments yet. As a newcomer to the RDMA community, I just want to
> make sure I'm following the right process. Should I proactively send a v2 with only
> the fix (now that the selftest is removed), or is it preferable to wait for more
> reviews on the current version before resending?
>
> Please don't take this as a nudge — I'm genuinely asking because I want to avoid
> missing any step that I should be taking on my side. I'm happy to wait if
> that's the usual practice.
Hi Gang,

I think it's fine to send a v2 with only the fix. There's no need to 
include the selftest in this series anymore.

If you'd like, you can also add the following since I have reviewed this 
commit and made tests in my local host. It can pass my local testcases.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Thanks,

Zhu Yanjun


>
> Thanks
> Gang

-- 
Best Regards,
Yanjun.Zhu

