Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168D6ECAAD8
	for <linux-rdma@archiver.kernel.org>; Tue, 20 Sep 2022 11:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiITLMc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 20 Sep 2022 07:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiITLMc (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 20 Sep 2022 07:12:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DDF2FFE3;
        Tue, 20 Sep 2022 04:12:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A303B80BE8;
        Tue, 20 Sep 2022 11:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C82C433D7;
        Tue, 20 Sep 2022 11:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663672348;
        bh=+GIYm0NJBJEFHCjOavrASVLECnvafzbswmRJpO48OSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyGswVZNB+kBmtRJYzGM6dZLEU3ATcXAMyOeESJawguWVviqv9xBXDQnvnyGuQD5D
         XJ4zmZ6TbkCEgF/8icq+KytONojMPmJ7hGW5F3VyG6D4VFcJRc51xEk4XIq6Tvz59k
         bisqnX5sZ+QEH5yD4vjmYdo9/ar09k5jkBiOoLvIdeIDGkl1XQX9fBoeaZSmuaiFDs
         swYOSCffxFS8TicK9v/Qb0UPARTRl0M1VfskkYwJIg54egrPBDc2KhShssU1e517BL
         bLbaQ0gwx2RtIoe7gA7S7rhnkeczA8GfzXnmMfnl9mQgEi/H0xTx3bNl4w8IPClvKm
         nu7azYNbR6Urg==
From:   Leon Romanovsky <leon@kernel.org>
To:     dennis.dalessandro@cornelisnetworks.com,
        wangjianli <wangjianli@cdjrlc.com>, jgg@ziepe.ca
Cc:     linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] hw/qib: fix repeated words in comments
Date:   Tue, 20 Sep 2022 14:12:23 +0300
Message-Id: <166367232108.101888.17297793069315987435.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220908132036.42355-1-wangjianli@cdjrlc.com>
References: <20220908132036.42355-1-wangjianli@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, 8 Sep 2022 21:20:36 +0800, wangjianli wrote:
> Delete the redundant word 'to'.
> 
> 

Applied, thanks!

[1/1] RDMA/qib: fix repeated words in comments
      commit: 7eff36527195cf434dc8f9ddc7bedc0254d0d835

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
