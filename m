From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [GIT PULL] pull request: linux-firmware: Add Intel OPA hfi1
 firmware
Date: Tue, 11 Aug 2015 16:25:57 -0600
Message-ID: <20150811222557.GA6293@obsidianresearch.com>
References: <20150811213205.GA28613@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150811213205.GA28613-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-firmware-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Sowa <david.sowa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Vogel <steve.vogel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 11, 2015 at 05:32:06PM -0400, ira.weiny wrote:
> Doug,
> 
> Please Pull:
> 
> git://github.com/weiny2/linux-firmware.git  master-hfi1-firmware
> 
> This is the first release of the Intel OPA hfi1 firmware required by the hfi1
> driver.

Um, I'm not a lawyer, but that license does not look OK for the
firmware repo.. At least I've never seen a redistributable license
with stuff like this:

 (1)	reproduce and execute the Software only for internal use with Intel Products, 
 including designing products for Intel Products,; this license does not include the 
 right to sublicense, and may be exercised only within Your facilities by Your 
 employees;

You should talk internally and ask why this needs to be different from
other Intel firmware blob licenses like i915 ..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
