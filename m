Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E54EB64DC
	for <linux-rdma@archiver.kernel.org>; Thu,  6 Jul 2023 16:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjGFQr5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjGFQrz (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 6 Jul 2023 12:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12561BD3
        for <linux-rdma@vger.kernel.org>; Thu,  6 Jul 2023 09:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A1A160F27
        for <linux-rdma@vger.kernel.org>; Thu,  6 Jul 2023 16:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054DCC433C8;
        Thu,  6 Jul 2023 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688662072;
        bh=lyaJBSvzKa1zFFkBCW7tUQMFCcA5FlhQjn46NniUDYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FPt+FXHOJsutG0Gf7jgwDlXbnPqS2T7Iih+tKToKSpDWZ93KWTOMi9CZuet0WIhQc
         mzc5meS0tT0sTKZ0MqjhCtnUv3RftLcUhqwcJ705qwjJFbu49xPT8SwgqAvRwalFlT
         PWWWeLc7LVBVq7rOTsU41ZUWocM0LiOHVxhnLdAY+qgqponYFLtwXQxAwsS1d1Y5IX
         kRtZhBuFSGRcaMRvQStHBpOZP3Rp0/aGSOjqo35R2wYNxny56hNqUzlyqRiUF+dv2y
         ysXSpFfFBFO5rh1oU/MFwhJ0WGNGTLpHeqd/4RTuuJLuC+9CBTojj+d7+6W3XtSIu1
         0WU9V+QNXW1WA==
Date:   Thu, 6 Jul 2023 19:47:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Olaf.Krzikalla@dlr.de
Cc:     linux-rdma@vger.kernel.org
Subject: Re: Understanding the allocation size of mlx5_alloc_buf
Message-ID: <20230706164748.GW6455@unreal>
References: <7f6a9b854205410eb45a665b1e84c0f2@dlr.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f6a9b854205410eb45a665b1e84c0f2@dlr.de>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jul 06, 2023 at 12:48:46PM +0000, Olaf.Krzikalla@dlr.de wrote:
> Hi @all,
> 
> creating connections via create_qp fails on our cluster for rather small numbers of processes (128 is working, 256 not) due to an out-of-memory error. I've tracked down the issue to an mlx5_alloc_buf call, which allocates ~500kB per call, which seems to be a lot.
> 
> heaptrack tells me the following:
> 
> 34.47M peak memory consumed over 92 calls from
> mlx5_alloc_buf
>   in /usr/lib64/libibverbs/libmlx5-rdmav34.so
> 8.65M consumed over 16 calls from:
>     create_qp
>       in /usr/lib64/libibverbs/libmlx5-rdmav34.so
>     mlx5_create_qp
>       in /usr/lib64/libibverbs/libmlx5-rdmav34.so
> .
> 
> Can anyone help me to understand, what causes a 500kB allocation in create_qp? Maybe it is some sort of a configuration issue, which I can handle somehow.
> 
> Thanks for help and best regards
> Olaf Krzikalla
> 
> 
> System information:
> CentOS Linux 7 (Core)
> Linux 3.10.0-1160.88.1.el7.x86_64

Please contact your Nvidia support representative, you are talking about distro kernel
and not linux upstream.

Thanks

> CA 'mlx5_0'
>         CA type: MT4123
>         Number of ports: 1
>         Firmware version: 20.33.1048
>         Hardware version: 0
> 
> 
> 
> 
> 
> 
