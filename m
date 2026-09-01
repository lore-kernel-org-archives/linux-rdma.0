Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C5939C632;
	Tue,  1 Sep 2026 13:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788267733; cv=none; b=YvGconoHpkvbwILQy2a4Tb+VDFiiwKHX5556JpHQlBpv5hnHFzo2MALUORmdf2461xyBziXoU/JyY09YTndcWRFgfrbcn93fch/EvG07P0rC2aP+dps2A/9fYbv50gdw3QH75/4IJ/9TcZ/CryE5rtkOSg1U9kp0YbYVU9pio4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788267733; c=relaxed/simple;
	bh=pZUMlEwtsaEeH7TVMF5qsqoi7Zgr+VsMU0EuwmAA45I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvLD2iVaTMaBtyeB/9D4Dtis87qSYaGhdUj/rKDVcy9V/zWqjc8MJxtJGsOHo5Wcsze10J2TycgkLQqOTs9xA9Oibypo/6Zusvq/5dfaWbwPbDDW9TlOgMGnI3DJcQXMNXolKqPAL1e4WuBsZJ4Il8L20PG8qJ8Lecu7kitm+gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c9fTC4u0; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c9fTC4u0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788267722; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=ppWzcSYLfmdmUEwetfWNeyyHnWXusGFRwvVsm+qIFG8=;
	b=c9fTC4u0sW16Jw5RG5bR+SGcvOCz98cMeG47wuP+Fal/Qmi0bYCPBBP2EAaofMHbEm9WM/fljcDHMilifyl4WmxWoFnFiWQZqucrmCNV8jue7OSqrYtUelxCdvz8jUKHr/dFyiTt4isfGe0qF7LJ465OZW6G+7CZj9nFWa0wPPI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XA8SIPL_1788267721;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XA8SIPL_1788267721 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 21:02:01 +0800
Date: Tue, 1 Sep 2026 21:02:00 +0800
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
Message-ID: <apbMyLc0IhLMKwwA@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
 <apWEzobrZ3QR3IfN@linux.alibaba.com>
 <4f303f9f-fd20-475a-8004-1a670dfd34df@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f303f9f-fd20-475a-8004-1a670dfd34df@linux.ibm.com>

On 2026-08-31 20:27:38, Mahanta Jambigi wrote:
>
>
>On 31/08/26 7:12 pm, Dust Li wrote:
>> On 2026-08-28 08:54:37, Mahanta Jambigi wrote:
>>> This series fixes multiple lifetime races in the SMC diag dump path.
>>>
>>> The first patch adds the basic infrastructure needed to synchronize diag readers
>>> against connection-owned conn->lgr/conn->lnk updates. It introduces a
>>> per-connection spinlock and uses it in the link switch and connection free
>>> handoff paths. conn->lgr and conn->lnk are NULLed under the lock before the
>>> borrowed references are released, so a non-NULL conn->lgr seen under the lock
>>> guarantees the lgr object is alive. The diag reader can rely on this invariant
>>> without borrowing any extra reference.
>>>
>>> The second patch fixes two races in smc_diag itself:
>>>
>>> - serialize clcsock field access against smc_clcsock_release() with
>>>  mutex_trylock()
>>> - take conn->lgr_lnk_lock when reading conn->lgr and conn->lnk; use
>>>  smc_conn_lgr_valid() inside the lock to check that the connection is
>>>  still registered, then snapshot all required fields and call nla_put()
>>>  after releasing the lock
>> 
>> Hi Mahanta,
>> 
>> As discussed in the other thread, I think we should defer the release of
>> smc->clcsock and remove clcsock_release_lock.
>> 
>> In that case, we should no longer need these two patches. Also,
>> introducing more locks in SMC is the last thing I want to do :)
>
>Thanks for the new series "[RFC net-next 0/7] net/smc: tie clcsock
>lifetime to the smc socket and remove clcsock_release_lock" — once it
>lands, we can drop the mutex_trylock() fix for Race 1 (clcsock).
>
>However, Race 2 remains open. Your series does not touch smc_core.c or
>smc_cdc.c, so smc_conn_free(), smc_switch_link_and_count(), and
>smc_cdc_msg_validate() still write conn->lgr/conn->lnk with no
>synchronization against the diag reader.

Hi Mahanta,

Thanks for the detailed explanation. You are right that a per-connection
spinlock can work here, and I agree none of the lock sites are on the
per-message hot path. But I think we can also do the same thing we did with
clcsock_release_lock: instead of adding a lock, tie the lifetime of
conn->lgr/conn->lnk to the point where the connection stops being observable,
and remove the need for synchronization altogether.

For lgr/lnk, that point is the hash table. Once the connection is unhashed, the
diag dump (which iterates under the hash read_lock) can no longer reach it. So
if we make sure the connection-owned references are only dropped after unhash,
the invariant becomes: holding the hash read_lock and seeing a non-NULL
conn->lgr implies it is safe to dereference. The diag path then reduces to
`hold hash read_lock -> read conn->lgr -> if non-NULL, use it -> done` with no
new lock, no extra reference, and no trylock. The invariant is carried by
object lifetime rather than by a lock, which I find easier to keep correct over
time.

Best regards,
Dust

