Return-Path: <SRS0=0boT=X4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F8EC10F14
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Oct 2019 08:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8797E20815
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Oct 2019 08:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570090852;
	bh=zma8b4WVQpeJfiL2fy1SEiHV9CPEtfvm4I+YEdFQC8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=w5pGs6+Osy5miJEM8MR2q5SlT43glRwFFMWrlW3fEYfAouQJQmtZDXcUp0OoM4QHy
	 3J0Hwu3z0kEaPqAlQ0cMTMXnmAANidt24e+87rC0xmOI5ORPbT/RA7uBuoLpLJTHg8
	 qW9sjDNF1wx6vR+T5ZoFlPYfxTy8Nda+YCO/RE5E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfJCIUv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Oct 2019 04:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbfJCIUv (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Oct 2019 04:20:51 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F5420815;
        Thu,  3 Oct 2019 08:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570090851;
        bh=zma8b4WVQpeJfiL2fy1SEiHV9CPEtfvm4I+YEdFQC8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SsYTOmWDqV9ID1YtFhdNTo4rKkAHUlaSIYfzrJVjAX3mkR2RUeJLqk1fheLLP+tfm
         LYQo2WAiz4OMYMR7aRvcDsPfOXbGuqrY1820xVzMbaIYNQ32Rjk/MyhfRI+VAze2z6
         +fFsYyDXKyGnxi2yz41CRQYeG0MDkXKE0RaMtgrM=
Date:   Thu, 3 Oct 2019 11:20:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] RDMA: release allocated skb
Message-ID: <20191003082048.GK5855@unreal>
References: <20190923050823.GL14368@unreal>
 <20190923155300.20407-1-navid.emamdoost@gmail.com>
 <20191001135430.GA27086@ziepe.ca>
 <CAEkB2EQF0D-Fdg74+E4VdxipZvTaBKseCtKJKnFg7T6ZZE9x6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEkB2EQF0D-Fdg74+E4VdxipZvTaBKseCtKJKnFg7T6ZZE9x6Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Oct 02, 2019 at 04:35:06PM -0500, Navid Emamdoost wrote:
> Hi Jason,
>
> Thanks for the feedback. Yes, you are right if the skb release is
> moved under err4 label it will cause a double free as
> c4iw_ref_send_wait will release skb in case of error.
> So, in order to avoid leaking skb in case of c4iw_bar2_addrs failure,
> the kfree(skb) could be placed under the error check like the way
> patch v1 did. Do you see any mistake in version 1?
> https://lore.kernel.org/patchwork/patch/1128510/

No, it is not enough.
c4iw_ref_send_wait() ->
  c4iw_wait_for_reply() ->
    return wr_waitp->ret; <--- can be -EIO

Thanks
