Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED147CA8A;
	Wed,  2 Sep 2026 12:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788351427; cv=none; b=rWZl7VLVXxM7rWSVG9NhvGUo2aYpNX534NNZDyKscTV3X93cf9XAahXTv6TS39mt6xTlFieSX3iGghE+BQOb66Sr5hUCrLsyQVFBvDMAMb4fq7NK41IWhnbE7PLoNStH71wt7JGo0Q5oW8t+S4ZvH4/eHHDEJ8jSa5lDH5pgjZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788351427; c=relaxed/simple;
	bh=vonAWKRarr/Xacwj0baC+2XrgM/fgSt+w0/JmiE22uQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GcN/7XY3XEJVGC9WxzYKit5SSkCjxlZ87mXPwC3FJBa1hZLnWHZKVtcNQM51clyRzCO2uVmcii/8ldYHY0bOJ4WaK9LyQFqxBWnHUNd34//gUyrjo7j11Uu5JkBptvZytzAQz4rwt3gfRbmkU1MS16aoRn0ZiIv/beXbCclel+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=S1Z2KU/P; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="S1Z2KU/P"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788351421; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=R+lWUm8CAIRBN3Lmcj0B3BaLuE9DzBK0k1/wahQa3Vc=;
	b=S1Z2KU/P0bfzlp9DUkzWGgQ/MSNJEdZNLZrSp70/xQbc4y5o7PAiz0UC2m55M2JSRBjlFjZ6P/rNQ/FttQwfnUoUHUWknrjNJ/4eoU0Zt9+vzw7IjGvIICp+2CSAiTrA4qCPpJ03PMxHQWeRLnpIiAn38k7FGBZ8LcUJU6SbdWA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XACYNUb_1788351419;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XACYNUb_1788351419 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 20:17:00 +0800
Date: Wed, 2 Sep 2026 20:16:59 +0800
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
Message-ID: <apgTu9dRGIQE6tm3@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
 <apWEzobrZ3QR3IfN@linux.alibaba.com>
 <4f303f9f-fd20-475a-8004-1a670dfd34df@linux.ibm.com>
 <apbMyLc0IhLMKwwA@linux.alibaba.com>
 <85fa9f02-7516-4595-b5a8-4ae4ca845121@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <85fa9f02-7516-4595-b5a8-4ae4ca845121@linux.ibm.com>

On 2026-09-01 20:43:11, Mahanta Jambigi wrote:
>
>
>On 01/09/26 6:32 pm, Dust Li wrote:
>> On 2026-08-31 20:27:38, Mahanta Jambigi wrote:
>>>
>>>
>>> On 31/08/26 7:12 pm, Dust Li wrote:
>>>> On 2026-08-28 08:54:37, Mahanta Jambigi wrote:
>>>>> This series fixes multiple lifetime races in the SMC diag dump path.
>>>>>
>>>>> The first patch adds the basic infrastructure needed to synchronize diag readers
>>>>> against connection-owned conn->lgr/conn->lnk updates. It introduces a
>>>>> per-connection spinlock and uses it in the link switch and connection free
>>>>> handoff paths. conn->lgr and conn->lnk are NULLed under the lock before the
>>>>> borrowed references are released, so a non-NULL conn->lgr seen under the lock
>>>>> guarantees the lgr object is alive. The diag reader can rely on this invariant
>>>>> without borrowing any extra reference.
>>>>>
>>>>> The second patch fixes two races in smc_diag itself:
>>>>>
>>>>> - serialize clcsock field access against smc_clcsock_release() with
>>>>>  mutex_trylock()
>>>>> - take conn->lgr_lnk_lock when reading conn->lgr and conn->lnk; use
>>>>>  smc_conn_lgr_valid() inside the lock to check that the connection is
>>>>>  still registered, then snapshot all required fields and call nla_put()
>>>>>  after releasing the lock
>>>>
>>>> Hi Mahanta,
>>>>
>>>> As discussed in the other thread, I think we should defer the release of
>>>> smc->clcsock and remove clcsock_release_lock.
>>>>
>>>> In that case, we should no longer need these two patches. Also,
>>>> introducing more locks in SMC is the last thing I want to do :)
>>>
>>> Thanks for the new series "[RFC net-next 0/7] net/smc: tie clcsock
>>> lifetime to the smc socket and remove clcsock_release_lock" — once it
>>> lands, we can drop the mutex_trylock() fix for Race 1 (clcsock).
>>>
>>> However, Race 2 remains open. Your series does not touch smc_core.c or
>>> smc_cdc.c, so smc_conn_free(), smc_switch_link_and_count(), and
>>> smc_cdc_msg_validate() still write conn->lgr/conn->lnk with no
>>> synchronization against the diag reader.
>> 
>> Hi Mahanta,
>> 
>> Thanks for the detailed explanation. You are right that a per-connection
>> spinlock can work here, and I agree none of the lock sites are on the
>> per-message hot path. But I think we can also do the same thing we did with
>> clcsock_release_lock: instead of adding a lock, tie the lifetime of
>> conn->lgr/conn->lnk to the point where the connection stops being observable,
>> and remove the need for synchronization altogether.
>> 
>> For lgr/lnk, that point is the hash table. Once the connection is unhashed, the
>> diag dump (which iterates under the hash read_lock) can no longer reach it. So
>> if we make sure the connection-owned references are only dropped after unhash,
>> the invariant becomes: holding the hash read_lock and seeing a non-NULL
>> conn->lgr implies it is safe to dereference. The diag path then reduces to
>> `hold hash read_lock -> read conn->lgr -> if non-NULL, use it -> done` with no
>> new lock, no extra reference, and no trylock. The invariant is carried by
>> object lifetime rather than by a lock, which I find easier to keep correct over
>> time.
>
>I looked carefully at the new design and found one remaining gap.
>
>The *unhash* invariant — "any socket in the hash has its
>connection-owned lgr/lnk refs held" — protects against smc_conn_free()
>dropping refs while the socket is still hashed. However it does not
>protect the conn->lnk->smcibdev->ibdev->name access in the
>SMC_DIAG_LGRINFO block in smc_diag.c file.
>
>The gap is in *smc_switch_link_and_count*(). It is called under
>send_lock (not under any hash-related lock) and calls
>smcr_link_put(conn->lnk) on the old link before reassigning conn->lnk.
>If that put drops the last reference, __smcr_link_clear() runs
>immediately, doing memset(lnk, 0, sizeof(struct smc_link)) which zeroes
>lnk->smcibdev. The socket remains hashed throughout — so the *unhash*
>invariant is not violated — but the diag reader can hold a stale pointer
>to the old link and race this memset. The timeline:
>
>diag reader [hash read_lock held]:
>    conn->lnk → old_lnk (non-NULL, socket hashed ✓)
>    [about to read old_lnk->smcibdev->ibdev->name]
>
>smc_switch_link_and_count() [send_lock held]:
>    smcr_link_put(old_lnk) → last ref → __smcr_link_clear()
>        memset(old_lnk, 0, ...) ← smcibdev = NULL
>
>diag reader:
>    old_lnk->smcibdev->ibdev->name ← NULL deref
>
>The *unhash* invariant says nothing about the link a connection used to
>point at before *smc_switch_link_and_count*() swapped it. Hash
>membership of the socket provides no protection here because the socket
>is still hashed — the link pointer simply changed underneath the diag
>reader.
>
>Any ideas on this?

Good catch ! You are right that the "unhash invariant" as stated
does not cover the stale-conn->lnk race through a link switch + clear.

I think we can close this window by holding the SMC hash table lock in
smcr_link_clear()? As the diag walker captures and dereferences the stale
pointer within a single read_lock hold on the SMC hash table. Since
smc_link_clear() is a cold path, and the region where we hold the SMC hash
table lock is small, the overhead should be negligible.


Something like this:

```diff
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 5af55abece57..ca3030f02e70 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1361,6 +1361,18 @@ static void __smcr_link_clear(struct smc_link *lnk)
        struct smc_ib_device *smcibdev;
 
        smc_wr_free_link_mem(lnk);
 
+       write_lock_bh(&smc_v4_hashinfo.lock);
+       write_lock_bh(&smc_v6_hashinfo.lock);
        smc_ibdev_cnt_dec(lnk);
        put_device(&lnk->smcibdev->ibdev->dev);
        smcibdev = lnk->smcibdev;
@@ -1368,6 +1380,9 @@ static void __smcr_link_clear(struct smc_link *lnk)
        lnk->state = SMC_LNK_UNUSED;
        if (!atomic_dec_return(&smcibdev->lnk_cnt))
                wake_up(&smcibdev->lnks_deleted);
+       write_unlock_bh(&smc_v6_hashinfo.lock);
+       write_unlock_bh(&smc_v4_hashinfo.lock);
```

What do you think ?

Best regards,
Dust
