From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Wed, 21 Sep 2016 13:21:29 -0400
Message-ID: <20160921172129.GB27837@phlsvsds.ph.intel.com>
References: <20160823185441.GA1233@obsidianresearch.com> <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com> <20160825173916.GC20612@obsidianresearch.com> <20160825195246.GI1916@redhat.com> <20160825201306.GA5421@obsidianresearch.com> <8ef70f6c-e26d-191d-9a9a-2e0bf47fb227@redhat.com> <20160828132804.GN594@leon.nu> <20160828183627.GC12783@obsidianresearch.com> <20160829062918.GR594@leon.nu> <fcfcff11-fe5c-6cf5-3575-52da4b9241ed@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fcfcff11-fe5c-6cf5-3575-52da4b9241ed-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Unfortunataely, what you speak of is not really realistic, both for the
> reasons I've cited and a whole litany of other reasons I didn't mention.
> 
> But I don't think Jason jumped in to work on this because of the goal of
> making Red Hat's life easier in packaging up the separate code.  He did
> it for upstream related reasons:
> 
> 1) Put all of the providers and libibverbs in one place so that they can
> be kept in sync.  This allows us to do the exact same thing we do with
> the kernel in user space.  Namely, if someone makes an incompatible
> change in the libibverbs core, we can require that they fix up all
> providers in the same patch series.  This works rather well for the
> kernel, and it would be good to bring that policy to user space too.
> 
> 2) Put all of the kernel interacting libraries in one place.  This makes
> it easier to perform the write->ioctl conversion we've been discussing
> as there would be only one larger package that needs to be updated for
> any given kernel ioctl update.
> 
> 3) Bring librdmacm and libibverbs together so that the occasional
> incompatible update between the two is not an issue any more.
> 
> 4) Create an easier to build/install package for developers to use.
> 
> Those are the issues we should be discussing the relative merits of in
> order to determine whether this work should be adopted.
> 

I see one more benefit here.  This should give us an opportunity to consolidate
and clarify the interface to the _users_ of these libraries.  For example it
has always bothered me is there are about 3 places that a PathRecord struct was
defined.  To be clear I think PathRecords should be hidden from the user but in
general keeping a clean interface to the user between librdmacm, libibverbs,
and to a lesser extent (or maybe not at all) libibumad would be very nice for
the end user.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
