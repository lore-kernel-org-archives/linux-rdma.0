Return-Path: <SRS0=E0T5=XV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B9AC4360C
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 12:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78713222C3
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 12:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569501769;
	bh=QP8TvOvQxO3nJLf+Qx0o2mFi33wtotjl1X1ZI0+sMtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=U2sztzpSkztH8QepVqS7rqRuNl2TnLZxYk1r9lrGROHyobitAP9KqGm2Gev16hiyF
	 e9XtVnTiuNWk9DiHpmYVv+QhGD6QP+JdZuAgkIZVKqBIpxjVcie0O+xk+z+yNdqxZE
	 kv/B9juU7LKAvoZmGjCfIkaXDoECGF69fcfFQi8Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfIZMms (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Sep 2019 08:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbfIZMms (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 26 Sep 2019 08:42:48 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C8BE217F4;
        Thu, 26 Sep 2019 12:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569501768;
        bh=QP8TvOvQxO3nJLf+Qx0o2mFi33wtotjl1X1ZI0+sMtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UJCcOGNrhbzeehGYh92FQbOCKFq0qFO8StcRH4Z/58gFxPYipFCM4+iQzvF9TFTS5
         9yaw+ct0GDK+cIcfo4MCjnXkOInS+SiH5HjduqfM4MSisMzGOx+23h0ze5d5oPbEI+
         aN98xgl2AdwOsy9bPBvqWNgBcDI4gHi7dk+ihC6A=
Date:   Thu, 26 Sep 2019 15:42:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-core] kernel-boot: Tighten check if device is virtual
Message-ID: <20190926124243.GY14368@unreal>
References: <20190926094253.31145-1-leon@kernel.org>
 <20190926123427.GD19509@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926123427.GD19509@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Sep 26, 2019 at 12:34:31PM +0000, Jason Gunthorpe wrote:
> On Thu, Sep 26, 2019 at 12:42:53PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Virtual devices like SIW or RXE don't set FW version because
> > they don't have one, use that fact to rely on having empty
> > fw_ver file to sense such virtual devices.
>
> Have you checked that every physical device does set fw version?

I checked it with "grep", another solution which I had in mind is to
write "virtual" keyword as FW version.

Thanks

>
> Seems hacky
>
> Jason
