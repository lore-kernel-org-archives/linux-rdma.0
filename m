Return-Path: <SRS0=sZ6g=XS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCD3C3A5A6
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Sep 2019 03:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 558AA20640
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Sep 2019 03:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404349AbfIWDaJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 22 Sep 2019 23:30:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404054AbfIWDaJ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 22 Sep 2019 23:30:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32B65307D915;
        Mon, 23 Sep 2019 03:30:09 +0000 (UTC)
Received: from localhost (unknown [10.66.128.227])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFDD519C58;
        Mon, 23 Sep 2019 03:30:06 +0000 (UTC)
Date:   Mon, 23 Sep 2019 11:30:04 +0800
From:   Honggang LI <honli@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Subject: Re: [patch v3 1/2] RDMA/srp: Add parse function for maximum
 initiator to target IU size
Message-ID: <20190923033004.GA8298@dhcp-128-227.nay.redhat.com>
References: <20190919035032.31373-1-honli@redhat.com>
 <8f15fcfa-d0d8-e04b-8202-0cc56fa75941@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f15fcfa-d0d8-e04b-8202-0cc56fa75941@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 23 Sep 2019 03:30:09 +0000 (UTC)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Sep 20, 2019 at 09:11:06AM -0700, Bart Van Assche wrote:
> 
> Something I forgot to mention last time: since this patch adds a new login
> parameter Documentation/ABI/stable/sysfs-driver-ib_srp should be updated. I

I will submit a new patch to update 'sysfs-driver-ib_srp'.

thanks
