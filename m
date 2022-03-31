Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA90C433FE
	for <linux-rdma@archiver.kernel.org>; Thu, 31 Mar 2022 09:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiCaJI0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 31 Mar 2022 05:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiCaJIZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 31 Mar 2022 05:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1633C10C524
        for <linux-rdma@vger.kernel.org>; Thu, 31 Mar 2022 02:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07D6618F5
        for <linux-rdma@vger.kernel.org>; Thu, 31 Mar 2022 09:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD96C340F3;
        Thu, 31 Mar 2022 09:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648717597;
        bh=aMAHPH7RDHYgOrtd/3ZcmC2uqmdVfSBm1Ff423aTe+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iSvCYALpOmKNfFDiu3cEuY9Ezm549DoTA9ARMWS3kkVHNPFeeIzR92uO3r4piWNtt
         SFwj0Zvx9fHSZBgIlZ+Elcs9zvRpc+puBGF0uH9UgHs05ffLAFGoz8m+op2ufZvGxE
         sxDYUNAFoTmnnW0KHWVU18Nz/uaLeV8yYd1J/lOH+kETTYwDLyUPly+KobaeU5nJqD
         YvA0KGe0kFtQAzXSMQSStX3EbZAEnNuytuC6Kigfh2EXG4re2OqL+vTVVvQBbaO8uf
         7syAZ+IUZDLq3Nv5QhbZSYMId0GBrJlRT7mjv0nxIfIGeIVkJqE37Qu169wvRIhuc6
         7INlytKIXQaHw==
Date:   Thu, 31 Mar 2022 12:06:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiao Yang <yangx.jy@fujitsu.com>
Cc:     jgg@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v4 1/2] IB/uverbs: Move enum ib_raw_packet_caps to uapi
Message-ID: <YkVvGKYG9iYimlsk@unreal>
References: <20220331032419.313904-1-yangx.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331032419.313904-1-yangx.jy@fujitsu.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Mar 31, 2022 at 11:24:18AM +0800, Xiao Yang wrote:
> This enum is used by ibv_query_device_ex(3) so it should be defined
> in include/uapi/rdma/ib_user_verbs.h.
> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
> ---
>  include/rdma/ib_verbs.h           | 18 +++++++++++-------
>  include/uapi/rdma/ib_user_verbs.h |  7 +++++++
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
