Return-Path: <SRS0=HDkz=V4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F332DC433FF
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Jul 2019 09:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8968206B8
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Jul 2019 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564567148;
	bh=JrGOxQoylMdesv4k3NT24vPMWfkMERv7D4jIUgftwIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eGntTmHvVIwtUK94D04Fy3z6dqqn/DV7R8w+FA/+dDYDMWiGDMSwd33Y3imdF5Syg
	 9kagZox/JfPnGnztqmtxG2Ypb+JoCmV6vmjP//Ly5iVDqdLjYfTcSNr0X/5Js4acvb
	 OTsqLdL1aVHtXxI03d+V4IrRmZs7maYznFOUUPmo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbfGaJ7H (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 31 Jul 2019 05:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729033AbfGaJ7H (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 31 Jul 2019 05:59:07 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71A9C206A3;
        Wed, 31 Jul 2019 09:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564567146;
        bh=JrGOxQoylMdesv4k3NT24vPMWfkMERv7D4jIUgftwIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=116alLq9lpBagYiYZxidyo7HmSuBaakVnH0/arEtEigZ/v6N496NL+4BFNMcAx3Fx
         XQYRNId5SUn5mNRLHqwGO8PnbpNsW3HaiR/sDsCyh8kesH7WKYBe8K3ovzOZv6iKIE
         HdLl5bCq+M1s0DEGNZ6xOILUSRlWk0jMWPx7VORQ=
Date:   Wed, 31 Jul 2019 12:59:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     c00284828 <chenglang@huawei.com>
Cc:     oulijun <oulijun@huawei.com>, dledford@redhat.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH for-next 10/13] RDMA/hns: Remove unnecessary kzalloc
Message-ID: <20190731095901.GQ4878@mtr-leonro.mtl.com>
References: <1564477010-29804-1-git-send-email-oulijun@huawei.com>
 <1564477010-29804-11-git-send-email-oulijun@huawei.com>
 <20190730134025.GD4878@mtr-leonro.mtl.com>
 <aab804d4-561a-2e3a-969c-55a523c6ee0d@huawei.com>
 <20190731074936.GN4878@mtr-leonro.mtl.com>
 <fab1c105-b367-7ca7-fa2f-b46808ae1b24@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fab1c105-b367-7ca7-fa2f-b46808ae1b24@huawei.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Jul 31, 2019 at 05:16:38PM +0800, c00284828 wrote:
>
> 在 2019/7/31 15:49, Leon Romanovsky 写道:
> > On Wed, Jul 31, 2019 at 10:43:01AM +0800, oulijun wrote:
> > > 在 2019/7/30 21:40, Leon Romanovsky 写道:
> > > > On Tue, Jul 30, 2019 at 04:56:47PM +0800, Lijun Ou wrote:
> > > > > From: Lang Cheng <chenglang@huawei.com>
> > > > >
> > > > > For hns_roce_v2_query_qp and hns_roce_v2_modify_qp,
> > > > > we can use stack memory to create qp context data.
> > > > > Make the code simpler.
> > > > >
> > > > > Signed-off-by: Lang Cheng <chenglang@huawei.com>
> > > > > ---
> > > > >   drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 64 +++++++++++++-----------------
> > > > >   1 file changed, 27 insertions(+), 37 deletions(-)
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> > > > > index 1186e34..07ddfae 100644
> > > > > --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> > > > > +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> > > > > @@ -4288,22 +4288,19 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
> > > > >   {
> > > > >   	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
> > > > >   	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
> > > > > -	struct hns_roce_v2_qp_context *context;
> > > > > -	struct hns_roce_v2_qp_context *qpc_mask;
> > > > > +	struct hns_roce_v2_qp_context ctx[2];
> > > > > +	struct hns_roce_v2_qp_context *context = ctx;
> > > > > +	struct hns_roce_v2_qp_context *qpc_mask = ctx + 1;
> > > > >   	struct device *dev = hr_dev->dev;
> > > > >   	int ret;
> > > > >
> > > > > -	context = kcalloc(2, sizeof(*context), GFP_ATOMIC);
> > > > > -	if (!context)
> > > > > -		return -ENOMEM;
> > > > > -
> > > > > -	qpc_mask = context + 1;
> > > > >   	/*
> > > > >   	 * In v2 engine, software pass context and context mask to hardware
> > > > >   	 * when modifying qp. If software need modify some fields in context,
> > > > >   	 * we should set all bits of the relevant fields in context mask to
> > > > >   	 * 0 at the same time, else set them to 0x1.
> > > > >   	 */
> > > > > +	memset(context, 0, sizeof(*context));
> > > > "struct hns_roce_v2_qp_context ctx[2] = {};" will do the trick.
> > > >
> > > > Thanks
> > > >
> > > > .
> > > In this case, the mask is actually writen twice. if you do this, will it bring extra overhead when modify qp?
> > I don't understand first part of your sentence, and "no" to second part.
> >
> > Thanks
>
> +	struct hns_roce_v2_qp_context ctx[2];
> +	struct hns_roce_v2_qp_context *context = ctx;
> +	struct hns_roce_v2_qp_context *qpc_mask = ctx + 1;
> ...
> +	memset(context, 0, sizeof(*context));
>  	memset(qpc_mask, 0xff, sizeof(*qpc_mask));
>
> ctx[2] ={} does look more simple, just like another function in patch.
> But ctx[1] will be written 0 before being written to 0xff, is it faster than twice memset ?

Are you seriously talking about this micro optimization while you have mailbox
allocation in your modify_qp function?

Thanks

>
> > >
> > >
> > .
> >
