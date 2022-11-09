Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A30CC4332F
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Nov 2022 18:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiKISBQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiKIR7P (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 9 Nov 2022 12:59:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A881F9F0
        for <linux-rdma@vger.kernel.org>; Wed,  9 Nov 2022 09:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B064A61C28
        for <linux-rdma@vger.kernel.org>; Wed,  9 Nov 2022 17:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90006C433C1;
        Wed,  9 Nov 2022 17:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668016652;
        bh=P7j4XturCnYMWmW4D45l36pMTxI3T2D08ywuBEb+NP0=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Fq3rvh9NeswQyWd9y/jAWj+cVD7/JJGgFhx9KsL/kdgNAnecrKt/rkgxPcbx2ntB7
         zgZ3ZlChY6rFrNfAhDWFgk+N26wMK8r2jlv2hqyaZoJJdYrmmgvJLjA1Gxii5oYOfq
         legUai8nmy5xRgmQXc4IGSOktH5CQCmSHxljv/Un+1UTmSIQqteLD3dekX4h9zpC1l
         6baUp8eZ3z5zG6diwA2XumCFEW+ITRRaGT9Bs3Wi/Pi8TSg2TG7psBjt5zTbqwyWbI
         LClkr59jL38ckabUozIgSoCUFWE1dOdRJbQZmD8ezV/F4RhN6VWGsrjA6xNTOjuNNA
         SpJ8Nb2RbCRPw==
From:   Leon Romanovsky <leon@kernel.org>
To:     linux-rdma@vger.kernel.org, zyjzyj2000@gmail.com,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Cc:     lizhijian@fujitsu.com
In-Reply-To: <20221107055338.357184-1-matsuda-daisuke@fujitsu.com>
References: <20221107055338.357184-1-matsuda-daisuke@fujitsu.com>
Subject: Re: [PATCH v2] RDMA/rxe: Implement packet length validation on responder
Message-Id: <166801664772.141738.5080558397389252768.b4-ty@kernel.org>
Date:   Wed, 09 Nov 2022 19:57:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-87e0e
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, 7 Nov 2022 14:53:38 +0900, Daisuke Matsuda wrote:
> The function check_length() is supposed to check the length of inbound
> packets on responder, but it actually has been a stub since the driver was
> born. Let it check the payload length and the DMA length.
> 
> 

Applied, thanks!

[1/1] RDMA/rxe: Implement packet length validation on responder
      https://git.kernel.org/rdma/rdma/c/837a55847ead27

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
