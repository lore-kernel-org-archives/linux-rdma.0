Return-Path: <SRS0=bifO=63=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6B4C433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 18:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B52D72065C
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 18:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589395778;
	bh=Ys5KDcuIhzg94At9DkC++VLgyO7vAIMO1cgfj9AUkrc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=vBUmGVrajgRREOk/nGEqLbXOvixQTMl0bZxhLkMXXtpp/V8JUljRCFuPNo+kydhXD
	 0A8Sy6Rsg69I/OvZRM+XJASp4isaG9qckkGT3CVYJbYLJVQBVdnWKVaZ/WXvxPsNR6
	 FffocMoQiJnQJ2EUJ2rme0IBtrQVmK6+wsuQcYGQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387507AbgEMSth (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 May 2020 14:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732218AbgEMStg (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 May 2020 14:49:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10918205CB;
        Wed, 13 May 2020 18:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589395777;
        bh=Ys5KDcuIhzg94At9DkC++VLgyO7vAIMO1cgfj9AUkrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jxrLapFqWOwqbY4eyTu6jHwQsLBUZ61GrHzYKzf5dEjHUCWOQSVowJu0z6AT2PynV
         /5FEACyVMxcpySDcOmLgVSIVZXcJjs4Ox2YVr0VyueyaTovmYUcUBp3kT4J92WeIhz
         aRLB+qLgA22BWkQOxfuvKStDnibz7/8yIXSfgKQE=
Date:   Wed, 13 May 2020 11:49:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/mlx4: Replace zero-length array with flexible-array
Message-ID: <20200513114934.22415a35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200513184316.GA2217@ziepe.ca>
References: <20200507185921.GA15146@embeddedor>
        <20200509205151.209bdc9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200513184316.GA2217@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 13 May 2020 15:43:16 -0300 Jason Gunthorpe wrote:
> On Sat, May 09, 2020 at 08:51:50PM -0700, Jakub Kicinski wrote:
> > On Thu, 7 May 2020 13:59:21 -0500 Gustavo A. R. Silva wrote:  
> > > The current codebase makes use of the zero-length array language
> > > extension to the C90 standard, but the preferred mechanism to declare
> > > variable-length types such as these ones is a flexible array member[1][2],
> > > introduced in C99:
> > > 
> > > struct foo {
> > >         int stuff;
> > >         struct boo array[];
> > > };
> > >
> > > ...  
> > 
> > Applied, thank you!  
> 
> Jakub,
> 
> Please don't take RDMA patches in netdev unless it is a special
> case. There is alot of cross posting and they often get into both
> patchworks.

Sorry about that, I only looked at the subject after applying. 
