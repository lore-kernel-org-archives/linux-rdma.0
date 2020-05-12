Return-Path: <SRS0=8X7E=62=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAB5C54E8B
	for <linux-rdma@archiver.kernel.org>; Tue, 12 May 2020 05:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A256208D5
	for <linux-rdma@archiver.kernel.org>; Tue, 12 May 2020 05:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589262927;
	bh=UYfTp7JUeDQOHPcWO489fkxFF4nTgJk3C4qQ163vnHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=M+luqH2jklsh85wIgby8rc2Xn/GfnY5Het2yi4f8fxR16f1XFA+2uXzZMCxdHZLSf
	 wVQhl+iAgx2Gf5Dens16yA6l3MHfTZkJi6uD3jcxF+XnME7MRIgAgQHeNK0CO/flLN
	 h65fAr/sXZBdMxnoTvcLPU+geE7qLf/KCDaaCU+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgELFz0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 12 May 2020 01:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgELFz0 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 12 May 2020 01:55:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F4BC20733;
        Tue, 12 May 2020 05:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589262926;
        bh=UYfTp7JUeDQOHPcWO489fkxFF4nTgJk3C4qQ163vnHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SM8tYPNC/GZfoF2yeZK7fCROZxN3+dgJxKeHrz9fe7dzmcoX2VxL4WhDxw95rahJ6
         NuBsIuCPr97pW29NRV6w/2SvBhndrtwSL66Tmsy3akwc+zmGgGgr/jJTiXb7ibnikd
         SrcZ8zQsZto+123eCbqhkQjPAUhnszGzHY1CvcPA=
Date:   Tue, 12 May 2020 08:55:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Message-ID: <20200512055521.GA4814@unreal>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031315.189865.15477.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512031315.189865.15477.stgit@awfm-01.aw.intel.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, May 11, 2020 at 11:13:15PM -0400, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
>
> The workqueue hfi1_wq is destroyed in function shutdown_device(), which
> is called by either shutdown_one() or remove_one(). The function
> shutdown_one() is called when the kernel is rebooted while remove_one()
> is called when the hfi1 driver is unloaded. When the kernel is rebooted,
> hfi1_wq is destroyed while all qps are still active, leading to a
> kernel crash:

I was under impression that kernel reboot should follow same logic as
module removal. This is what graceful reboot will do anyway. Can you
please give me a link where I can read about difference in those flows?

Thanks
