Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59986C4332F
	for <linux-rdma@archiver.kernel.org>; Sun,  4 Dec 2022 13:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiLDNfX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 4 Dec 2022 08:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDNfX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 4 Dec 2022 08:35:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F60414004;
        Sun,  4 Dec 2022 05:35:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9CAA3CE0A0C;
        Sun,  4 Dec 2022 13:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C34AC433D6;
        Sun,  4 Dec 2022 13:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670160918;
        bh=VlKuCgOQ28C212SdnRP/jadsFdbY9F2MPbY8bCGAltk=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=ftD9lMIkviQAtO184KO+aoAn20Jjc3vIh19Y2I2f0P8heif44MqUNzOgRSlYIs3dZ
         0FTz5DSYFZ8YiF8lL29DHqYnGvNocFHS7Yixw+0czRDskGYPvttpJopeGthCwgBuox
         I8ZGxowV7JfW+Y0jz5Ed9GXXdsBqNFdyvtaiVWSC7Baec5YwxyEy1PaKW0clq+I1fo
         CKgIraUYtHeyGvFPiVs+fiUWOPwCAav3/Fv2IQu/OY3Q/AAbXAC2NOaiEry7mrEIf7
         EyF7IZoUKsYchwyOcPipHLmB3GtHVv+Z5MfDORVLxzVFEqkz7GrttHl5PqoeGrTqa8
         oaeiWD9uMCO/g==
From:   Leon Romanovsky <leon@kernel.org>
To:     jgg@ziepe.ca, Li Zhijian <lizhijian@fujitsu.com>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20221203033714.25870-1-lizhijian@fujitsu.com>
References: <20221203033714.25870-1-lizhijian@fujitsu.com>
Subject: Re: [PATCH] RDMA/mlx5: no need to kfree NULL pointer
Message-Id: <167016091277.37965.6806153987261665211.b4-ty@kernel.org>
Date:   Sun, 04 Dec 2022 15:35:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-87e0e
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, 3 Dec 2022 11:37:14 +0800, Li Zhijian wrote:
> Goto label 'free' where it will kfree the 'in' is not needed though
> it's safe to kfree NULL. Return err code directly to simplify the code.
> 
> 1973 free:
> 1974         kfree(in);
> 1975         return err;
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: no need to kfree NULL pointer
      https://git.kernel.org/rdma/rdma/c/6978837ce42f8b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
