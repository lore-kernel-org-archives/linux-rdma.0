Return-Path: <SRS0=5wWz=C4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA55C43464
	for <linux-rdma@archiver.kernel.org>; Sat, 19 Sep 2020 09:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF0AB21D43
	for <linux-rdma@archiver.kernel.org>; Sat, 19 Sep 2020 09:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600506575;
	bh=s5/xQapJ6OH0+wibubDhoEf/wZqpAYla/VZaTZ09IjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0MbOLOHKYtRAOwZJhZLmxNATcNgZy57l25ARkFCMoPUnpdJNnWRvU7mZubDoxDBw6
	 QcvXlonXitticicpvf/3CGW+tvvwzs1gtUujtlBIf9czXmWxbnpsNeboRPTj0tgV2/
	 jSDJ/HQTm/iVWNPbIpUaH01dr64MP4x1ruqN7+FU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgISJJe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 19 Sep 2020 05:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgISJJd (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 19 Sep 2020 05:09:33 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDACB21741;
        Sat, 19 Sep 2020 09:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600506573;
        bh=s5/xQapJ6OH0+wibubDhoEf/wZqpAYla/VZaTZ09IjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vm3PvkWn5LWIwOcpP4XjSKuuDohGntfhjMUx5QgYh9U6p0maZB2uzbmvIho8lf7xG
         HCU3+GCdfb68GfT11EvAxY/3oyArxmjexakZOAaRqdBrQpUPbxOnOCG8FaCCp+4uBb
         bhfxPUKig7FeE9vMGWQ+fErhoh8Pu00d/Z3vnhtE=
Date:   Sat, 19 Sep 2020 12:09:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markz@nvidia.com>
Subject: Re: [PATCH rdma-next v2 11/14] RDMA/restrack: Make restrack DB
 mandatory for IB objects
Message-ID: <20200919090928.GC869610@unreal>
References: <20200907122156.478360-1-leon@kernel.org>
 <20200907122156.478360-12-leon@kernel.org>
 <20200918233152.GF3699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918233152.GF3699@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Sep 18, 2020 at 08:31:52PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 07, 2020 at 03:21:53PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Restrack stores the IB objects in the internal xarray and insertion
> > where can fail. As long as restrack was helper tool for the
> > debuggability, such failure were ignored.
> >
> > In the following patches, the ib_core will be changed to manage allocated
> > IB objects in restrack DB for the proper memory lifetime. It requires to
> > ensure that insertion errors are not ignored.
>
> Why? This looks like it is all about removing valid, not sure what the
> kref has to do with it..

This DB is going to be main source of all HW objects and their memory
allocations. We want to be sure that everything there is valid.

Thanks

>
> Jason
