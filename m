Return-Path: <SRS0=oVUF=XT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C71DC432C1
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Sep 2019 07:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A6921655
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Sep 2019 07:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569308589;
	bh=AlEW8CxXuFn8P/oDpAqEk3frXBsRLiuf+egkL9mACt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mEdq//Nh3L8Bd7SS4ouGklS08Eivoa7wXpDbYiVCedVMhG6++s4XtBvk/vpKd0/4J
	 dYor9msJKjpHKACFY8aAIa61DAfcgNKe0Vl7JHBqEUBUSfJE58b5kzkPQNMLUj6Y0k
	 DoL/U5BC5pDytEWGH9RE1zd9slu2e/i2in4pA36w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409160AbfIXHDJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409158AbfIXHDJ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 24 Sep 2019 03:03:09 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8F720673;
        Tue, 24 Sep 2019 07:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569308588;
        bh=AlEW8CxXuFn8P/oDpAqEk3frXBsRLiuf+egkL9mACt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NgPhsXprAhfXfXBMPmhNi6zDCC8P+Lv1t1OJaBYYq/OuXI2l+wTr48atArBd4iujI
         pEiGSyKx2TzTQHYLZDzoFRzF7eIxparEi1i+IHrr5h2FzyssV4vjBmgrl3X4i81jMA
         Gpzm0UZN6E6YR5znnHJXZueTNcgVSqzF9xZTqB1c=
Date:   Tue, 24 Sep 2019 10:03:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH trivial 2/2] drivers: net: Fix Kconfig indentation
Message-ID: <20190924070305.GP14368@unreal>
References: <20190923155243.6997-1-krzk@kernel.org>
 <20190923155243.6997-2-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923155243.6997-2-krzk@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Sep 23, 2019 at 05:52:43PM +0200, Krzysztof Kozlowski wrote:
> Adjust indentation from spaces to tab (+optional two spaces) as in
> coding style with command like:
>     $ sed -e 's/^        /\t/' -i */Kconfig
>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

<--->

>  .../net/ethernet/mellanox/mlx5/core/Kconfig   |  36 +++---

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
