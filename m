Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B06DECAAD8
	for <linux-rdma@archiver.kernel.org>; Tue, 20 Sep 2022 11:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiITLQu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 20 Sep 2022 07:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiITLQt (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 20 Sep 2022 07:16:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB167170E
        for <linux-rdma@vger.kernel.org>; Tue, 20 Sep 2022 04:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1396C61F71
        for <linux-rdma@vger.kernel.org>; Tue, 20 Sep 2022 11:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DE2C433D6;
        Tue, 20 Sep 2022 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663672606;
        bh=2N2xCcQh6jk9O/yWivpxQj00DXMk1LzfaPfg9HRVcEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ybrge/7BKXnUh/pPkSSJGDua9+y9YyqQ7y3KNH+ijFZzm/ZvhMmCUONa2aODBTEpb
         jSS8MybLYv5uSPAsb68XSwAMINasRzF2B3qNE5bapd/u8VvP3oWEQqSoVXXxb1oerR
         rYIJT0uJq/1m9YSo2UrsRWggRbDM8rHb1Xg9KF5IOevG3bczxLg/n0ZMShY358NsGB
         enuBbcvQHFqWQ2bEYFKKxr2qxJa4s/3qtYRxGou58ZQlg9EuauYfVagIFna4bUpFGQ
         G5dSzvobRwfbKzRYip9/ep8ROn073+z4GmmwoVMvMw2Nu1tYKSnqSpDcrdEgGpiVbv
         j0rJf9Ke6pOPg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-rdma@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH] RDMA/srp: Fix srp_abort()
Date:   Tue, 20 Sep 2022 14:16:37 +0300
Message-Id: <166367257300.143927.14343632204089174434.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220908233139.3042628-1-bvanassche@acm.org>
References: <20220908233139.3042628-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, 8 Sep 2022 16:31:39 -0700, Bart Van Assche wrote:
> Fix the code for converting a SCSI command pointer into an SRP request
> pointer.
> 
> 

Applied, thanks!

[1/1] RDMA/srp: Fix srp_abort()
      commit: 6dbe4a8dead84de474483910b02ec9e6a10fc1a9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
