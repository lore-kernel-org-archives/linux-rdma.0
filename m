Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC2658125F;
	Tue,  8 Sep 2026 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884615; cv=none; b=cWcB8x+hvYhGR/9czX2p2ko/PknA660qlqTcaSIC87G+LbTW7fjd8RaolpeGNtiWaI3Th4isy+GgK9nZaoKRN5+mQGQ/tg/MYG2GErSErnwgferotX1vLFIGuK2AkabKwomde8jbIBHiQ5NsmhECnIwqEWljPo0w5s+veIXcPHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884615; c=relaxed/simple;
	bh=+J5zbQKf4eywIo9CTA7KsIV5ls2Wo3WhMctuUU7SK+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kalur+Pky3Ng96aNoe7PoXYJPiZ7wdbT8589vbBPtJpF6FsdUb5kX5zU3ujrzNQhqpfpLFO0IwfuzmyB3gwiiF62aQzw2r2YoB8r70kySFSEV8+qOFTpaHs991ggxOPeFUtTVXzZ34ph2AixQixjP3aDaSHNKSkXyOgWsb14s+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OxMoiTT3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OxMoiTT3"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688F1fuZ3545300;
	Tue, 8 Sep 2026 16:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QlgXXB
	rorwGSyIXIkqlXdkMnkEsNf07rcyafcNglo0U=; b=OxMoiTT3c/Ussz9PJBxF/c
	nO8Z4HkunOcO8bUBNwD4iT9FylsfgTV4dy+XyslnL/C4vDS784n1AAdLKWp0070F
	oiQvpooAUQ5pVgvHh9NAbYTgOg/AAP06KvE9PLKR3sgmsQ/uldbbJmVP+UxyrINi
	h8BFzUWjPRPxFWJz7UOyRq8TQLZjaMhC0d9flDJCku529pAZT3t67tM95OTQbrUW
	W3rFXwMbC5znBVSzChVEZ7vEt6CA3t7p0VrUAQ/eCUoSZex1DGScpqyZ1gCyUN7n
	D4hp5ndA8M64bJwd+QGgzkHAAj057msIPMPqsCOuUHGiEV3P8SGfI2Bb95m0Xb5Q
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbqk0awr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 16:23:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 688GBGdV024172;
	Tue, 8 Sep 2026 16:23:25 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggymgcumc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 16:23:25 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 688GNO9o22413862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Sep 2026 16:23:24 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D6E35804B;
	Tue,  8 Sep 2026 16:23:24 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C44F458055;
	Tue,  8 Sep 2026 16:23:16 +0000 (GMT)
Received: from [9.39.31.24] (unknown [9.39.31.24])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Sep 2026 16:23:16 +0000 (GMT)
Message-ID: <3803428a-2edc-4a5c-88e8-025f2f3322f4@linux.ibm.com>
Date: Tue, 8 Sep 2026 21:53:14 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 0/2] net/smc: fix diag dump lifetime races
To: dust.li@linux.alibaba.com, Mahanta Jambigi <mjambigi@linux.ibm.com>,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
 <apWEzobrZ3QR3IfN@linux.alibaba.com>
 <4f303f9f-fd20-475a-8004-1a670dfd34df@linux.ibm.com>
 <apbMyLc0IhLMKwwA@linux.alibaba.com>
 <85fa9f02-7516-4595-b5a8-4ae4ca845121@linux.ibm.com>
 <apgTu9dRGIQE6tm3@linux.alibaba.com>
 <899816c9-c908-4d64-8f5c-ba35619f78f2@linux.ibm.com>
 <apriDec7yHBkQgNv@linux.alibaba.com>
Content-Language: en-GB
From: Hidayath Khan <hidayath@linux.ibm.com>
In-Reply-To: <apriDec7yHBkQgNv@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 5fqY98Q1398DB3b0Upo0ygA0QZu-PKtT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MyBTYWx0ZWRfXxi3vi/YAyguo
 KS1Fn/n5o5NuWN+TnL6nSzxBQuA8Zx09IqbMYdyauPHdH3fOVLvu/6BvJ7VhpFR4WRJFD7DUVU7
 UeF8fGCnGNFl+eJXeuRaBD4W/Ucefqk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MyBTYWx0ZWRfX/Ig7ORl5GMQ2
 YJbFZlrVJNAKyxZWh+t8Ur5RsBRk5PVIP/cpUAooHYqpL4dPii/kUZ8v4MpHOyD2/Os9RwFrKQD
 hcrIXGPBPDc0Mo415ZUuF1bctDCGzwmhgQ6TwktPMUjNBpnBUdHECniwEPXlTYTmd0fcE42DmLJ
 +kFnGFFCYu0ha6OiE8PbNhWOZbu1NyYRIzcG+jvMyL3JjAcknIZssKyhhsqJ5K2UEnrEwjs8lT2
 XzzFXk4haZ71zOL8GquaIDDrB6nVxtQyXz/0whc10f1Brlv6iBD5hXc14AGWA3TfexbvpQ4xfIx
 AUPsz0VXdAQ9+xfC5MZGrK2gpUI/G+dfLYEK5Q9KaTI6D6jJBc+1pYNpV/g5IR/ZZqjN3VcLydy
 Ug4d6NKAHlu7IseOiHNcvbmWo5PWpN3EnA0vIdP8tvxKxwi/FD05dTLNhFdnjZ5vTa+9ChauztQ
 3vAnYqRKiLh5CQgpk2Q==
X-Authority-Analysis: v=2.4 cv=JaKMa0KV c=1 sm=1 tr=0 ts=6aa0367e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=eYgAQB3uTrKrHDNDXAgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: XEin1-ch5SiKkVuMRGtEIR_blwOEQr7o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080173


On 04/09/26 8:51 pm, Dust Li wrote:
> On 2026-09-03 13:26:30, Mahanta Jambigi wrote:
>> On 02/09/26 5:46 pm, Dust Li wrote:
>>> I think we can close this window by holding the SMC hash table lock in
>>> smcr_link_clear()? [...]
>> Hi Dust,
>>
>> After debugging further, I believe that __smcr_link_clear() cannot be
>> called from smc_switch_link_and_count() because
>> refcount_dec_and_test(&lnk->refcnt) is always false on that path — the
>> initial ref (set in smcr_link_init(), released only in
>> smcr_link_clear()) is always held while the switch executes. So there is
>> no UAF from that path. The only consequence is that the diag reader may
>> observe a stale conn->lnk pointer value — pointing to the old link which
>> is still fully live — and read the old link's ibport/link_id/ibname from it.
> Hi Mahanta,
>
> Sorry for the late reply. I've done some more thinking on this topic.
>
> That's true, but strictly I think there is still a small gap. The old link is
> memset later, in smcr_link_clear() after all connections have migrated, so a
> reader that loaded conn->lnk just before its own connection was switched has a
> few-instruction window before it dereferences. In practice this window is
> really narrow: the clear path runs the whole switch + LLC + QP teardown, orders
> of magnitude longer than the reader's load+deref.
>
>> The real UAF is via smc_conn_free(): it drops both the connection-owned
>> conn->lnk reference via smcr_link_put() and the connection-owned
>> conn->lgr reference via smc_lgr_put(), while the socket is still visible
>> in the hash table. [...] The current patch tries to fix this using
>> lgr_lnk_lock. Since you suggested we fix it with *unhash-before-free*, I
>> thought about it and here is my proposal.
>>
>> Proposed fix (high level):
>>
>> Introduce a smc_conn_unhash() helper with a per-connection unhashed flag
>> that ensures the socket is removed from the hash table exactly once.
>> Call it at the top of smc_conn_free(), before any lgr/lnk references are
>> dropped.
>>
>> This establishes the invariant: any socket still visible to the diag
>> reader under read_lock(hash->lock) has valid conn->lgr and conn->lnk
>> pointers. [...]
>>
>> Does this design look reasonable to you?
> Yes, I think it's the right fix and we can go ahead and fix it this way first.
>
>> There is a separate minor issue — smc_switch_link_and_count() updates
>> conn->lnk under send_lock while the diag reader loads it without any
>> lock, which can cause stale ibport/link_id/ibname in *smcss -R* during a
>> failover event. This is a data race but not a safety issue since the
>> link struct is always live at that point.
>>
>> This race is very rare in practice [...] Even when it occurs, the effect
>> is transient: one dump may show the old link's ibport/link_id/ibname, and
>> the next dump will show the correct values.
> I think this is acceptable.
>
> ---
>
> I've been re-thinking this a bit more. We've been plagued by SMC's tangled
> locks and ad-hoc lifetime handling for years — every fix adds another lock or
> another ordering rule. I think it's time to step back and refactor this area as
> a whole, and set up some rules for how we use locks/refcounts in SMC, instead of
> keeping patching individual races. Below are some rough thoughts.
>
> 1. Object layering
>
> SMC really has three lifetime tiers, and the top one has to be split the way
> TCP splits struct socket from struct sock:
>
> - the file (struct socket) — lifetime tied to fput;
> - the connection sock (smc_sock, with conn embedded) — lifetime tied to
>    sk_refcnt; like a TCP sock it can be orphaned and outlive the file. On an
>    active close, close(fd) orphans it first, but it stays alive — still bound to
>    the transport — to finish the close handshake;
> - the shared transport (lgr / link / device) — lifetime by refcount, multiplexed
>    across connections.
>
> It's the socket/sock split, plus one more tier because our transport is shared
> (TCP's sock is 1:1, our lgr/link is not). Today smc_conn_free() mixes all three
> and is called from the transport layer while the socket is still hashed —
> that's exactly where these races come from.
>
> With the tiers separated, teardown becomes two independent, idempotent steps
> rather than one:
>
> - orphan (file <-> sock): at fput, via sock_orphan();
> - transport-detach (sock <-> transport): the connection drops its lgr/link
>    refs. On an active close this happens later, after the handshake completes;
>    on a transport fault it happens immediately.
>
> The sock is freed only once it is orphaned, transport-detached, and the last
> sock_put lands; the order of the two steps just depends on who initiates
> teardown (app close vs. transport fault).
>
> 2. Lifetime & boundary contract
>
> Give each tier the right tool, and a clear boundary between them:
>
> - ownership by kref; traversal by RCU (conn->lgr / conn->lnk become RCU
>    pointers, the lgr is freed with kfree_rcu); fd-visible objects (clcsock)
>    released only after the last fput; and no in-place mutation of a published
>    object (stop memset()ing a link — mark it dead and reclaim it with the lgr
>    after a grace period);
>
> - boundary rule: on a transport fault the lower layer only signals and
>    transport-detaches; it never orphans, unhashes, or frees the sock.
>    - signal = wake the app with an error (sk_err + wakeup);
>    - transport-detach = publish rcu_assign_pointer(conn->lgr/lnk, NULL), then
>      drop the usage references (smc_lgr_put / smcr_link_put). The transport
>      object itself is reclaimed later by its own refcount + kfree_rcu; the sock
>      is left untouched.
>    Handle-side teardown (orphan, unhash, clcsock release, final sock_put)
>    belongs to the connection/file side and is driven by close — never by the
>    transport layer.
>
> With that, a diag reader under rcu_read_lock is guaranteed the link/lgr
> outlives its critical section, so the per-connection lgr_lnk_lock is no longer
> needed and smc_conn_unhash() can be retired too. (clcsock_release_lock goes
> away separately, via the clcsock lifetime series.) It's a larger, mostly
> mechanical change and would take a lot of careful rework, so I'd do it as a
> follow-up. Your smc_conn_unhash() is the right fix to take now (and for
> stable); the rework, if we agree on this direction, would retire it afterwards.
Hi Dust,

Thanks for writing this up and for the pointer from my abort_work patch.

You describe three tiers, with lgr, link and device as the transport one.
I was not sure where the buffer descriptor fits. It does not seem to
follow the lgr: smc_buf_unuse() returns conn->rmb_desc to lgr->rmbs, and
smc_buf_get_slot() can then hand it to another connection while the lgr is
still alive.

Two places look like they can outlive it:

- a splice reader still holding pipe pages, since smc_buf_unuse() does not
   consult conn->splice_pending;

- smc_cdc_msg_recv_action() and smc_cdc_handle_urg_data_arrival(), which
   read conn->rmb_desc after smc_cdc_rx_handler() has already left
   conns_lock. On the is_reg_err path smcr_buf_unuse() frees the
   descriptor rather than recycling it.

Have you already considered the descriptor in this model? Would it need
its own kref, or is it meant to sit inside the transport tier? I may be
missing something here.

One smaller question, on the boundary rule. The SMC-D side already looks
close to what you describe: smcd_handle_irq() holds smcd->lock across both
the lookup and the tasklet_schedule(), and smc_ism_unset_conn() clears the
slot under the same lock. The SMC-R receive path drops conns_lock between
the lookup and the action. Is that difference something the refactor
would make uniform, or is there a reason the receive path cannot hold the
lock that long?

If it would be useful, I can write up the lifetime assumptions I have run
into while working through the teardown paths. Please tell me if that
helps, or if it would only repeat what you already have.

Thanks,
Hidayath
>
> Best regards,
> Dust
