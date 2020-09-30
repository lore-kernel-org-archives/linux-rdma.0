Return-Path: <SRS0=0+5s=DH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BF0C4727C
	for <linux-rdma@archiver.kernel.org>; Wed, 30 Sep 2020 18:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 535B32076A
	for <linux-rdma@archiver.kernel.org>; Wed, 30 Sep 2020 18:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="XD7/Bf+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgI3S0p (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 30 Sep 2020 14:26:45 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17785 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3S0p (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 30 Sep 2020 14:26:45 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f74cdb10001>; Wed, 30 Sep 2020 11:25:53 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 18:26:44 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.53) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 30 Sep 2020 18:26:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYreekAH/xjTq8e8PnmgT2v1dH7MLeNgaLhkI7x7wvClN842wgFobFs4bxz7xlbx1LdcHglbSkaKmRWZHA1OLpnFj7hBgntA5TpRnPKvpKtpBLwCKT4rOJmlNqC3u4lb+VltRU75f+AOaAUN50A77ma0HrMKJ0I/VZV/f+NSUQ5pf4k2Fkaee3zRVsAzPb/eZR31fRwJbqqKS2fenSc2r8akkKAP6NnQggVwiZio42WntN7ECaFzyGOeEPD3wMoest58IGBCvmzexykG1ZuBYhXZnsLUrfZR3lQa0EZcgPLbg1K6fFIB35U+PkvRBY5pSfKIltGpsmA1IPcrg6JMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1mm3GBgW2kFtLT4iIUEYWS8YNxW46GU0GruvZ2QfrQ=;
 b=XogyP+DLN8m8BkWBNeZ4CanTazrNf5eWPC4Y/Aki20sbrNjB7uRL1OKMZOmWn+QXMbd+iV3jQGWmSd+eYcOGZpVGQZze85Hqun1qriFfHpOIUnUvHir1BWti2Qv8k9TdunCE8v2ITxfnLKQIbLhNemDA7G+X8s8uw+NwSRdHyotUmugy9vion521KWq4K9e3FyiG6rovx+OmDgKMDcBZVsowPSWQRIWh5Ml5rQF8GNC/AvpsaN+VAwTqMnoOoFV9tjZWezBvrtL9wLDVeW4kp3PvA7K0hC8ISFEs7Stl3Eqbc+7nWCb34UdeDbWYK/eEBwWy/dAax0aZ9Dn052489g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3017.namprd12.prod.outlook.com (2603:10b6:5:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.26; Wed, 30 Sep
 2020 18:26:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 18:26:42 +0000
Date:   Wed, 30 Sep 2020 15:26:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Gioh Kim <gi-oh.kim@cloud.ionos.com>
CC:     <danil.kipnis@cloud.ionos.com>, <jinpu.wang@cloud.ionos.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] RDMA/rtrs: remove unused field of rtrs_iu
Message-ID: <20200930182641.GA1018383@nvidia.com>
References: <20200930131407.6438-1-gi-oh.kim@clous.ionos.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200930131407.6438-1-gi-oh.kim@clous.ionos.com>
X-ClientProxiedBy: MN2PR15CA0066.namprd15.prod.outlook.com
 (2603:10b6:208:237::35) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR15CA0066.namprd15.prod.outlook.com (2603:10b6:208:237::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Wed, 30 Sep 2020 18:26:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kNgoL-004GwM-F8; Wed, 30 Sep 2020 15:26:41 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601490353; bh=j1mm3GBgW2kFtLT4iIUEYWS8YNxW46GU0GruvZ2QfrQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=XD7/Bf+OcaYV6O+d75oMJlx8R7MsJfrbYoC9UlXzs6u+WHDVCFyiChjYYCDixGVSf
         U/4vu8Krc9vFgj00f9ZFvfDjVnOJ1g5ZFFECweXq7tkXZdJFyhhMHFZJkLA6QpP9iJ
         CcsD6D0Dly82/NowFTQOWsp3m7laVlZ2WV6TIJ4j3aigfhOtQJyJ4Ob9745qPaGeRB
         XLLRt70HLLQEEOC6UoqeElEMWmqsa+RJXgax5YoR3CLWZPSLIkTFO/c0vtau5SyGZj
         Vcu/yUin79Ii6gtSMyuAT9zmeiyi1+3/xpaUxKPYAvaaAqP6a72Hubc4BseRcEPJ4T
         18YFZ82rplOuA==
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Sep 30, 2020 at 03:14:07PM +0200, Gioh Kim wrote:
> From: Gioh Kim <gi-oh.kim@cloud.ionos.com>
> 
> list field is not used anywhere
> 
> Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
> Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-pri.h | 1 -
>  1 file changed, 1 deletion(-)

Applied to for-next, thanks

Jason
