Return-Path: <SRS0=M/HP=Y4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDF8CA9EB5
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 15:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74FBD214B2
	for <linux-rdma@archiver.kernel.org>; Mon,  4 Nov 2019 15:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572883014;
	bh=KSHvmPulcvvClVkdnZRmfT8nwEZUFYa9pOosEQgqeKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hVEO4ONDGURsbAyQhILS8lzb2YY0mwbf0Ui21ktmpSr9rom/HeRet/QO5LLjqqoOG
	 PHGHlRMhxshTyS81fvwV4AxD3LvA4C7sM68ESxAbaaVJuSFnxTb8+2+I2pRSpzcTQy
	 aFZUs+DDrBOUxhr4yb0iDWKuLTlxvSXj7Ni4xGw8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKDP4y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfKDP4x (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 4 Nov 2019 10:56:53 -0500
Received: from localhost (unknown [77.137.93.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97FB720869;
        Mon,  4 Nov 2019 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572883013;
        bh=KSHvmPulcvvClVkdnZRmfT8nwEZUFYa9pOosEQgqeKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrqGxn6FqdSCad2SxNKn75eZjXLtDX/zyA2qa84Rlof6sjR8J4JHiP29dZrrHt0ZK
         2vK0rqeFV/tdgNEtAaXv+n715XhDvbXNRnx9G9PMaQoDjrfHpSCPo+Wklwdt5asFgj
         ZITCgB5+FJyDD5irYBwFeXG/kZMNA1lanttOny6U=
Date:   Mon, 4 Nov 2019 17:56:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Potnuri Bharat Teja <bharat@chelsio.com>
Cc:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>
Subject: Re: [PATCH rdma-core] cxgb4: free appropriate pointer in error case
Message-ID: <20191104155647.GB100753@unreal>
References: <1572866050-29952-1-git-send-email-bharat@chelsio.com>
 <20191104114548.GA100753@unreal>
 <20191104122149.GA8473@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104122149.GA8473@chelsio.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Nov 04, 2019 at 05:51:50PM +0530, Potnuri Bharat Teja wrote:
> On Monday, November 11/04/19, 2019 at 17:15:48 +0530, Leon Romanovsky wrote:
> > On Mon, Nov 04, 2019 at 04:44:10PM +0530, Potnuri Bharat Teja wrote:
> > > Fixes: 9b2d3af5735e ("Query device to get the max supported stags, qps, and cqs")
> > > Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> > > ---
> >
> > We are not super-excited to see patches with empty commit message.
> My bad sent an older one instead. Shall resend the right one.
> > Care to send PR to rdma-core? It will be easier for us to merge it.
> This is how i do for rdma-core patches. first sent to mailing list and then
> send a PR. Is it the other way?

You can skip sending patches to ML for trivial ones.

Thanks
