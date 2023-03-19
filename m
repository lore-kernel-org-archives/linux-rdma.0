Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA604C6FD1F
	for <linux-rdma@archiver.kernel.org>; Sun, 19 Mar 2023 12:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjCSME0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 19 Mar 2023 08:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCSMEY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 19 Mar 2023 08:04:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B73423327;
        Sun, 19 Mar 2023 05:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFD4BB80B8E;
        Sun, 19 Mar 2023 12:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09353C43443;
        Sun, 19 Mar 2023 12:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679227451;
        bh=WJZytaF6OdOzu7h3FzZMS4BBGejeJCGgQ1VC9APTlfA=;
        h=From:To:In-Reply-To:References:Subject:Date:From;
        b=jz0butGwe1/9JeI5W0W45vluqUgp/dAgtuROL2AuByaC0sBqsSH1eH+JSkfy+9a9Y
         t9LhYSVeEYJE7wEUDSHvMfb0+AQiozrR6/PJ/9sREnwgTuF/w9RhTvYYNmL4HXNp4E
         IgFLwml0EUJ59J8r0RPUMSJV7L8pOQaRsdOxBmjdacrPtV902gFD/A8wjIm2gD2xOP
         7fNmk6wcOZ4JrhFEJcRBtMfVwQq9g6sVQo6kTpTndNxorYG9tUGux+jlvmYamghwuF
         928Re3TKtsK6VABaotdlhWDlwtCDcc4unHiww9VnjFAnMGo8qGxPqvxRMQdqUwZLBr
         JKUcgOA2wfOJA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rohit Chavan <roheetchavan@gmail.com>
In-Reply-To: <20230319100847.5566-1-roheetchavan@gmail.com>
References: <20230319100847.5566-1-roheetchavan@gmail.com>
Subject: Re: [PATCH] RDMA/mlx5: Coding style fix reported by checkpatch
Message-Id: <167922744736.839992.7922037754218629686.b4-ty@kernel.org>
Date:   Sun, 19 Mar 2023 14:04:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Sun, 19 Mar 2023 15:38:47 +0530, Rohit Chavan wrote:
> Block comments should align the * on each line on line 2849
> Avoid line continuations in quoted strings on line 3848
> 
> 

Applied, thanks!

[1/1] RDMA/mlx5: Coding style fix reported by checkpatch
      https://git.kernel.org/rdma/rdma/c/c4526fe2e4090b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
