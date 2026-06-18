Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D493F38D40D;
	Thu, 18 Jun 2026 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792516; cv=none; b=PUor9O2WuPDSjLs2NYh24JwM0ub7Eqyxd70IhDx2fTEIz4+8OyUWBUdjVtpYIAIQKnY0rCFJM/5TxeVLUHtw9+UMB0UgecvAubq0OUXZaXTHmEIEpgFGBXMSwZIDnCtERyiB90J3lZkunJzjB8sJRX5eQrqSyVbMVv/68qy/39o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792516; c=relaxed/simple;
	bh=L5U93jZHJyDASCbYgKUYgJLTODAE27QkVBFWgkckHp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EqB2qxVCbzj6ADwEIiu4QUvYQC7JenWK2fCq4HyRTm3iCSmH9riiCQ5GoJ0dem9/RU3EVp+Ql03zWov4vnizM+y57WZbo/V787sZgZDpNKogIiWCq7tTlae40npi6xm5KYyRc00RPOcztY/KLZJ9L8o4w3O+E+tsk5v/qiDcfHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=MoqV4MmD; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="MoqV4MmD"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 42ee4c373;
	Thu, 18 Jun 2026 22:16:34 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Karsten Graul <kgraul@linux.ibm.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	runyu.xiao@seu.edu.cn
Subject: Re: [PATCH net] net/smc: avoid recursive sk_callback_lock in listen data_ready
Date: Thu, 18 Jun 2026 22:16:29 +0800
Message-Id: <20260618141629.2904071-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <f7e36176-d00a-4471-94ed-d385e579b43d@linux.ibm.com>
References: <f7e36176-d00a-4471-94ed-d385e579b43d@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9edb173fd803a1kunmb825a670a55e1
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGE4YVkxKGU9MTB0YSE1DHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=MoqV4MmDRylUoqoUi+YtDHcBMu14DQc4kKkjuz1YU0otMj8TXwY+HxXTf5/VMCJgubQFjGCt3tHFeYrl5EEsZ9tkpL3WZ6577zEriBUPvds8GKpQEwnePFz4aL9F2DRMJUXyNB06jfdOUEHfithPx4fLeKu6NEppZzBTlAZXfkU=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=GM5MKfzBrLqFzrUns6jEKAvDRObTqAY5/7+P5HHfT8I=;
	h=date:mime-version:subject:message-id:from;

Hi,

Thanks for taking a look.

The exact Lockdep stack I have is from the grounded reproducer, not from
a production SMC setup.  The reproducer keeps the same callback shape:
the close/flush side holds sk_callback_lock and invokes the installed
sk_data_ready callback, which re-enters smc_clcsock_data_ready() and tries
to take sk_callback_lock again.

The relevant Lockdep report is:

  WARNING: possible recursive locking detected
  kworker/u4:3/39 is trying to acquire lock:
    (sk_callback_lock) at smc_clcsock_data_ready+0xa/0x4d

  but task is already holding lock:
    (sk_callback_lock) at smc_close_flush_work+0xc/0x30

  Possible unsafe locking scenario:

        CPU0
        ----
        lock(sk_callback_lock);
        lock(sk_callback_lock);

  *** DEADLOCK ***

  Workqueue: smc_close_wq smc_close_flush_work

  Call Trace:
    dump_stack_lvl
    __lock_acquire
    lock_acquire
    _raw_read_lock_bh
    smc_clcsock_data_ready+0xa/0x4d
    smc_close_flush_work+0x1f/0x30
    process_one_work
    worker_thread
    kthread
    ret_from_fork

The nvmet change I referred to is:

  2fa8961d3a6a ("nvmet-tcp: fixup hang in nvmet_tcp_listen_data_ready()")

The stable/backport patch I originally used as the reference is:

  1c90f930e7b4 ("nvmet-tcp: fixup hang in nvmet_tcp_listen_data_ready()")

Its commit message says that when the socket is closed while in
TCP_LISTEN, the flush callback can call nvmet_tcp_listen_data_ready()
with sk_callback_lock already held, so nvmet moved the TCP_LISTEN check
before taking sk_callback_lock.

For the TCP_LISTEN check: my reasoning was that smc_clcsock_data_ready()
is installed by smc_listen() on the underlying TCP listen socket and only
queues smc_tcp_listen_work() for the SMC listen/accept path.  Once that
underlying socket is no longer in TCP_LISTEN, there should be no SMC
listen accept work to queue from this callback.  TCP_SYN_RECV and
TCP_ESTABLISHED are not listen-socket states for this callback path, so I
did not intend the callback to queue listen work for those states.

That said, if SMC expects smc_clcsock_data_ready() to handle a non-LISTEN
state during fallback or another transition, then the proposed check is
too strict and I should rework the fix.

Thanks,
Runyu
