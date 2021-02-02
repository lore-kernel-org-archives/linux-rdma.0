Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72867C433E0
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Feb 2021 13:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30B6F64F7B
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Feb 2021 13:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhBBNjS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 2 Feb 2021 08:39:18 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:63694 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhBBNbx (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 2 Feb 2021 08:31:53 -0500
Date:   Tue, 02 Feb 2021 13:31:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612272671; bh=Ykp5oBUQqC+epeovOARUFyMIlBz94OtNSxnarlpoxCM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=VuC82FKp0cBH26gfiPCBhPYJciwSACumC7iNgDRUYmQxnOJSShchLNXSwlnvj1Wib
         Pnai7uHviuGVYpmsC7xcVQk3XrKLW1nAUBTt3IEwNtXf83PPs5SJ6h3ISr4E4WlCXi
         uu9SNKnTLcVmdbqHA4oatbpUKg1qStJ5lBowG+ZKe72EykqijoPGY5zz8z+tRbOtfX
         TZGx5O1Yz2TbP6If5Nr18xeFqiT27iFM2T8lrexPfjlzaZI3Okyh4wvsEuEWdZrqA2
         iujsg9mV236040xjxcu8kACpX3O4PIjbuWb6Yb2srEIUbdsJ6rqFfa1jPazJu3U8xw
         075L/68sfYiAw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH RESEND v3 net-next 2/5] skbuff: constify skb_propagate_pfmemalloc() "page" argument
Message-ID: <20210202133030.5760-3-alobakin@pm.me>
In-Reply-To: <20210202133030.5760-1-alobakin@pm.me>
References: <20210202133030.5760-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The function doesn't write anything to the page struct itself,
so this argument can be const.

Misc: align second argument to the brace while at it.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 include/linux/skbuff.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9313b5aaf45b..b027526da4f9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2943,8 +2943,8 @@ static inline struct page *dev_alloc_page(void)
  *=09@page: The page that was allocated from skb_alloc_page
  *=09@skb: The skb that may need pfmemalloc set
  */
-static inline void skb_propagate_pfmemalloc(struct page *page,
-=09=09=09=09=09     struct sk_buff *skb)
+static inline void skb_propagate_pfmemalloc(const struct page *page,
+=09=09=09=09=09    struct sk_buff *skb)
 {
 =09if (page_is_pfmemalloc(page))
 =09=09skb->pfmemalloc =3D true;
--=20
2.30.0


