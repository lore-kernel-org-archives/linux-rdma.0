From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
Date: Thu, 22 Dec 2016 13:28:32 -0700
Message-ID: <20161222202832.GA10732@obsidianresearch.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221234014.GA13538@obsidianresearch.com>
 <0d77c962-607b-1e05-4fbf-41195446128d@redhat.com>
 <20161222173807.GA15461@obsidianresearch.com>
 <e300b2ab-c963-d755-895d-29c8a6dbdc94@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e300b2ab-c963-d755-895d-29c8a6dbdc94-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 22, 2016 at 01:17:52PM -0500, Doug Ledford wrote:
> On 12/22/2016 12:38 PM, Jason Gunthorpe wrote:
> > On Thu, Dec 22, 2016 at 02:32:07AM -0500, Jarod Wilson wrote:
> 
> > Yes.. Somehow libfabric is doing this:
> > 
> > https://github.com/ofiwg/libfabric/releases
> > 
> > It looks like they produced the .tar.gz by hand and then uploaded it
> > again as an attached release file?
> > 
> > Should we do this too, Doug?
> 
> I was going to try changing the tag format on the next tag to get the
> desired result.  So, instead of v12-rc4 or v12, rdma-core-12-rc4 or just
> rdma-core-12.

I don't know enough about github to comment..

The advantage of the libfabric approach is that the tar.gz is produced
once and never changed so we can provide the SHA2, while I'm not
certain the github .tar.gz link is bit-for-bit content-stable?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
