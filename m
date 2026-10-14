Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6C0531628
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999593; cv=none; b=GPTBYAp9sgPYoSOjQlLeOiY9fFsLYwfllOz14g6CsUw6V8musWXHiHcWmbEaNIDKwT2G9znvCR2Wa+Ey9KxxKKutzzub9kScq0Jd1z1O7h4GyVF11xt8nBf7/sRKPEpUjwsCpLb/MUh7tWb8K/kD3TD8rmtkLUJGEPJ6jQtE6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999593; c=relaxed/simple;
	bh=oluG7xcmeITa8FLe+FfnkX9ip9PZfkSG9lEZJ8KGjgU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sjudzrJk958HvPJOoOKxCHK3OcPWa+cYsF3gC/ZQ9grWJynQmuo5rC+bpq1jaj8ZxhylniE+JbE62eh3W6vo2CWvdUog6SmZ2Eo82LqCeyhVSJY6/Y3uPqE61VdcG6EYuxg89mLeqjZEsAHQBQmEQpfGGZIELNgwLygEWI5ti6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FHNmFEda; arc=none smtp.client-ip=74.125.82.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FHNmFEda"
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-351788121cfso8088005eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 10:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791999586; x=1792604386; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZGiIOUHQmkHQqIV3kW/XLCzmw9OTAtIO2OAegBC+Ifc=;
        b=FHNmFEdaFVAAwfxyBF5krWrJu13XCissowIJqWrMICvPl5PEeTU0cJaYSVOmNA9lxr
         +ebIVidCQrXE51Fho28NGbl54s2qxcLUZXJgW+WyKzMh9bN0H5tarQ0mgq2M6tyPmpoK
         vl5+J/6lf49VnX3loQNt93gnfqu2OtNiQVvPZqZJ2o0BPqucGSAccSHcTMxKBeJtUUhB
         faJnmCUaIEr5Qxh6V9dd7bJWODBIEHOfE/RE+bVfOTvz/MXNbSEntHuxqMduzHGxB1eB
         cEhuXbwAbZq1GaceScL0Ez9XoLjgXv8ueZ3UWjjHqef73iFxn2FeHRrJP8OCbWoVuCyW
         CVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791999586; x=1792604386;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZGiIOUHQmkHQqIV3kW/XLCzmw9OTAtIO2OAegBC+Ifc=;
        b=O3Vsg9VOhVmrtoch/5X7TNlpEcwzD+xYus3I7aG1ezQj3EEmk8ku9c3pvCkMygU55T
         Lezhty/yWaJ+LL1m7FtvmTf+7hu9NTy2M61meT+PYcqojOcvjY4Mv4S3r9TfBDlLliHs
         0MxGlT5LoWzBUA7KkGzEqX5w4jfZNCpzfdduao35yG5B+A2/x2Jb1xcBg+Ul4nI54msU
         FpUuZjom2gKt/PG4/tnKz6QpG/QOzztWtQs41TJe7Mr6exjvqwbNeo+Dua5ouZIwA7fz
         12gyqwrlExukgoBSUQAjhZa8rDJEh1bqmK1WsZD1AIBb72s55U7xjzjopnZrc4uqlzUx
         tJyw==
X-Forwarded-Encrypted: i=1; AKwUvBz3xyjTmMqVo7MVkZwE7b9eo+F6XUszoEm3agnTj75Nat+mDz2HWxOSrCGCqS+87Jt6AljM3RXL3fMi@vger.kernel.org
X-Gm-Message-State: AFq9FYK/Zl3wj5HRlxGnZp2SLUHyxm4FcCuYd/z/y6ruUeKqN29jdl/7
	4p0aDBNGea3ALHHZ7UOxs3fqharwg8KNyINsr5qgRUPrJHimavFCo89uEGg4jT7r84CM3b8ZOYc
	KFdewCoDR/xPRduBzFsZ3NOyWjw==
X-Received: from dycno2.prod.google.com ([2002:a05:7301:1442:b0:351:7d2d:e1d7])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:20c3:10b0:35c:afc2:a752 with SMTP id 5a478bee46e88-35cafc2a8acmr6893595eec.7.1791999585721;
 Wed, 14 Oct 2026 10:39:45 -0700 (PDT)
Date: Wed, 14 Oct 2026 17:37:14 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261014173945.373295-1-almasrymina@google.com>
Subject: [PATCH net-next v3 0/6] net: unify symmetric netmem and page_pool refcounting
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
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Petr Machata <petrm@nvidia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?=" <u.kleine-koenig@baylibre.com>, Jakub Raczynski <j.raczynski@samsung.com>, 
	Wang Zhan <wang.zhan@smartx.com>, Willem de Bruijn <willemb@google.com>
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

Found by code inspection while reviewing [1] and confirmed with the KUnit
tests in patch 6; not observed in production. Driver and ULP call-site
changes are compile-tested only.

Link: https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-912fa72106f0@secunet.com/ [1]

---
v3:
- Linearize straddling output segments in skb_segment() when frag_list
  SKBs mix pp_recycle flags instead of clearing NETIF_F_SG, and add a
  KUnit regression test (Sashiko).
- Link to v2: https://lore.kernel.org/netdev/20261012082148.1698596-1-almasrymina@google.com/

v2:
- Clear NETIF_F_SG in skb_segment() when frag_list SKBs mix pp_recycle
  flags (patch 4).
- Export skb_shift() via EXPORT_SYMBOL_IF_KUNIT() to fix the
  CONFIG_NET_TEST=m modpost error reported by NIPA (patch 6).
- Reset mac_header before skb_segment() and check skb_clone() results in
  KUnit (Sashiko), and extend KUnit coverage to compound tail pages,
  skb_try_coalesce(), TCP devmem recvmsg, skb_zerocopy() rollbacks,
  skb_split()/skb_shift() edge cases, and mixed pp_recycle frag_list GSO.
- Note how the issues were found and tested (netdev-bot), and add
  Assisted-by tags.
- Link to v1: https://lore.kernel.org/netdev/20261010083935.3274178-1-almasrymina@google.com/

Mina Almasry (6):
  netmem: rename __get/__put_netmem() to get/put_net_iov()
  net: skbuff: add napi_pp_get_page() and use it in tcp_recvmsg_dmabuf()
  net: skbuff: replace skb_page_unref() and __skb_frag_unref() with
    skb_netmem_unref()
  net: skbuff: replace __skb_frag_ref() with symmetric skb_netmem_ref()
  net: skbuff: use skb_frag_ref() in skb_try_coalesce()
  net: kunit: test netmem, page_pool, and skb frag refcounting

 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |    2 +-
 drivers/net/ethernet/marvell/sky2.c           |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |    2 +-
 drivers/net/ethernet/sun/cassini.c            |    4 +-
 drivers/net/veth.c                            |    2 +-
 include/linux/skbuff_ref.h                    |   64 +-
 include/net/netmem.h                          |   24 +-
 net/core/net_test.c                           | 1222 +++++++++++++++++
 net/core/skbuff.c                             |  157 ++-
 net/ipv4/esp4.c                               |    4 +-
 net/ipv4/tcp.c                                |    6 +-
 net/ipv6/esp6.c                               |    4 +-
 net/tls/tls_device.c                          |    2 +-
 net/tls/tls_device_fallback.c                 |    2 +-
 net/tls/tls_strp.c                            |    2 +-
 net/xfrm/xfrm_iptfs.c                         |    3 +-
 16 files changed, 1387 insertions(+), 115 deletions(-)


base-commit: 05b5019b01fb9443b09ae4ed34af1135a80a84c8
-- 
2.56.0.212.g129ede20d9-goog

