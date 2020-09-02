Return-Path: <SRS0=RpEd=CL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874F7C433E2
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Sep 2020 09:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53BCC2087D
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Sep 2020 09:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599037410;
	bh=bfO9wCuw+Eh9xeDv1yXorY5yhggM67D8s0J74GOKDgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=L/Gbx2nZKF18Q8YaEeGw+e1Y0f18Tv8eIc+BP362CqliMaevhFWHlmEa6jTWBQPoA
	 QZLtvBhKxCBULiaIdWHQoKwMPUEhRAOP+QmEI3gGEsCgStQnXmEcm8YMJcKoSVrpbU
	 nj7SZ10aVD74+hWdJL/RiMiDIzBsFauBcAmTXS6Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIBJD3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgIBJD2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Sep 2020 05:03:28 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99A0F20709;
        Wed,  2 Sep 2020 09:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599037408;
        bh=bfO9wCuw+Eh9xeDv1yXorY5yhggM67D8s0J74GOKDgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U2ekdiUC150UFqQQk4z9g5zUnK03MRqYroxIcjwi8ZfHW256FHduePnaWT9spydm8
         y6J9mZJgA2HCvLpAMBMIPQiiuvp1svhC2EGdYTc1WJQMTZw8/ZcokM5JDmqBxAKUNV
         HZHmPCUYva0NwENmptRlmW4kqNRDL15veWgNizng=
Date:   Wed, 2 Sep 2020 12:03:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     selvin.xavier@broadcom.com, devesh.sharma@broadcom.com,
        dledford@redhat.com, jgg@ziepe.ca, kamalheib1@gmail.com,
        maxg@mellanox.com, monis@mellanox.com, gustavoars@kernel.org,
        galpress@amazon.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bernard Metzler <bmt@zurich.ibm.com>
Subject: Re: [PATCH] RDMA: error code handling
Message-ID: <20200902090325.GF59010@unreal>
References: <20200824234422.1261394-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824234422.1261394-1-ztong0001@gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Aug 24, 2020 at 07:44:21PM -0400, Tong Zhang wrote:
> ocrdma_qp_state_change() returns 1 when new and old state are the same,
> however caller is checking using <0
>
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Fixes: 057729cb2347 ("RDMA/ocrdma: Remove driver QP state machine")

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
