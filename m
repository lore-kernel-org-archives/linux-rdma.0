Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16F93E3C53;
	Tue, 15 Sep 2026 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789485247; cv=none; b=r64R6Y6Nl2kYHmZ/krbmfn4CeD3AqpMX55jUS3TPTrwWw+xaLqn9Ze9ypPz+STdJRvgrYD/GOrDOA+3Wtuz2DPYCmkNgp+8pZrhRT2dgoIoSKyZi6fN8KtTTff+vTga0iAgirtJ9dHtnpY+YYLXtqvkLPTEX4Tex2v/AIm/j/jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789485247; c=relaxed/simple;
	bh=Vq7DJ6VGCA/n8dT3LDyD6vG78Mde7Hkg1JRXE/US32U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lSkJQzX4Mq1W1mKJeqS8BSK+HaVFVU56QYEHN4gKUOzn2LNczfpWimcxJCwkKs21aRrqLJDwcxsRj2MZyA/dizqimJ4Kv2U8YomA4S86hGmxKIQ4/MQ6yVoHghUOZPEa6HxfHcO2OAb2B8uH5vxPOVGoJ0iEcB/GREYFCx2X0e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Nxm02UYr; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Nxm02UYr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789485239; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=9kholIoURhJxPvvf2Bgb1Hw65r9rF5ZS2z73QbfwEac=;
	b=Nxm02UYrICjgnmitLGKNFu68bLKVzGxFZcNlr4NBKVQnntqN50Kpp+ngdkW8UwYLRMLUtHW98I7Z/2+wLDkZgybTXZuRb/DSEITQu+O117/vMjlHqwjdEHE84OEHvI8nHh0QjIhNnujogIzu2qeHZWabo761PSv0aqJuFu2zbYo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XB21F99_1789485238;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XB21F99_1789485238 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 23:13:58 +0800
Date: Tue, 15 Sep 2026 23:13:57 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, hidayath@linux.ibm.com,
	stable@vger.kernel.org, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v4] net/smc: fix lgr/lnk lifetime vs diag reader race
Message-ID: <aqlgtaEk3kNcg-Yp@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260911090906.1949163-1-mjambigi@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911090906.1949163-1-mjambigi@linux.ibm.com>

On 2026-09-11 11:09:06, Mahanta Jambigi wrote:
>The diag dump walks the socket hash table under a read_lock and dereferences
>conn->lgr and conn->lnk.  Two terminal teardown paths drop those references via
>smc_conn_free() while the socket is still hashed:
>
>  - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free()
>  - smc_close_passive_work() -> smc_conn_free()
>
>This allows the diag reader to dereference a freed lgr or lnk.
>
>Fix it by unhashing the socket before smc_conn_free() is called at each of these
>two sites.  Any socket visible to the diag reader under the hash read_lock then
>has valid conn->lgr and conn->lnk pointers.
>
>Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
>Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R connections")
>Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>---
>Changes in v4:
>- dropped smc_conn_unhash() wrapper, conn->unhashed flag, and all
>  changes to af_smc.c, smc.h, smc_core.c and smc_core.h; smc_unhash_sk()
>  is already idempotent via sk_hashed(), so direct calls at the two
>  teardown sites in smc_close.c are sufficient
>- dropped the __smc_release() hunk: it needs no change since the
>  subsequent unhash there is already a safe no-op
>- fixed premature-unhash issue present in v3: smc_conn_free() must not
>  unhash because smc_conn_abort() calls it before smc_switch_to_fallback()
>  in both smc_listen_decline() and smc_connect_rdma() error paths;
>  unhashing there would make live fallback sockets invisible to smcss
>- likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(),
>  smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed
>  attempt and then smc_conn_create() on the next device; unhashing in
>  smc_conn_free() would permanently hide the established connection from
>  smc_diag since smc_conn_create() does not re-hash the socket

Hi Mahanta,

This version looks clean. And you explained why we can't call unhash in
smc_conn_abort() well. But smc_conn_abort() still calls smc_conn_free(),
when the smc_sk is still hashed, is there still a race window with dump ?

Best regards,
Dust

