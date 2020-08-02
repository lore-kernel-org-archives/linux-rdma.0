Return-Path: <SRS0=CapX=BM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C317BC433DF
	for <linux-rdma@archiver.kernel.org>; Sun,  2 Aug 2020 22:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB3D1206F6
	for <linux-rdma@archiver.kernel.org>; Sun,  2 Aug 2020 22:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgHBWdS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 2 Aug 2020 18:33:18 -0400
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:34536 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726257AbgHBWdS (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 2 Aug 2020 18:33:18 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2020 18:33:17 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id BB6B51828A42E
        for <linux-rdma@vger.kernel.org>; Sun,  2 Aug 2020 22:24:02 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 6B8211730850;
        Sun,  2 Aug 2020 22:24:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: taste53_3b1265f26f98
X-Filterd-Recvd-Size: 1940
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sun,  2 Aug 2020 22:23:59 +0000 (UTC)
Message-ID: <fb7ec4d4ed78e6ae7fa6c04abb24d1c00dc2b0f7.camel@perches.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
From:   Joe Perches <joe@perches.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date:   Sun, 02 Aug 2020 15:23:58 -0700
In-Reply-To: <20200802221020.GN24045@ziepe.ca>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
         <20200731045301.GI75549@unreal> <20200731053306.GA466103@kroah.com>
         <20200731053333.GB466103@kroah.com> <20200731140452.GE24045@ziepe.ca>
         <20200731142148.GA1718799@kroah.com> <20200731143604.GF24045@ziepe.ca>
         <20200731171924.GA2014207@kroah.com> <20200801053833.GK75549@unreal>
         <20200802221020.GN24045@ziepe.ca>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, 2020-08-02 at 19:10 -0300, Jason Gunthorpe wrote:
> On Sat, Aug 01, 2020 at 08:38:33AM +0300, Leon Romanovsky wrote:
> 
> > I'm using {} instead of {0} because of this GCC bug.
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119
> 
> This is why the {} extension exists..

There is no guarantee that the gcc struct initialization {}
extension also zeros padding.


