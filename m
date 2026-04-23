Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932D5318B83;
	Thu, 23 Apr 2026 11:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776943122; cv=none; b=CeeOMFLQYRFT0V+1FZOKpz1+KNsd9T3trW7hcy/LbbAPWeO2Bf6JsJTAm0+k7t0MqBfpCVdPVHpIsDVeFmvPyON0SX+vSLXZuwDZCwCIVKXutozKUumgpediJZx3BRGvm2eejYVC8y4OG8Fx0obqOdxnORaZRmk61SxGd9knj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776943122; c=relaxed/simple;
	bh=+Ht1fX7O8pKem0a8MgKLr6XElqTzJxRyeT9Bznf9fMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7hBqOROhiF4ZX1U5Au42nyXCHISLcF104QZAmkoGqJIN8MiCDqRX693DYLQ956ECm2ccUweToUUs7EIBbDJwLdHhq7Lhd7eNi77ul+NDK3rDGe4jnioqRnVX/Z68/NzsidKgJIXs5TCIDT+hO7rnHLu9DSxTim49YIFXCyRNVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GrspeKci; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GrspeKci"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776943117; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=1EeyjAvqHGtasAKLij7JQvZvTEdx3GHT3hnRxa4XgIo=;
	b=GrspeKciy7JvZWe6DOoSDRXLwkn3fwSms0QANQ1FKJuF+aj9rqRWYrqoXuOoS1XvfXVjSSwZSTrE0YZYCBu9gsFYG+/aJ0R6XWEY+Sn05XyuagSE7dVg309AK5S6U/Bn3E51NzKW32JGw1AtcTf/fBqhJPHw/Le93xVaZgUYkfI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X1ZU3hl_1776943115;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X1ZU3hl_1776943115 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Apr 2026 19:18:36 +0800
Date: Thu, 23 Apr 2026 19:18:35 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Weiming Shi <bestswngs@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, Simon Horman <horms@kernel.org>,
	Ursula Braun <ubraun@linux.vnet.ibm.com>,
	Ren Wei <n05ec@lzu.edu.cn>, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH net] net/smc: fix NULL pointer dereference in
 smc_clc_wait_msg()
Message-ID: <aeoAC_rsoqNpmAdl@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260423100205.1093987-3-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423100205.1093987-3-bestswngs@gmail.com>

On 2026-04-23 03:02:07, Weiming Shi wrote:

Hi Weiming,

Ren Wei has already send the patch to the mailist

[PATCH net 1/1] net/smc: avoid early lgr access in smc_clc_wait_msg

Best regards,
Dust

>In smc_listen_work(), smc_clc_wait_msg() is called to wait for a CLC
>PROPOSAL message before any link group has been created, so
>smc->conn.lgr is still NULL at this point. smc_clc_wait_msg() also
>accepts CLC DECLINE messages regardless of the expected type. When a
>DECLINE with SMC_FIRST_CONTACT_MASK set in hdr.typev2 arrives, the code
>unconditionally dereferences smc->conn.lgr to set sync_err, causing a
>NULL pointer dereference.
>
>KASAN reported a null-ptr-deref in smc_clc_wait_msg():
>
> Oops: general protection fault, 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000310-0x0000000000000317]
> RIP: 0010:smc_clc_wait_msg (net/smc/smc_clc.c:793)
> Call Trace:
>  <TASK>
>  smc_listen_work (net/smc/af_smc.c:2491)
>  process_one_work (kernel/workqueue.c:3281)
>  worker_thread (kernel/workqueue.c:3440)
>  kthread (kernel/kthread.c:436)
>  ret_from_fork (arch/x86/kernel/process.c:164)
>  ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
>  </TASK>
> Kernel panic - not syncing: Fatal exception
>
>Add a NULL check for smc->conn.lgr before dereferencing it. 
>
>Fixes: 0cfdd8f92cac ("smc: connection and link group creation")
>Reported-by: Xiang Mei <xmei5@asu.edu>
>Signed-off-by: Weiming Shi <bestswngs@gmail.com>
>---
> net/smc/smc_clc.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
>index c38fc7bf0a7e..d22c9417d239 100644
>--- a/net/smc/smc_clc.c
>+++ b/net/smc/smc_clc.c
>@@ -790,8 +790,10 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
> 		smc->peer_diagnosis = ntohl(dclc->peer_diagnosis);
> 		if (((struct smc_clc_msg_decline *)buf)->hdr.typev2 &
> 						SMC_FIRST_CONTACT_MASK) {
>-			smc->conn.lgr->sync_err = 1;
>-			smc_lgr_terminate_sched(smc->conn.lgr);
>+			if (smc->conn.lgr) {
>+				smc->conn.lgr->sync_err = 1;
>+				smc_lgr_terminate_sched(smc->conn.lgr);
>+			}
> 		}
> 	}
> 
>-- 
>2.43.0
