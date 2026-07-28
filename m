Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30FB384CD1;
	Tue, 28 Jul 2026 11:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785238636; cv=none; b=f4tXcSQX+ctDHEt1u9I6AnsEPbIjdqtutJ5bVVMzhPC99Z6WKQ3G1oWd5SzgF2ple1lsTb4WDkg28U97WBeaLYG1pMRXTNc9jye3d+FRxiPkpbkmrc3YEbJzv/dG4tljSpLnfwjLNHt3fQh2VI5eR9BFTKjZ8vcFaEUVxf/mwLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785238636; c=relaxed/simple;
	bh=9Rka7PqY93z5NlRwJnKe56x5z6jdTCf/o/Szyc76aFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tDNdZHEmXX5tLCADv3uXQlwX1tSSthIYvcZPO+6LEkKn73ZBErjqpgAaMZ0gOW0cuo+eRkEekZoxF1BqotbPckbFlHXtFpKg9g8VAz353KEA+ErsFNJRpz1XVWqk3xc0VcVeGU60eLSk9w0fTQk4aJklhq6ARmPdauFJGYjXgmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VCfg1RLV; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VCfg1RLV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785238627; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=jkYJfqj3q6zOmjb9xF64tdOwzEH4MqIt3aPdm8N0htc=;
	b=VCfg1RLVqWGfggSN8WEDr37ku75noAb8WfA7qDpJYSaNEn+eEDVV05cJ06TRqQdh7wf9kN5TB2gNjhWp3l/nj5lsHC02k950C5prAY0OtUqKMZsqMwXlsWfeAn0MPeKaQnEsbWUzvcmwxhce4lqzZwXMUH+n+93rox2/1FpmGIY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8-kB6Y_1785238625;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X8-kB6Y_1785238625 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 19:37:06 +0800
Date: Tue, 28 Jul 2026 19:37:05 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Paolo Abeni <pabeni@redhat.com>,
	Ibrahim Hashimov <security@auditcode.ai>, alibuda@linux.alibaba.com,
	wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: validate peer CDC cursor against RMBE
 size before accepting it
Message-ID: <amiUYVILfbgKPUte@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260722101758.37817-1-security@auditcode.ai>
 <a0d58258-4042-41e9-ab32-8f7e5deba5e5@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0d58258-4042-41e9-ab32-8f7e5deba5e5@redhat.com>

On 2026-07-28 12:04:32, Paolo Abeni wrote:
>On 7/22/26 12:17 PM, Ibrahim Hashimov wrote:
>> smc_cdc_cursor_to_host() converts the wire-format producer/consumer
>> cursor of an incoming CDC message into a host smc_host_cursor. It rejects
>> a cursor that goes backwards, but never checks that the cursor stays
>> inside the buffer it indexes. Per smc_host_cursor ("an offset in an
>> RMBE") and the invariant smc_curs_add() enforces for every local advance
>> (0 <= count < size), a valid cursor count must be < size and a single
>> advance can be at most one bufferful; the wire cursor is peer-controlled
>> and was never checked against either.
>> 
>> smcr_cdc_msg_to_host() accepts the producer and consumer cursors, and the
>> unbounded value feeds smc_curs_diff() in smc_cdc_msg_recv_action(), which
>> computes the advance without clamping against size. A peer can inflate it
>> two ways: an out-of-range prod.count (e.g. 0x7fffffff), or -- since on a
>> wrap increment smc_curs_diff() returns (size - old.count) + new.count --
>> a cursor with a bumped wrap and new.count above old.count. Either drives
>> bytes_to_rcv far past rmb_desc->len, the very invariant the comment above
>> the atomic_add() claims but does not enforce.
>> 
>> smc_rx_recvmsg() then trusts bytes_to_rcv as the amount of valid RMB
>> data. Its first copy chunk is safely bounded by rmb_desc->len -
>> cons.count, but the second chunk copies (copylen - chunk_len) bytes from
>> offset 0, and copylen came from the inflated readable -- an out-of-bounds
>> read of the RMB's backing (v)malloc allocation, copied straight to the
>> receiving process via _copy_to_iter(). This is a remote kernel-memory
>> disclosure driven by a malicious SMC-R peer, needing no local privilege
>> on the victim. The same unbounded count also reaches
>> smc_cdc_handle_urg_data_arrival() (base + urg_curs.count - 1) -- a
>> second, narrower OOB read.
>> 
>> Reject the bad cursor at ingress, mirroring the cursor-sanity idiom two
>> lines above: drop any incoming cursor whose count is outside the buffer
>> (>= size), and any whose advance from the last accepted cursor exceeds
>> one bufferful (smc_curs_diff() > size), which catches the wrap case.
>> smc_cdc_cursor_to_host() gains a size parameter; smcr_cdc_msg_to_host()
>> passes conn->rmb_desc->len for the producer cursor and
>> conn->peer_rmbe_size for the consumer cursor, bounding it at its single
>> origin instead of patching every downstream consumer. SMC-D
>> (smcd_cdc_msg_to_host()) does not use this helper and is a separate,
>> out-of-scope gap.
>
>@SMC crew: please review.
>
>The above looks so correlated and quite simple to address that possibly
>it makes sense to address it in the same series.

Hi Paolo,

This patch was discussed in the v1 thread. Bryan had already sent a the
v5 addressing the issue, so I think this patch can be dropped.

https://lore.kernel.org/netdev/20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me

Best regards,
Dust
