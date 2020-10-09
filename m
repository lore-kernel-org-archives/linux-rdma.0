Return-Path: <SRS0=zYoG=DQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3501EC433DF
	for <linux-rdma@archiver.kernel.org>; Fri,  9 Oct 2020 16:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0667622277
	for <linux-rdma@archiver.kernel.org>; Fri,  9 Oct 2020 16:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389451AbgJIQZf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 9 Oct 2020 12:25:35 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:43442 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389259AbgJIQZf (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 9 Oct 2020 12:25:35 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 2A674182CF669;
        Fri,  9 Oct 2020 16:25:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: run89_3b02ded271e2
X-Filterd-Recvd-Size: 1862
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Fri,  9 Oct 2020 16:25:33 +0000 (UTC)
Message-ID: <16bbd7f0b23c8978f0c792739e7f77a7f7bd216a.camel@perches.com>
Subject: Re: [PATCH 2/4] RDMA: Convert sysfs kobject * show functions to use
 sysfs_emit()
From:   Joe Perches <joe@perches.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-rdma@vger.kernel.org
Date:   Fri, 09 Oct 2020 09:25:31 -0700
In-Reply-To: <20201009140938.GR5177@ziepe.ca>
References: <cover.1602122879.git.joe@perches.com>
         <7761c1efaebb96c432c85171d58405c25a824ccd.1602122880.git.joe@perches.com>
         <20201009140938.GR5177@ziepe.ca>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, 2020-10-09 at 11:09 -0300, Jason Gunthorpe wrote:
> On Wed, Oct 07, 2020 at 07:36:25PM -0700, Joe Perches wrote:
> > Done with cocci script:
> > 
> > @@
> > identifier k_show;
> > identifier arg1, arg2, arg3;
> > @@
> > ssize_t k_show(struct kobject *
> > -	arg1
> > +	kobj
> > 	, struct kobj_attribute *
> > -	arg2
> > +	attr
> > 	, char *
> > -	arg3
> > +	buf
> > 	)
> > {
> > 	...
> > (
> > -	arg1
> > +	kobj
> > -	arg2
> > +	attr
> > -	arg3
> > +	buf
> > )
> > 	...
> > }
> 
> This is nice

The 1/4 patch for device * cannot do this as there are
conflicts with dev/device naming within the functions.

It'd be nice to do the conversions though.

Maybe rename

	dev->ibdev
	device->dev

so that all sysfs _show function are consistently

ssize_t <foo>_show(struct device *dev, struct device_attribute *attr, char *buf);


