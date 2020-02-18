Return-Path: <SRS0=tax/=4G=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F1DC34026
	for <linux-rdma@archiver.kernel.org>; Tue, 18 Feb 2020 13:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C7882176D
	for <linux-rdma@archiver.kernel.org>; Tue, 18 Feb 2020 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582033550;
	bh=iLOCk2L78fxHg2iLYAz6fvj7+46sa7+uPUcX5sp/2pE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wiBScyQSVNTvrjEF8czL2MHK1bMLg66bf22cXDzC1MH2guvgYVrNRsULeijYroklf
	 Ouw+05UVRINWFc/eiTdc0t6tpstf9mEhI32LrQMwrcRrQ0k7Sma/RXIGqvc61E85yH
	 P86bDwH04NRql4kFrgGZSp2cHc/gb4XOXOvRwfqA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBRNpt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 18 Feb 2020 08:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgBRNpt (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 18 Feb 2020 08:45:49 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D7652173E;
        Tue, 18 Feb 2020 13:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582033548;
        bh=iLOCk2L78fxHg2iLYAz6fvj7+46sa7+uPUcX5sp/2pE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oS+A7AM46bDpP3BU62BuFk1lusIGEeq4lVVWJiISyEkSSdvVK09rjhScDkhhfWJVG
         OfmeN+5Mr8Q2qdJCijPD7N1r3KwNa/KdpBwC+BbdWbUUrDJl38yC/LKskK4gjiLg32
         sqWuUlw7CI8BfxQEdGQ3zM/1ZBu5A2O9t/XEJxT8=
Date:   Tue, 18 Feb 2020 15:45:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: fix spelling mistake "reserverd" -> "reserved"
Message-ID: <20200218134546.GA8816@unreal>
References: <20200214143002.23140-1-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214143002.23140-1-alexandre.belloni@bootlin.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Feb 14, 2020 at 03:30:01PM +0100, Alexandre Belloni wrote:
> The reserved member should be named reserved.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> ---
>  include/linux/mlx5/mlx5_ifc_fpga.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Applied to mlx5-next.

Thanks
