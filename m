Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27B8175A76
	for <linux-rdma@vger.kernel.org>; Sat, 28 Feb 2026 22:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772318108; cv=none; b=XLwJ48/d2VQRrStjUtcDhmE6DgBy6h/l0Bxx6m9Dd2uK6sGIu4ISn+SA1J7B8nwHVpY1Bo9rEiwFD6U7yHRz05g0xHBWfbpQcHX6O0ivTsOyqTbZvvX+eZWC57/3STDeJDlC2n/1D4WlL1wcdUw7H/3VIu+ABIA2+yPtZ45h/lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772318108; c=relaxed/simple;
	bh=Zu93DIcdmr6N7igC6YsHB8Nw0DBNUFS54rOZ82/1O/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LVrXDUzDLF2FiBPPrcoq0q9fTXG4zAH+paqDZ9nkIb7Kb2nSBba+yj0KOAB0P5LD/ksR8sGlYwCnF67WvIA7Bn1upNQ12m7lgKO10I9k56awgk7qjzTQ03A//kFAYHdlqPgdSaDVknILti53eWYsjh32XX6IOxPVb88f+A3L35I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 61SMZ0wg048650;
	Sun, 1 Mar 2026 07:35:00 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.2] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 61SMZ0oW048643
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 1 Mar 2026 07:35:00 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <68867ec9-28f4-4ec1-8639-0b970da148a4@I-love.SAKURA.ne.jp>
Date: Sun, 1 Mar 2026 07:35:00 +0900
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [rdma] "rdma link del" operation hangs at wait_for_completion()
 when a file descriptor is in use.
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
References: <cc96166a-a469-4bc9-bfbe-de6f40dffe97@I-love.SAKURA.ne.jp>
 <d800131b-d257-4dc7-adcf-7c35e7a223d2@I-love.SAKURA.ne.jp>
 <20260228164336.GQ44359@ziepe.ca>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260228164336.GQ44359@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav405.rs.sakura.ne.jp

On 2026/03/01 1:43, Jason Gunthorpe wrote:
> On Sat, Feb 28, 2026 at 03:07:29PM +0900, Tetsuo Handa wrote:
>> On 2025/12/04 17:26, Tetsuo Handa wrote:
>>> I found that running the attached example program causes khungtaskd message. What is wrong?
>>
>> I found that this is a deadlock caused by "struct ib_device_ops"->disassociate_ucontext == NULL.
>> If the thread which called ib_uverbs_remove_one() is unable to call ib_uverbs_release_file()
>>  from ib_uverbs_close() because it is blocked at
>> wait_for_completion(), it forms a deadlock.
> 
> That doesn't sound right at all, the wait_for_completion is waiting
> for other threads to let go of the context before closing it. rxe/etc
> that syzkaller is testing don't support disassociate so they need to
> wait.

This issue was not found by syzkaller. Please see the reproducer.

> 
> If the wait gets stuck that is a different issue.

My question is how we can support disassociate...

