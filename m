Return-Path: <SRS0=zqf9=YA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43769ECE58C
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 13:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1983420867
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 13:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570454231;
	bh=xa5tCod28JJBbGcKVRTOQ0XJYf74j2f5L1PTRdyyON0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fDxy+Bgpcq5NFbGLlOkbbozRRcpGnwJS4Aylu/3d3ijiIZgaeOLEuyyuNn4HIo5Je
	 e5X/Ma4G0W5paRXEyssDtn0v6bHdeMAKE3/GZtl7GsrWH2Arh6z8VRGXLRELMk+q4h
	 4LC8WRQVtr+TB2UcsrwLFhy8l6AksUmQt4lGZ18U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfJGNRK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfJGNRK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 7 Oct 2019 09:17:10 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3BAD2084D;
        Mon,  7 Oct 2019 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570454229;
        bh=xa5tCod28JJBbGcKVRTOQ0XJYf74j2f5L1PTRdyyON0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xt+kDFhqe4uP3NTWqLWDms9Z8oW3IU2k63m2IJt2PTzUhhnifzKXjaMdY4RIutQmo
         yJphlQZa3HY0TZfdrxJ2DGDO/4gmcpDKMWn1TOMOWmyCtfLGdbe19uMVctp04NWtF/
         L8PsvC0idol+8rGuJiHrytl3f5HqiAdv6/vaYN2c=
Date:   Mon, 7 Oct 2019 16:17:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007131706.GX5855@unreal>
References: <20191007115819.9211-1-leon@kernel.org>
 <20191007115819.9211-3-leon@kernel.org>
 <20191007121244.GA19843@infradead.org>
 <20191007123656.GW5855@unreal>
 <20191007124831.GA20840@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007124831.GA20840@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Oct 07, 2019 at 05:48:31AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 07, 2019 at 03:36:56PM +0300, Leon Romanovsky wrote:
> > > >  	if (rdma_protocol_iwarp(dev, port_num) && dir == DMA_FROM_DEVICE)
> > > >  		return true;
> > > > +	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE &&
> > > > +	    dma_nents > dev->attrs.max_sgl_rd)
> > > > +		return true;
> > >
> > > This can be simplified to:
> > >
> > > 	if (dir == DMA_FROM_DEVICE &&
> > > 	    (rdma_protocol_iwarp(dev, port_num) ||
> > > 	     (dev->attrs.max_sgl_rd && dma_nents > dev->attrs.max_sgl_rd)))
> > > 		return true;
> >
> > I don't think that it simplifies and wanted to make separate checks to
> > be separated. For example, rdma_protocol_iwarp() has nothing to do with
> > attrs.max_sgl_rd.
>
> The important bit is to have the DMA_FROM_DEVICE check only once, as
> we only do the registration for reads with either parameter.  So if
> you want it more verbose the wya would be:
>
>  	if (dir == DMA_FROM_DEVICE) {
> 		if (rdma_protocol_iwarp(dev, port_num))
> 			return true;
> 		if (dev->attrs.max_sgl_rd && dma_nents > dev->attrs.max_sgl_rd)
> 			return true;
> 	}

I'm doing it now, Thank you for taking time to explain.
