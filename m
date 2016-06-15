From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 01/13] IB/core: Add get FW version string to the core
Date: Wed, 15 Jun 2016 10:51:06 -0600
Message-ID: <20160615165106.GA10256@obsidianresearch.com>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com>
 <1465971728-24104-2-git-send-email-ira.weiny@intel.com>
 <20160615064008.GS5408@leon.nu>
 <20160615152048.GB8690@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160615152048.GB8690-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 15, 2016 at 11:20:49AM -0400, ira.weiny wrote:
> The default here is that a device does not provide a firmware string.  In that
> case the assumption is that there is no firmware.  Hence the empty string.  I
> don't think that reporting 0's or F's are appropriate if a device does not have
> firmware.
> 
> In the cases you speak of I would expect the device to supply the firmware
> function and report all 0s or all Fs for whatever version that may represent.
> (I'm assuming that would be some sort of debug or unreleased firmware...)
> 
> I could just as well done something like.
> 
> snprintf(str, str_len, "<none>");

Just don't provide a 'fw' sysfs file at all if the driver cannot
support it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
