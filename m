Return-Path: <SRS0=uoZ+=CQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72D7C2BB84
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Sep 2020 10:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B76820659
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Sep 2020 10:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599474849;
	bh=n9Of4k0w4YnJ3xQnu3kAzSc2cLgkd036Xrgvbd+5mvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FPhmUaOuPfJc+BoY0XTmRJZ05VSxF6JcMUKnkdDQC+5QLv76MRFd3iy9t4WakZU/z
	 36tUSskXsN3WmYrglQNAxSq/yBGI6M2B7pNLNvoRlnqii3pFGFHIK5NonUl6kwNnru
	 gTauhhRlJB/QhQNheiMMWX3bdpbEWlvVeH58L7mA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgIGKd5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Sep 2020 06:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729008AbgIGKd0 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 7 Sep 2020 06:33:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43AD221481;
        Mon,  7 Sep 2020 10:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599474806;
        bh=n9Of4k0w4YnJ3xQnu3kAzSc2cLgkd036Xrgvbd+5mvc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cV/JLOKcaugzI4HxAVkSSLdmUwAQPzorS/icPhjBY/vF6Nm/YucoXwZrTdfBsq1xM
         EGn54bTnpR9+NJEamoiIBKL3LlO5Hw5dAIwgYy5glti2VhbBRZG1zgrt4SX0WjNINi
         RzurQnsiMPXXmHSOv5xYrEwfs3l8TbvbF3/pYRiQ=
Date:   Mon, 7 Sep 2020 13:33:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Cc:     danil.kipnis@cloud.ionos.com, jinpu.wang@cloud.ionos.com,
        linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2] RDMA/rtrs-srv: Set .release function for rtrs srv
 device during device init
Message-ID: <20200907103322.GB421756@unreal>
References: <20200907102216.104041-1-haris.iqbal@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907102216.104041-1-haris.iqbal@cloud.ionos.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Sep 07, 2020 at 03:52:16PM +0530, Md Haris Iqbal wrote:
> The device .release function was not being set during the device
> initialization. This was leading to the below warning, in error cases when
> put_srv was called before device_add was called.
>
> Warning:
>
> Device '(null)' does not have a release() function, it is broken and must
> be fixed. See Documentation/kobject.txt.
>
> So, set the device .release function during device initialization in the
> __alloc_srv() function.
>
> Fixes: baa5b28b7a47 ("RDMA/rtrs-srv: Replace device_register with device_initialize and device_add")
> Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
> ---
> Change in v2:
>         Use the complete Fixes line
>
>  drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 8 --------
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 8 ++++++++
>  2 files changed, 8 insertions(+), 8 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
