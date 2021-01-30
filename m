Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA98BC433E0
	for <linux-rdma@archiver.kernel.org>; Sat, 30 Jan 2021 10:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5A264DE7
	for <linux-rdma@archiver.kernel.org>; Sat, 30 Jan 2021 10:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhA3KEc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 30 Jan 2021 05:04:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232098AbhA3KDy (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 30 Jan 2021 05:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6A9464E0E;
        Sat, 30 Jan 2021 02:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611974348;
        bh=Xa3aXdkH6VcjkQv2mRzeHTVU3FePrWxYumhPtvDn8zo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CuA7saw/NDT+jltBVLbBOTtilmjJ0UnnOPSNhIp0vShR5tTLtelQ/Ci1Y9jrcJzjk
         3FDxe+ykvXfRDbwSZtUYnXtiMKt7H4HVivJJqrTYJLfVxJhJmmk9QLMSNTtOVqUTDb
         dZyybRVqcd4QDuNd46UIFCQs37Gnk5Wg+w4OCZp/BECSGKKr2Rsk1VOvwYaiqlQywb
         VzKklQrRbxLRmDiDCPqKf/0JADwvBNgIVZ5Q1Jh2qc26DZyViIudB0FLkI9srNwS0N
         JVXIyfhG944QWXOaymGasP3yjFfN1BYSqkbDq7WrhqUa8KGo01/23gOQAkgrkSry62
         RWTV4TxpCVpcg==
Date:   Fri, 29 Jan 2021 18:39:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v2 net-next 3/4] net: introduce common
 dev_page_is_reserved()
Message-ID: <20210129183907.2ae5ca3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127201031.98544-4-alobakin@pm.me>
References: <20210127201031.98544-1-alobakin@pm.me>
        <20210127201031.98544-4-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 27 Jan 2021 20:11:23 +0000 Alexander Lobakin wrote:
> + * dev_page_is_reserved - check whether a page can be reused for network Rx
> + * @page: the page to test
> + *
> + * A page shouldn't be considered for reusing/recycling if it was allocated
> + * under memory pressure or at a distant memory node.
> + *
> + * Returns true if this page should be returned to page allocator, false
> + * otherwise.
> + */
> +static inline bool dev_page_is_reserved(const struct page *page)

Am I the only one who feels like "reusable" is a better term than
"reserved".
