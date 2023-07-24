Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077E8C001DF
	for <linux-rdma@archiver.kernel.org>; Mon, 24 Jul 2023 12:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjGXMKB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 24 Jul 2023 08:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjGXMKA (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 24 Jul 2023 08:10:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64D51A1;
        Mon, 24 Jul 2023 05:09:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C0D5610E8;
        Mon, 24 Jul 2023 12:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4737AC433C8;
        Mon, 24 Jul 2023 12:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690200598;
        bh=EoXi+SbOO8vDaHlFvh9EVJp1zz3LkQYJjaqWNgjLlMg=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=StjLlV4ZDnlH8S/PUJPmeeHp4xb/d4yNw9ruUP40RQZy+02d8C9iGKL7RkR9dfAzl
         PPgXHMDFI5ua3KsfTIS7TaGJrZ63AgXdb6cKjM339T0o1iCsOY4tvSx0ydGrdQN9FM
         6G8wQnFJZAVg9bsRE2p1PaeC68SxB0+4uQpjSSazboueB7dV6vV+PfPSFQo8j4h4fU
         vWE03u0xUcxUu7SqV2uf1CVpP8u2hy/e3Hc8tqZ2Q8yNeJigFqjBrNNVDhJXSWsiBb
         /1MKZG5Ts9vaXldmTkQd9XMsm5JkOL5tz/cVUzrNvxYb7lSPwcOQxIKEaM225naVHX
         WAzgngAvED0dQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-rdma@vger.kernel.org
In-Reply-To: =?utf-8?q?=3Cf4618a67d5ae0a30eb3f2b4558c8cc790feed79a=2E1690044?=
 =?utf-8?q?376=2Egit=2Echristophe=2Ejaillet=40wanadoo=2Efr=3E?=
References: =?utf-8?q?=3Cf4618a67d5ae0a30eb3f2b4558c8cc790feed79a=2E16900443?=
 =?utf-8?q?76=2Egit=2Echristophe=2Ejaillet=40wanadoo=2Efr=3E?=
Subject: Re: [PATCH v2] IB/hfi1: Use struct_size()
Message-Id: <169020059491.473139.10236132535455236281.b4-ty@kernel.org>
Date:   Mon, 24 Jul 2023 15:09:54 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Sat, 22 Jul 2023 18:47:24 +0200, Christophe JAILLET wrote:
> Use struct_size() instead of hand-writing it, when allocating a structure
> with a flex array.
> 
> This is less verbose, more robust and more informative.
> 
> 

Applied, thanks!

[1/1] IB/hfi1: Use struct_size()
      https://git.kernel.org/rdma/rdma/c/24b1b5d85c1c1e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
