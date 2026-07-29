Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F35E3CC9E9;
	Wed, 29 Jul 2026 09:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318407; cv=none; b=ijvPN/IZvoEQQg6nHwzrFZ6XP9Mlh1S3r9ym0YbswiMQaW+Pk0rarfU7SBx1Ty0IKWCNi7S5gsLm/QrCS/98j/6nLU5mrEAINeS3dBOcirZUYwZz0RoZAWaR9+5TMlYRwNPphYIP202xp5jarW67V0jtdDrfD1iHS9VEmhFJhiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318407; c=relaxed/simple;
	bh=9qkurKEBQ5XzOCxrJxskBkJaR8n8PEQhmRL9w2MixlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=prEmE5oIj7FsrrS8hzFlwku+tB7BSGRdeJFQJRy/dFBy20X0p/tpAYlkrHbqPeHwgXc95vHDo8vY3MeFXjDc5Rtfl2e1cEHSJ99/J+yb/cUu4pAmvCwaOcdGbd0oFiMz2bZffWStkm7DPZZuOJ85yqYwfvmgRywBFh66F4i/eQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oOO9uIFO; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oOO9uIFO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785318393; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=3Kb+gxxNFsPAk9YfrV77ZgzYxrountwmYNwZZmdsfuk=;
	b=oOO9uIFOf+VEEyZolWFD89pT7toWVnx9OUkbqHnNCNxPD4dPt+Y//m3eCENiDH1peu28BRL73Xl5A3tpn2rA4VnQMGYNZVeqd3cxKRDC/KEjYhrM0J+DwGoHO8yQShJaqCLtyeBYEzTeYBnEePUuWlClGt3XrmkSLO06nRqypOM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X81qbYq_1785318392;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X81qbYq_1785318392 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Jul 2026 17:46:33 +0800
Date: Wed, 29 Jul 2026 17:46:32 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: hexlabsecurity@proton.me, Wenjia Zhang <wenjia@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tony Lu <tonylu@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: drain the rx tasklet before detaching the
 ghost sndbuf
Message-ID: <amnL-DjPaTQyOXT1@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260726-b4-disp-a135b4e5-v1-1-705aaec79986@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-b4-disp-a135b4e5-v1-1-705aaec79986@proton.me>

On 2026-07-26 21:14:04, Bryam Vargas via B4 Relay wrote:
>From: Bryam Vargas <hexlabsecurity@proton.me>
>
>On the SMC-D DMB-nocopy path smcd_buf_detach() frees conn->sndbuf_desc
>while the receive tasklet can still be running: both teardown sites free
>first and drain afterwards. A tasklet already past the conn->killed check
>then dereferences the freed buffer in smc_cdc_msg_recv_action(), which
>reaches the same field again through smc_tx_prepared_sends().
>
>Drain the tasklet before the detach at both sites, mirroring rmb_desc,
>which smc_buf_unuse() only releases after the drain.
>
>Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
>Cc: stable@kernel.org
>Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
>---
>Found with KASAN on an SMC-D loopback rig (CONFIG_SMC_LO, x86_64).
>
>The teardown is driven through smc_conn_kill() by arming abort_work from a debug
>module parameter: on SMC-D nothing in the receive path queues that work, while on
>SMC-R smc_cdc_msg_validate() queues it for an out-of-range peer seqno. Everything
>after the abort is the unmodified path. A second parameter holds the receive tasklet
>just past the conn->killed check, so the free lands mid-run.
>
>  arm         ordering           abort armed   result
>  vulnerable  detach then drain  yes           KASAN slab-use-after-free
>  control     detach then drain  no            clean
>  patched     drain then detach  yes           clean
>
>Same module, same boot, same trigger, same delay; only the ordering differs.
>
>  BUG: KASAN: slab-use-after-free in smc_cdc_msg_recv_action+0x1ed9/0x1f20 [smc]
>  Read of size 4 at addr ffff88810f6c9720 by task kworker/3:1/147
>  Workqueue: smc_close_wq smc_conn_abort_work [smc]
>   <IRQ>
>    smc_cdc_msg_recv_action+0x1ed9/0x1f20 [smc]
>    smcd_cdc_rx_tsklet+0x1f2/0x2f0 [smc]
>    tasklet_action_common+0x2fd/0x850
>    handle_softirqs+0x18c/0x4f0
>    do_softirq+0x3a/0x60
>   </IRQ>
>   <TASK>
>    __local_bh_enable_ip+0x5d/0x60
>    smc_cdc_get_slot_and_msg_send+0x253/0x680 [smc]
>    smc_conn_kill+0xa8/0x4d0 [smc]
>    smc_conn_abort_work+0x34/0x90 [smc]
>   </TASK>
>
>  Allocated by task 70:
>    smcd_buf_attach+0xbd/0x2a0 [smc]
>    smc_listen_work+0x2499/0x49a0 [smc]
>
>  Freed by task 44:
>    kfree+0x135/0x390
>    smc_conn_kill+0x3ab/0x4d0 [smc]
>    smc_conn_abort_work+0x34/0x90 [smc]
>
>  The buggy address belongs to the object at ffff88810f6c9700
>   which belongs to the cache kmalloc-128 of size 128
>  The buggy address is located 32 bytes inside of
>   freed 128-byte region [ffff88810f6c9700, ffff88810f6c9780)
>
>The read is conn->sndbuf_desc->len.
>
>A plain close() does not get there: smc_close_active() always moves the socket to
>SMC_PEERCLOSEWAIT1, so the free happens in smc_close_passive_work() after the peer's
>close CDC -- the same event that stops feeding the tasklet. About 18000 such teardowns
>produced nothing. The ordering is wrong either way, and smc_conn_kill() has no such
>coupling.
>
>Logs on request.
>---
> net/smc/smc_core.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>index cf6b620fef05..da64e7a6bd73 100644
>--- a/net/smc/smc_core.c
>+++ b/net/smc/smc_core.c
>@@ -1270,9 +1270,9 @@ void smc_conn_free(struct smc_connection *conn)
> 	if (lgr->is_smcd) {
> 		if (!list_empty(&lgr->list))
> 			smc_ism_unset_conn(conn);
>+		tasklet_kill(&conn->rx_tsklet);
> 		if (smc_ism_support_dmb_nocopy(lgr->smcd))
> 			smcd_buf_detach(conn);
>-		tasklet_kill(&conn->rx_tsklet);
> 	} else {
> 		smc_cdc_wait_pend_tx_wr(conn);
> 		if (current_work() != &conn->abort_work)
>@@ -1525,12 +1525,12 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
> 	smc_sk_wake_ups(smc);
> 	if (conn->lgr->is_smcd) {
> 		smc_ism_unset_conn(conn);
>-		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
>-			smcd_buf_detach(conn);
> 		if (soft)
> 			tasklet_kill(&conn->rx_tsklet);
> 		else
> 			tasklet_unlock_wait(&conn->rx_tsklet);
>+		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
>+			smcd_buf_detach(conn);

Hi Bryam,

I think Sashiko's review makes sense. Your change doesn't seem to fully
eliminate the race here. I'm wondering if this should be solved with
RCU rather than just moving smcd_buf_detach() later?

Best regards,
Dust


> 	} else {
> 		smc_cdc_wait_pend_tx_wr(conn);
> 	}
>
>---
>base-commit: 4235cb24ec1e8e96843f3671ba4da2a6ccca2c7b
>change-id: 20260726-b4-disp-a135b4e5-945574bd0938
>
>Best regards,
>--  
>Bryam Vargas <hexlabsecurity@proton.me>
>
