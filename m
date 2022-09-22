Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3752CC6FA82
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Sep 2022 09:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiIVJgQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 22 Sep 2022 05:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIVJgP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 22 Sep 2022 05:36:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8660733E3B
        for <linux-rdma@vger.kernel.org>; Thu, 22 Sep 2022 02:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E55629E4
        for <linux-rdma@vger.kernel.org>; Thu, 22 Sep 2022 09:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB72C433C1;
        Thu, 22 Sep 2022 09:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663839373;
        bh=TN338hrpnHypEMNVDAikOb1LyoUd9QrcfAL5p5Bly8U=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Ao52A0vS4rOTdTK5N1lyMEPZL5LB8A+5fI5eF53OgDObgjFf4oWsmLtF5HkoP/krC
         EmTdvCi6bFd05a+F6TFGiP9jo3gv1NPNXL5fsOeYnv4DFc3NZ3MsngVaxmmWX8LA/I
         LpQO9buacLPW7jYnKjrp6cVcsIaLy4O3ET3dbaSL4v7QrtgU2aDC+RIACFxESWGlJ9
         EPqhAWoenCBfcfGw86XrrwvRce4hrwQW4GYFTkuK8703NXq7zF62PiSldQVeWMoVod
         LmKKUgkrYDqDLqax26uK2XpUv2DqJRbFFonGSp8YUfmsqsB68yxUwymtzAIShJw2eE
         GtbTUX2m2qXCQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Mark Bloch <mbloch@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <cover.1662631201.git.leonro@nvidia.com>
References: <cover.1662631201.git.leonro@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] Support multiple path records
Message-Id: <166383936923.929497.12159526364985833338.b4-ty@kernel.org>
Date:   Thu, 22 Sep 2022 12:36:09 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-87e0e
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, 8 Sep 2022 13:08:59 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> From Mark:
> 
> These patches allow IB core to receive multiple path records from
> user-space rdma netlink service.
> 
> [...]

Applied, thanks!

[1/4] RDMA/core: Rename rdma_route.num_paths field to num_pri_alt_paths
      https://git.kernel.org/rdma/rdma/c/bf9a9928510a03
[2/4] RDMA/cma: Multiple path records support with netlink channel
      https://git.kernel.org/rdma/rdma/c/5a374949339427
[3/4] RDMA/cm: Use SLID in the work completion as the DLID in responder side
      https://git.kernel.org/rdma/rdma/c/b7d95040c13f61
[4/4] RDMA/cm: Use DLID from inbound/outbound PathRecords as the datapath DLID
      https://git.kernel.org/rdma/rdma/c/eb8336dbe373ed

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
