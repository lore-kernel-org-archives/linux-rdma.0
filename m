Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B064BC433E6
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Jan 2021 00:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A23323A5E
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Jan 2021 00:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbhAPAWZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 Jan 2021 19:22:25 -0500
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:48362 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725833AbhAPAWZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 15 Jan 2021 19:22:25 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 6F01A1DFB;
        Sat, 16 Jan 2021 00:21:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: week26_440097727533
X-Filterd-Recvd-Size: 3037
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Sat, 16 Jan 2021 00:21:41 +0000 (UTC)
Message-ID: <8e3b6fc01165034dc37512b4f38aa839fc0a8fd3.camel@perches.com>
Subject: Re: [PATCH] RDMA: usnic: Fix misuse of sysfs_emit_at
From:   Joe Perches <joe@perches.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Date:   Fri, 15 Jan 2021 16:21:40 -0800
In-Reply-To: <6af0a6562b67a24e6233ed360189ba8071243035.camel@HansenPartnership.com>
References: <f4ce30f297be4678634b5be4917401767ee6ebc5.camel@perches.com>
         <6af0a6562b67a24e6233ed360189ba8071243035.camel@HansenPartnership.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, 2021-01-15 at 14:15 -0800, James Bottomley wrote:
> On Fri, 2021-01-15 at 13:23 -0800, Joe Perches wrote:
> > In commit e28bf1f03b01 ("RDMA: Convert various random sprintf sysfs
> > _show
> > uses to sysfs_emit") I mistakenly used len = sysfs_emit_at to
> > overwrite
> > the last trailing space of potentially multiple entry output.
> > 
> > The length of the last sysfs_emit_at call is 1 and it should instead
> > be
> > ignored.  Do so.
> > 
> > Fixes: e28bf1f03b01 ("RDMA: Convert various random sprintf sysfs
> > _show uses to sysfs_emit")
> > 
> > Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/infiniband/hw/usnic/usnic_ib_sysfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
> > b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
> > index e59615a4c9d9..fc077855b46c 100644
> > --- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
> > +++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
> > @@ -231,7 +231,7 @@ static ssize_t summary_show(struct
> > usnic_ib_qp_grp *qp_grp, char *buf)
> >  		}
> >  	}
> >  
> > 
> > -	len = sysfs_emit_at(buf, len, "\n");
> > +	sysfs_emit_at(buf, len, "\n");	/* Overwrite the last
> > trailing space */
> 
> len is the offset of where the next character gets written, isn't it?
> so if you're overwriting the last character emitted into buf, shouldn't
> the offset point at that character rather than one beyond it?  So
> 
> sysfs_emit_at(buf, len - 1, "\n");	/* Overwrite the last trailing
> space */

<sigh> quite right, thanks for catching yet another braino from me today.

I'll step away from the keyboard and go back to doing other things today
after submitting a V2 with a more typical style without the silly
backspace/newline by trimming the trailing space from the formats...




