Return-Path: <SRS0=/7et=EE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB319C5517A
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Oct 2020 01:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3C920791
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Oct 2020 01:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgJ1WE4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:04:56 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:35072 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729466AbgJ1WAu (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 28 Oct 2020 18:00:50 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 7C33618015D9D
        for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2020 18:22:12 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id B538912EA;
        Wed, 28 Oct 2020 18:22:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: fight42_63002d327286
X-Filterd-Recvd-Size: 3039
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Wed, 28 Oct 2020 18:22:09 +0000 (UTC)
Message-ID: <e0adf52646f1206747a3087fd59edc748ba9b208.camel@perches.com>
Subject: Re: [PATCH 4/4] RDMA: Convert various random sprintf sysfs _show
 uses to sysfs_emit
From:   Joe Perches <joe@perches.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-rdma@vger.kernel.org
Date:   Wed, 28 Oct 2020 11:22:08 -0700
In-Reply-To: <20201028181201.GA2468498@nvidia.com>
References: <cover.1602122879.git.joe@perches.com>
         <ecde7791467cddb570c6f6d2c908ffbab9145cac.1602122880.git.joe@perches.com>
         <20201028181201.GA2468498@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 2020-10-28 at 15:12 -0300, Jason Gunthorpe wrote:
> On Wed, Oct 07, 2020 at 07:36:27PM -0700, Joe Perches wrote:
> > diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
[]
> > @@ -444,16 +444,17 @@ static ssize_t show_port_pkey(struct mlx4_port *p, struct port_attribute *attr,
> >  {
[]
> > +	int len;
> > +	struct pkey_mgt *m = &p->dev->pkeys;
> > +	u8 key = m->virt2phys_pkey[p->slave][p->port_num - 1][tab_attr->index];
> >  
> > 
> > -	if (p->dev->pkeys.virt2phys_pkey[p->slave][p->port_num - 1][tab_attr->index] >=
> > -	    (p->dev->dev->caps.pkey_table_len[p->port_num]))
> > -		ret = sprintf(buf, "none\n");
> > +	if (key >= p->dev->dev->caps.pkey_table_len[p->port_num])
> > +		len = sysfs_emit(buf, "none\n");
> >  	else
> > -		ret = sprintf(buf, "%d\n",
> > -			      p->dev->pkeys.virt2phys_pkey[p->slave]
> > -			      [p->port_num - 1][tab_attr->index]);
> > -	return ret;
> > +		len = sysfs_emit(buf, "%d\n",
> > +				 p->dev->pkeys.virt2phys_pkey[p->slave]
> > +				 [p->port_num - 1][tab_attr->index]);
> > +	return len;
> >  }
> 
> This duplication of virt2phys_pkey can be simplified to:
> 
> static ssize_t show_port_pkey(struct mlx4_port *p, struct port_attribute *attr,
> 			      char *buf)
> {
> 	struct port_table_attribute *tab_attr =
> 		container_of(attr, struct port_table_attribute, attr);
> 	struct pkey_mgt *m = &p->dev->pkeys;
> 	u8 key = m->virt2phys_pkey[p->slave][p->port_num - 1][tab_attr->index];
> 
> 	if (key >= p->dev->dev->caps.pkey_table_len[p->port_num])
> 		return sysfs_emit(buf, "none\n");
> 	return sysfs_emit(buf, "%d\n", key);
> }
> 
> (I adjusted it)

Thanks, it seems better without using the len automatic too.


