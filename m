Return-Path: <SRS0=K2hL=XM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8340CC49ED7
	for <linux-rdma@archiver.kernel.org>; Tue, 17 Sep 2019 03:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E89120665
	for <linux-rdma@archiver.kernel.org>; Tue, 17 Sep 2019 03:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390460AbfIQDVl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 16 Sep 2019 23:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbfIQDVl (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 16 Sep 2019 23:21:41 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69F0F76520;
        Tue, 17 Sep 2019 03:21:41 +0000 (UTC)
Received: from localhost (unknown [10.66.128.227])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CAD2E60BEC;
        Tue, 17 Sep 2019 03:21:40 +0000 (UTC)
Date:   Tue, 17 Sep 2019 11:21:38 +0800
From:   Honggang LI <honli@redhat.com>
To:     bvanassche@acm.org, dledford@redhat.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/2] IB/srp: Add parse function for maximum initiator to
 target IU size
Message-ID: <20190917032138.GA10897@dhcp-128-227.nay.redhat.com>
References: <20190917013905.2600-1-honli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917013905.2600-1-honli@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 17 Sep 2019 03:21:41 +0000 (UTC)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Sep 17, 2019 at 09:39:04AM +0800, Honggang LI wrote:
> From: Honggang Li <honli@redhat.com>
> 
> According to SRP specifications 'srp-r16a' and 'srp2r06',
> IOControllerProfile attributes for SRP target port include
> the maximum initiator to target IU size.

Please drop this patchset. Wrong patchset was sent. I will
send a new version.

