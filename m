From: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 0/4] ibacm: acmp retry issues
Date: Tue, 14 Nov 2017 19:10:45 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E86639F0C279D@FMSMSX108.amr.corp.intel.com>
References: <20171114164006.24557.72093.stgit@phlsvslse11.ph.intel.com>
 <20171114184603.GG18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114184603.GG18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Tuesday, November 14, 2017 1:46 PM
> To: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH v3 0/4] ibacm: acmp retry issues
> 
> On Tue, Nov 14, 2017 at 11:43:00AM -0500, Michael J. Ruhl wrote:
> > While testing the retry mechanism for the acmp provider, I observed
> > that the retry event_wait() did not appear to be working correctly.
> > After studying the issue a bit more, I discovered that there were a
> > couple of issues.
> >
> > This patch set addresses those issues.
> >
> > v2 - added patch for MONOTONIC time base
> > v3 - Updated and cleaned various type cast issues
> >
> > ---
> >
> > Michael J. Ruhl (4):
> >       ibacm: Fix an incorrect expiration check for the retry timer
> >       ibacm: Calculate correct tv_nsec value in event_wait()
> >       ibacm: Fix a retry loop calculation race condition
> >       ibacm: Use MONOTONIC time base to avoid timer expiration issues
> >
> >
> >  ibacm/linux/osd.h          |   25 ++++++++++++++++---------
> >  ibacm/prov/acmp/src/acmp.c |   12 +++++++-----
> >  2 files changed, 23 insertions(+), 14 deletions(-)
> >
> 
> Can you please use [PATCH rdma-core ..] format for rdma-core patches?

Hi Leon,

Yes, I will reformat.

Is there a place to put patch set version information?  i.e [PATCH rdma-core v4, x/y]?  (should I just drop it for this patch set?)

Thanks,

Mike
 
> We are using patchworks to handle queue and it is so handy to filter
> patches in such way:
> https://patchwork.kernel.org/project/linux-rdma/list/?q=rdma-core
> 
> Thanks
> 
> > --
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
