Return-Path: <SRS0=jqE+=CT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B51BC43461
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Sep 2020 12:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD2A20882
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Sep 2020 12:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599741021;
	bh=JhDy2mnhdUXTzdyv1E3E8/uOxCaSl+2yeAGmi5yhCQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=s8WpXmjpZAKpj10RorWCscqnnbOZVq/ub8gm0EbmFUfK2R4ro6fmrWzWBVwOdQfqe
	 kHSh4LakR1DZBOFbGPl8QCiWdtcKj7J+XBq+dVcsNLO2wBpvTG8BbRVdtPX9oCZMMn
	 sbeHH/8CCLObcCUtOKfpN7el1UXieXPojCzoAHFI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgIJM35 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 10 Sep 2020 08:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730720AbgIJM1v (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 10 Sep 2020 08:27:51 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA77520882;
        Thu, 10 Sep 2020 12:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599740863;
        bh=JhDy2mnhdUXTzdyv1E3E8/uOxCaSl+2yeAGmi5yhCQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n4wzarm9GvjgYE3IC96eJP7zCI1iXHhGh4aq99gcFFAAB06mB+zD5R3aR5kxa8rSJ
         C4r6HjO0v3iC+I7PhlduxO3A3ecPWB682fYHJjCCXxgqywHssBsyO4W5LfsRroZB81
         J+JQtryNFRsDIGPeCPLjMg7BKCVkQmQOtIzxrMMc=
Date:   Thu, 10 Sep 2020 15:27:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Potnuri Bharat Teja <bharat@chelsio.com>
Cc:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] RDMA/iw_cxgb4: disable delayed ack by default
Message-ID: <20200910122739.GJ421756@unreal>
References: <20200909134726.10348-1-bharat@chelsio.com>
 <CY4PR1201MB02327F3093F7DD29E08CCF32CE260@CY4PR1201MB0232.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1201MB02327F3093F7DD29E08CCF32CE260@CY4PR1201MB0232.namprd12.prod.outlook.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Sep 09, 2020 at 03:28:44PM +0000, Potnuri Bharat Teja wrote:
> Missed rdma-next subject prefix. Resending.
>
> -----Original Message-----
> From: Potnuri Bharat Teja <bharat@chelsio.com>
> Sent: Wednesday, September 9, 2020 7:17 PM
> To: jgg@ziepe.ca; dledford@redhat.com
> Cc: linux-rdma@vger.kernel.org; Potnuri Bharat Teja <bharat@chelsio.com>
> Subject: [PATCH] RDMA/iw_cxgb4: disable delayed ack by default
>
> Receive side delayed ack mode is needed only for certain area networks/ connections. Therefore disable it by default.
>
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 1f288c73ccfc..8769e7aa097f 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -77,9 +77,9 @@ static int enable_ecn;  module_param(enable_ecn, int, 0644);  MODULE_PARM_DESC(enable_ecn, "Enable ECN (default=0/disabled)");
>
> -static int dack_mode = 1;
> +static int dack_mode;
>  module_param(dack_mode, int, 0644);
> -MODULE_PARM_DESC(dack_mode, "Delayed ack mode (default=1)");
> +MODULE_PARM_DESC(dack_mode, "Delayed ack mode (default=0)");

Are you sure that this doesn't break user scripts?

Thanks

>
>  uint c4iw_max_read_depth = 32;
>  module_param(c4iw_max_read_depth, int, 0644);
> --
> 2.24.0
