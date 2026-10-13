Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594EB3BADA2;
	Tue, 13 Oct 2026 08:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880499; cv=none; b=k0OrIjvFFi3gj/dhUDya+HSFUFqoXH+I3KPRsojuQTJ17E21tNoZ4TVJMpd2+uPDiqTgI8U57V2d9DbHdm4uLlAmyX8tuQao+a0ZppGPVHVa8Hv+oNl4MqPqQWYwn4nHArk4FuWcUwFvIaSL2IEstms8ciTOkKwq6qb8heKz9Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880499; c=relaxed/simple;
	bh=LtUyvLq4Z8x44hLSYKYGmBnRt9wgykGP6l683RDi3MU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RPzwMWHmRZphBNHp5p1ZzS/Dbhz7pL073zHkFcMLO+6FbfIlCoR6xj+iQ7TUgBZIRf8XgWLlIflXRzSHDMGq8NT0E6nV8xJgZFbDgGvxgws9bKSDk2UXFlp/2SuZKWp9fkt2g4dD7bW6pgxxdQneSmFJ9jc87JgAxBo1ATR7WZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUI6E+N3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUI6E+N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876471F000FF;
	Tue, 13 Oct 2026 08:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791880497;
	bh=TsEkVXndMihYYBXGZI+by4N5RyQghoF1gkWLMia2bCU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bUI6E+N3sQmlkD/994wcvx3S6lbSJQXu6NICgtuPxe9+RbJqp3XAnK15/3DmUyjoo
	 OsO4A3N2EIgWd2GIRtzXQwFH2UxQeM3tuoBEmfDh5y5iPDjtzVUMWZlBwZzXcBhatA
	 lfVuOoBnRuPcrfzePk/iC7oQjrt+OYSIG/PcBYFS8rKc/BOhx/HTaKPphyf3Gp2wWK
	 RqMvjKe2sBfF6QH7vwKfa/VhPM4ywBMyRBI77sgmeSPe3C2r2KIKl4/GmWbzlOPPui
	 xf6LHojlaB6sw+DAhBLu4N1wWS1Pjpc/HmMWwxrG+GCMsuLhR/Rnkwdk8Yph2SZdRn
	 8QOydACQ9yxRA==
Subject: Re: [PATCH net-next v2 4/6] net: skbuff: replace __skb_frag_ref()
 with symmetric skb_netmem_ref()
From: netdev-bot+sashiko@kernel.org
To: almasrymina@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org,
 steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com,
 sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org,
 aleksandr.loktionov@intel.com, u.kleine-koenig@baylibre.com,
 shaojijie@huawei.com, mgr@kernel.org, j.raczynski@samsung.com
Date: Tue, 13 Oct 2026 08:34:56 +0000
Message-ID: <179188049610.434549.3145310752638856710@kernel.org>
In-Reply-To: <20261012082148.1698596-5-almasrymina@google.com>
References: <20261012082148.1698596-5-almasrymina@google.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new SG-disable block in skb_segment() (net/core/skbuff.c,
  lines 4861-4873) clears NETIF_F_SG whenever frag_list members have…
- [Medium] The commit fixes pp_ref_count/page refcount corruption that is
  reachable today, but it has no Fixes: tag and no stable Cc.
- [Medium] The commit message overstates which paths were buggy and
  leaves out real behavioural changes.

--

net: skbuff: replace __skb_frag_ref() with symmetric skb_netmem_ref()

This replaces __skb_frag_ref() with skb_netmem_ref(netmem, recycle). As a
result, skb_frag_ref() takes a pp_ref_count reference when the destination
skb has pp_recycle set, mirroring skb_frag_unref(). The patch also stops
clearing pp_recycle in skb_release_data(), propagates pp_recycle in several
copy/split/segment paths, and clears NETIF_F_SG in skb_segment() when
frag_list members have mixed pp_recycle bits.

Link: https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-912fa72106f0@secunet.com/ [1]

> Previously, __skb_frag_ref() and skb_frag_ref() unconditionally
> incremented the non-pp backing refcount via get_netmem(), while
> skb_frag_unref() decremented pp_ref_count whenever skb->pp_recycle was
> set. Ref-ing a page_pool fragment into a pp_recycle=1 SKB (or clearing
> pp_recycle=0 on an uncloned SKB while clones still held pp_recycle=1)
> leaked the backing non-pp refcount and underflowed pp_ref_count across
> IP-TFS, skb_split(), skb_shift(), and cloned unclone paths.

[Severity: Medium]
Is this list of buggy paths accurate?

skb_shift() is only called from TCP write/retransmit queue paths:
tcp_skb_shift(), tcp_grow_skb() and tcp_collapse_retrans(). pp_recycle is
never set on those skbs, and skb_shift() already asserts:

    DEBUG_NET_WARN_ON_ONCE(tgt->pp_recycle != skb->pp_recycle);

How would the described leak happen across skb_shift()?

Before this patch, the cloned unclone paths (pskb_expand_head(),
pskb_carve_inside_header() and pskb_carve_inside_nonlinear()),
__pskb_copy_fclone(), skb_zerocopy() and skb_segment() all looked
self-consistent. Each took plain page refs, and in each case one of these
held:

  - the destination had pp_recycle=0, since __copy_skb_header() does not
    copy it
  - skb_release_data() had cleared pp_recycle, so the release was a
    put_page()

Isn't removing skb->pp_recycle = 0 then required by the new skb_frag_ref()
semantics, rather than a fix for an existing bug?

The removed comment and behaviour in skb_release_data() came from "skbuff:
Fix a potential race while recycling page_pool packets". Could the commit
message explain why that race no longer applies?

The message also leaves out some behaviour changes:

  - skb_shift() switches from skb_can_coalesce() to
    skb_can_coalesce_netmem(), so adjacent net_iov frags can now coalesce.
    Before, page_to_netmem(NULL) never matched.
  - Every skb_frag_ref() caller this patch does not touch now takes pp refs
    when pp_recycle is set. That includes iptfs_consume_frags(),
    tcp_clone_payload(), __skb_zcopy_downgrade_managed(),
    pskb_expand_head() and the pskb_carve_*() helpers.

Should these be called out?

[ ... ]

> Link: https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-912fa72106f0@secunet.com/ [1]
> Cc: Antony Antony <antony.antony@secunet.com>
> Cc: Stanislav Fomichev <sdf@fomichev.me>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: bpf@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

[Severity: Medium]
This fixes page_pool refcount corruption that can be reached today, but the
trailers have no Fixes: tag or stable Cc. Should they be added?

For IP-TFS, the actual fix appears to be a behaviour change at a call site
in iptfs_consume_frags() that this patch does not touch:

    iptfs_skb_head_to_frag(from, &toi->frags[toi->nr_frags]);
    skb_frag_ref(to, toi->nr_frags++);

Before this patch, that took a plain get_page() on from's page_pool head
page. Then consume_skb(from) dropped a pp ref, and to (pp_recycle=1) later
dropped another pp ref through napi_pp_put_page(). Could the commit message
name this call site as the IP-TFS fix?

For skb_split(), batadv_frag_create() calls:

    skb_split(skb, skb_fragment, skb->len - fragment_size);

skb_fragment comes from dev_alloc_skb(), so it has pp_recycle=0.
batadv_frag_send_packet() only linearizes frag_list, not frags[].

Before this patch, page_pool-backed frags moved into skb_fragment were
later released with put_page() while page_pool still considered them in
flight. The new skb1->pp_recycle = skb->pp_recycle in skb_split() fixes
this, but the caller is not mentioned.

The fix is mixed in with an API rename and a semantic change to every
skb_frag_ref() caller. Would splitting the fixes out make them easier to
backport?

Also, how does this patch relate to the separately linked IP-TFS fix [1],
which touches the same code?

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 46da61ad1f9eb..fe73f6e8d2b3e 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c

[ ... ]

> @@ -4866,6 +4858,20 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>  		}
>  	}
>  
> +	if (list_skb) {
> +		bool recycle = skb_shinfo(head_skb)->nr_frags ?
> +			       head_skb->pp_recycle : list_skb->pp_recycle;
> +		struct sk_buff *check_skb;
> +
> +		for (check_skb = list_skb; check_skb;
> +		     check_skb = check_skb->next) {
> +			if (check_skb->pp_recycle != recycle) {
> +				features &= ~NETIF_F_SG;
> +				break;
> +			}
> +		}
> +	}

[Severity: High]
Can clearing NETIF_F_SG here lead skb_segment() into BUG_ON(i >= nfrags)?

Each iteration of the !sg copy path ends with continue. It never advances
pos, i, frag, nfrags or list_skb:

    if (!sg) {
        ...
            if (skb_copy_bits(head_skb, offset, skb_put(nskb, len), len))
                goto err;
        }
        continue;
    }

Once hsize <= 0 and i >= nfrags, a later segment can take the clone branch
with a stale list_skb and pos. This happens when its len equals
skb_headlen() of that stale list_skb:

    if (hsize <= 0 && i >= nfrags && skb_headlen(list_skb) &&
        (skb_headlen(list_skb) == len || sg)) {
        ...
        while (pos < offset + len) {
            BUG_ON(i >= nfrags);

Take this example with mss 1000:

  - head_skb has 1000 bytes of linear payload and no frags
  - frag_list member A has 100 linear bytes, one 900 byte frag, and
    pp_recycle=1
  - member B has 100 linear bytes and pp_recycle=0

With SG cleared, the iterations go like this:

  - iteration 1 copies the head
  - iteration 2 has hsize 0 and headlen(A) 100 != len 1000, so it copies A
    without advancing the cursor
  - iteration 3 has len 100 == headlen(A), so it clones the stale A
  - pos goes from doffset+1000 to doffset+1100, and then to doffset+2000
    after the 900 byte frag
  - pos is still below offset + len (doffset+2100), so BUG_ON(1 >= 1)
    fires

With other geometries, could nskb instead be cloned from the wrong
frag_list member and carry the wrong payload?

Mixed pp_recycle frag_lists look reachable:

  - skb_gro_receive() rejects mismatched pp_recycle, but
    skb_gro_receive_list() does not check it.
  - Drivers like bnxt mix copybreak napi_alloc_skb() skbs (pp_recycle=0)
    with page_pool skbs (pp_recycle=1).
  - tcp4_gso_segment() falls back from __tcp4_gso_segment_list() to
    skb_segment() when SKB_GSO_DODGY is set (for example by a tc BPF
    program) or when skb_pagelen() no longer matches gso_size.

The !sg cursor issue predates this patch. But before this change, these
skbs took the SG path, where the cursor stays in sync.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012082148.1698596-1-almasrymina%40google.com
