Return-Path: <SRS0=OVxU=5L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E9DC2D0EC
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Mar 2020 16:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F87F2083E
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Mar 2020 16:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgCZQlB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Mar 2020 12:41:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:7059 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgCZQlB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 26 Mar 2020 12:41:01 -0400
IronPort-SDR: QocpAerC0XtuEBmvwHcfT5lfmCvK56LFiCBECoWqHW2Z+u17ELD6T7Ft8NTTl6eMBEwtRwpkTZ
 +R2a3U3+TS6w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 09:41:00 -0700
IronPort-SDR: DSODgxtVCl8+PmNCNVn7Uj3hQk1cdGPkjxTHa8jCeIfH6SfenzJefkBKXCMaI2QjWgJqs8D2/V
 FAd2+LSEg/vw==
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="420773576"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.200.139]) ([10.254.200.139])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 09:40:59 -0700
Subject: Re: [PATCH for-rc 2/2] IB/hfi1: Call kobject_put() when
 kobject_init_and_add() fails
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
References: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
 <20200326163813.21129.44280.stgit@awfm-01.aw.intel.com>
Message-ID: <da6e7401-de90-5786-51c1-142ea89c254b@intel.com>
Date:   Thu, 26 Mar 2020 12:40:57 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326163813.21129.44280.stgit@awfm-01.aw.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 3/26/2020 12:38 PM, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
> 
> When kobject_init_and_add() returns an error in the function
> hfi1_create_port_files(), the function kobject_put() is not called for
> the corresponding kobject, which potentially leads to memory leak.
> 
> This patch fixes the issue by calling kobject_put() even if
> kobject_init_and_add() fails.
> 
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

My bad, overzealous commit message clean up on my part, lost this:

Fixes: 7724105686e7 ("IB/hfi1: add driver files")

-Denny
