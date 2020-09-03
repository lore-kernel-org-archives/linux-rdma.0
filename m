Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E87C433E9
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 15:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7CEB2072A
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 15:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgICPPN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 11:15:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:24475 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728677AbgICPOv (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Sep 2020 11:14:51 -0400
IronPort-SDR: ahvZLYwi5TM8qiQ6Zpt+FVDKant5NImLkVa/vYqbQstwDIZhryCeZjaT9qu5LU7ARnyV94Bal2
 2ap/Cu2m10nQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="221805055"
X-IronPort-AV: E=Sophos;i="5.76,387,1592895600"; 
   d="scan'208";a="221805055"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2020 08:14:28 -0700
IronPort-SDR: JYvjb49amCaWfOYrMnLmN+JebAC3cS2d26LyLbD6FK5Ge40VCFWypwGqTEWnAivSemwtgKK2gh
 VBn3X1kv71HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,387,1592895600"; 
   d="scan'208";a="282707541"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 03 Sep 2020 08:14:27 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 3 Sep 2020 08:14:22 -0700
Received: from orsmsx105.amr.corp.intel.com (10.22.225.132) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 3 Sep 2020 08:14:22 -0700
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.181]) by
 ORSMSX105.amr.corp.intel.com ([169.254.2.22]) with mapi id 14.03.0439.000;
 Thu, 3 Sep 2020 08:14:22 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: RE: [PATCH 13/14] RDMA/mlx5: Use ib_umem_num_dma_blocks()
Thread-Topic: [PATCH 13/14] RDMA/mlx5: Use ib_umem_num_dma_blocks()
Thread-Index: AQHWgMIowDrhXnrQJE+lTQqh4Vxw/qlXBzOA
Date:   Thu, 3 Sep 2020 15:14:22 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A70107142196@ORSMSX101.amr.corp.intel.com>
References: <0-v1-00f59ce24f1f+19f50-umem_1_jgg@nvidia.com>
 <13-v1-00f59ce24f1f+19f50-umem_1_jgg@nvidia.com>
In-Reply-To: <13-v1-00f59ce24f1f+19f50-umem_1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

> Subject: [PATCH 13/14] RDMA/mlx5: Use ib_umem_num_dma_blocks()
> 
> For the calls linked to mlx4_ib_umem_calc_optimal_mtt_size() compute the number
> of DMA pages directly based on the returned page_shift. This was just being used
> as a weird default if the algorithm hits the lower limit.
> 
> All other places are just using it with PAGE_SIZE.
> 
> As this is the last call site, remove ib_umem_num_pages().

Typo. remove ib_umem_page_count


