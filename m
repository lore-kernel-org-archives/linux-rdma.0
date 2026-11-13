Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565006;
	b=yyTlNtjRqGjUvZWoe1Tr5EZyfWhtgB4Dq3mgdJenTZe9tkE5Oq7ntJ3ClIgQsH5sd1On
	 00uCPHvPcU4u/kHUmvEFKleKkHUICfTfoGixDk/tmjPEVvmjlyrd4A+5lx+4DWLh/pvUv
	 ze7oQjw0ioreaf0S6MOg94vGDUCE3cF2gBipAaZ17jkVk7ZSkq16dCiBxyFJpCbnE9URD
	 cSc9nodBlxuvBM+83igaJRuAxTVvbdYxXqUnZ3SihfMbn9MgkRe7E6C7ys+6x8QlePv3c
	 TdwWQg1gAyYzbZ+jwQHjXd5Kj2O473AdbKg5hZSgl2bccqoVKN/etueEnRgQrckiQmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565006;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=nyI8Wzh+zPe8JcksqY0asVbnsaDs2VdQRMjWQ9hvknc=;
	b=JAUxgk8qFB2Ucg2qAVfgV3pyxiqMd3ll5Fmq3GawyLNoPe5roVaIFXATAElElUCjcIOq
	 2Nvci8A7shCix4tfhVTK3brqmlj3CMvB1l4Sl8Dro9gMhvII2grNcHmZchUyINmqTb9UU
	 9LFsiGOwLLf8k8p9FKE7K0z1k3k6/eqsA41aqvw/okizFJpd49KJsZU0qmOgw3S3rhn6b
	 gxzz2NwnQsjOwwf5O2UnIvnaGP42XBjEi2TVZT3QYcvdHquvFLXQW0vexRRDg/Jzo8mV7
	 QoaYJVGQx96E0ScRxr95Is+4VFGJv0560rj0NwYuxpV511vCvxroeow6OJZKPeDsxtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=VoTxBywD;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAA5606A327;
	Fri, 13 Nov 2026 10:16:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADAA5606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=VoTxBywD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nyI8Wzh+zPe8JcksqY0asVbnsaDs2VdQRMjWQ9hvknc=; b=VoTxBywDYd9qjE5Al6NcAsyxp8
	/XzPeuK7hNyoHvRXXWgdSfJJ70MTSPdjpte2GjYnaXVXYdZIZzhmkMEUvIfltiIkgNdzmIArCwYdl
	YDxnDB06XZQYvhkt01azUaRYjyDu9vOWAr78V60vbAEYitdTU3xkokmA027D+lbZ+cnVo1gzQEerR
	ohUFyldI0l/CXA4I9UkRFGnKJnj3g0BTQlXo9OaRfibL309r72PIB1Kolnf2OeHZ3rEYKPc/tSj+H
	fAMBx61V+RAttDfuYnarV1x/lCYxU3BvQw9eZ/mYzHSClCL1o+G9J8EqlC7h3huMN6/l0twDkqqMN
	WPsjlFYg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xRoKc-00Eg12-1G;
	Fri, 13 Nov 2026 10:16:30 +0000
Date: Fri, 13 Nov 2026 02:16:24 -0800
From: Breno Leitao <leitao@debian.org>
To: Sahil Chandna <sahilchandna@linux.microsoft.com>
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, weh@microsoft.com, kotaranov@microsoft.com, horms@kernel.org, 
	ernis@linux.microsoft.com, gargaditya@linux.microsoft.com, linux-hyperv@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add CQE polling as first-level TX
 timeout recovery
Message-ID: <avbdPt1WSC9qEuYw@gmail.com>
References: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
 <avWrMQK_DuZ1hAwD@gmail.com>
 <fc2ae552-86ee-40af-a997-454c2d3b176d@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc2ae552-86ee-40af-a997-454c2d3b176d@linux.microsoft.com>
X-Debian-User: leitao

On Fri, Nov 13, 2026 at 02:04:08PM +0530, Sahil Chandna wrote:
> On 12-11-2026 17:37, Breno Leitao wrote:
> > Hello Sahil,
> > 
> > On Thu, Nov 12, 2026 at 04:57:18AM -0600, Sahil Chandna wrote:
> >> Implement a graduated recovery approach: on the first TX timeout (or
> >> when the previous timeout was more than 2 minutes ago), schedule NAPI on
> >> the stalled queue's TX CQ via napi_schedule(). This triggers
> >> mana_poll_tx_cq() through the normal NAPI path, processing any pending
> >> completions without relying on the interrupt and recovering
> >> missed-interrupt scenarios without queue reset.
> > 
> > Which interrupt is being missed here?
> > 
> Hi Breno,
> 
> It is the TX CQ completion interrupt. After NAPI finishes, it re-arms
> the TX CQ. When a new CQE arrives, the hardware post EQE, which raises
> the MSI-X and schedules NAPI. If that notification for the TX CQ is lost
> , NAPI never runs for the TX CQ and pending_sends never drains and the
> queue stays stopped,  so napi_schedule() polls the CQ, reaps the CQEs
> and re-arms it.

Thanks.  Which one gets lost, the EQE or the MSI-X?

> >> If any subsequent TX timeout fires on any queue, within 2 minutes of
> >> the previous one, escalate to the existing port-level detach/attach
> >> reset, as the CQE poll did not recover the queue.
> > 
> > How was 2 minutes chosen? mana sets watchdog_timeo to 15 * HZ, no?
> The watchdog_timeo is TX stall timeout setting i.e if a queue remains
> stalled for this much time, it trigger watchdog timeout. Here, 2 minute
> is not timeout/wait. The 2 minutes here is for deciding whether a new
> queue stall event is a repeat of the previous incident or a new,
> unrelated one that should get the cheap poll first. For e.g. if a queue
> gets stalled, 15 * HZ sec later, timeout occurs and this patch trigger
> manual NAPI, if another stall occurs (it can be on any queue) within 2
> minutes of last one, the existing recovery mechanism of mana
> detach/attach will be tried.The patch is adding a first level less
> destructive recovery first.
> For selecting 2 minutes, I do not have any hardware basis for it afaik,
> but I can confirm and check with our host team as well.

So the goal is to tell an isolated stall from a wider problem.

A port-wide timestamp only approximates that. It cannot tell the same
queue from another one, and since dev_watchdog() reports one queue per
run, two queues that stall together show up ~15s apart: the first gets
a kick, the second gets the port reset anyway, no?

Could mana_tx_timeout() check this directly? Look at the other TX queues
the way dev_watchdog() does (stopped, with trans_start older than
watchdog_timeo). If more than one is stalled, reset right away.

Otherwise kick this queue, and reset if the same queue times out again
within a couple of watchdog periods, as gve_tx_timeout_try_q_kick()
does. That also gets rid of the 2 minutes.
