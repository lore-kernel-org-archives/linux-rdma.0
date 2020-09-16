Return-Path: <SRS0=XmsV=CZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C14C433E2
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Sep 2020 16:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC84122AAB
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Sep 2020 16:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgIPQYP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Sep 2020 12:24:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:12178 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgIPQT5 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 16 Sep 2020 12:19:57 -0400
IronPort-SDR: fUIMv5EA8HJ7UvbwzS/wZZmW1UENIUZqYpeaB66iJUV4LljIB/BLtZW9rg+s13R6IdZnoJ/SBW
 lxGVUQtz+q3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="244316329"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="244316329"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 07:53:23 -0700
IronPort-SDR: Dpgi8oXr/pEULftqjmu2mLjH0Tpv02QN2pJ15qOzzWDTzHF/tfn/YjA2iOCSe4LCob5nd6Yyti
 JvgbHsobGu6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="307063757"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 16 Sep 2020 07:53:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Sep 2020 07:53:22 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Sep 2020 07:53:19 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Wed, 16 Sep 2020 07:53:19 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Parav Pandit <parav@mellanox.com>,
        "Latif, Faisal" <faisal.latif@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: RE: [PATCH rdma-next] IB/i40iw: Avoid typecast from void to pci_dev
Thread-Topic: [PATCH rdma-next] IB/i40iw: Avoid typecast from void to pci_dev
Thread-Index: AQHWipOZKd/0GyOXkUK+C+49SJERX6lrToSQ
Date:   Wed, 16 Sep 2020 14:53:19 +0000
Message-ID: <9ce782da4c8a4872aa93c8bd737848c4@intel.com>
References: <20200914123528.270382-1-parav@mellanox.com>
In-Reply-To: <20200914123528.270382-1-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

> Subject: [PATCH rdma-next] IB/i40iw: Avoid typecast from void to pci_dev
> 
> From: Parav Pandit <parav@nvidia.com>
> 
> hw_context stores pci device pointer. Use the pci_dev pointer instead of void *
> and avoid typecasts.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_main.c  | 2 +-
> drivers/infiniband/hw/i40iw/i40iw_pble.c  | 4 ++--
> drivers/infiniband/hw/i40iw/i40iw_type.h  | 3 ++-
> drivers/infiniband/hw/i40iw/i40iw_utils.c | 4 ++--
> drivers/infiniband/hw/i40iw/i40iw_verbs.c | 2 +-
>  5 files changed, 8 insertions(+), 7 deletions(-)
> 

Looks good. Thanks Parav!

Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
