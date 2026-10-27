Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793100340;
	b=SYXy8mmwpJhx0SxQ2w/FAUKhWXXUxRBO8zVyg3UXajAYXqsBk5NFmc58ktaL/tV77sWX
	 gKanIUejjHcCmL0gWeSrQ0yyVZs09HLLb/mrd9QOANoiX31OlwDgmoxY7yeC2n7L8LTDU
	 W4tyuwF1WeHTL0Nll+Ka+VcwM69UVObpeMoGxI0ow0otk4P/nH2UfbA9Lf4S7h3X4+Hf2
	 yenk5ImoQKL1G9sKGXyHGHyOTXvbGbzzy1eZJ/1kgaeRw6uG5BEidYFa7HjAMTRANWWxE
	 Ebux2YsdLx4txK2QSTfbK5HvENRXBvlZOcT5J/B+SpYhWkBWNat2zu2H3xRuoPLZ5mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793100340;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=gNaOmLJ54pQ1sRvF3/VAAAqJujB8QNCU6C1ZtrVopkw=;
	b=EMqVR6ZhD95YpRI/gBrTH1uLQz5Xd/XNomV7ciO82MGAYLqDW8LDpjZCXuW8UFo/YQaZ
	 DwB6FJO1Hey51CVqNEO/cGAe3TidplB8CD68v/8gdIHwEBej/kxpoV9Do3Mc1F0V0twUw
	 qKkPXrwVVYenaU/+D2ABB5UGc7kXOQP1qqlJHBrsGc1pKRbLotgPYk+p9LqVFkFiRAFu/
	 iIAwHx5aEOXS1oSbBxLZwyDfKaVGBiXeaNTryt6YpaHFd3C4/cX+Eel+oEF5DYTBdDLg/
	 IkO00hJfwY9uSNFjuFoBEraS0k2HWZjE83VjgBYBYqoxa9Q9ppw+Eopwo4ie7LTqqaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sAX4aqcl;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632C5606A31B;
	Tue, 27 Oct 2026 11:25:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 632C5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sAX4aqcl
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793100333; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=gNaOmLJ54pQ1sRvF3/VAAAqJujB8QNCU6C1ZtrVopkw=;
	b=sAX4aqclhG3gavWkBfeM4ig7Ez5nXLhBK2ooNXshYWsylEz1TNc8t029AnELw7ZPCKsV+2zTNTrfmzKySDJTRSMQ/GtB8oyw5NBnYD2mrTuq2vM5BRwp3/bYCvyV8ixA+l2ARJ+lIyQX+RQ/qvFrujNGl97FPrcvtp2WCVdorPU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDdfyuc_1793100331;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XDdfyuc_1793100331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 19:25:32 +0800
Date: Tue, 27 Oct 2026 19:25:31 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com, davem@davemloft.net, edumazet@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, horms@kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v3 2/3] net/smc: serialize early link group cleanup
 with termination
Message-ID: <auCKK_VoWfbT0YH5@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
 <20261013091716.1210420-3-nicoyip.dev@gmail.com>
 <atisUaV2eIC2yTvX@linux.alibaba.com>
 <CAAo+4rXas4BS85yfiDSPvDhzpWkjoKBiZSHn9VeV0VcATTO0Aw@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAo+4rXas4BS85yfiDSPvDhzpWkjoKBiZSHn9VeV0VcATTO0Aw@mail.gmail.com>

On 2026-10-27 19:16:26, Chengfeng Ye wrote:
>Hi Dust,
>
>Sorry for the late reply.
>
>On Wed, Oct 21, 2026 at 8:13 PM Dust Li <dust.li@linux.alibaba.com> wrote:
>>
>> On 2026-10-13 17:17:15, Chengfeng Ye wrote:
>> >smc_lgr_cleanup_early() enters __smc_lgr_terminate() even when another
>> >teardown path has already claimed lgr->freeing. Both callers can observe
>> >lgr->terminating clear before either sets it, then tear down the same
>> >link group, causing use-after-free and duplicate resource release.
>> >
>> >  BUG: KASAN: use-after-free in __smc_lgr_terminate+0x393/0x3a0
>> >  Write of size 1 at addr ffff8880bf2c0300 by task poc/106
>> >  Call Trace:
>> >   __smc_lgr_terminate+0x393/0x3a0
>> >   __smc_connect+0x2e3d/0x4930
>> >   smc_connect+0x42c/0x580
>> >   __sys_connect+0xfc/0x130
>> >   __x64_sys_connect+0x6d/0xb0
>> >
>> >Check freeing under the link group list lock before unlinking the group
>> >or entering termination. The existing locked freeing transition then
>> >claims exclusive teardown ownership; an early cleanup that loses the
>> >claim leaves teardown to the existing owner and does not remove the group
>> >from a device teardown's private list.
>> >
>> >Keep a temporary link group reference across smc_conn_free() and early
>> >cleanup in smc_conn_abort(). Once the connection is unregistered, a
>> >termination worker can finish without taking its socket lock. The extra
>> >reference keeps the allocation alive until the ownership check returns.
>> >
>> >A new group is published before its first connection is registered. Hold
>> >it before publication until registration or failed-registration cleanup
>> >finishes. The reference keeps the allocation alive, but teardown can still
>> >destroy the group's resources before registration. Take the list lock
>> >around the freeing check and first registration, nesting conns_lock as in
>> >the reuse path. Reject a group already claimed for teardown and clear
>> >conn->lgr, since that connection never acquired a group reference.
>> >
>> >On success, acquire the connection reference before dropping the temporary
>> >hold. A later terminator sees the registered connection and must acquire
>> >its socket lock before removing it. On failure, keep the temporary hold
>> >through early cleanup and then release it. Reused groups retain their
>> >existing reference protocol.
>> >
>> >This depends on "net/smc: serialize link group free work scheduling" for
>> >the standalone freeing bool and the locked early-cleanup transition.
>> >
>> >Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early()")
>> >Cc: stable@vger.kernel.org
>> >Assisted-by: GPT-6.1-Sol
>> >Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
>> >---
>> >Changes in v3:
>> >- Serialize first registration with the teardown claim under the group list
>> >  lock, nesting conns_lock in the same order as connection reuse.
>> >- Reject groups already being freed and clear conn->lgr on that path.
>> >- Document the scheduling fix prerequisite in the permanent commit message.
>> >
>> >Changes in v2:
>> >- Pin newly created link groups before publication, covering the
>> >  registration failure handoff to early cleanup. Drop the temporary hold
>> >  after cleanup on failure, or after the connection hold on success.
>> >- Send after the free-work scheduling fix and reuse its standalone
>> >  freeing bool and locked early-cleanup transition.
>> >- Pin the link group across the smc_conn_abort() early-cleanup ownership
>> >  check.
>> >
>> >v1: https://lore.kernel.org/r/20260927063607.3691520-1-nicoyip.dev@gmail.com/
>> >
>> >v2: https://lore.kernel.org/r/20261003183237.2284245-3-nicoyip.dev@gmail.com/
>> >
>> > net/smc/af_smc.c   |  8 ++++++--
>> > net/smc/smc_core.c | 21 ++++++++++++++++++---
>> > 2 files changed, 24 insertions(+), 5 deletions(-)
>> >
>> >diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>> >index e9f93b3ab435..97b0a0b51066 100644
>> >--- a/net/smc/af_smc.c
>> >+++ b/net/smc/af_smc.c
>> >@@ -1011,12 +1011,16 @@ static void smc_conn_abort(struct smc_sock *smc, int local_first)
>> >       struct smc_link_group *lgr = conn->lgr;
>> >       bool lgr_valid = false;
>> >
>> >-      if (smc_conn_lgr_valid(conn))
>> >+      if (local_first && smc_conn_lgr_valid(conn)) {
>> >               lgr_valid = true;
>> >+              smc_lgr_hold(lgr);
>> >+      }
>> >
>> >       smc_conn_free(conn);
>> >-      if (local_first && lgr_valid)
>> >+      if (lgr_valid) {
>> >               smc_lgr_cleanup_early(lgr);
>> >+              smc_lgr_put(lgr);
>> >+      }
>> > }
>> >
>> > /* check if there is a rdma device available for this connection. */
>> >diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> >index 660cd41ec720..c1bb284c4233 100644
>> >--- a/net/smc/smc_core.c
>> >+++ b/net/smc/smc_core.c
>> >@@ -693,6 +693,10 @@ void smc_lgr_cleanup_early(struct smc_link_group *lgr)
>> >
>> >       smc_lgr_list_head(lgr, &lgr_lock);
>> >       spin_lock_bh(lgr_lock);
>> >+      if (lgr->freeing) {
>> >+              spin_unlock_bh(lgr_lock);
>> >+              return;
>> >+      }
>> >       /* do not use this link group for new connections */
>> >       if (!list_empty(&lgr->list))
>> >               list_del_init(&lgr->list);
>> >@@ -999,6 +1003,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
>> >               lgr->buf_type = lgr->net->smc.sysctl_smcr_buf_type;
>> >               atomic_inc(&lgr_cnt);
>> >       }
>> >+      smc_lgr_hold(lgr); /* lgr_put in smc_conn_create() */
>> >       smc->conn.lgr = lgr;
>> >       spin_lock_bh(lgr_lock);
>> >       list_add_tail(&lgr->list, lgr_list);
>> >@@ -2049,15 +2054,25 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
>> >               if (rc)
>> >                       goto out;
>> >               lgr = conn->lgr;
>> >-              write_lock_bh(&lgr->conns_lock);
>> >-              rc = smc_lgr_register_conn(conn, true);
>> >-              write_unlock_bh(&lgr->conns_lock);
>> >+              spin_lock_bh(lgr_lock);
>> >+              if (lgr->freeing) {
>> >+                      conn->lgr = NULL;
>> >+                      rc = SMC_CLC_DECL_SYNCERR;
>>
>> This should not be SMC_CLC_DECL_SYNCERR, maybe SMC_CLC_DECL_INTERR or add
>> a new error code.
>
>No problem, I will use SMC_CLC_DECL_INTERR in v4.
>
>> >+              } else {
>> >+                      write_lock_bh(&lgr->conns_lock);
>> >+                      rc = smc_lgr_register_conn(conn, true);
>> >+                      write_unlock_bh(&lgr->conns_lock);
>> >+              }
>> >+              spin_unlock_bh(lgr_lock);
>> >               if (rc) {
>> >                       smc_lgr_cleanup_early(lgr);
>> >+                      smc_lgr_put(lgr); /* lgr_hold in smc_lgr_create() */
>>
>> smc_lgr_put() may call smcr_buf_free() -> vfree(), which may sleep.
>> And you put it in the spinlock.
>
>It seems the smc_lgr_put(lgr) is added after the
>spin_unlock_bh(lgr_lock). Were you referring to another lock held by a
>caller? I will keep this unchanged in v4, let me know if anything
>should be adjusted further.

No, I mean this part in [PATCH net v3 3/3], sorry for replying to the wrong thread.


@@ -89,14 +89,22 @@ static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
         * otherwise there is a risk of out-of-sync link groups.
         */
        if (!lgr->freeing) {
-               mod_delayed_work(system_percpu_wq, &lgr->free_work,
-                                (!lgr->is_smcd && lgr->role == SMC_CLNT) ?
-                                               SMC_LGR_FREE_DELAY_CLNT :
-                                               SMC_LGR_FREE_DELAY_SERV);
+               smc_lgr_hold(lgr); /* released by the worker or cancellation */
+               if (mod_delayed_work(system_percpu_wq, &lgr->free_work,
+                                    (!lgr->is_smcd && lgr->role == SMC_CLNT) ?
+                                            SMC_LGR_FREE_DELAY_CLNT :
+                                            SMC_LGR_FREE_DELAY_SERV))
+                       smc_lgr_put(lgr); /* pending work already owns a reference */
        }
        spin_unlock_bh(lgr_lock);

Best regards,
Dust
