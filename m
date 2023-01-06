Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA71FC4708E
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Jan 2023 00:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbjAFAcD (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjAFAcB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 5 Jan 2023 19:32:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C494F12B;
        Thu,  5 Jan 2023 16:32:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B85FEB81C0C;
        Fri,  6 Jan 2023 00:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A10DC433F0;
        Fri,  6 Jan 2023 00:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672965118;
        bh=MRMaueUj3kUBIzAsrGPBZWGaok0XoL/8Hd7SDBcdyEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TOGnG9jwVIve8E1PWraaO8LqF3lGOY71VtN7tELBPzYJSJ3mJA9poU77uNGJrbZsT
         5Edp76D7xvDhp6ac08h+h+EDj98gRM6pXWrnQ2GuUjsDQZE67gzZ6cfsy9fyNQ2tXu
         LwFyvEBdwlF16lumPcc6nW1PpxvojU1sN2EAudSeb4bfC2miAVFUwM2u5wHl6QUULh
         +LZVV9QSroNFRzYPR/NFukFEm4ZsHlxjwxXHbZT3P+7YZEIRErvOGs3rSCn7xcDfCA
         xzjSYGSGkJhsH9F6H1hTOLZR5elEs5+xXH2kTF1nu7fgmrFfdupc5CX3r3V6ZDHH7p
         w3X2B8qMn52MQ==
Date:   Thu, 5 Jan 2023 16:31:57 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next v1 3/3] RDMA/mlx5: Print error syndrome in case
 of fatal QP errors
Message-ID: <Y7dr/YIw61EIN/Wo@x130>
References: <cover.1672821186.git.leonro@nvidia.com>
 <edc794f622a33e4ee12d7f5d218d1a59aa7c6af5.1672821186.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <edc794f622a33e4ee12d7f5d218d1a59aa7c6af5.1672821186.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 04 Jan 11:43, Leon Romanovsky wrote:
>From: Patrisious Haddad <phaddad@nvidia.com>
>
>Print syndromes in case of fatal QP events. This is helpful for upper
>level debugging, as there maybe no CQEs.
>
>Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
>Signed-off-by: Mark Zhang <markzhang@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>


Reviewed-by: Saeed Mahameed <saeed@kernel.org>

