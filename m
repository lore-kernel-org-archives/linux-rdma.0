Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E054A3F1F;
	Mon, 31 Aug 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183769; cv=none; b=iGGj/9rIq/Yk+ehVqFivIxZvqa3A0jv7py5RE/H+Sadnejvz8EQmU+wXvS0XcUwhKbn9OovFPChMr3cayekfLDCtLPJQogtEDVgX5Cjj4l8790sChIa7BjjlSDT+ePbrn9sUo2XkHny6ypbyeym5/HpFN1cDSmBffmh48aahPeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183769; c=relaxed/simple;
	bh=vUtvfixwYnzLiM1CBrohoDH2GCu7NAFjygxRvN8mlKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0zn1wcQylpsEKCrCuXaEtrawDd1KMVtGchtRUxX45vgm4tQWAsUKPRZMkerFCaagRG/Tyep0ITK15Eu+944TUBzznM2wQFCWtTLM69i8aRo0NneTR9ApTGnH/Ue9iGKdN+3EYa7DyHA6YQEYQEZFz63OohrEUm356iqajLMdVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kCa4QHs0; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kCa4QHs0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788183760; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=oxdG6gQLZaqFODj0uFTcNVgmEud2jloQlqfA1+GPLB8=;
	b=kCa4QHs0OIrWkVOcR8dJLTu9RQnkRrt4PtHVwJc7szyMwUctQBzy/GL+/1dEzsGREWJi2SrrxBYLndWHO9BJgd6k7VqJUIZP4E62vG7tz/s8JU7B0nahvlWlQxOYYdkP7IDx2kTehkl/3eNjLGrf+bpJRFlrznEdUuV/fcZcPl0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XA-DTgt_1788183759;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XA-DTgt_1788183759 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 21:42:39 +0800
Date: Mon, 31 Aug 2026 21:42:38 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
	hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, stable@vger.kernel.org,
	netdev@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net/smc: fix diag dump lifetime races
Message-ID: <apWEzobrZ3QR3IfN@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828065439.3582783-1-mjambigi@linux.ibm.com>

On 2026-08-28 08:54:37, Mahanta Jambigi wrote:
>This series fixes multiple lifetime races in the SMC diag dump path.
>
>The first patch adds the basic infrastructure needed to synchronize diag readers
>against connection-owned conn->lgr/conn->lnk updates. It introduces a
>per-connection spinlock and uses it in the link switch and connection free
>handoff paths. conn->lgr and conn->lnk are NULLed under the lock before the
>borrowed references are released, so a non-NULL conn->lgr seen under the lock
>guarantees the lgr object is alive. The diag reader can rely on this invariant
>without borrowing any extra reference.
>
>The second patch fixes two races in smc_diag itself:
>
>- serialize clcsock field access against smc_clcsock_release() with
>  mutex_trylock()
>- take conn->lgr_lnk_lock when reading conn->lgr and conn->lnk; use
>  smc_conn_lgr_valid() inside the lock to check that the connection is
>  still registered, then snapshot all required fields and call nla_put()
>  after releasing the lock

Hi Mahanta,

As discussed in the other thread, I think we should defer the release of
smc->clcsock and remove clcsock_release_lock.

In that case, we should no longer need these two patches. Also,
introducing more locks in SMC is the last thing I want to do :)

Best regards,
Dust
