Return-Path: <SRS0=A3Y9=DF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F0FC2D0A8
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Sep 2020 23:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFBEC206D9
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Sep 2020 23:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601335356;
	bh=sTyZvhq114L5nAaclMLktROJOoHqutZW+nN+oQVjZto=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=OpYCTJLkBjlzp4CPdooiBNg+4aorKujLC96dB6OMAU6Or3ko+VNcXm17Bpz+KsE5I
	 VHL89qxtz8eh52AgK9wvCcbLg8rgWCAfAC2kVJEx1iSx7c+wkCh363kjqFa9NHgSWM
	 ZBlEeHgRr8CSLbYKOxEs4MF2TSIGA3IjrQw4sEzk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgI1XWf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgI1XWf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 28 Sep 2020 19:22:35 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51ADD206C9;
        Mon, 28 Sep 2020 23:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601335354;
        bh=sTyZvhq114L5nAaclMLktROJOoHqutZW+nN+oQVjZto=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y7rlpp/plWd203EsI1Cd2Rludn4y9Zh0SQhjjVgPJMq/irWwxX4Bg6BpIQbFRTMW+
         ScFbh2bS411nhNgXUDe/LtX3ywHZeSwomhW2dgv569dLEKbjAO6LH/xOb+GvDwE2MR
         IcKWqruZNSPqm/4zKambCcjv+csPwIF12eJRFu7Q=
Message-ID: <25336478fe5bca68b6c7d2c37766a9f98f6c7ad1.camel@kernel.org>
Subject: Re: [PATCH][next] net/mlx5e: Fix potential null pointer dereference
From:   Saeed Mahameed <saeed@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ariel Levkovich <lariel@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 28 Sep 2020 16:22:33 -0700
In-Reply-To: <20200925164913.GA18472@embeddedor>
References: <20200925164913.GA18472@embeddedor>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, 2020-09-25 at 11:49 -0500, Gustavo A. R. Silva wrote:
> Calls to kzalloc() and kvzalloc() should be null-checked
> in order to avoid any potential failures. In this case,
> a potential null pointer dereference.
> 
> Fix this by adding null checks for _parse_attr_ and _flow_
> right after allocation.
> 
> Addresses-Coverity-ID: 1497154 ("Dereference before null check")
> Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes
> structure")
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> 

Applied to net-next-mlx5.
Thanks.

