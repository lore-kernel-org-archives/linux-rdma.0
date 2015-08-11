From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/core: Make ib_dealloc_pd return void
Date: Tue, 11 Aug 2015 09:57:38 +0300
Message-ID: <55C99CE2.6030102@dev.mellanox.co.il>
References: <20150805203431.GB30271@obsidianresearch.com>
 <55C39A0E.6020008@dev.mellanox.co.il>
 <20150811055731.GD13314@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150811055731.GD13314-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/11/2015 8:57 AM, Jason Gunthorpe wrote:
> On Thu, Aug 06, 2015 at 08:31:58PM +0300, Sagi Grimberg wrote:
>
>> This looks generally good. Would it make sense to go the extra mile
>> here and just fixup ocrdma (the only driver that seems to be able to
>> fail) to WARN_ON() instead of propagating an error and make it go
>> away from the core?
>
> I've remarked to the ocrdma folks about fixing this in the past, I'm
> not sure where they are on that..

I was simply suggesting to move the (specific to ocrdma) WARN_ON() from
the core to ocrdma. The ocrdma folks can take care of that if they feel
like it.

>
> There are also a few other dealloc APIs (mr, etc) that need a similar
> treatment. I was planning to address the ULP side and driver side in
> two steps to keep things simpler.

mr deallocation can only fail if there are memory windows on it. I
don't know if I would bother changing it. Perhaps ULPs that don't use
windows (all at the moment) will knowingly ignore it and ULPs that will
use windows will be required to check it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
