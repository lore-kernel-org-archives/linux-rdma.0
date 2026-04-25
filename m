Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D40514F70
	for <linux-rdma@vger.kernel.org>; Sat, 25 Apr 2026 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777132072; cv=none; b=VqQ6f27Vu2t89CPICSpcoPbvIneH9mih3Ch/bUscXUPf3Xs0/l88vl3HsOd5SnfYlYiqP5uzU3Hfq7qyE7uPKxayUwmJz0cpM5ydy//SHMk/djXpV90dhG3906B8E7zwIO4IheRjFG0wE+/Ukm6aloyUqj8dvzYryKU4VCwHILw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777132072; c=relaxed/simple;
	bh=wNjozK1+MnjBOgdQAl0MnW1BXRsXxEbgCD6HJSKhzI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eouI2CA5b4sWLgiotYmJO8JRYV2Nc2NxsJPmARN+hgFKHDVsnLQdt6q5kNKEuLVQuNWP2ZqHTBeKvzkj5lv1eorgDw+pkS4IPpkPIUqRJYjURLDCRIiifJjhf1+C/9f6aYrGSFayVGPmKqgI65kAckzzOpqFHQ2KVb0JerO7zi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdIza/iU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdIza/iU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BEAC2BCB0;
	Sat, 25 Apr 2026 15:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777132072;
	bh=wNjozK1+MnjBOgdQAl0MnW1BXRsXxEbgCD6HJSKhzI4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EdIza/iU2dBA+8OM931K7WU0qDPgIikF9KvjVgSUg5IS+OhwihQqeIHgr+wCIvZvO
	 6iHTAOqK8KnJGfoKsW6tugG+zksk6O8dv6OkMLbofidd2Oc+ZGHpwJnrlwuRt3ZyGz
	 fs++zpwJcGRO1Di8N0ZUdVvdZF0Dwz2c4kXtlpKARyOSPauTSeTxyQxWfe7EwUTIpO
	 KPdTJfe6Nd6pe1L2HgZvs6yZjPwpsZvU/nN5G9/uwh9T6BV3RUB/+7fzCzczC5cJpy
	 TgjRNsCHVUu0YGpLBDvk5+3D4qayX76fwN9SkqEwdfICkZD3b6WZq0/osPgPQPB4pg
	 3K4T1xT0ubGjw==
Message-ID: <35659770-6046-45c3-8714-c6d5bb140978@kernel.org>
Date: Sat, 25 Apr 2026 09:47:51 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] RDMA/rxe: Fix null-ptr-deref in
 kernel_sock_shutdown().
Content-Language: en-US
To: Kuniyuki Iwashima <kuniyu@google.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>, linux-rdma@vger.kernel.org,
 syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com
References: <20260425060436.2316620-1-kuniyu@google.com>
 <20260425060436.2316620-2-kuniyu@google.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20260425060436.2316620-2-kuniyu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/26 12:04 AM, Kuniyuki Iwashima wrote:
> syzbot reported null-ptr-deref in kernel_sock_shutdown(). [0]
> 
> The problem is ->newlink() and ->dellink() can be called
> concurrently with no synchronisation, leading sk leak or
> double free, etc.

My expectation is that the synchronization is managed by:

rdma_nl_rcv_msg()
    down_read(&rdma_nl_types[index].sem);

as the RTNL equivalent.

> 
> We defer UDP tunnel allocation to the first device creation,
> but this would requrie per-netns locking.

typo: s/requrie/require/


