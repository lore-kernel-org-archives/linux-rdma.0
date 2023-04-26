Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F46C77B78
	for <linux-rdma@archiver.kernel.org>; Wed, 26 Apr 2023 07:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbjDZHUZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 26 Apr 2023 03:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239788AbjDZHUP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 26 Apr 2023 03:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FCE40E9
        for <linux-rdma@vger.kernel.org>; Wed, 26 Apr 2023 00:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9000E633D6
        for <linux-rdma@vger.kernel.org>; Wed, 26 Apr 2023 07:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F103C433EF;
        Wed, 26 Apr 2023 07:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682493577;
        bh=ZB/+cE8VCIP9POgnc8kLomqyrULy3H+KjIA6xXKNCcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u7VzHihyzNtdvEDCpO59dlrX1+ir8o9x4KLFT34fmCqgmfRYYvqVeB1MLOyjb8iEf
         bMQ3kQWEa1VZZj6GN9Rm5pwJn+EtltsGUCLRvGBl1oot7ceaa30G3LIkBE+EG3J6A4
         L3dXN7M8tTD7q+cd4cu2HK1BgYoNhbAyS1JCFR+n8UA3VfPTJo7cJvQ0+xq8hY1G31
         9hao0jg5gRO0hkmKCGYoWn6Ehcn5lxx0oyQi5/Nqp1uzHnRtfJb0IMoIAn3ncvo8SV
         TkvPWmFPB0PTm4hjNfIasOkcjmaqmnUMsFwwZjoK4MLu8kG28pU/3MqvFd5zj6Kw+P
         Y5A2bcKxWkvYA==
Date:   Wed, 26 Apr 2023 10:19:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Selvin Xavier <selvin.xavier@broadcom.com>
Cc:     jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        andrew.gospodarek@broadcom.com
Subject: Re: [PATCH v2 for-next 0/6] RDMA/bnxt_re: driver update for
 supporting low latency push
Message-ID: <20230426071933.GL27649@unreal>
References: <1682450993-17711-1-git-send-email-selvin.xavier@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682450993-17711-1-git-send-email-selvin.xavier@broadcom.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Apr 25, 2023 at 12:29:47PM -0700, Selvin Xavier wrote:
> The series aims to add support for Low latency push path in
> some of the bnxt devices. The low latency implementation is
> supported only for the user applications. Also, the code
> is modified to use  common mmap helper functions exported
> by IB core. 
> 
> User library changes are getting submitted in the pull request
> https://github.com/linux-rdma/rdma-core/pull/1321
> 
> Please review.
> 
> Thanks,
> Selvin Xavier
> 

We are in merge window now.

Thanks
