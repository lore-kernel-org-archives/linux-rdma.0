Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDE7C433ED
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Apr 2021 06:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 306EF60FDB
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Apr 2021 06:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhDSGgw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 19 Apr 2021 02:36:52 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:44846 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhDSGgu (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 19 Apr 2021 02:36:50 -0400
Received: from wwinf2229 ([172.22.131.103])
        by mwinf5d36 with ME
        id uWcJ2400a2E01B803WcJ16; Mon, 19 Apr 2021 08:36:19 +0200
X-ME-Helo: wwinf2229
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 19 Apr 2021 08:36:19 +0200
X-ME-IP: 86.243.172.93
Date:   Mon, 19 Apr 2021 08:36:18 +0200 (CEST)
From:   Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reply-To: Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Bart Van Assche <bvanassche@acm.org>, tj@kernel.org,
        jiangshanlai@gmail.com, saeedm@nvidia.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
In-Reply-To: <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
 <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [86.243.172.93]
X-WUM-FROM: |~|
X-WUM-TO: |~||~||~||~||~||~||~|
X-WUM-CC: |~||~||~||~|
X-WUM-REPLYTO: |~|
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

 

> Message du 19/04/21 01:03
> De : "Bart Van Assche" 
> A : "Christophe JAILLET" , tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net, kuba@kernel.org, "Tejun Heo" 
> Copie à : netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
> Objet : Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros accept a format specifier
> 
> On 4/18/21 2:26 PM, Christophe JAILLET wrote:
> > Improve 'create_workqueue', 'create_freezable_workqueue' and
> > 'create_singlethread_workqueue' so that they accept a format
> > specifier and a variable number of arguments.
> > 
> > This will put these macros more in line with 'alloc_ordered_workqueue' and
> > the underlying 'alloc_workqueue()' function.
> > 
> > This will also allow further code simplification.
> 
> Please Cc Tejun for workqueue changes since he maintains the workqueue code.
>
 
Hi,

The list in To: is the one given by get_maintainer.pl. Usualy, I only put the ML in Cc:
I've run the script on the 2 patches of the serie and merged the 2 lists. Everyone is in the To: of the cover letter and of the 2 patches.

If Théo is "Tejun Heo" (  (maintainer:WORKQUEUE) ), he is already in the To: line.

CJ


> > diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> > index d15a7730ee18..145e756ff315 100644
> > --- a/include/linux/workqueue.h
> > +++ b/include/linux/workqueue.h
> > @@ -425,13 +425,13 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
> > alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED | \
> > __WQ_ORDERED_EXPLICIT | (flags), 1, ##args)
> > 
> > -#define create_workqueue(name) \
> > - alloc_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, 1, (name))
> > -#define create_freezable_workqueue(name) \
> > - alloc_workqueue("%s", __WQ_LEGACY | WQ_FREEZABLE | WQ_UNBOUND | \
> > - WQ_MEM_RECLAIM, 1, (name))
> > -#define create_singlethread_workqueue(name) \
> > - alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
> > +#define create_workqueue(fmt, args...) \
> > + alloc_workqueue(fmt, __WQ_LEGACY | WQ_MEM_RECLAIM, 1, ##args)
> > +#define create_freezable_workqueue(fmt, args...) \
> > + alloc_workqueue(fmt, __WQ_LEGACY | WQ_FREEZABLE | WQ_UNBOUND | \
> > + WQ_MEM_RECLAIM, 1, ##args)
> > +#define create_singlethread_workqueue(fmt, args...) \
> > + alloc_ordered_workqueue(fmt, __WQ_LEGACY | WQ_MEM_RECLAIM, ##args)
> > 
> > extern void destroy_workqueue(struct workqueue_struct *wq);
> > 
> > 
> 
>
