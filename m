Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F35C04A6A
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Aug 2023 20:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjHHUMP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjHHULw (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Aug 2023 16:11:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0784329B43;
        Tue,  8 Aug 2023 11:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B251629FE;
        Tue,  8 Aug 2023 18:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AC1C433C8;
        Tue,  8 Aug 2023 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691519814;
        bh=U3GsjWEyr7fqxo65LELfbO15ejz+FqYQjoBzY2ixnl8=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=C8J0qG2Fe2Nxztc255mIECqgwCJlKRibL3zGK4uVGOLp68vHywYeEH3IwCaMdZePq
         Tsd4aCplzW8LKpO1sAQcdn2iXnybf5XN8IjJ7or2rtQ2BBModmmJ66jPp6T4Tcf7V3
         Kkl1hO7VBWd4ash9eJo9j3QIm8JViHG6+wHQrVy0QNvudsrBAGoCNExLOm8l0TAPkz
         12TgzkQUtSbaSumrVaxc0VOO0be5+2hT3TZoKw8DWqPE8RWqjHtvgw7C1abuLwBT3B
         X0PwJsHJZFoXbIluUS7DvnN49Wx9SWSOGdveKFO+zQfcQp33+CvcRIe59biX4CHQ6o
         6f21ZDjDMpYaA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Junxian Huang <huangjunxian6@hisilicon.com>
Cc:     linux-rdma@vger.kernel.org, linuxarm@huawei.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20230807064228.4032536-1-huangjunxian6@hisilicon.com>
References: <20230807064228.4032536-1-huangjunxian6@hisilicon.com>
Subject: Re: [PATCH for-rc] MAINTAINERS: Remove maintainer of HiSilicon RoCE
Message-Id: <169151980721.543215.1240276394300998178.b4-ty@kernel.org>
Date:   Tue, 08 Aug 2023 21:36:47 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Mon, 07 Aug 2023 14:42:28 +0800, Junxian Huang wrote:
> Haoyue no longer maintains the Hisilicon RoCE driver. So remove him
> from MAINTAINERS.
> 
> 

Applied, thanks!

[1/1] MAINTAINERS: Remove maintainer of HiSilicon RoCE
      https://git.kernel.org/rdma/rdma/c/8e7b295da1ed05

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
