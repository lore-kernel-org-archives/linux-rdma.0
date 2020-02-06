Return-Path: <SRS0=p0Sv=32=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B750C2D0B1
	for <linux-rdma@archiver.kernel.org>; Thu,  6 Feb 2020 08:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D92A821775
	for <linux-rdma@archiver.kernel.org>; Thu,  6 Feb 2020 08:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580978292;
	bh=Ts1Y3ru5PoyoK/RFG8J6yeoJODoPDhO7xgwEpwOizZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dsqZpphYUWwy+2rCH9qFkMGuUtkGsmbWN+PSkQJrNGpjjGZtg9UgMy+bSBfrM6vMz
	 8ZKYxRf0tmUS7lc6BlGoX7Qeli5YInugEKq8QXemz0Rw19KHbSO6vZhkaOBUY8yhWT
	 I+itwxSIvw2C03dN0awDVxlG7KmDw1tREoYOgSZ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgBFIiL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 6 Feb 2020 03:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgBFIiL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 6 Feb 2020 03:38:11 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D01214AF;
        Thu,  6 Feb 2020 08:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580978290;
        bh=Ts1Y3ru5PoyoK/RFG8J6yeoJODoPDhO7xgwEpwOizZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SAbFH035fuEqRomMIVJIHjrmjksoD/rwFi3aGKEeDDBErXVH+va2WBeJcctgeYShc
         KhjNYWj3kyW9ya3Ust4AVeB6rf8GXfT+smrHcTXBIElijcseJgYexkQtx3SF6L4OBe
         5URg0ppIbTP2+S54giBrVM5wodmDxmyz6mz7wBAc=
Date:   Thu, 6 Feb 2020 10:38:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Devesh Sharma <devesh.sharma@broadcom.com>
Cc:     linux-rdma@vger.kernel.org, jgg@mellanox.com
Subject: Re: [PATCH v7] libibverbs: display gid type in ibv_devinfo
Message-ID: <20200206083807.GD414821@unreal>
References: <1580967842-11220-1-git-send-email-devesh.sharma@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580967842-11220-1-git-send-email-devesh.sharma@broadcom.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Feb 06, 2020 at 12:44:02AM -0500, Devesh Sharma wrote:
> It becomes difficult to make out from the output of ibv_devinfo
> if a particular gid index is RoCE v2 or not.
>
> Adding a string to the output of ibv_devinfo -v to display the
> gid type at the end of gid.
>
> The output would look something like below:
> $ ibv_devinfo -v -d bnxt_re2
> hca_id: bnxt_re2
>  transport:             InfiniBand (0)
>  fw_ver:                216.0.220.0
>  node_guid:             b226:28ff:fed3:b0f0
>  sys_image_guid:        b226:28ff:fed3:b0f0
>   .
>   .
>   .
>   .
> 	phys_state:     LINK_UP (5)
> 	GID[  0]:       fe80:0000:0000:0000:b226:28ff:fed3:b0f0, IB/RoCE v1
> 	GID[  1]:       fe80::b226:28ff:fed3:b0f0, RoCE v2
> 	GID[  2]:       0000:0000:0000:0000:0000:ffff:c0aa:0165, IB/RoCE v1
> 	GID[  3]:       ::ffff:192.170.1.101, RoCE v2
> $
> $
> $
>
> Reviewed-by: Jason Gunthrope <jgg@ziepe.ca>
> Reviewed-by: Leon Romanovsky <leon@kernel.org>

Please don't add my Reviewed-by, before I explicitly wrote it.

Thanks
