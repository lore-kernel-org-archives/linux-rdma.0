Return-Path: <SRS0=cwSi=BK=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0E4C433DF
	for <linux-rdma@archiver.kernel.org>; Fri, 31 Jul 2020 05:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BA4F208E4
	for <linux-rdma@archiver.kernel.org>; Fri, 31 Jul 2020 05:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596173596;
	bh=Ey9Sbx63l35tpZRAlTqbhj39QlhEfAk6lnnRJ0GbmKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=BbFGSIkIkEFqu9vZldSsAPWpR21J9qG9T99HpfYdBgvIPVJpd77omdKydokjpe/sY
	 p3v0aFlnp+u0/9rD2x4L7YTNYcA2kTrlu6E9odDWwDp2/Ho99KEZ4G4gljsz4ZoUQO
	 C3ws4pDyi4czJxRBE4yRJ31UU/zZutHlbxU6F4hc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgGaFdK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 31 Jul 2020 01:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726972AbgGaFdK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 31 Jul 2020 01:33:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76248208E4;
        Fri, 31 Jul 2020 05:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596173590;
        bh=Ey9Sbx63l35tpZRAlTqbhj39QlhEfAk6lnnRJ0GbmKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kFeznJvlJLIKGU7a+xR/vPryMW1/HRaqLnnUF8/Qo9g6GwLSGNzszKYgVuTEhqbG6
         0/R1y0qxc/7LAYy7huXZwxN+Y9gTkHmcNjKtknfvJBjTzGimo7HvXBtoTBhj+Fgb1a
         vbwF4a5Fi9jQ/BLnkYOhKx9ZOxfSppQidXBY8AvU=
Date:   Fri, 31 Jul 2020 07:33:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731053306.GA466103@kroah.com>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731045301.GI75549@unreal>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
> On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
> > rds_notify_queue_get() is potentially copying uninitialized kernel stack
> > memory to userspace since the compiler may leave a 4-byte hole at the end
> > of `cmsg`.
> >
> > In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
> > unfortunately does not always initialize that 4-byte hole. Fix it by using
> > memset() instead.
> 
> Of course, this is the difference between "{ 0 }" and "{}" initializations.

Really?  Neither will handle structures with holes in it, try it and
see.

thanks,

greg k-h
