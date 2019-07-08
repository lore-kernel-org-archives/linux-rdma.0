Return-Path: <SRS0=cc4V=VF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C843C606CE
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Jul 2019 20:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDE6216F4
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Jul 2019 20:20:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="K1Xasd5G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbfGHUUZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 8 Jul 2019 16:20:25 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:32986 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfGHUUZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 8 Jul 2019 16:20:25 -0400
Received: by mail-qt1-f194.google.com with SMTP id h24so19413453qto.0
        for <linux-rdma@vger.kernel.org>; Mon, 08 Jul 2019 13:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l9H2InVfPpYLKW6iri4EJDHsOReDKTmYEBAcsIcmk6I=;
        b=K1Xasd5GA93r2xbus2zSLNvvJeMGBZtZ8SCC20gL5p0WC2hF12FZJULzL0cNtiU662
         8tPJKHt4W8XURT6DvJlnKrF325Vx0Sy+ugD0zj065Nk1RUn246R1Sv0JEQi9xBINLOQq
         TetN3doRiI7RqxrICVUbNqYH3hUVuXrcR79emg7j/pFuWdMslwnrlYZxR+JpWeRKjRgF
         VEpiYg8gEJj2AZRNpLDBI1TCXIn2oJlzMkCzzPAMaWza5c50lvPPjMUPi8gkFBTgVX5/
         vPk1w84/O5CzWiiW8p3asbhmSJ+KjBHaAKreUFdvUPh5j/siRdYY16Avkth3iY66f33B
         4ATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l9H2InVfPpYLKW6iri4EJDHsOReDKTmYEBAcsIcmk6I=;
        b=H6TQ72zjIquLcI+NXc8BfgUOi9hBuqeBKujiEvSjUfBq2G7JIsEU1Tp/xO+0mhWjRw
         BWp4jwi8RqoJ9aUmklJ11GJW6EkM0pB7Y5/cfw14yjqCP+i/73JvZ+D/brFWM++sItcd
         C8ACaT6Wk/QpiA+KfglXX2Q6Vyg/wC6ZdRZOw4LwcwTjHaPSneZHZfhnSyUathEV2RUR
         C82yLfScySp+z7klNDjCKx+i7sfSDC8GGzplQm/8c5KyaKgr58oGHso6zI9ySIWhxElU
         tzY3n43zWVdDcrwfrb6mhBQPSRdhspYt8UbHmKbgMoDwg/Wfl/cKYn2Ie7Uy+hWblODH
         QCxA==
X-Gm-Message-State: APjAAAXfyrUGMKfe53TwhflfztqbsFyEMEbC6S+Brn0RqxqwL0Q6BTa+
        /6S9QP61fMayvRd+EpO08IHnZbQdslwOlA==
X-Google-Smtp-Source: APXvYqz4XNF9KLIVVjRBr+r/ec3UdFIrZpqcPKI8NUOcdIoaPCmyOhBCGRFlagouFGxTZkqJPPL7Ag==
X-Received: by 2002:ac8:2409:: with SMTP id c9mr15499391qtc.145.1562617224368;
        Mon, 08 Jul 2019 13:20:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id 42sm9147487qtm.27.2019.07.08.13.20.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Jul 2019 13:20:23 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hka7b-00027r-FA; Mon, 08 Jul 2019 17:20:23 -0300
Date:   Mon, 8 Jul 2019 17:20:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH rdma-next 2/2] IB: Support netlink commands in non
 init_net net namespaces
Message-ID: <20190708202023.GA8020@ziepe.ca>
References: <20190704130402.8431-1-leon@kernel.org>
 <20190704130402.8431-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704130402.8431-3-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jul 04, 2019 at 04:04:02PM +0300, Leon Romanovsky wrote:
> -int rdma_nl_unicast(struct sk_buff *skb, u32 pid)
> +int rdma_nl_unicast(struct net *net, struct sk_buff *skb, u32 pid)
>  {
> +	struct rdma_dev_net *rnet = net_generic(net, rdma_dev_net_id);

This should be a proper type safe accessor in all places

> -void rdma_nl_exit(void)
> +void rdma_nl_net_exit(struct rdma_dev_net *rnet)
>  {
> -	int idx;
> -
> -	for (idx = 0; idx < RDMA_NL_NUM_CLIENTS; idx++)
> -		rdma_nl_unregister(idx);

There should be a WARN_ON during the module unload that no NL clients
are still registered

Thanks,
Jason
