Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D2EC05027
	for <linux-rdma@archiver.kernel.org>; Sun, 12 Feb 2023 18:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjBLSZv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 12 Feb 2023 13:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBLSZu (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 12 Feb 2023 13:25:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08E610ABC
        for <linux-rdma@vger.kernel.org>; Sun, 12 Feb 2023 10:25:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D8E5B80D1D
        for <linux-rdma@vger.kernel.org>; Sun, 12 Feb 2023 18:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26B3C433D2;
        Sun, 12 Feb 2023 18:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676226347;
        bh=4rTbJwUZqe3cf1C4C8Vchk11hlFf9kg7q1EMIoz+2F0=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=AgxPTIT8PUPWOD2fTrojrNbfLZYKVwDC9Kwqyi8A7VbcXWv/JaAFbpDRdOxNkjvZi
         faPBS9Xq6fjsv6Cwuf/u2lE+y2i/HkqtCStjIho6axCv+5pZ3wZVUvd+GvakEKduL4
         g2bFOK1aNCE3x/7a5VI+XZ6BSxSnai9oUfnqjZN8e4v1ReLxxkTQ9lyQq1Nn07RZHT
         z6LdcWD0SRE4U/kl/0DxjYEcmP6u+UT/YxK/9Iu1Y5PP1XlfELdsuxVNxbSQl6TVRH
         MZVhg6o7vL4TN/+LA8VeyQE40i3rYws2b+YCKcXWj1YUh4/LQfn6kHvf++INZkb3Pp
         FRE7a/gZvaaKw==
From:   Leon Romanovsky <leon@kernel.org>
To:     linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Davidlohr Bueso <dbueso@suse.de>, Ira Weiny <ira.weiny@intel.com>
In-Reply-To: <0-v1-22a2667fa089+a3-umem_work_jgg@nvidia.com>
References: <0-v1-22a2667fa089+a3-umem_work_jgg@nvidia.com>
Subject: Re: [PATCH] RDMA/umem: Remove unused 'work' member from struct ib_umem
Message-Id: <167622634306.227593.14033242514890278794.b4-ty@kernel.org>
Date:   Sun, 12 Feb 2023 20:25:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Thu, 09 Feb 2023 12:51:36 -0400, Jason Gunthorpe wrote:
> It is not used now.
> 
> 

Applied, thanks!

[1/1] RDMA/umem: Remove unused 'work' member from struct ib_umem
      https://git.kernel.org/rdma/rdma/c/91d088a0304941

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
