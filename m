Return-Path: <SRS0=yIwQ=73=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B191CC433E0
	for <linux-rdma@archiver.kernel.org>; Sun, 14 Jun 2020 07:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83FE42074D
	for <linux-rdma@archiver.kernel.org>; Sun, 14 Jun 2020 07:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592118952;
	bh=zZll6urelXML0NUSf47w9Vs7Ajbn1wggmOPGwgn3j1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=f5kTlvEKTVYHREM6t9rV0SMejfcYkq1SVQnExkRf0EEyDghCE/2s0LA/O18Bwyf9n
	 a/pKKwv67Fv9GC1eZmXAchtJYMFD0oF4I+h33QjNcz0AMKhSsVrmtru8Iv0A4naO40
	 eFcINTmAqNrxCzpKnW3nFysUfjAn4AIg3EyNIbhc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgFNHPv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 14 Jun 2020 03:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgFNHPv (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 14 Jun 2020 03:15:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72ADA20747;
        Sun, 14 Jun 2020 07:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592118951;
        bh=zZll6urelXML0NUSf47w9Vs7Ajbn1wggmOPGwgn3j1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u7C5T79t0SzgyScYuY2I5hl5Jv03Uc5Kh92W2UQ56gcNN3ZahJz7111Vp22nb4t3r
         4svvn5fiL+13qCWi1zsmKCwwexgdPP1cDwXcFT7SfdtsWEk5Jh0EB1g0a46P1HJfgM
         ZDL9+dupLe0uk3h1u+xlk0tIml+UB8NAqBIvvHfQ=
Date:   Sun, 14 Jun 2020 09:15:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Aditya Pakki <pakki001@umn.edu>, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Kangjie Lu <kjlu@umn.edu>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Qiushi Wu <wu000273@umn.edu>
Subject: Re: [PATCH] RDMA/rvt: Improve exception handling in rvt_create_qp()
Message-ID: <20200614071548.GG2629255@kroah.com>
References: <5d99dfe5-67ed-00d2-c2da-77058fb770c6@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d99dfe5-67ed-00d2-c2da-77058fb770c6@web.de>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, Jun 13, 2020 at 09:15:12AM +0200, Markus Elfring wrote:
> > … The patch fixes this issue by
> > calling rvt_free_rq().
> 
> I suggest to choose another imperative wording for your change description.
> Will the tag “Fixes” become helpful for the commit message?
> 
> …
> > +++ b/drivers/infiniband/sw/rdmavt/qp.c
> > @@ -1203,6 +1203,7 @@  struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
> >  			qp->s_flags = RVT_S_SIGNAL_REQ_WR;
> >  		err = alloc_ud_wq_attr(qp, rdi->dparms.node);
> >  		if (err) {
> > +			rvt_free_rq(&qp->r_rq);
> >  			ret = (ERR_PTR(err));
> >  			goto bail_driver_priv;
> >  		}
> 
> How do you think about the following code variant with the addition
> of a jump target?
> 
>  		err = alloc_ud_wq_attr(qp, rdi->dparms.node);
>  		if (err) {
>  			ret = (ERR_PTR(err));
> -			goto bail_driver_priv;
> +			goto bail_free_rq;
>  		}
> 
> …
> 
>  bail_rq_wq:
> -	rvt_free_rq(&qp->r_rq);
>  	free_ud_wq_attr(qp);
> +
> +bail_free_rq:
> +	rvt_free_rq(&qp->r_rq);
> 
>  bail_driver_priv:
> 
> 
> Regards,
> Markus

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
