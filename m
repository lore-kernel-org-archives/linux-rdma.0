Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8989C3DA6B
	for <linux-rdma@archiver.kernel.org>; Sat, 27 Aug 2022 01:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiH0BcQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 26 Aug 2022 21:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiH0BcP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 26 Aug 2022 21:32:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35250C9EBA;
        Fri, 26 Aug 2022 18:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFAEA6147C;
        Sat, 27 Aug 2022 01:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D965AC433C1;
        Sat, 27 Aug 2022 01:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661563934;
        bh=w7JK0dOpTIfnNITu9EJJP8AtVbw2z24CqztkLPzFmvs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oeljVeyJMpDIAfpnBl63g/oKaB1UQWiX05r58PGYpG7I2hh4TwfEwIpaf50vuzOxF
         c02Zkq0zU/PHcDTi8bO3ngquT0nAXnQyZY8oFamjh8t7rc8C8yza3RmbMvRkz4aa5u
         WxL8NceqNXXmYv6i2p8vM7dCbURXDuiWE6dfL312kruGq0QQXlTezxeunHX6nDIFCa
         VpnVH6KaXUolY6CrVL2skLrJPH9ymZ99mHkvqfTjrg4i8q+FLvQofqrEwie9BLheLE
         QxV78gfpEIgrG5mpdzakQIOmdorX/wEkQloCK5zSreurevVLu0CLZXFkiphrNtKIVN
         8NXty+YvUTb+Q==
Date:   Fri, 26 Aug 2022 18:32:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/10] optimize the parallelism of SMC-R
 connections
Message-ID: <20220826183213.38eb4cac@kernel.org>
In-Reply-To: <cover.1661407821.git.alibuda@linux.alibaba.com>
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, 26 Aug 2022 17:51:27 +0800 D. Wythe wrote:
> This patch set attempts to optimize the parallelism of SMC-R connections,
> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> occur after thoses optimization.
> 
> According to Off-CPU graph, SMC worker's off-CPU as that: 
> 
> smc_close_passive_work			(1.09%)
> 	smcr_buf_unuse			(1.08%)
> 		smc_llc_flow_initiate	(1.02%)
> 	
> smc_listen_work 			(48.17%)
> 	__mutex_lock.isra.11 		(47.96%)

The patches should be ordered so that the prerequisite changes are
first, then the removal of locks. Looks like there are 3 patches here
which carry a Fixes tag, for an old commit but in fact IIUC there is no
bug in those old commits, the problem only appears after the locking is
removed?

That said please wait for IBM folks to review first before reshuffling
the patches, I presume the code itself won't change.

Also I still haven't see anyone reply to Al Viro, IIRC he was
complaining about changes someone from your team has made. 
I consider this a blocker for applying new patches from your team :(
