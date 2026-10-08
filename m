Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0754AF175;
	Thu,  8 Oct 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791474535; cv=none; b=qZKyL5s/N894x6ZCuEDN8n9UlGOHHx0U2+4F5Wec4SOFsjW5JWpPFfExcu4eeTqDLQy7LUde1GuzFxifF6+Jt0vhr+5dBb0hhCV0YTeafO2ddVvWdqTJpt7uj0is5VDTnzGaCkGozO80rN6ZdV2dapBk4ajUm1ARIusKgDLDLiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791474535; c=relaxed/simple;
	bh=NOuEQwnxFTWg3MDBjgWaAHk3OvZtuogZm/KjcGl9944=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRi0z3u9rw7nq8UMZjxSFvuEhhB+NEssDaH+4kZzTz8HGiZWy5ffRKcm9311Ik5fu+H3rz5xJ/NtAvA9+8jqPjzWulF+8qVkF2eUxZJaIGJoFJTqcSG2EEejtb3VjaDfLyeg+mUqGJA6zKzZ0liaNHJIdQA5SjnV6coLLTqMLss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ivKrIVhF; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ivKrIVhF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791474523; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=nrAwFKZWFyUtApB8neLjvDzQnsHGO6YggBbNziyeqzY=;
	b=ivKrIVhF3KhyVy7NdxONVd4GIMgHygCbzW7JwgALPF1GBnza7By4rLYm8YJ4i2Ke8W+WbUZpTOEMHyy/V9G23kmHIxAwIsjPFUsqdjbJHaf22UfRUCSwVmJYv7MLnRnxFYqCz79DgxOMN5X+IYpGnZO9al9gK+X4J6Jocf28jX4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XCQfqOC_1791474522;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XCQfqOC_1791474522 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 23:48:43 +0800
Date: Thu, 8 Oct 2026 23:48:42 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Chengfeng Ye <nicoyip.dev@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v3] net/smc: protect clcsock lifetime in smc_getname
Message-ID: <ase7WgfRaX01wNxQ@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261008084444.787449-1-nicoyip.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008084444.787449-1-nicoyip.dev@gmail.com>

On 2026-10-08 16:44:44, Chengfeng Ye wrote:
>smc_getname() dereferences smc->clcsock without holding
>clcsock_release_lock. Link-group termination can release the CLC socket
>through smc_close_active_abort() while the SMC socket is still open,
>for example after shutdown(SHUT_WR).
>
>A getsockname() caller can load smc->clcsock, then the termination worker
>can clear the pointer and call sock_release() before the caller accesses
>clcsock->ops or invokes getname(). This causes a use-after-free; if the
>worker clears the pointer before the load, it causes a NULL dereference.
>The syscall's file reference keeps the SMC socket alive but does not
>prevent asynchronous release of its CLC socket.
>
>KASAN reported the following with test-only timing instrumentation:
>
>  BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
>  Read of size 8 at addr ffff888109abb4e0 by task poc/103
>  Call Trace:
>   smc_getname+0x19e/0x1b0
>   do_getsockname+0xe5/0x170
>   __sys_getsockname+0x8c/0x100
>
>  Allocated by task 95:
>   sock_alloc_inode+0x1e/0x280
>   sock_alloc+0x3d/0x240
>   __sock_create+0x7e/0x430
>   smc_create+0x121/0x240
>
>  Freed by task 0:
>   kmem_cache_free+0xcc/0x340
>   rcu_core+0x50a/0x1850
>
>  Last potentially related work creation:
>   evict+0x446/0x6c0
>   smc_clcsock_release+0xa8/0xd0
>   smc_close_active_abort+0x26a/0x3a0
>   __smc_lgr_terminate.part.0+0x137/0x2e0
>
>Hold clcsock_release_lock across the pointer check and the getname()
>callback to serialize with smc_clcsock_release(). Return -EBADF if the
>CLC socket has already been released, preserving the existing peer
>state check and the callback's return value otherwise.
>
>Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
>Cc: stable@vger.kernel.org
>Assisted-by: GPT-6.1-Sol
>Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
>---
>Changes in v3:
>- Limit the fix to smc_getname(), as requested by Mahanta. The code
>  change is identical to v1 and uses the existing release mutex.
>- Drop the new clcsock_lock and the other v2 changes. Mahanta will
>  address the other readers through the broader CLC lifetime changes
>  discussed with Dust Li.
>- Rebase onto current net/main; keep the stable Cc.

Agree on the current fix.

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

