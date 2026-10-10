Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA533B775A
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 08:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621583; cv=none; b=eujEamxGanqzNB5G25F+5rb9e1xtPBFYHVA3XVFLccrW1xdNpT1wOgp7d53Xzoq3EiuVXmjbDXnPVmd1oP2n/eCNxjiArDbsWd9BJMx1z9q+iYh8wgtexAN5mRQwojgALekYCzITZRDW9gKncIP2CKnBowOePkuXZJJNxMDmXNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621583; c=relaxed/simple;
	bh=yJPx+2NjK9QXSRZnpkECYqzwogeVBJ5CYjQo9wXfUBE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kt5bbvshtav0CRvUr0yLavAXCmmJKhLkcD0JN3b0UA3mnDmX4HCkYGUY+8Qw2qQpiieHxsrLkymwu55sR8mDJCmRnzrTuGxFMSISzpQwueq4d5C9ATrqeFBjRLRzHW6oAthnoBsTuHege5ftSaX7vCDaU59AqDDqMCtJWX8TvLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b7lxaZKr; arc=none smtp.client-ip=74.125.82.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b7lxaZKr"
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso1039930eec.1
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 01:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791621576; x=1792226376; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=konKcecyvECbbvQ18/L6qLdUB40zhoOLVBmrCxo31fE=;
        b=b7lxaZKrxD3UFktzJ8sRFkFV8gE4uhVI6zQcdpYLyeLYRcY/vWA37CPaV/aGikukwT
         EBr0laY3dWgi5Sr5ndLKHg8v3x0U9bYep7QVZ6SzNJPUABKFMt6mwrrOiBClQqla012E
         EL7BSezCnvV80Y2VsetELf0caUo3WoolwDjBYuQX/a5GaLAqEZYyA/ui2yvFd6hanawr
         1j8n8Xx41o8xC4+X2do7bTPY06JA4iq6/APdjcgZ4B36eaa/LWRJeiRDMc+7MzoxX1G/
         QdUNNar+0uGDBmE5ylHglov+UO4B/HIQ6Yz68IsB4uSsrxEtwy+P09Gx+o4KZxX9D4qL
         lXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791621576; x=1792226376;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=konKcecyvECbbvQ18/L6qLdUB40zhoOLVBmrCxo31fE=;
        b=HirPqZgZy04jlo9DBkAlwhHRV/JQF9Et8K+BvgvcNqZlYLQ1fMao25Gcdo+5pLOOk5
         2Gwro7ls8om0DATbYECv6a9ZSKCvCzhZjA1/IUANxS5D3c73y1I5UfFYn8g86YCtnnyS
         pk91g6ikLjOxYBSpMNQr4WMcFnKeWhtdEkm31K+WB9gL9Q5NXnN+OR9y99ZZYTDQR+MH
         g15sScniI9z0T+avuqPcfPRbLXBMz+YhsGFXANouqqCc+S+6rA4qp8wUe8IyvS4y9BH+
         dAmNUQbgFsXsNr3xrJmimxzm8SgmcXuCQhJGM0hdBMWWETHc49he3ClDGotfg4l0IO+v
         r5aw==
X-Forwarded-Encrypted: i=1; AKwUvBx6kE+lSa5GIQNqaFAE1vkEAdPvVAUSz9ml7yl9nfqmPEjaYJsKPQBJ1UCoH1egR/rsJAAcqkeAm9vG@vger.kernel.org
X-Gm-Message-State: AFq9FYLGoSampWAE7KpiUAaGME8gQHJeDhJPXOBqWXFrH6QDni/d/Cjd
	6enXgNUJbWp3ct6fCVLU9YH4j6RR884W7RAqUWgBHFF2YT4zCN/UYiP/8OjN2PQI4ukPtB02dk2
	K3ouB5ESVNeKxvmK0xtwnD3Zb9Q==
X-Received: from dli5-n2.prod.google.com ([2002:a05:7022:285:20b0:165:ba5:ba2b])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7023:a4b:20b0:158:b944:b20 with SMTP id a92af1059eb24-16a5dcf5a57mr5509841c88.11.1791621575725;
 Sat, 10 Oct 2026 01:39:35 -0700 (PDT)
Date: Sat, 10 Oct 2026 08:38:41 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261010083935.3274178-1-almasrymina@google.com>
Subject: [PATCH net-next v1 0/6] net: unify symmetric netmem and page_pool refcounting
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Ayush Sawal <ayush.sawal@chelsio.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Tariq Toukan <tariqt@nvidia.com>, Simon Horman <horms@kernel.org>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	John Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>, 
	Michael Grzeschik <mgr@kernel.org>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Petr Machata <petrm@nvidia.com>, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, Jakub Raczynski <j.raczynski@samsung.com>
Content-Type: text/plain; charset="UTF-8"

netmems (pages and net_iovs) have two independent refcounts: a non-pp
refcount (page._refcount or binding->ref) governing backing memory
lifetime, and pp_ref_count governing recycling within a page_pool while
page_pool holds a single backing non-pp reference. SKBs with
pp_recycle=1 own pp_ref_count references on page_pool fragments; SKBs
with pp_recycle=0 own non-pp references.

Core helpers currently mix these two refcounts asymmetrically:
skb_frag_ref() always increments the non-pp refcount via get_netmem(),
whereas skb_frag_unref() decrements pp_ref_count when skb->pp_recycle
is set. Any path that refs a fragment on a pp_recycle=1 SKB (or unrefs
with a hardcoded recycle=false) increments one counter and decrements
the other, leaking the backing memory while underflowing pp_ref_count
(e.g., IP-TFS [1], skb_split(), skb_shift(), and cloned SKB uncloning).
Unclear core APIs also led drivers and ULPs to open-code pp_ref_count
manipulations or add one-off helpers like skb_pp_frag_ref().

Unify fragment refcounting into symmetric pairs where each layer clearly
specifies which refcount it touches:

- Non-PP refcount: get/put_page(), get/put_net_iov(), get/put_netmem()
- PP refcount:     napi_pp_get/put_page()
- SKB netmem:      skb_netmem_ref/unref(netmem, recycle)
- SKB fragment:    skb_frag_ref/unref(skb, f)

[1] https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-912fa72106f0@secunet.com/

Mina Almasry (6):
  netmem: rename __get/__put_netmem() to get/put_net_iov()
  net: skbuff: add napi_pp_get_page() and use it in tcp_recvmsg_dmabuf()
  net: skbuff: replace skb_page_unref() and __skb_frag_unref() with
    skb_netmem_unref()
  net: skbuff: replace __skb_frag_ref() with symmetric skb_netmem_ref()
  net: skbuff: use skb_frag_ref() in skb_try_coalesce()
  net: kunit: test netmem, page_pool, and skb frag refcounting

 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |   2 +-
 drivers/net/ethernet/marvell/sky2.c           |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   2 +-
 drivers/net/ethernet/sun/cassini.c            |   4 +-
 drivers/net/veth.c                            |   2 +-
 include/linux/skbuff_ref.h                    |  64 +-
 include/net/netmem.h                          |  24 +-
 net/core/net_test.c                           | 747 ++++++++++++++++++
 net/core/skbuff.c                             | 145 ++--
 net/ipv4/esp4.c                               |   4 +-
 net/ipv4/tcp.c                                |   6 +-
 net/ipv6/esp6.c                               |   4 +-
 net/tls/tls_device.c                          |   2 +-
 net/tls/tls_device_fallback.c                 |   2 +-
 net/tls/tls_strp.c                            |   2 +-
 net/xfrm/xfrm_iptfs.c                         |   3 +-
 16 files changed, 900 insertions(+), 115 deletions(-)


base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.56.0.385.gd3acb90ef8-goog

