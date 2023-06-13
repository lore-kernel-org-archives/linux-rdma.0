Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B47CC77B7A
	for <linux-rdma@archiver.kernel.org>; Tue, 13 Jun 2023 09:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbjFMJKs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 13 Jun 2023 05:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239821AbjFMJKn (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 13 Jun 2023 05:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2471BCD
        for <linux-rdma@vger.kernel.org>; Tue, 13 Jun 2023 02:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C9D06310C
        for <linux-rdma@vger.kernel.org>; Tue, 13 Jun 2023 09:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BC1C433D2;
        Tue, 13 Jun 2023 09:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686647431;
        bh=ojT8P6TZ38hgzyVXwtH06OUEK9BtoC93sz4oGF60/Go=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=iu/1m2qvYMOdT0Qx9r8+bhq1NtdCudFn1wyILrC+iPEB4GHikyl1VcvvC8gK67vBu
         PoWQkJHTimsy8v/XxlS/JC6Ayi+EWIDY/54wigK2GXx116XL+fkwPO3wgfOnEHPCB/
         BkDjkUqGG8XynFTLm6xT9xNs/9pz13CdvIPWHVw6SvqcsYCxDTZGZCL9OHj+LO2yU6
         7lqvH3htwOldkaAhYiIq7MTAPum3KVrB7RMnfnO9V2INInqKKzYyZM0Cmor8K9wH2w
         8JuJ/nN4Pwax0RPQT7vts6o9omaKbOwIDKsjd+F/ZkPGf/CB3XJ2QWkgi/uOjmOg78
         1Oj1Cbvt+jwfw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
In-Reply-To: <6ad1e44be2b560986da6fdc6b68da606413e9026.1686644105.git.leonro@nvidia.com>
References: <6ad1e44be2b560986da6fdc6b68da606413e9026.1686644105.git.leonro@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Initialize opcode while sending message
Message-Id: <168664742689.2552210.9087883618901211969.b4-ty@kernel.org>
Date:   Tue, 13 Jun 2023 12:10:26 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Tue, 13 Jun 2023 11:15:57 +0300, Leon Romanovsky wrote:
> Fix compilation warning:
> 
> drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:325:18:
>   error: variable 'opcode' is uninitialized when used here [-Werror,-Wuninitialized]
>         crsqe->opcode = opcode;
>                         ^~~~~~
> drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:291:11:
>   note: initialize the variable 'opcode' to silence this warning
>         u8 opcode;
>                  ^
>                   = '\0'
> 
> [...]

Applied, thanks!

[1/1] RDMA/bnxt_re: Initialize opcode while sending message
      https://git.kernel.org/rdma/rdma/c/56a1f96d30dc9b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
