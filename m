Return-Path: <SRS0=2cZW=VI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F3EC74A54
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Jul 2019 14:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33CF921670
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Jul 2019 14:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="FOLvRp65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfGKOr2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 11 Jul 2019 10:47:28 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:33997 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbfGKOr2 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 11 Jul 2019 10:47:28 -0400
Received: by mail-vs1-f66.google.com with SMTP id m23so4363791vso.1
        for <linux-rdma@vger.kernel.org>; Thu, 11 Jul 2019 07:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0QB4G2/xBHjcBNeOJeGkcEW1zTEpr0Wwngojk7AMV6U=;
        b=FOLvRp6568/WXK18c2fpfwhDlQV/cnX2CQ7cu4gYCiS+gDi5zeiVZ8UTdLz6iayDWX
         7fHU3RA10QJyx/ivL5kO48KNdOJvIeVfmGC9riV3vvnSCY/GbtIBXEFfj5IRN16MyM21
         da/Pu3ShQOzLWcXE9u4rOo27/itdbbH3GzQ4WGnSyhA9LC23zfRwPaCz5mkpoDgfaecK
         SKAY7f8Sdn6nSTjz9aKuUUWVAFawKRVnFlzFmmA+Kbarj1kkA2cZBWVG00RweXswCxIf
         WQYX3M+mcXOkunzBiyBJTTC6yLdDlxG7vGm8xY4yv/0gzfFfYbNhMKcCWcecTkFg3lXy
         /ZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0QB4G2/xBHjcBNeOJeGkcEW1zTEpr0Wwngojk7AMV6U=;
        b=dkXKA+gSVc/s996dMn5YdAmcXgG7FRbAruYd5UoT0zu8mAsV1LuBsUve0hrE0Nt6Le
         +MwpryzpguLjiPi3gMSau0lJ+7vLY7UHFJjtRuWu90ZtMg0++b2k5hPjCJd/zYEUy6v3
         BrpaBZcqELOUV8/mXEohG4B5GORStf8yt4npNN9byqNZyOIJtzhzfUIiBi+sotZjC3EH
         0XO2h2Rdotw1uAEaIWOAnSi7aYMwBQTT5ERpwHA/exR77dPF6l1MaKESO8BJIfynpUxM
         vRV0mFnwRkCBqHBrQVYE/rTndnF1spONIL2Jn2Jdz17N6WRhrZ7voHtsfeo2okr2Tok0
         XMOQ==
X-Gm-Message-State: APjAAAVWEIFVKa0xmoSCLLfok3OdMTQGS/XFlCyvdQzrVPyJ1u13VD9Z
        aL/f1VD5FdZYYNrUIlCmHddBlg==
X-Google-Smtp-Source: APXvYqzWMjwLvEzUNthWoul7YQeleHCiUHqqGdCJBrTbLUhep0lALHQe3k1n0bUT17K33/yU3PvY2w==
X-Received: by 2002:a67:ea49:: with SMTP id r9mr4828851vso.223.1562856447047;
        Thu, 11 Jul 2019 07:47:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id v71sm1794480vke.11.2019.07.11.07.47.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jul 2019 07:47:26 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hlaM1-0003T2-QC; Thu, 11 Jul 2019 11:47:25 -0300
Date:   Thu, 11 Jul 2019 11:47:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH -next] rdma/siw: Add missing dependencies on LIBCRC32C
 and DMA_VIRT_OPS
Message-ID: <20190711144725.GA13197@ziepe.ca>
References: <20190710133930.26591-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710133930.26591-1-geert@linux-m68k.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Jul 10, 2019 at 03:39:30PM +0200, Geert Uytterhoeven wrote:
> If LIBCRC32C and DMA_VIRT_OPS are not enabled:
> 
>     drivers/infiniband/sw/siw/siw_main.o: In function `siw_newlink':
>     siw_main.c:(.text+0x35c): undefined reference to `dma_virt_ops'
>     drivers/infiniband/sw/siw/siw_qp_rx.o: In function `siw_csum_update':
>     siw_qp_rx.c:(.text+0x16): undefined reference to `crc32c'
> 
> Fix the first issue by adding a select of DMA_VIRT_OPS.
> Fix the second issue by replacing the unneeded dependency on
> CRYPTO_CRC32 by a dependency on LIBCRC32C.
> 
> Reported-by: noreply@ellerman.id.au (first issue)
> Fixes: c0cf5bdde46c664d ("rdma/siw: addition to kernel build environment")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/infiniband/sw/siw/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied to for-next, thanks

Jason
