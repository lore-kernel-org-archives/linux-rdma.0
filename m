From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Thu, 4 Jun 2015 10:47:59 -0600
Message-ID: <20150604164759.GC27699@obsidianresearch.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433098827.114391.179.camel@redhat.com>
 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
 <1433157904.114391.188.camel@redhat.com>
 <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com>
 <20150602180844.GD17776@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE4F16@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE4F16-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 04, 2015 at 04:17:35PM +0000, Hefty, Sean wrote:
> > No, if they followed (I didn't check yes) the extension scheme then the
> > poll call is
> > 
> >  struct ibv_wc_ex wcs[num_wcs]
> >  ibv_poll_wc_ex(&wcs,num_wcs,sizeof(wcs[0]));
> > 
> > And the drivers decide what to do based on the 3rd argument, which is
> > essentially the ABI version.
> 
> As a couple of options:
> 
> You could add a 'completion format' field to the cq attribute
> structure, which would allow poll to cast to a specific structure.

Subtle, and tricky to use.. But sure..

> If we wanted to go with Doug's earlier idea, you could add a
> 'provider context' field to the wc.  This would allow calling back
> into the provider to retrieve more data.  Though, this concept would
> be racy if other completions can overwrite whatever data was trying
> to be retrieved.

Right, in the model we have where poll advances the HW completion
queue, that is not straightforward at all.

Can you share what the libfabric change would look like to add a
timestamp field to the completion? That might be informative,
libfabric is also consuming the kernel UAPI.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
