Return-Path: <SRS0=4Nee=YV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FA5CA9EC0
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Oct 2019 13:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1259620717
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Oct 2019 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572268763;
	bh=CoFq3iPoKgCFEZdREDhDZvWQ0moU0akRG8sRLClukWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lFAZ9g7EBYY1wP83G9tpR1uwnnd6X3aDyOWPDI4VJGywYAfYhN7/7ExMgq+KWSRkg
	 rhkrhWQ9GaRnuaQvkMfxw+qF0qUstGHO7ATygM81sXL7j8tZrVFVkDv0tu8hakcWW5
	 v7+gyHOKyw8i3P4RkjQrr3Vj1vuumUuHYL/2HjZI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfJ1NTW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Oct 2019 09:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbfJ1NTW (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 28 Oct 2019 09:19:22 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C784A20650;
        Mon, 28 Oct 2019 13:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572268761;
        bh=CoFq3iPoKgCFEZdREDhDZvWQ0moU0akRG8sRLClukWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X4+30DR/omoBihfzJMNnOpeElL7HnAsKo+9sUGiWOdt+TQWr0SY1pHDaY9P1KIoVI
         G8rOmXM+aobxXhNGsFkEVimsw/0WLhyjpUSWvnyJhoNDClb3crBgaEoBwm9qLrHQwH
         037nxQkBT8jcrFeAS9wCoH8JevM5VX3mYE75i9Bk=
Date:   Mon, 28 Oct 2019 15:19:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH rdma-next 6/6] RDMA/srpt: Use private_data_len instead of
 hardcoded value
Message-ID: <20191028131917.GE5146@unreal>
References: <20191020071559.9743-1-leon@kernel.org>
 <20191020071559.9743-7-leon@kernel.org>
 <20191028131319.GA15102@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028131319.GA15102@ziepe.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Oct 28, 2019 at 10:13:19AM -0300, Jason Gunthorpe wrote:
> On Sun, Oct 20, 2019 at 10:15:59AM +0300, Leon Romanovsky wrote:
> > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > index daf811abf40a..e66366de11e9 100644
> > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > @@ -2609,7 +2609,7 @@ static int srpt_cm_handler(struct ib_cm_id *cm_id,
> >  	case IB_CM_REJ_RECEIVED:
> >  		srpt_cm_rej_recv(ch, event->param.rej_rcvd.reason,
> >  				 event->private_data,
> > -				 IB_CM_REJ_PRIVATE_DATA_SIZE);
> > +				 event->private_data_len);
>
> So, I took a look and found a heck of a lot more places assuming the
> size of private data that really should be checked if we are going to
> introduce a buffer length here.

But we are not interested to make it dynamic, "private_data_len" has
constant size according to IBTA spec, I just don't want users to be
aware of this.

Why should we add the below checks if it wasn't before?

>
> This is the first couple I noticed, but there were many many more and
> they all should be handled..
>
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2677,9 +2677,14 @@ static void srp_ib_cm_rej_handler(struct ib_cm_id *cm_id,
>                 break;
>
>         case IB_CM_REJ_CONSUMER_DEFINED:
> +               if (event->private_data_len < sizeof(struct srp_login_rej)) {
> +                       ch->status = -ECONNRESET;
> +                       break;
> +               }
> +
>
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -985,12 +985,15 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id,
>  {
>         struct ipoib_cm_tx *p = cm_id->context;
>         struct ipoib_dev_priv *priv = ipoib_priv(p->dev);
>         struct ipoib_cm_data *data = event->private_data;
>         struct sk_buff_head skqueue;
>         struct ib_qp_attr qp_attr;
>         int qp_attr_mask, ret;
>         struct sk_buff *skb;
>
> +       if (event->private_data_len < sizeof(*data))
> +               return -EINVAL;
> +
>
>
> Thanks,
> Jason
