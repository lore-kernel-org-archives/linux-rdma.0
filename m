Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F53274641
	for <linux-rdma@vger.kernel.org>; Tue, 28 Apr 2026 05:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777353149; cv=none; b=TwQJqaRuMUoTMm8UVc0VOo2S6LMQs8cxId2k5+JXewNFwjg4Kccln5M8zJSP6uoHfr+nNqPpsYag3E7KT3PqPQszlX3zXwTJHbS5PqAoEspB/qUrT3FCCTuyylCaD9TIA7O8zpSd5E0cC0f0aDn2Whe4V70LU3Bf0X2KUJNN3Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777353149; c=relaxed/simple;
	bh=rA/S7tihoO60CQ1PPgYyjzxWC5aQY3zXwjdWEqqArKg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ujTWSINqOT10MQPYE6tdG8IoszmwhXrwKqMAMruYrN71KHeBC8HSYcHP67leVrneLe0Wxb6DIVSJwbbx6AJW755kkSFYGbLzAK3OxcOQhmduNLArzMz8qh+vLA2utJUm7Yt6wiProL3DGrq1JJgIDQABgb2Slq7VDyWBh10BANw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tYRgiUgM; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tYRgiUgM"
Message-ID: <bbaf583c-2170-41d8-9226-2d4e742f71d1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777353143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iEMdHSVBbPNOWiAk8LmQGWtCqKAvbVL+vgwSblVQjQQ=;
	b=tYRgiUgMBm4ZSTPGGWTOunJpClhxayUQazz/EuS6jFQol3IkQWuYPNu22DxCU9HNrQtoAW
	9c7m2oOJNqhb7mGdqyX44rrXI0Jd1SJgbOcSWjdxd0CuGfZXzMNa99SN086Yr2BNPebVLX
	Iag7EPfuy+xjafRT+dS+PRGDKrv+kTo=
Date: Mon, 27 Apr 2026 22:12:17 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] RDMA/rxe: Fix null-ptr-deref in
 kernel_sock_shutdown().
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: David Ahern <dsahern@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>,
 linux-rdma@vger.kernel.org,
 syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com
References: <20260425060436.2316620-1-kuniyu@google.com>
 <20260425060436.2316620-2-kuniyu@google.com>
 <030d3487-b5b9-4067-8b8c-89b4e8756e1a@linux.dev>
 <86499305-4522-4a82-a689-0247f2d5f6c0@kernel.org>
 <4196fe33-88c2-416d-ac20-b68bf7f328a6@linux.dev>
 <CAAVpQUAh2KT=YpfDO5nkqrzH0kbAXEBVe6jtOtLc93wjs3N7Fg@mail.gmail.com>
 <e2e1406f-8d9d-4a96-949d-e75096446d1a@linux.dev>
 <9681c9e2-79a9-4d72-b1ad-229ba6d7aab7@kernel.org>
 <0cf42593-0149-4019-a51b-36f74ff67f51@linux.dev>
 <CAAVpQUDVb4VDibeXz-DmAHF7gOAvDenSTGA6DpEwwS5HaQjM5w@mail.gmail.com>
 <0c1258e2-7060-4084-9a07-dd7af8262dec@kernel.org>
 <0ef2f2e0-e437-4ec9-8ebe-21c702041acb@linux.dev>
In-Reply-To: <0ef2f2e0-e437-4ec9-8ebe-21c702041acb@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/4/27 19:15, Zhu Yanjun 写道:
> 
> 在 2026/4/27 17:58, David Ahern 写道:
>> On 4/27/26 6:52 PM, Kuniyuki Iwashima wrote:
>>> To be clear, you meant implementing David' idea, right ?
>>> I'm asking because dellink won't need locking then.
>> dellink is not needed with my suggestion. It was added to manage
>> basically a refcount on the socket to close on last rxe delete in the
> 
> This is my original implementation.
> 
> @Kuniyuki Iwashima, can you reproduce this problem in your local host or 
> other test environments?
> 
> If yes, can you make tests after applying the commit in the link: 
> https://patchwork.kernel.org/project/linux-rdma/ 
> patch/20260424043522.22901-1-yanjun.zhu@linux.dev/
> 
> Thanks a lot.

Hi, David && Kuniyuki

I read the call trace again.

If net namespace has already released socket in A thread, then rdma link 
del command is called in B thread to release socket.

So A thread has released socket firstly, then B thread also release socket.

The similar call trace would appear.

The followiing is the explanation to the commit 
https://patchwork.kernel.org/project/linux-rdma/patch/20260424043522.22901-1-yanjun.zhu@linux.dev/

The double-free occurs as follows:

CPU 0 (Net NameSpace cleanup)        CPU 1 (RDMA device removal)
---------------------                ---------------------------
rxe_ns_exit()                        rxe_link_delete() (rdma link del )
    -> sk = ns_sk->rxe_sk4               -> sk = ns_sk->rxe_sk4
    -> udp_tunnel_sock_release(sk)
       [Success: First Free]             -> udp_tunnel_sock_release(sk)
                                            [Crash: Double Free]

After removing the socket release logic from rxe_ns_exit(), we ensure
that only the device destruction path (rxe_link_delete) is responsible
for freeing the tunnel sockets, effectively eliminating the double-free
problem.

I am not sure if this is the root cause or not.

Please comment.

Thanks a lot.
Zhu Yanjun

> 
> Zhu Yanjun
> 
>> namespace.
> 

-- 
Best Regards,
Yanjun.Zhu

