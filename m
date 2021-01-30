Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B394C433DB
	for <linux-rdma@archiver.kernel.org>; Sat, 30 Jan 2021 15:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4807664E09
	for <linux-rdma@archiver.kernel.org>; Sat, 30 Jan 2021 15:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhA3PrZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 30 Jan 2021 10:47:25 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:36878 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbhA3Pq7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 30 Jan 2021 10:46:59 -0500
Date:   Sat, 30 Jan 2021 15:42:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612021352; bh=SqOOfzeH0noXKgcwnW/E6N5QTvdiF5329lwzLQGnSBA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=QNesXZCqMsxg9WWq30zTsSxoLyYfcPmwRs7aX304JT8WeHNT2iGeKEibhU43V9vgT
         OcUNJmqqlVZvquPt6J7MLkmBaKhnUDCH23CFKrtXuP8CIQAzp8bYEWC7Ml27/Xc8Kv
         f1C/khyFadsGNsXhEO1dzJJ1HgqXdA5r7yJfx+tsRajwQc82BlDqw5ZjlanwRvD1p/
         Z6/yyOW9dpxawki7sSDlRjQ8u8VXcF1HC/BOx5w/k5QhQxYz3scGwOIxNqXL+3s/5C
         rCuWxQuQ5OT/DcRqoNddGAAnHcb6UjvmotgX1eW2NpSx7FLK/lnTTT8mb84wIIyEYx
         YpUaky0ym1igA==
To:     Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net-next 3/4] net: introduce common dev_page_is_reserved()
Message-ID: <20210130154149.8107-1-alobakin@pm.me>
In-Reply-To: <20210129183907.2ae5ca3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210127201031.98544-1-alobakin@pm.me> <20210127201031.98544-4-alobakin@pm.me> <20210129183907.2ae5ca3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 29 Jan 2021 18:39:07 -0800

> On Wed, 27 Jan 2021 20:11:23 +0000 Alexander Lobakin wrote:
> > + * dev_page_is_reserved - check whether a page can be reused for netwo=
rk Rx
> > + * @page: the page to test
> > + *
> > + * A page shouldn't be considered for reusing/recycling if it was allo=
cated
> > + * under memory pressure or at a distant memory node.
> > + *
> > + * Returns true if this page should be returned to page allocator, fal=
se
> > + * otherwise.
> > + */
> > +static inline bool dev_page_is_reserved(const struct page *page)
>=20
> Am I the only one who feels like "reusable" is a better term than
> "reserved".

I thought about it, but this will need to inverse the conditions in
most of the drivers. I decided to keep it as it is.
I can redo if "reusable" is preferred.

Regarding "no objectives to take patch 1 through net-next": patches
2-3 depend on it, so I can't put it in a separate series.

Thanks,
Al

