From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 00/10] i40iw: Fixes and optimizations
Date: Fri, 9 Dec 2016 23:24:43 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB10AC5C2C@fmsmsx104.amr.corp.intel.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <13AA599688F47243B14FCFCCC2C803BB10AC5AA2@fmsmsx104.amr.corp.intel.com>
 <20161209183650.GB10830@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161209183650.GB10830-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

I followed your recommendation about github PR. 

When applying the patches to rdma-core, patch 08/10 V2 failed to apply, because it is removing a variable already removed:

-unsigned int i40iw_debug_level

This issue is fixed in my github branch. Please pull the patches from
 
https://github.com/tatyana-en/rdma-core.git

Starting with "i40iw: Optimize setting fragments" - commit 3c642b3f6477d0e4733802d863788d4aa30f55b0

Ending with " i40iw: Remove SQ size constraint" - commit 1ccbcd4e3c6630a43e9adc0fcc4e9659cd721440

Thank you,
Tatyana


-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org] 
Sent: Friday, December 09, 2016 12:37 PM
To: Nikolova, Tatyana E <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Subject: Re: [PATCH V2 00/10] i40iw: Fixes and optimizations

On Fri, Dec 09, 2016 at 06:33:30PM +0000, Nikolova, Tatyana E wrote:

> I am sorry I missed to specify rdma-core in the patch description for 
> the V2 series.  All ten patches in the series are rdma-core V2 
> patches.

Indeed, you may also wish to consider doing a github PR for this big series. I'm generally encouraging the providers maintainers to do this as it reduces the workload on Leon :)

I have no other comments on the series..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
