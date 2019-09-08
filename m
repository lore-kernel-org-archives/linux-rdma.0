Return-Path: <SRS0=Mzqd=XD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BFAC43217
	for <linux-rdma@archiver.kernel.org>; Sun,  8 Sep 2019 08:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D1520854
	for <linux-rdma@archiver.kernel.org>; Sun,  8 Sep 2019 08:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567929792;
	bh=xlGEnsaaAlekncHwPPKPb8uAq1rRlvuH5JCLYaoMBoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=m8uNLwHa9TIFB+jClmmA+hcwEEPIgIijfIh94EvTbVkJQF54V3QAPx1U/FE4Cm4Tz
	 i2aN8EhBy7JWc70Zr12AXKpXfXcWb7UpWRbqkgkU5u2j9FnNcpSy8E2qvKJuOjEZms
	 UK4NpAVlIxQGc4NuG2cOAbolC1xE5S+P9gf0mXUU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfIHIDK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 8 Sep 2019 04:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfIHIDJ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 8 Sep 2019 04:03:09 -0400
Received: from localhost (unknown [77.137.95.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FA3A2081B;
        Sun,  8 Sep 2019 08:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567929789;
        bh=xlGEnsaaAlekncHwPPKPb8uAq1rRlvuH5JCLYaoMBoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kqNSVMNhkDYzV0h4VQPlio+mpU+RRQNqXz6gnPnKZ0NSqHPDxlCQLchPcBFjhF2Au
         pJzQVffbIET75jKbSsOjTOVX52Fcwd0gGz7K7RRm4tMVmtSDM2Gty6/cntxYPLU2mq
         WoNOk0UT10aSQzhQ0mPezR2w2sFqziLe//K2auUI=
Date:   Sun, 8 Sep 2019 11:03:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Weihang Li <liweihang@hisilicon.com>
Cc:     dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH for-next] RDMA/hns: Bugfix for flush cqe in case softirq
 and multi-process
Message-ID: <20190908080303.GC26697@unreal>
References: <1567686671-4331-1-git-send-email-liweihang@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567686671-4331-1-git-send-email-liweihang@hisilicon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Sep 05, 2019 at 08:31:11PM +0800, Weihang Li wrote:
> From: Yixian Liu <liuyixian@huawei.com>
>
> Hip08 has the feature flush cqe, which help to flush wqe in workqueue
> (sq and rq) when error happened by transmitting producer index with
> mailbox to hardware. Flush cqe is emplemented in post send and recv
> verbs. However, under NVMe cases, these verbs will be called under
> softirq context, and it will lead to following calltrace with
> current driver as mailbox used by flush cqe can go to sleep.
>
> This patch solves this problem by using workqueue to do flush cqe,

Unbelievable, almost every bug in this driver is solved by introducing
workqueue. You should fix "sleep in flush path" issue and not by adding
new workqueue.

Thanks
