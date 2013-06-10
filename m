From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Status of "ummunot" branch?
Date: Mon, 10 Jun 2013 15:56:26 +0000
Message-ID: <D554B471892C914E90E136467281724DAD695B50@MTLDAG01.mtl.com>
References: <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
 <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com> <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jeff Squyres (jsquyres)
> Sent: Monday, June 10, 2013 5:50 PM
> To: Jason Gunthorpe
> Cc: Haggai Eran; Or Gerlitz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Shachar Raindel
> Subject: Re: Status of "ummunot" branch?
> 
> On Jun 7, 2013, at 4:57 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> >> We talked about this at the MPI Forum this week; it doesn't seem like
> >> ODP fixes any MPI problems.
> >
> > ODP without 'register all address space' changes the nature of the
> > problem, and fixes only one problem.
> 
> I agree that pushing all registration issues out of the application and
> (somewhere) into the verbs stack would be a nice solution.
> 
> > You do need to cache registrations, and all the tuning parameters (how
> > much do I cache, how long do I hold it for, etc, etc) all still apply.
> >
> > What goes away (is fixed) is the need for intercepts and the need to
> > purge address space from the cache because the backing registration
> > has become non-coherent/invalid. Registrations are always
> > coherent/valid with ODP.
> 
> > This cache, and the associated optimization problem, can never go
> > away. With a 'register all of memory' semantic the cache can move into
> > the kernel, but the performance implication and overheads are all
> > still present, just migrated.
> 
> Good summary; and you corrected some of my mistakes -- thanks.
> 
> That being said, everyone I've talked to about ODP finds it very, very strange
> that the kernel would keep memory registrations around for memory that is
> no longer part of a process.  Not only does it lead to the "new memory is
> magically already registered" semantic that I find weird, it's just plain *odd*
> for the kernel to maintain state for something that doesn't exist any more.  It
> feels dirty.
> 
> Sidenote: I was just informed today that the current way MPI
> implementations implement registration cache coherence (glibc malloc
> hooks) has been deprecated and will be removed from glibc
> (http://sourceware.org/ml/libc-alpha/2011-05/msg00103.html).  This really
> puts on the pressure to find a new / proper solution.
> 
> >> What MPI wants is:
> >>
> >> 1. verbs for ummunotify-like functionality 2. non-blocking memory
> >> registration verbs; poll the cq to know when it has completed
> >
> > To me, ODP with an additional 'register all address space' semantic,
> > plus an asynchronous prefetch does both of these for you.
> >
> > 1. ummunotify functionality and caching is now in the kernel, under
> >   ODP. RDMA access to an 'all of memory' registration always does the
> >   right thing.
> 
> "Register all address space" is the moral equivalent of not having userspace
> registration, so let's talk about it in those terms.  Specifically, there's a subtle
> difference between:
> 
> a) telling verbs to register (0...2^64)
>    --> Which is weird because it tells verbs to register memory that isn't in my
> address space


Another way to look at it is "specify IO access permissions" for address space ranges.
This could be useful to implement a buffer pool to be used for a specific MR only, yet still map/unmap memory within this pool on the fly to optimize physical memory utilization.
In this case, you would provide smaller ranges than 2^64...


> b) telling verbs that the app doesn't want to handle registration
>    --> How that gets implemented is not important (from userspace's point of
> view) -- if the kernel chooses to implement that by registering non-existent
> memory, that's the kernel's problem
> 
> I guess I'm arguing that registering non-existent memory is not the Right
> Thing.
> 
> Regardless of what solution is devised for registered memory management
> (ummunotify, ODP, or something else), a non-blocking verb for registering
> memory would still be a Very Useful Thing.
> 
> --
> Jeff Squyres
> jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
> For corporate legal information go to:
> http://www.cisco.com/web/about/doing_business/legal/cri/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
