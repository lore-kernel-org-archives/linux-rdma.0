Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E3A2AEE4
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 05:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785388539; cv=none; b=PCOzI5g5H4Pim3FL4zzrhm1KKtRZouGhei7idqElocc6PhExgBBzn712UPHl34YeipGb9rmvRcsrMqMWAlisf574DotjnUvCRFKbqQ5OjexjPbHq9cdZlj7MdF8YZOLwF6JGJxBmKDKwuBUCza6LcuUkt2QgEL8QQgKwkYCqQiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785388539; c=relaxed/simple;
	bh=DwLanO9+vp3AN49+A2U50lQ9FgNWrgfDVuWlK6x5YeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BUBys14597SLRQT6psNEtiJcyXgh/+ZYPvOjRqUMCBk1uQbIecXFGIHG79MI5ulaDg88Xq82HdzGog70HHTY8eG6Y2xP27Qr2p/tw6stBFd2PrjrEHbB4SXjBGlAkkdbarIDxTS0bAfOfqUY1vNz07WbW2OK1Y5an+7QLLzT9hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g7zYmB8Q; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g7zYmB8Q"
Message-ID: <f60cfa62-8fe3-410d-a12d-24ebd22a79fd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785388535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZITZtzpOtOEtWg/1z1B1iCs3/LhpA4imLx0mcpEa4E=;
	b=g7zYmB8QyJFVng0vMFyOQk1iryrxsE9u9Z+ySh53bawsP1NAutaId/ksk113h9Hr1a2jah
	XeXRznoRDn6D6pV7Lk+HDQciJNavUChWlu1eRQv5t6Cmxjf3AKGX+ncdYcUZLWbjHWqKqm
	78UvNSJr9JzgAo0jIUq55Y/oL7dLi04=
Date: Wed, 29 Jul 2026 22:15:31 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net 0/2] RDMA/rxe: fix mr_check_range() iova overflow
 (OOB)
To: Gang Yan <gang.yan@linux.dev>, zyjzyj2000@gmail.com,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, Gang Yan <yangang@kylinos.cn>
References: <20260728091128.9116-1-gang.yan@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260728091128.9116-1-gang.yan@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/7/28 2:11, Gang Yan 写道:
> From: Gang Yan <yangang@kylinos.cn>
>
> Hi, Maintainers
>
> I've recently started learning RDMA, using soft-RoCE (rxe) as my study
> platform. While pair-programming with an AI assistant during this learning,
> it flagged an integer overflow in mr_check_range(). I dug in, stood up a
> small reproducer, and -- believing the issue is real and worth fixing --
> put together this small series.

Do you have a small reproducer for this issue? If so, could you please 
share it on the RDMA mailing list?

I’d like to use it to reproduce the problem and confirm that this commit 
fixes the reported issue.

Thanks a lot.

Zhu Yanjun

>
> Thanks
> Gang
>
> Gang Yan (2):
>    RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB
>      access
>    DO-NOT-MERGE: selftest: add rxe mr_check_range() overflow reproducer
>
>   drivers/infiniband/sw/rxe/rxe_mr.c            |   3 +-
>   tools/testing/selftests/rdma/Makefile         |   8 +-
>   tools/testing/selftests/rdma/config           |   2 +
>   .../testing/selftests/rdma/rxe_mr_overflow.c  | 187 ++++++++++++++++++
>   .../testing/selftests/rdma/rxe_mr_overflow.sh | 132 +++++++++++++
>   5 files changed, 330 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.c
>   create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.sh
>
-- 
Best Regards,
Yanjun.Zhu

