From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Tue, 25 Aug 2015 10:24:11 -0600
Message-ID: <20150825162411.GB4425@obsidianresearch.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DC667A.30208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DC667A.30208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 25, 2015 at 08:58:34AM -0400, Hal Rosenstock wrote:
> On 8/21/2015 7:34 PM, Jason Gunthorpe wrote:
> > Even though we don't expect the group to be created by the SM we
> > sill need to provide all the parameters to force the SM to validate
> > they are correct.
> 
> Out of curiosity, has it been observed that there was inconsistency in
> these additional IPoIB parameters between broadcast and non broadcast
> groups on client side or is this just to be defensive to make sure this
> does not occur ?

Not that I've seen. This is one half a code clean up, one half
better following the spec..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
