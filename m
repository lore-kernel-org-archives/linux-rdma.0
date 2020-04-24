Return-Path: <SRS0=Sij9=6I=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30BFC54FCB
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Apr 2020 12:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE7520767
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Apr 2020 12:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgDXM1d (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:27:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:52493 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgDXM1c (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 24 Apr 2020 08:27:32 -0400
IronPort-SDR: EPSalnQeqTm3TwbBU/Tm0Ut/Rbzet5NvuZJoFnk5KY9eLIEiJysnS7JAJecZC4htXOkNZXXBgr
 CsQpJeMK0JJQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 05:27:32 -0700
IronPort-SDR: XbVEO6zq7krMdtDZZR+WCvgw+ZhicXn7DixPwW6fKcFqbJ/tQ3NBYIgiuJLioTef0VeV2gRNaV
 hNa0Wqux2gBg==
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="430749751"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.203.197]) ([10.254.203.197])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 05:27:30 -0700
Subject: Re: [PATCH] IB/rdmavt: return proper error code
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20200423120434.19304-1-sudipm.mukherjee@gmail.com>
 <20200423140947.GX26002@ziepe.ca>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <6f4e01f9-7d9b-9087-9d4a-4b61dc73dacb@intel.com>
Date:   Fri, 24 Apr 2020 08:27:27 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423140947.GX26002@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 4/23/2020 10:09 AM, Jason Gunthorpe wrote:
> On Thu, Apr 23, 2020 at 01:04:34PM +0100, Sudip Mukherjee wrote:
>> The function rvt_create_mmap_info() can return either NULL or an error
>> in ERR_PTR(). Check properly for both the error type and return the
>> error code accordingly.
> 
> Please fix rvt_create_mmap_info to always return ERR_PTR, never null
> on failure.
> 
> Thanks,
> Jason
> 

Yes, that is a better approach.

-Denny
