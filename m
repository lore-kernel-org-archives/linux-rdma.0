Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A97FA3742
	for <linux-rdma@archiver.kernel.org>; Mon, 24 Oct 2022 12:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiJXMFQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 24 Oct 2022 08:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbiJXMEF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 24 Oct 2022 08:04:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F202F558FA;
        Mon, 24 Oct 2022 04:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7DBFB811B1;
        Mon, 24 Oct 2022 11:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0001AC433D6;
        Mon, 24 Oct 2022 11:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666612123;
        bh=cswlCaj9VwBonTfXSZ1J1DKFa5XV0tJmp/Plc7iexDE=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Y1u87aFhnIK1FJ2TxmbqsxD4JLPo7ijLFPLjv4rl7KqSJ7VLGR6AEAppRCIb3uYke
         qGLLxAks9sbp9M8VzTf3mmqW9hGsniuhdx8YcehFkVxrI0N+H+tOCb1Iw1w+yEGR3/
         JEFrbwMgIcCU7wLgwpz4cCrs4mxL+dgLyD0LA42GuSMrUNK0GVorvgPDFK71iGdL/h
         z1U4GJbeUQmQrk4bcKSQ3iRlRIFnUrQFYsyabNROt9mSr471rTcTF4MnVnFCczlnlv
         HziAG1PKDh2JgY8FLMLH585cVyJrRJqAgtI/JotQ/lmUrCDywMPNEm6CrRffKJ7K15
         zeZyee1sFhJ9w==
From:   Leon Romanovsky <leon@kernel.org>
To:     aelior@marvell.com, jgg@ziepe.ca, mkalderon@marvell.com,
        wangjianli <wangjianli@cdjrlc.com>
Cc:     linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20221022055257.42905-1-wangjianli@cdjrlc.com>
References: <20221022055257.42905-1-wangjianli@cdjrlc.com>
Subject: Re: [PATCH] infiniband/hw: fix repeated words in comments
Message-Id: <166661211934.860464.11739360867240865732.b4-ty@kernel.org>
Date:   Mon, 24 Oct 2022 14:48:39 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-87e0e
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, 22 Oct 2022 13:52:57 +0800, wangjianli wrote:
> Delete the redundant word 'the'.
> 
> 

Applied, thanks!

[1/1] infiniband/hw: fix repeated words in comments
      https://git.kernel.org/rdma/rdma/c/65bf03427cee48

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
