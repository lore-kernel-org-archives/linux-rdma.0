Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE66EC05027
	for <linux-rdma@archiver.kernel.org>; Thu,  9 Feb 2023 03:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjBIDM7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 8 Feb 2023 22:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjBIDM4 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 8 Feb 2023 22:12:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F17D4;
        Wed,  8 Feb 2023 19:12:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 853ADB81FCE;
        Thu,  9 Feb 2023 03:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C648BC433EF;
        Thu,  9 Feb 2023 03:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675912372;
        bh=6XJF+OF9Ob2FoJS7gGF6Acry8ixapyNcZzCVknEvx48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b5jLjM2PcnTNJ0gUjnCYZSvtq/W5LtnhIPoD9EkRX3BpbbdOR/448lEsEB8G329w2
         DHituuOjeZ14lSatNoHIkQMOP06AquhHnlh33cPMhVFzMFidponKN5T2qBdWKFX+rH
         T34HVpmooZOQkHkLn6Uey7v8yKj4mPeYPAXnyBHB17NvjlxXotQZumakRIR0cuvBa9
         ydzFT8jp2sefgF9WSAOVuHplrzRFZfmVN+IYs984mlSKaZoZz3hDM8g7BvJkZ6E4lM
         R0R7ZM+LQR55xA4OvnOtBDgidgboGD1k1TXIPOyauFWMu93b9LzmdKPykXIYHF9hnN
         aASWr/KR8s8iw==
Date:   Wed, 8 Feb 2023 19:12:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next netdev notifier deadlock 2023-02-07
Message-ID: <20230208191250.45b23b6f@kernel.org>
In-Reply-To: <20230208005626.72930-1-saeed@kernel.org>
References: <20230208005626.72930-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue,  7 Feb 2023 16:56:26 -0800 Saeed Mahameed wrote:
> @@ -674,6 +675,7 @@ struct mlx5e_resources {
>  	} hw_objs;
>  	struct devlink_port dl_port;
>  	struct net_device *uplink_netdev;
> +	struct mutex uplink_netdev_lock;

Is this your preferred resolution?

diff --cc include/linux/mlx5/driver.h
index 91e8160ed087,cc48aa308269..000000000000
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@@ -670,11 -673,11 +671,12 @@@ struct mlx5e_resources 
                u32                        mkey;
                struct mlx5_sq_bfreg       bfreg;
        } hw_objs;
        struct devlink_port dl_port;
        struct net_device *uplink_netdev;
+       struct mutex uplink_netdev_lock;
 +      struct mlx5_crypto_dek_priv *dek_priv;
  };
  
  enum mlx5_sw_icm_type {
        MLX5_SW_ICM_TYPE_STEERING,
        MLX5_SW_ICM_TYPE_HEADER_MODIFY,
