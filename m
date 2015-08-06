From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/core: Make ib_dealloc_pd return void
Date: Thu, 6 Aug 2015 20:31:58 +0300
Message-ID: <55C39A0E.6020008@dev.mellanox.co.il>
References: <20150805203431.GB30271@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150805203431.GB30271-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/5/2015 11:34 PM, Jason Gunthorpe wrote:
> The majority of callers never check the return value, and even if they
> did, they can't do anything about a failure.
>
> All possible failure cases represent a bug in the caller, so just
> WARN_ON inside the function instead.
>
> This fixes a few random errors:
>   net/rd/iw.c infinite loops while it fails. (racing with EBUSY?)
>
> This also lays the ground work to get rid of error return from the
> drivers. Most drivers do not error, the few that do are broken since
> it cannot be handled.
>
> Since uverbs can legitimately make use of EBUSY, open code the
> check.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Hi Jason,

This looks generally good. Would it make sense to go the extra mile
here and just fixup ocrdma (the only driver that seems to be able to
fail) to WARN_ON() instead of propagating an error and make it go
away from the core?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
