Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944DCC433EF
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Sep 2021 03:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E48F6115B
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Sep 2021 03:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhIODCz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234811AbhIODCy (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 14 Sep 2021 23:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EFA660F11;
        Wed, 15 Sep 2021 03:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631674896;
        bh=btPzhwmCtuY8+FwOQYXR67Lr00QwnapaYCM5CT7aNOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Iv7bniIpBShceUyOBh/ucvbgx88A3iex8WWnSxZ5LXg1k3S52WGBaLYyErL+wTY2z
         I+v1ey5pCh57aWI6QqYnf9TlbIhzPSstOz54KIxYEO6DWRwP1FLw6bIyJmMvE0ZU50
         juKrZ6rpzAmz6HTsaZsoebtp5ZQ1RiAJL6N7p1AiQbuHiiHjs+wRa/fHX7LI4LLiAB
         e+drtbN5Y4o9tkA84sXkh1/qAdQ34er0S+amHIvgEOHe4uSXOGehlGOL+fLxYbH5G4
         R234kj1X40OGaPxIwiTDZHLv8F7M5O600gCM4jTqndg4wXu/Upawv3Kn1G87vP8oKC
         Rhmsv1XJGfqNA==
Date:   Tue, 14 Sep 2021 20:01:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 2/2] devlink: Delete not-used single parameter
 notification APIs
Message-ID: <20210914200135.3756715c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1403fe624b0ece5ce989dbb9ced77a02f0ac5db7.1631623748.git.leonro@nvidia.com>
References: <cover.1631623748.git.leonro@nvidia.com>
        <1403fe624b0ece5ce989dbb9ced77a02f0ac5db7.1631623748.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 14 Sep 2021 15:58:29 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> There is no need in specific devlink_param_*publish(), because same
> output can be achieved by using devlink_params_*publish() in correct
> places.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
