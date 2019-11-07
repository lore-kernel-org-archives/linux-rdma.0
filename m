Return-Path: <SRS0=yP1V=Y7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA9EC43331
	for <linux-rdma@archiver.kernel.org>; Thu,  7 Nov 2019 17:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 435752166E
	for <linux-rdma@archiver.kernel.org>; Thu,  7 Nov 2019 17:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573146231;
	bh=PDtqNzCQVvJ1yFWlVv7DsCYv722OieQOHmlBoBVQ/Rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2WdpEuX9IUKSAQesFyeWLfOXxfuYwmqCUWveFD3XOS1ADa3Y5CeR7ahQtLGICzo7h
	 k3ptHNCEhANFN9YggQlw6XnwixPK64svDkVOsoKI/LIsjlvIRHyDb4oFYRS2qZau8M
	 OPhbNiRG/KS/DYee112XDGy0mlUnRI8wkRSGUC1I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389767AbfKGRDu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 Nov 2019 12:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389763AbfKGRDu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 7 Nov 2019 12:03:50 -0500
Received: from localhost (unknown [77.137.81.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B1F82077C;
        Thu,  7 Nov 2019 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573146229;
        bh=PDtqNzCQVvJ1yFWlVv7DsCYv722OieQOHmlBoBVQ/Rk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NqHtARVqqABdjJmz8yLHYLOMk+/Hn7RygTL7wOHFgq/eJ79ImGqI4gp2f3gz6iU3o
         buFlNo/sIxuo9bS/t5j6k6lj3L0VlJs9VJ8MrRBdcpGOTBQ82xlbjKlvzGasnYGtYP
         t08El1FC9sZAa5/u0srt1Wpe46cRomt8AW4XZqpY=
Date:   Thu, 7 Nov 2019 19:03:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191107170341.GM6763@unreal>
References: <20191107160448.20962-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160448.20962-1-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Nov 07, 2019 at 10:04:48AM -0600, Parav Pandit wrote:
> Hi Dave, Jiri, Alex,
>

<...>

> - View netdevice and (optionally) RDMA device using iproute2 tools
>     $ ip link show
>     $ rdma dev show

You perfectly explained how ETH devices will be named, but what about RDMA?
How will be named? I feel that rdma-core needs to be extended to support such
mediated devices.

Thanks
