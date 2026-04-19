Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C393373BF6
	for <linux-rdma@vger.kernel.org>; Sun, 19 Apr 2026 03:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776569708; cv=none; b=O/0uxltzZEpsk8iJ6w7DisP5TCcdGWk56GeyEfjC6pCSgNDxLLucSENkHaiX+GN3zocIca9hj9Ai0KO6yzxwy8GHszXXAwvRh705VJVWbCr4s7+kydvaD5NYabju9lG6uPz6xyvjJcl/idjLaGD9sbH5uGDokLa4YM5SaAdAVGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776569708; c=relaxed/simple;
	bh=ofQiTMHl4DWKqY/+S2NOYeSF5dxNp7Ur5u8hVXEiVjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jXH/9MBCOURfZMYfw/SM23eZVRIcYM2Hnq2YxRx7PA1a61CVwhtT5WbywbOXVs+d2bNhwlBA5SDwhLrmL0aoezm2/Qky0+G77kOvoMmsUIp+HIbNxj6r8M0xuZDfDnGrO5oB6I57vpfNsXs30FngVJxQ5jsp80H2iefOXAZUkzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q2IzFVWB; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q2IzFVWB"
Message-ID: <7176fdf5-55ed-4e95-ba15-52286975eccb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776569685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6DtKdbUbvKyMZZwB9YhEiF+u1y7IWhOmIfywqditr5c=;
	b=Q2IzFVWBDZU9cvt6m6iOr/5FDr5G87q9FwawivRw/8Un+F+jDkipceof/UB6Gqi64lMB/x
	tnXIAEp/00TFZEoGqYMvzupiCMUEGABb3tbdE6AgZeTBke9XnAy80XS4/mu8C/YWIJsns2
	dbxoDKt1Bpv/HCSFB9Wok2tKjNl6RWE=
Date: Sat, 18 Apr 2026 20:34:33 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: reject non-8-byte ATOMIC_WRITE payloads
To: Michael Bommarito <michael.bommarito@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Xiao Yang <yangx.jy@fujitsu.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260418162141.3610201-1-michael.bommarito@gmail.com>
 <06470bbf-ee39-4094-8c01-5860935af0f8@linux.dev>
 <CAJJ9bXza+XAX36-Fse1aW7FM-=G11bqKqf6Ds_9sArzUbZh9-w@mail.gmail.com>
 <1bd36ce7-e3dd-4ff5-867a-b8b9ade90a1e@linux.dev>
 <CAJJ9bXxd5jzzGcsf-sTw-v2zk-9Q0AtDrNwXRtyh-m5O9tr-6Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CAJJ9bXxd5jzzGcsf-sTw-v2zk-9Q0AtDrNwXRtyh-m5O9tr-6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/4/18 18:57, Michael Bommarito 写道:
> On Sat, Apr 18, 2026 at 7:18 PM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>> The fix should stand on its own, and the test case can be added as a
>> follow-up patch under tools/testing/selftests/rdma (or rdma-core if more appropriate).
>> This keeps each patch focused on a single logical change and makes review easier.
> It seems like mainlining rdma tests might not be a good idea.  I found
> the last time here:
> Kamal Heib, 23 Oct 2019 — [PATCH for-next] selftests: rdma: Add rdma tests
>
> I put the tests here and will PR it into linux-rdma/rdma-core tomorrow:
> https://github.com/mjbommar/rdma-core/blob/4104d991a764de4aad9f645a2f0ec723f6076209/tests/test_rxe_atomic_write_oob.py

Thanks a lot. I am fine with the above link.

Zhu Yanjun

>
> Thanks,
> Mike Bommarito

-- 
Best Regards,
Yanjun.Zhu

