Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6949EC05027
	for <linux-rdma@archiver.kernel.org>; Thu,  9 Feb 2023 03:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjBIDqH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 8 Feb 2023 22:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjBIDqF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 8 Feb 2023 22:46:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B7A234CC;
        Wed,  8 Feb 2023 19:46:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE3766184B;
        Thu,  9 Feb 2023 03:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE18C433D2;
        Thu,  9 Feb 2023 03:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675914361;
        bh=LbDCOyxTlXM//Xe4XvpokkfiCzZao1NybQs5rIALiDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PsddlNOtnBuAynTJOewPRHD4fLSrSJyh9NRWOA4/fbj4FTDBC9aD9CUKOHKfbdl/X
         VUd20l81bO21WIPRqQxX06fLCGQy1I+YPBaU4PJRr3le3NWly6vLaDNpWvwcEDJrSU
         HZuJA11uzNH+sBJ9KewelT12dveXEbJGwUsN8A9Ine04OPxsHDEy9RU7Uxc4+0XKTU
         7NKKzAvTQvjsgZh+1nVbRZA4JcfowmQrn3d5wv7aKrvmwvvep6ZSls0xnPSrCKD/VK
         qA1IHJUodzF8WRRqmtb3UNlaSU0i0QifqD5hIBb3MWl2MU07NKeZwkfuOvVeSIZfS8
         V55xDJAVqsYOw==
Date:   Wed, 8 Feb 2023 19:46:00 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next netdev notifier deadlock 2023-02-07
Message-ID: <Y+RseKpYCBnXzImH@x130>
References: <20230208005626.72930-1-saeed@kernel.org>
 <20230208191250.45b23b6f@kernel.org>
 <20230208191605.719b19db@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230208191605.719b19db@kernel.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 08 Feb 19:16, Jakub Kicinski wrote:
>On Wed, 8 Feb 2023 19:12:50 -0800 Jakub Kicinski wrote:
>> On Tue,  7 Feb 2023 16:56:26 -0800 Saeed Mahameed wrote:
>> > @@ -674,6 +675,7 @@ struct mlx5e_resources {
>> >  	} hw_objs;
>> >  	struct devlink_port dl_port;
>> >  	struct net_device *uplink_netdev;
>> > +	struct mutex uplink_netdev_lock;
>>
>> Is this your preferred resolution?
>
>Ooh, maybe I'm not supposed to pull?
>Jiri's changes have Change-Ids on them:

Fixed now, same tag, if you wanna go ahead and pull.
Please let me know if you prefer V2..


