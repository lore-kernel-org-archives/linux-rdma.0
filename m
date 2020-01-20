Return-Path: <SRS0=PaA+=3J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE71C33CA1
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Jan 2020 07:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C8AF207E0
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Jan 2020 07:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579506350;
	bh=WWj0jvtanOKRVNDMh9lDDAbKXymX9iYj1P7mscfj6QQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DlY8cJ4sY4dLBHgb3t5ApuhikmzZeVzpMckJZzhdB3EWdKYU7Ix8vTcrtJWxTTY0n
	 vRrwG3sJkrZyEygUn+xp2QKOvoU4cZA9DD3yp4RZTXFGy0GEARxGyPDbtSMrpMvnk0
	 ylZgzxVM80FVxSIqTNq5z8md24wAGRxfPNga7llg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgATHpu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 20 Jan 2020 02:45:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgATHpt (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 20 Jan 2020 02:45:49 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E3822073D;
        Mon, 20 Jan 2020 07:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579506349;
        bh=WWj0jvtanOKRVNDMh9lDDAbKXymX9iYj1P7mscfj6QQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UggoDAMnbm7tyoKDPQHIwHPoGXwp7FsvNiJhSUPFDyBMMyUI43U/h9UZY4hGZHLI8
         wYiIYjIguTmUFLsFORLHjFIZRO5Z3Gua9tqSqPxJwNtP4kveidSfIohLEPHgNYjco+
         Idlk0Re2nie6Tim6I4OMpS3H2TYJWTwCXJwqa5GQ=
Date:   Mon, 20 Jan 2020 09:45:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lang Cheng <chenglang@huawei.com>
Cc:     Weihang Li <liweihang@huawei.com>, aelior@marvell.com,
        mkalderon@marvell.com, linuxarm@huawei.com, aditr@vmware.com,
        jgg@ziepe.ca, dledford@redhat.com, shiraz.saleem@intel.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RFC for-next 2/6] RDMA/mlx5: remove deliver net device
 event
Message-ID: <20200120074545.GF51881@unreal>
References: <1579147847-12158-1-git-send-email-liweihang@huawei.com>
 <1579147847-12158-3-git-send-email-liweihang@huawei.com>
 <20200116114115.GE6853@unreal>
 <7f3f8190-6b62-f3c6-e4db-2425411fa639@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f3f8190-6b62-f3c6-e4db-2425411fa639@huawei.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jan 20, 2020 at 03:31:14PM +0800, Lang Cheng wrote:
>
> On 2020/1/16 19:41, Leon Romanovsky wrote:
> > On Thu, Jan 16, 2020 at 12:10:43PM +0800, Weihang Li wrote:
> > > From: Lang Cheng <chenglang@huawei.com>
> > >
> > > The code that handles the link event of the net device has been moved
> > > into the core, and the related processing should been removed from the
> > > provider's driver.
> > I have serious doubts that this patch broke mlx5 LAG functionality.
>
> All vendor drivers need to remove port link event code,
> and query slave info(only if support bonding) in ops.query_port callback.
> Here is about 4 function:
>
> mlx5_netdev_event(): remove all port link event code after ib core supports
> sending them,
>
> mlx5_get_rep_roce(): Only mlx5_netdev_event() ever called it, and now no
> one, so remove it.
>
> get_port_state():just move public operation to ib core.
>
> mlx5_query_port_roce():	query more info, no impact on existing code.
>
>
> Is there any hidden relationship that I didn't notice?

You didn't missed the functions which are relevant to bond, but from
what I saw you implemented wrongly events handling related to mlx5 bond.

I didn't look very deeply yet because the series is far from
completion and maybe I'm mistaken and bond works perfectly.

Thanks

>
> Thanks.
>
> >
> > Thanks
> > _______________________________________________
> > Linuxarm mailing list
> > Linuxarm@huawei.com
> > http://hulk.huawei.com/mailman/listinfo/linuxarm
> >
