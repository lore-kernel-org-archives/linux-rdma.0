Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641E2C433EF
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Mar 2022 08:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354420AbiCPIOO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Mar 2022 04:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346256AbiCPIOO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 16 Mar 2022 04:14:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0B81149;
        Wed, 16 Mar 2022 01:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E02A96147A;
        Wed, 16 Mar 2022 08:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72C8C340E9;
        Wed, 16 Mar 2022 08:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647418379;
        bh=BAYTzpBca3P4yJX24YLl8CoJ5t6OIckGpeRM5IbYOz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X/nSIQnUElha7pnxxFrisYaHA0W2yPLqjmZKUFjpslznforkq8yd52ZiMFGexLEFM
         QHodjVfVYgI/LoDlRAqVl9cdSgCoL1pQdzplxjVWIdCKEjJw6yXJY0lfGHS/Apuy5Q
         XeC2oApWEoam/GpBkyRxYqj38ZgSRGFgCjAcEdi7Mr+Ki8MVUOnIwceH0fyr6zsGu5
         h6P24MoZFla9piTPguLUDvSXbEwJRtwY6SA67k2eNqyMfDV0nv4AlMvBREcMnGnni5
         NV3toJ/DrNJuKbdZjuiYyf2DiH2bCbLEX1Id+YGrj96EughYDw1ypdfcGjLv7mPMhc
         5EOjNJluzE8Fw==
Date:   Wed, 16 Mar 2022 10:12:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: Re: [PATCH rdma-next] Revert "RDMA/core: Fix ib_qp_usecnt_dec()
 called when error"
Message-ID: <YjGcB8xmYJWxMY3T@unreal>
References: <74c11029adaf449b3b9228a77cc82f39e9e892c8.1646851220.git.leonro@nvidia.com>
 <20220314234450.GC172564@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314234450.GC172564@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Mar 14, 2022 at 08:44:50PM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 09, 2022 at 08:42:13PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > This reverts commit 7c4a539ec38f4ce400a0f3fcb5ff6c940fcd67bb. which
> > causes to the following error in mlx4.
> 
> Dare I ask why this happens?

I didn't debug it, but my guess is that mistake is in relation between
xrc_qp and qp (real_qp).

Thanks

> 
> Applied to for-next 
> 
> Thanks,
> Jason
