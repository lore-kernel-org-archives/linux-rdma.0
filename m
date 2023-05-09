Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B63C77B7C
	for <linux-rdma@archiver.kernel.org>; Tue,  9 May 2023 13:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbjEINiT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 9 May 2023 09:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbjEINiP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 9 May 2023 09:38:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4623C31
        for <linux-rdma@vger.kernel.org>; Tue,  9 May 2023 06:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 629F862F31
        for <linux-rdma@vger.kernel.org>; Tue,  9 May 2023 13:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252DAC433D2;
        Tue,  9 May 2023 13:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683639451;
        bh=dlMPQjuBb7e55KlaDLr8dira1zBO5bQghWj3LB19G3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ofoHwZaB/WUrqPFkHAYYydJZLSjv/nfiSP+e0LY9dplALSt1MiRNKj6O3NQTVa59H
         CgDRu5fViH6+2hBxOs2CTWrfQ0/XWBLF6NBCelReZlCOwFEWgO1tB3s5lQv5ahGHoE
         UN5XBz+JryR45Cym/zXt/itejlFPD2vrTU8RLq3TSHnLoBpZP3yJpoBvo0ZszoqBmm
         1VXn7ONABB8M7ScKrsgBQOdoIWcsOa5tcQez/6Q8hbSGrrJYGZFdB3pyRtn86U6WD6
         t1bbSlt62NO69Kftg04nXp1Jgc218gLjza1NMR5keNFMjjGVRYfnzbsfYClEjFJRAk
         dCoqlIq/DR+xg==
Date:   Tue, 9 May 2023 16:37:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Animesh Kishore <animesh.kishore@gmail.com>
Cc:     yishaih@dev.mellanox.co.il, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] verbs: Add RDMA write RC pingpong test
Message-ID: <20230509133727.GJ38143@unreal>
References: <20230509095016.112453-1-animesh.kishore@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509095016.112453-1-animesh.kishore@gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, May 09, 2023 at 12:50:16PM +0300, Animesh Kishore wrote:
> - The test pingpongs data between server and client
> instance using RC QPs with RDMA write BTH opcode.
> - For RDMA write, there's no completion at responder. Hence,
> we send a sideband ACK(using socket) from requester side
> on completion. This indicates to responder that it has
> received data.
> 
> Check available test arguments and help:
> ./build/bin/ibv_rc_wr_pingpong -h
> 
> e.g.
> Run server instance:
> ./build/bin/ibv_rc_wr_pingpong -g 0 -d <ib_dev> -c -s 8192
> 
> Run client instance:
> ./build/bin/ibv_rc_wr_pingpong -g 0 -d <ib_dev> -c -s 8192 <server IP>
> 
> Signed-off-by: Animesh Kishore <animesh.kishore@gmail.com>
> ---
>  debian/ibverbs-utils.install         |   2 +
>  libibverbs/examples/CMakeLists.txt   |   3 +
>  libibverbs/examples/rc_wr_pingpong.c | 782 +++++++++++++++++++++++++++
>  libibverbs/man/CMakeLists.txt        |   1 +
>  libibverbs/man/ibv_rc_wr_pingpong.1  |  63 +++
>  5 files changed, 851 insertions(+)
>  create mode 100644 libibverbs/examples/rc_wr_pingpong.c
>  create mode 100644 libibverbs/man/ibv_rc_wr_pingpong.1

Like I said in relevant PR https://github.com/linux-rdma/rdma-core/pull/1325#issuecomment-1531194836
This new ibv_rc_wr_pingpong is unlikely to be merged.

Thanks
