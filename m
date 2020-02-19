Return-Path: <SRS0=b7KD=4H=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B0FC34047
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 15:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA7A824654
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 15:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgBSPeH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:34:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:53448 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgBSPeH (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 19 Feb 2020 10:34:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 07:34:06 -0800
X-IronPort-AV: E=Sophos;i="5.70,459,1574150400"; 
   d="scan'208";a="229142853"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.204.151]) ([10.254.204.151])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 19 Feb 2020 07:34:05 -0800
Subject: Re: RDMA device renames and node description
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Honggang LI <honli@redhat.com>,
        Gal Pressman <galpress@amazon.com>
References: <5ae69feb-5543-b203-2f1b-df5fe3bdab2b@intel.com>
 <20200218140444.GB8816@unreal>
 <1fcc873b-3f67-2325-99cc-21d90edd2058@intel.com>
 <20200219071129.GD15239@unreal>
 <bea50739-918b-ae6f-5fac-f5642c56f1da@intel.com>
 <20200219144816.GM15239@unreal>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <4ebd9adb-7915-f699-4188-217c45c09e56@intel.com>
Date:   Wed, 19 Feb 2020 10:34:03 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200219144816.GM15239@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2/19/2020 9:48 AM, Leon Romanovsky wrote:
>>> At the end, OFED stacks behave like "mini-distros", so if they manage to
>>> handle it, distro should do the same.
>>   The difference there is to the distro the RDMA sub system is but one small
>> part. To OFED it is the sole focus. So I expect OFED stacks to be more agile
>> at handling this sort of thing.
> 
> I disagree about first part of this paragraph. All major distributions
> follow closely rdma-core and this ML.
> 

The distros do certainly have people that follow the list. What I'm 
saying is we shouldn't have relied on them to ensure there were no 
implications brought on by the default behavior change. Instead we as 
developers should have brought the node description impact to light more 
proactively vs being reactive.

-Denny
