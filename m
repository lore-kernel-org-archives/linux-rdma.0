Return-Path: <SRS0=RHPu=CD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1636DC433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Aug 2020 20:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1DDA206EB
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Aug 2020 20:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHYUzc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 25 Aug 2020 16:55:32 -0400
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:37306 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726149AbgHYUzc (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 25 Aug 2020 16:55:32 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id CDB9318019153;
        Tue, 25 Aug 2020 20:55:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: dock12_4708a5a2705e
X-Filterd-Recvd-Size: 1702
Received: from XPS-9350 (unknown [172.58.43.20])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 20:55:28 +0000 (UTC)
Message-ID: <1e9f4efd420c7ff516097050f1f50d0299a1e180.camel@perches.com>
Subject: Re: [PATCH] IB/qib: remove superfluous fallthrough statements
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alex Dewar <alex.dewar90@gmail.com>
Cc:     Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Roland Dreier <roland@purestorage.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 25 Aug 2020 13:55:23 -0700
In-Reply-To: <36066d75-899e-c9ca-835e-0040659c914b@embeddedor.com>
References: <20200825155142.349651-1-alex.dewar90@gmail.com>
         <4877c3a5-365e-4500-43c0-4a4361e2cda3@embeddedor.com>
         <086ee29ef75f657dcf45e92d4ebfdf2b3f4fcab8.camel@perches.com>
         <da65ca20-49cb-2940-76d6-7e341687a9e2@embeddedor.com>
         <777e01f8dc9bd35e8b7bdf1b5181d0d13b86d8b9.camel@perches.com>
         <36066d75-899e-c9ca-835e-0040659c914b@embeddedor.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2020-08-25 at 12:01 -0500, Gustavo A. R. Silva wrote:
> On 8/25/20 11:47, Joe Perches wrote
[]
> You would have noticed this should be two patches.

That's interpretational.

> > I think your desire for micropatches is unnecessary.
> > 
> You might be generalizing. My 'desire' here is justified and specific.

And to date undescribed.


