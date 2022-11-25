Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56238C4332F
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Nov 2022 14:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiKYObR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 25 Nov 2022 09:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKYObR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 25 Nov 2022 09:31:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5094209B9;
        Fri, 25 Nov 2022 06:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669386673; x=1700922673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qDLD3fBqolvWdZw4+QW3UAeP3btXJS1HckNw0b9pvBk=;
  b=HJ7QA8LQSnXBKcnYnyMNFxfNZmTw756C4e1nxqpDh/Hz/jSqyC/QpLlR
   n7Re1vjundeTZ8gRIe8OcXaMK5FdSy4mC6/rsKW0yQ6iNqV5vmqKYDTUM
   oQ72zO0ihjRPefm75gQGaOOnms+9I6dsGOODeByKkCcItAYm1oztv7qKG
   aX/JzoOxuOuMeCS+sfIvO1ASyPJlDVXiyHnrBYyUgpa3geY9m3HfeUFZC
   2YsoPExpuSFKgBIHygo85ULoT7xyxKVlUI11tHPuXzBU5xCX2Z/jQztbc
   H9giXyF2Ag/WGQzGJCZWbhqSyQESJZ6CPshKq0+hCZ/frAZl7t/Vp7tck
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="315649430"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="315649430"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 06:31:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="817156468"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="817156468"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 25 Nov 2022 06:31:10 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oyZjQ-00HGM5-0j;
        Fri, 25 Nov 2022 16:31:08 +0200
Date:   Fri, 25 Nov 2022 16:31:07 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     bvanassche@acm.org, jgg@ziepe.ca, leon@kernel.org,
        dennis.dalessandro@cornelisnetworks.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        bart.vanassche@wdc.com, easwar.hariharan@intel.com
Subject: Re: [PATCH 1/2] RDMA/hfi1: Fix error return code in
 parse_platform_config()
Message-ID: <Y4DRqzSGtsqTpAhU@smile.fi.intel.com>
References: <1669377831-41386-1-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669377831-41386-1-git-send-email-wangyufen@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Nov 25, 2022 at 08:03:50PM +0800, Wang Yufen wrote:
> In the previous while loop, "ret" may be assigned zero. Therefore,
> "ret" needs to be assigned -EINVAL at the beginning of each loop.

...

>  	while (ptr < (u32 *)(dd->platform_config.data + file_length)) {
> +		ret = -EINVAL;
>  		header1 = *ptr;
>  		header2 = *(ptr + 1);
>  		if (header1 != ~header2) {

You may do it differently and simplify even existing code, i.e.

// The following two lines to add
bali_with_einval:
	ret = -EINVAL;
bail:
	memset(pcfgcache, 0, sizeof(struct platform_config_cache));
	return ret;

Then you convert all goto bail; to goto bail_with_einval; where it's
appropriate. And dropping some duplicative ret = -EINVAL; lines above.


-- 
With Best Regards,
Andy Shevchenko


