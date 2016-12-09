From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 00/10] i40iw: Fixes and optimizations
Date: Fri, 9 Dec 2016 16:45:02 -0700
Message-ID: <20161209234502.GA27736@obsidianresearch.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <13AA599688F47243B14FCFCCC2C803BB10AC5AA2@fmsmsx104.amr.corp.intel.com>
 <20161209183650.GB10830@obsidianresearch.com>
 <13AA599688F47243B14FCFCCC2C803BB10AC5C2C@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13AA599688F47243B14FCFCCC2C803BB10AC5C2C-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 09, 2016 at 11:24:43PM +0000, Nikolova, Tatyana E wrote:

> I followed your recommendation about github PR. 
> 
> When applying the patches to rdma-core, patch 08/10 V2 failed to
> apply, because it is removing a variable already removed:
> 
> -unsigned int i40iw_debug_level

Yes, I noticed that too..

> This issue is fixed in my github branch. Please pull the patches from

> https://github.com/tatyana-en/rdma-core.git

If you click on the 'Create Pull Request' button in the github GUI
on your repository then your patches will show up here:

https://github.com/linux-rdma/rdma-core/pulls

And travisci will run automatically on your series which is one less
step for Leon&Doug.

I also recommend in future to put a series onto branches in your
repository, eg from your local machine do:

 git push -f github master:fixes1

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
