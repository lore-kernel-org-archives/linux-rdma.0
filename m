Return-Path: <SRS0=3zC3=VG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBD4C606B0
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jul 2019 06:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0D952171F
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jul 2019 06:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562654327;
	bh=PZYIAIe28ueT3glSBNxrmKR4350lc1lH32EISt/ckR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jYva/m7ATwvP1+v3vtm6VHUJG83jH401e9Q/FAdyBiEI88YjkeA8UoT4HEAa6msAI
	 SHWKbawdm/b2es7CusRUe7Wj0bGUVJbG4q2BhaGWlRofUlPZqxHRMfZdS4rd2GmMOq
	 6UZ0Sn1XK2L+n4qDya8UtLv/3q1ryqRiSFCtlWRM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfGIGir (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 9 Jul 2019 02:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGIGiq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 9 Jul 2019 02:38:46 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 706AD216C4;
        Tue,  9 Jul 2019 06:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562654326;
        bh=PZYIAIe28ueT3glSBNxrmKR4350lc1lH32EISt/ckR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qb/cvMB5JLJxT26ja3ORwTVTi6gxi1DJNh8h1uugOWsvz/Q+De3M87kCaCkOoynHt
         y36gsVerZGe3Ug+UieOHFTqqhGs9kpfd9eelqrs9U29qfc9SYQXYE07JhDHRoMVR2Q
         Paiy4sK3lv7IdjeuiWeGKOPEt09MXDvg9oEyWgV0=
Date:   Tue, 9 Jul 2019 09:38:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH rdma-next 2/2] IB: Support netlink commands in non
 init_net net namespaces
Message-ID: <20190709063842.GE7034@mtr-leonro.mtl.com>
References: <20190704130402.8431-1-leon@kernel.org>
 <20190704130402.8431-3-leon@kernel.org>
 <20190708202023.GA8020@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708202023.GA8020@ziepe.ca>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jul 08, 2019 at 05:20:23PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 04, 2019 at 04:04:02PM +0300, Leon Romanovsky wrote:
> > -int rdma_nl_unicast(struct sk_buff *skb, u32 pid)
> > +int rdma_nl_unicast(struct net *net, struct sk_buff *skb, u32 pid)
> >  {
> > +	struct rdma_dev_net *rnet = net_generic(net, rdma_dev_net_id);
>
> This should be a proper type safe accessor in all places

"const struct net *net" and not "struct net *net"?

>
> > -void rdma_nl_exit(void)
> > +void rdma_nl_net_exit(struct rdma_dev_net *rnet)
> >  {
> > -	int idx;
> > -
> > -	for (idx = 0; idx < RDMA_NL_NUM_CLIENTS; idx++)
> > -		rdma_nl_unregister(idx);
>
> There should be a WARN_ON during the module unload that no NL clients
> are still registered

IMHO, the usage of WARN_ON is overrated.

>
> Thanks,
> Jason
