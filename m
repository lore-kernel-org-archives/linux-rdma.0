Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94081C433E6
	for <linux-rdma@archiver.kernel.org>; Tue,  5 Jan 2021 21:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64D5722D5A
	for <linux-rdma@archiver.kernel.org>; Tue,  5 Jan 2021 21:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbhAEVI2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 5 Jan 2021 16:08:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbhAEVI2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 5 Jan 2021 16:08:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A031622D5A;
        Tue,  5 Jan 2021 21:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609880867;
        bh=1x3S9TSA7Ie9Nf+x6eyl/PsTa4hwLKBwLORWus1XB4k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FPauxjjmnlgunXp9LMHzn8EZg89V/dKXyhBkxfKJNnciRxhF1jhygNwyJrMlzqrTN
         Sb6q495THCbHlFO5kZiCwzUFfa6FLN6OPt/CsOndqBHrVjX1uKQQqFQ5DoiiSJQtfl
         lI94VbLechAWnaFqMaYrtj1/XdaxT6KMoh22WCYX2fPdaU3DihkJl6TiWtPJrkCS+2
         l0rEjVBg6++YgMwHXEj7UrpqLqoScJxI+KxYwIAHcR/++r15h6rD2CU4ascDVxWJHu
         KefSyfkp6EDpHFsgIFV7V8U2mBW42CAPw7Vm5DnN+xALY8skkAsADWIoRehn/3iF7P
         67W/51Hzuqwfw==
Message-ID: <a8c416b8c3ea6417e909b0dcfe0b6ace97f11053.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5: fix spelling mistake in Kconfig
 "accelaration" -> "acceleration"
From:   Saeed Mahameed <saeed@kernel.org>
To:     Colin King <colin.king@canonical.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 05 Jan 2021 13:07:44 -0800
In-Reply-To: <20201215144946.204104-1-colin.king@canonical.com>
References: <20201215144946.204104-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2020-12-15 at 14:49 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are some spelling mistakes in the Kconfig. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 

applied to net-next-mlx5,
Thanks!

