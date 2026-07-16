Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AF71A6813
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 03:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784171876; cv=none; b=Tk+QW+rtsgeMC+4e5cfx0b+JW0d/X/u8DUm3pHNSqooYYljaP9LPsZBW3IsRWe3iZBMWGAau/Hfk5S7Fl3QskLtq1Jsya32cnqWP6p1PlGOvuoBFm1s5CCef1MAspOw7WgOuO/zCkw5Ab+xwuudRZULX0Ow5+yqpq7G7fb5VJAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784171876; c=relaxed/simple;
	bh=V4ievHFjUEIYTEdUO30x0i9t5/xFnZN5DSF17NHRYlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GJqWSXbpEeOGt2P37XILBksW1gpQ6XPj8CWOi7kK+4oTsRF2uKPFnu/Z9Owj03JEC44h1bN1ukYSWzyr7oLiEHISYqzqpw7lgsSTcRAzoXDNXjC0o7BqtMnXvAgP53jgh4BHsy4NZKpzCdivDl21m7Ufn1ITNfQUVpB7/EdkQ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WaB2Mq3/; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WaB2Mq3/"
Message-ID: <be5db399-5dd3-4714-b790-dc15b11e46bf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784171872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uT1ZgaPZBvPVOF0mHoU9tZ8/hIQnVgWG9mQETNu/HuU=;
	b=WaB2Mq3/aUJG6wDqlfFFimtNJbw1QcxxeEUqRfQINVpBeyKbP1gywT5SwTCi2ljo7CgirY
	A2McsX/sSqcGzZkoBAxNja350rvkoSrAeNwKnE2WR/27NoCA1GpkWfZFs7LS9omMAbvgrb
	MqgVj8Ew137bgOxsBv7hUztvnmr/6nw=
Date: Wed, 15 Jul 2026 20:17:41 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] RDMA/rxe: Hold netdev reference for transmit skbs
To: Xiong Weimin <15927021679@163.com>
Cc: linux-rdma@vger.kernel.org, jgg@nvidia.com, zyjzyj2000@gmail.com,
 xiongweimin <xiongweimin@kylinos.cn>, Leon Romanovsky <leon@kernel.org>
References: <20260714015554.174436-1-15927021679@163.com>
 <20260715064149.283009-1-15927021679@163.com>
 <e1a0dbd3-a576-41c4-9ca7-a20afda49f1f@linux.dev>
 <be8b5c24-2a54-41eb-a292-3fc09c6ae1ae@linux.dev>
 <33806ed7.2bb9.19f68e87c48.Coremail.15927021679@163.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <33806ed7.2bb9.19f68e87c48.Coremail.15927021679@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 7/15/26 8:11 PM, Xiong Weimin wrote:
>
>
> Subject: Re: [PATCH v3] RDMA/rxe: Hold netdev reference for transmit skbs
> Hi Yanjun,
> Thanks for taking the time to review. Let me clarify the question about the ndev pointer.
> The ndev pointer (struct net_device *) is a kernel virtual address that lives entirely in the local host's kernel address space. It is never serialized or transmitted over the wire. The RDMA/RoCE packet on the wire only contains protocol headers (ETH, IP, UDP, BTH) and payload data — no kernel pointers.
> The flow is:
>    1. rxe_init_packet() allocates an skb and calls dev_hold(ndev) to take a reference on the local net_device. This prevents the net_device from being unregistered (freeing the struct net_device memory) while the skb still references it.
>    2. The skb is passed to the kernel's IP stack via ip_local_out(). The IP stack may rewrite skb->dev during processing (e.g., VLAN, bonding, tunnel encapsulation) — this is why we stash the held ndev in skb_shinfo()->destructor_arg.
>    3. When the TX completes, rxe_skb_tx_dtor() calls dev_put() on the stashed ndev from destructor_arg (not the live skb->dev), releasing the reference.
>    4. Host B has its own completely separate struct net_device instances in its own kernel address space. It never sees or receives Host A's ndev pointer value.
> This is purely a reference counting fix for the local host's netdev lifetime — it ensures the net_device structure doesn't disappear while an in-flight TX skb still holds a pointer to it.
> Hope this clarifies. Please let me know if you have further questions.


Thanks a lot.

Zhu Yanjun


>
> Best regards,
> xiongweimin
>
>
> At 2026-07-16 10:56:20, "Yanjun.Zhu" <yanjun.zhu@linux.dev> wrote:
>> On 7/15/26 7:27 PM, yanjun.zhu wrote:
>>> On 7/14/26 11:41 PM, weimin xiong wrote:
>>>> From: xiongweimin <xiongweimin@kylinos.cn>
>>>>
>>>> rxe_init_packet() assigns skb->dev from an RCU-protected GID attribute
>>>> without holding a netdev reference. If the netdev is unregistered before
>>>> the skb is freed, subsequent accesses to skb->dev are unsafe.
>>>>
>>>> Hold a reference with dev_hold() when the skb is initialized and release
>>>> it from the transmit destructor or via rxe_put_skb() on error paths that
>>>> run before the destructor is installed.
>>>>
>>>> skb->dev can change on the TX path (VLAN/bond/tunnel, ip_finish_output2,
>>>> etc.), so put must use the same netdev that was held. Stash that pointer
>>>> in skb_shinfo()->destructor_arg: skb->cb is already used by
>>>> rxe_pkt_info and is rewritten by IP control blocks.
>>>>
>>>> To avoid blocking netdev unregistration on held skbs, flush all QPs to
>>>> the error state on NETDEV_GOING_DOWN and NETDEV_UNREGISTER so pending TX
>>>> work is drained and references can be dropped.
>>>>
>>>> Signed-off-by: xiongweimin <xiongweimin@kylinos.cn>
>>>> ---
>>>> v3:
>>>> - put the held netdev from destructor_arg, not live skb->dev
>>>>     (skb->dev may be rewritten by the TX stack)
>>> I am fine with this commit. Just a reminder: please send a new version
>>> of a patch in a new email thread. It is better not to send multiple
>>> versions of the same patch in the same thread.
>>>
>>> Other than that, thanks a lot!
>>> Let us wait for the feedback from Leon and Jason.
>>>
>>> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
>>>
>>> Zhu Yanjun
>>>
>>>> v2:
>>>> - rebase on current mainline so the patch applies cleanly
>>>> - flush all QPs on NETDEV_GOING_DOWN and NETDEV_UNREGISTER to
>>>>     release pending TX skbs before netdev unregister
>>>> ---
>>>>    drivers/infiniband/sw/rxe/rxe_loc.h  |  1 +
>>>>    drivers/infiniband/sw/rxe/rxe_net.c  | 68 ++++++++++++++++++++++++++--
>>>>    drivers/infiniband/sw/rxe/rxe_req.c  |  2 +-
>>>>    drivers/infiniband/sw/rxe/rxe_resp.c |  4 +-
>>>>    4 files changed, 68 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h
>>>> b/drivers/infiniband/sw/rxe/rxe_loc.h
>>>> index 64d636bf8..7c3cc48e8 100644
>>>> --- a/drivers/infiniband/sw/rxe/rxe_loc.h
>>>> +++ b/drivers/infiniband/sw/rxe/rxe_loc.h
>>>> @@ -92,6 +92,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
>>>>    /* rxe_net.c */
>>>>    struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av
>>>> *av,
>>>>                    int paylen, struct rxe_pkt_info *pkt);
>>>> +void rxe_put_skb(struct sk_buff *skb);
>>>>    int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
>>>>            struct sk_buff *skb);
>>>>    int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>>>> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c
>>>> b/drivers/infiniband/sw/rxe/rxe_net.c
>>>> index 3741b2c4b..86c9b19f6 100644
>>>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
>>>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
>>>> @@ -429,6 +429,29 @@ int rxe_prepare(struct rxe_av *av, struct
>>>> rxe_pkt_info *pkt,
>>>>        return err;
>>>>    }
>>>>    +/*
>>>> + * skb->dev may be rewritten on the TX path (VLAN/bond/tunnel, etc.).
>>>> + * The netdev we held in rxe_init_packet() is kept in destructor_arg so
>>>> + * that put always matches hold. skb->cb cannot be used: it is already
>>>> + * occupied by struct rxe_pkt_info and rewritten by IP control blocks.
>>>> + */
>>>> +static void rxe_skb_set_held_ndev(struct sk_buff *skb, struct
>>>> net_device *ndev)
>>>> +{
>>>> +    dev_hold(ndev);
>>>> +    skb->dev = ndev;
>>>> +    skb_shinfo(skb)->destructor_arg = ndev;
>> To be honest, I'm confused about this `ndev` pointer.
>>
>> `ndev` is a pointer to a `struct net_device` on Host A (the source
>> host). From what I understand, the current code appears to transfer this
>> `ndev` pointer to Host B (the destination host).
>>
>> On Host A, `dev_hold(ndev)` is called, while on Host B, `dev_put(ndev)`
>> is called.
>>
>> I don't understand how this can work. Host A and Host B have completely
>> separate virtual address spaces, so a pointer value from Host A should
>> be meaningless on Host B. Could you explain how this pointer remains
>> valid across two different hosts?
>>
>> Zhu Yanjun
>>
>>>> +}
>>>> +
>>>> +static void rxe_skb_put_held_ndev(struct sk_buff *skb)
>>>> +{
>>>> +    struct net_device *ndev = skb_shinfo(skb)->destructor_arg;
>>>> +
>>>> +    if (ndev) {
>>>> +        skb_shinfo(skb)->destructor_arg = NULL;
>>>> +        dev_put(ndev);
>>>> +    }
>>>> +}
>>>> +
>>>>    static void rxe_skb_tx_dtor(struct sk_buff *skb)
>>>>    {
>>>>        struct rxe_qp *qp = skb->sk->sk_user_data;
>>>> @@ -441,6 +464,18 @@ static void rxe_skb_tx_dtor(struct sk_buff *skb)
>>>>          rxe_put(qp);
>>>>        sock_put(skb->sk);
>>>> +    rxe_skb_put_held_ndev(skb);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Free an skb that still holds a netdev reference from
>>>> rxe_init_packet()
>>>> + * and does not yet have rxe_skb_tx_dtor() installed. Once the TX
>>>> + * destructor is set, callers must use kfree_skb() instead.
>>>> + */
>>>> +void rxe_put_skb(struct sk_buff *skb)
>>>> +{
>>>> +    rxe_skb_put_held_ndev(skb);
>>>> +    kfree_skb(skb);
>>>>    }
>>>>      static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
>>>> @@ -529,7 +564,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct
>>>> rxe_pkt_info *pkt,
>>>>        goto done;
>>>>      drop:
>>>> -    kfree_skb(skb);
>>>> +    rxe_put_skb(skb);
>>>>        err = 0;
>>>>    done:
>>>>        return err;
>>>> @@ -574,8 +609,7 @@ struct sk_buff *rxe_init_packet(struct rxe_dev
>>>> *rxe, struct rxe_av *av,
>>>>          skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(ndev));
>>>>    -    /* FIXME: hold reference to this netdev until life of this
>>>> skb. */
>>>> -    skb->dev    = ndev;
>>>> +    rxe_skb_set_held_ndev(skb, ndev);
>>>>        rcu_read_unlock();
>>>>          if (av->network_type == RXE_NETWORK_TYPE_IPV4)
>>>> @@ -710,6 +744,28 @@ void rxe_set_port_state(struct rxe_dev *rxe)
>>>>        dev_put(ndev);
>>>>    }
>>>>    +/*
>>>> + * Move all QPs to the error state so pending send/recv work is
>>>> drained and
>>>> + * in-flight TX skbs (which hold a netdev reference) can be
>>>> released. Called
>>>> + * from the netdev notifier so unregister cannot stall on held skbs.
>>>> + */
>>>> +static void rxe_flush_qps(struct rxe_dev *rxe)
>>>> +{
>>>> +    struct rxe_pool_elem *elem;
>>>> +    struct rxe_qp *qp;
>>>> +    unsigned long index;
>>>> +
>>>> +    rcu_read_lock();
>>>> +    xa_for_each(&rxe->qp_pool.xa, index, elem) {
>>>> +        if (!elem || !kref_get_unless_zero(&elem->ref_cnt))
>>>> +            continue;
>>>> +        qp = elem->obj;
>>>> +        rxe_qp_error(qp);
>>>> +        rxe_put(qp);
>>>> +    }
>>>> +    rcu_read_unlock();
>>>> +}
>>>> +
>>>>    static int rxe_notify(struct notifier_block *not_blk,
>>>>                  unsigned long event,
>>>>                  void *arg)
>>>> @@ -721,7 +777,12 @@ static int rxe_notify(struct notifier_block
>>>> *not_blk,
>>>>            return NOTIFY_OK;
>>>>          switch (event) {
>>>> +    case NETDEV_GOING_DOWN:
>>>> +        /* Start draining TX queues before the netdev disappears. */
>>>> +        rxe_flush_qps(rxe);
>>>> +        break;
>>>>        case NETDEV_UNREGISTER:
>>>> +        rxe_flush_qps(rxe);
>>>>            ib_unregister_device_queued(&rxe->ib_dev);
>>>>            rxe_net_del(&rxe->ib_dev);
>>>>            break;
>>>> @@ -735,7 +796,6 @@ static int rxe_notify(struct notifier_block
>>>> *not_blk,
>>>>                rxe_counter_inc(rxe, RXE_CNT_LINK_DOWNED);
>>>>            break;
>>>>        case NETDEV_REBOOT:
>>>> -    case NETDEV_GOING_DOWN:
>>>>        case NETDEV_CHANGEADDR:
>>>>        case NETDEV_CHANGENAME:
>>>>        case NETDEV_FEAT_CHANGE:
>>>> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c
>>>> b/drivers/infiniband/sw/rxe/rxe_req.c
>>>> index 12d03f390..927ef68de 100644
>>>> --- a/drivers/infiniband/sw/rxe/rxe_req.c
>>>> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
>>>> @@ -796,7 +796,7 @@ int rxe_requester(struct rxe_qp *qp)
>>>>                wqe->status = IB_WC_LOC_PROT_ERR;
>>>>            else
>>>>                wqe->status = IB_WC_LOC_QP_OP_ERR;
>>>> -        kfree_skb(skb);
>>>> +        rxe_put_skb(skb);
>>>>            if (ah)
>>>>                rxe_put(ah);
>>>>            goto err;
>>>> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c
>>>> b/drivers/infiniband/sw/rxe/rxe_resp.c
>>>> index d8cbdfa70..ee3630e4b 100644
>>>> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
>>>> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
>>>> @@ -866,7 +866,7 @@ static struct sk_buff *prepare_ack_packet(struct
>>>> rxe_qp *qp,
>>>>          err = rxe_prepare(&qp->pri_av, ack, skb);
>>>>        if (err) {
>>>> -        kfree_skb(skb);
>>>> +        rxe_put_skb(skb);
>>>>            return NULL;
>>>>        }
>>>>    @@ -994,7 +994,7 @@ static enum resp_states read_reply(struct
>>>> rxe_qp *qp,
>>>>        err = rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
>>>>                  payload, RXE_FROM_MR_OBJ);
>>>>        if (err) {
>>>> -        kfree_skb(skb);
>>>> +        rxe_put_skb(skb);
>>>>            state = RESPST_ERR_RKEY_VIOLATION;
>>>>            goto err_out;
>>>>        }
