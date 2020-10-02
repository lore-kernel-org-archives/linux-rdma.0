Return-Path: <SRS0=xA/t=DJ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64810C4363C
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Oct 2020 17:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21847205ED
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Oct 2020 17:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgJBRKl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Oct 2020 13:10:41 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:36380 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgJBRKl (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Oct 2020 13:10:41 -0400
Received: from localhost (pvp1.blr.asicdesigners.com [10.193.80.26])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 092HAESb002361;
        Fri, 2 Oct 2020 10:10:14 -0700
Date:   Fri, 2 Oct 2020 22:40:13 +0530
From:   Krishnamraju Eraparaju <krishna2@chelsio.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     linux-rdma@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: reduce iSERT Max IO size
Message-ID: <20201002171007.GA16636@chelsio.com>
References: <20200922104424.GA18887@chelsio.com>
 <07e53835-8389-3e07-6976-505edbd94f2a@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07e53835-8389-3e07-6976-505edbd94f2a@grimberg.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi Sagi & Max,

Any update on this?
Please change the max IO size to 1MiB(256 pages). 


Thanks,
Krishnam Raju.
On Wednesday, September 09/23/20, 2020 at 01:57:47 -0700, Sagi Grimberg wrote:
> 
> >Hi,
> >
> >Please reduce the Max IO size to 1MiB(256 pages), at iSER Target.
> >The PBL memory consumption has increased significantly after increasing
> >the Max IO size to 16MiB(with commit:317000b926b07c).
> >Due to the large MR pool, the max no.of iSER connections(On one variant
> >of Chelsio cards) came down to 9, before it was 250.
> >NVMe-RDMA target also uses 1MiB max IO size.
> 
> Max, remind me what was the point to support 16M? Did this resolve
> an issue?
