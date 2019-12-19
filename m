Return-Path: <SRS0=QLb8=2J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C88C43603
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Dec 2019 19:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66F3C222C2
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Dec 2019 19:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="O7ALl0+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfLSTHa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 Dec 2019 14:07:30 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40880 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728492AbfLSTH1 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 19 Dec 2019 14:07:27 -0500
Received: by mail-qk1-f195.google.com with SMTP id c17so5535479qkg.7
        for <linux-rdma@vger.kernel.org>; Thu, 19 Dec 2019 11:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3ynYYrABn/DKREDZtjdsPcjfmCyA8J/9/tPFn622uQo=;
        b=O7ALl0+hRrrF2Q0zXYiNWlS7hL3qlhl4QTULDe2UhU9JLUQ/5BW8Od/DNGCbAzJHPR
         YNNewkF0qx5fV7IIFjS/ATZHSnTM0jLszMPiTMRYAF7ZR9qAJre8MdudizxxG1l7d/wi
         nO+FcNbcKmdte/WC3CDuFB0tBP9a5lEbGdffMGba08RqzSpLC1683Bcfe8XTjfM9JmjB
         VADpkIcFjjQFIvn8EaQg5Q6Z/hV+GZxqCparfWtsfPqtvMp8lyoT+DMLYZhCdqqDMAoJ
         pBjPEkKAG0I+ePK1yMFaH/l3duN8yCOT9HkD2ervR6F+l0E9qbWCWZMSMsLyYVt06tsz
         j41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ynYYrABn/DKREDZtjdsPcjfmCyA8J/9/tPFn622uQo=;
        b=BvkDfl1q8FtfbqdE+8VOVKBJ6U7OABm9ZsbzFwP+H0QPBDvTrUYTzBqLQNhwdzaMaq
         fTxHc92uY/Gj45ZKvfbu+R9OaIQSAn62tijYwcPJFNnlQ4r6wno2BpJoldT69JxZvMaE
         NkjpZzr0w+hfjuedfNYttLhvJPHYjqGqEPagFTRARQSIfOIwh8aeQjJhwXGzjbgQ8Gmt
         eNhUGyRnT7Ddkt7ECnrT18784kHoTgypC3sIdzOYerRgEtCmRfDzRczLc4wI6IuTESF5
         5xs4b6HnBLjQyqjgIQJSY8QqvL/gNSuGYIMQK6wAqrRuSDGxhtOFlipx+uLoE9Fw4re9
         ScJg==
X-Gm-Message-State: APjAAAWeyzDpfrvSmsVz3/7mMVKKz3y9kU0xSerpw9kiFbvBD1PPQCrc
        9MvFd2kVBCEu+xYZu8AmnoFpyg==
X-Google-Smtp-Source: APXvYqy3oO+DYd+dQXJ2SxLbEhvbs+eqYSKc9jA0tEsRytUVkgFfrwO1b07U8uQ+X4ebuCBzbEjaww==
X-Received: by 2002:a37:9f57:: with SMTP id i84mr9735230qke.29.1576782446678;
        Thu, 19 Dec 2019 11:07:26 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id h34sm2193693qtc.62.2019.12.19.11.07.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Dec 2019 11:07:26 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ii18v-0008Bt-JN; Thu, 19 Dec 2019 15:07:25 -0400
Date:   Thu, 19 Dec 2019 15:07:25 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-rc 1/3] IB/mlx5: Unify ODP MR code paths to allow
 extra flexibility
Message-ID: <20191219190725.GL17227@ziepe.ca>
References: <20191219134646.413164-1-leon@kernel.org>
 <20191219134646.413164-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219134646.413164-2-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Dec 19, 2019 at 03:46:44PM +0200, Leon Romanovsky wrote:
> From: Artemy Kovalyov <artemyko@mellanox.com>
> 
> Building MR translation table in ODP case requires additional flexibility,
> namely random access to DMA addresses. Make both direct and indirect ODP MR
> use same code path, separated from non-ODP MR code path.
> 
> Fixes: d2183c6f1958 ("RDMA/umem: Move page_shift from ib_umem to
> ib_odp_umem")

What does it fix?

Jason
