Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0DCC433E9
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Feb 2021 06:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4823664FA1
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Feb 2021 06:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhBEGta (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 5 Feb 2021 01:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231347AbhBEGrC (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 5 Feb 2021 01:47:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B0164F40;
        Fri,  5 Feb 2021 06:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507581;
        bh=BCG9+tOXvSYhKM577wAkNYrapT32MYW6qjLoG6thrnk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UxAvswzlZgj+KXlqaj7k7Nox8PY0LBz6K4htz79Wiwv6LVTDBiSCV68qkv+ngTs3H
         BNGou92UT3tT6jvtxuXnO4iXX1lEEEhlV3K6MpxsHM8bLHbUirJ6IbIKt/E+1L80gr
         sc5P6IoFH15llB2x11xLR+l649W7wGvlqD8ttiR4EED/tybDfb74qJ4K6d4QEaeH7O
         jJr/zf2iGTkTawSvn2boH6L6WeQBeIVNy9pTydUNYlwfHBTdL14y3v2Vt1ytvinMII
         5hVaGFycTlE2UF7mGNw5p5OA8m06EE5MPa7DG/yWbhzSj0bixUklNe5wP+GWDrh7He
         AYNK/xDeGwUDQ==
Message-ID: <d3370e0a6d40b88deb4249aec37b6a1bedeb8c19.camel@kernel.org>
Subject: Re: [PATCH][next] net/mlx5e: Fix spelling mistake "channles" ->
 "channels"
From:   Saeed Mahameed <saeed@kernel.org>
To:     Colin King <colin.king@canonical.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 04 Feb 2021 22:46:20 -0800
In-Reply-To: <20210204093232.50924-1-colin.king@canonical.com>
References: <20210204093232.50924-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, 2021-02-04 at 09:32 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a netdev_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Applied to net-next-mlx5 

thanks!

