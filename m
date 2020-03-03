Return-Path: <SRS0=qw0q=4U=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77ED8C3F2D7
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Mar 2020 07:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE6C2146E
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Mar 2020 07:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583220145;
	bh=6YIBYv/DHqUoDX1YmoRy4BWctM8bFk193ETadZIOvq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iFbMU5vaVltkP9nOfLK4oZean3TrtuT4XlskYLEYh/P1C+eXodyDroIzF4x/g9mWX
	 mffgMPGsvZEElppiCFR0Xr+u7QKquHeZx15PcOtRHz3zis3n6ZZYQAzYSMgol2Q0ZY
	 3jEFPIsotY9+Vyta78eF94XJPvxcC5VOYLGQkofM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgCCHWY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 3 Mar 2020 02:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbgCCHWY (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 3 Mar 2020 02:22:24 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C47120726;
        Tue,  3 Mar 2020 07:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583220143;
        bh=6YIBYv/DHqUoDX1YmoRy4BWctM8bFk193ETadZIOvq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KhVCJjKrLsUAcy30HilGoH/rhXQQJrxcWODNWV0v/cj1LlKO1lFikpimXXyD3DgAI
         tr3zrml69xNDViend8iUBQUuDFgjRv5dN3YT2qkSpQUgiJmrBPnRu6kVBCaJJYiHHN
         dGfzMWTmTqgeR0k0sQH2A1ljH4BBKL2RFIwWXj+c=
Date:   Tue, 3 Mar 2020 09:22:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bernard Metzler <bmt@zurich.ibm.com>
Cc:     dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [Patch for-rc v2] RDMA/siw: Fix failure handling during device
 creation
Message-ID: <20200303072220.GE121803@unreal>
References: <20200302155814.9896-1-bmt@zurich.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302155814.9896-1-bmt@zurich.ibm.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Mar 02, 2020 at 04:58:14PM +0100, Bernard Metzler wrote:
> A failing call to ib_device_set_netdev() during device creation
> caused system crash due to xa_destroy of uninitialized xarray
> hit by device deallocation. Fixed by moving xarray initialization
> before potential device deallocation.
>
> Fixes: bdcf26bf9b3a (rdma/siw: network and RDMA core interface)

Fixes line should be slightly different.
Fixes: bdcf26bf9b3a ("rdma/siw: network and RDMA core interface")

Thanks
