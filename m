Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AC619F40A
	for <linux-rdma@vger.kernel.org>; Tue, 10 Mar 2026 00:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104155; cv=none; b=QyO+2uKtOGdj6xUjYPx2NHXvyW+pz5hrTI5NnMdNX9E+Ks5biqRKrb5UTATWBtKZG+iD/cQOCAIUERe+hy9gt1T0xqDh1SYx28zxOHOcWJTg2kP45zIke1USdeSOuutTQ9pBHxMSfKy+AxVvcPG+moM5absPRIGFAB7+l99GBoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104155; c=relaxed/simple;
	bh=iuFOTNOZ9nAny0GoOay9gi3ixhnGqhkwgs+PxXUc4tQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VDXb1xKhhBlHj1IQTg8BioFep7e5cXhpPiBmpKWr73kAUXMwxF0rlPsuXQ4I/0A+vOgk4Ywu1i0hizAhgjk+RhyqVBs6ffj3VvnBojoUGdMibECHM3ZbWPxzihBWjKwcbUZJEr2o8pLC6KoVYEC+b9d/N4I7FfUoaaOnAxuRlUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EGR84AU7; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EGR84AU7"
Message-ID: <0d451e5d-4621-4a9e-8689-1af101be95e6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773104142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jOfudJj+5I67Fi5+psnBJWqw2Jqw9Lkqu7qJblStpB8=;
	b=EGR84AU7yRueCszBW+dwf2RtZuG/XrvO7j0zYZ6qeaqvKXho4W523/Icvyv2xRYqVUDdjH
	3j63+C98AO7nhgVkxLnOY4YxUiVo7EDDHCCs5yQHbgrRPmrx7D3FMQTfnQq2Vf3EX8cCvF
	eaJzTk+le+aCMhkalUmrjBZzxr2QYps=
Date: Mon, 9 Mar 2026 17:55:38 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/4] RDMA/rxe: Add the support that rxe can work in net
 namespace
To: David Ahern <dsahern@kernel.org>, jgg@ziepe.ca, leon@kernel.org,
 zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20260308233540.13382-1-yanjun.zhu@linux.dev>
 <45947149-36ef-41f2-8ad0-aa3519344ce0@linux.dev>
 <83f6ede0-f65e-41a5-8c79-2d0d96cbff5e@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <83f6ede0-f65e-41a5-8c79-2d0d96cbff5e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 3/9/26 11:55 AM, David Ahern wrote:
> On 3/8/26 5:40 PM, Zhu Yanjun wrote:
>> # make -C tools/testing/selftests/ TARGETS=rdma run_tests
>> make: Entering directory '/root/Development/linux/tools/testing/selftests'
>> make[1]: Nothing to be done for 'all'.
>> TAP version 13
>> 1..4
>> # timeout set to 45
>> # selftests: rdma: rxe_rping_between_netns.sh
>> # server DISCONNECT EVENT...
>> # wait for RDMA_READ_ADV state 10
>> ok 1 selftests: rdma: rxe_rping_between_netns.sh
>> # timeout set to 45
>> # selftests: rdma: rxe_ipv6.sh
>> ok 2 selftests: rdma: rxe_ipv6.sh
>> # timeout set to 45
>> # selftests: rdma: rxe_socket_with_netns.sh
>> ok 3 selftests: rdma: rxe_socket_with_netns.sh
>> # timeout set to 45
>> # selftests: rdma: rxe_test_NETDEV_UNREGISTER.sh
>> ok 4 selftests: rdma: rxe_test_NETDEV_UNREGISTER.sh
>> make: Leaving directory '/root/Development/linux/tools/testing/selftests'
>> "
>>
> 
> Just put that in the cover letter; no need for followup emails to the set.

Thanks, will do.

Zhu Yanjun
