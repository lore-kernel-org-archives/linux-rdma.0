From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 1 Sep 2016 22:04:12 -0400
Message-ID: <20160902020411.GD23742@phlsvsds.ph.intel.com>
References: <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com> <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il> <20160828182715.GA12783@obsidianresearch.com> <004e01d20203$156edc30$404c9490$@opengridcomputing.com> <20160829161902.GB23557@obsidianresearch.com> <20160830060842.GJ594@leon.nu> <9C6B67F36DCAFC479B1CF6A967258A8C7DE04100@ORSMSX115.amr.corp.intel.com> <20160831200336.GA4134@obsidianresearch.com> <20160901152920.GA23742@phlsvsds.ph.intel.com> <20160901170955.GA19982@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160901170955.GA19982-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 11:09:55AM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 01, 2016 at 11:29:21AM -0400, ira.weiny wrote:
> 
> > > Erm, but we already have a mess. AFAIK Mellanox and Intel both use
> > > OFED derivatives as their main means to deliver fixes to customers
> > > that both entirely replace the distro stack and completely conflict
> > > with each other.
> > 
> > OPA's "delta install" is _not_ based on OFED and installs only the bits which
> > are needed beyond what is in the distro.  Many of those changes already appear
> > in upstream repos which have not made it into the specific distro version.  As
> > things are accepted we drop those bits from our install.  This has been our
> > policy for some time and if you look at our IFS download you can see that the
> > packages which get installed for newer distros like 7.2 are smaller than
> > previous versions.
> 
> Cool, I am behind the times on that I guess.
> 
> However, the my point remains, it still clashes with what MOFED does,
> and the idea of two vendors not stomping on each other is still
> ficitional.

How does it conflict with MOFED if we do _not_ change libmlx*, libibumad,
librdmacm, libibverbs, and only add an updated hfi1.ko?

> 
> > To some extent this supports Woody's position.  libhfi1verbs is being used by
> > many customers because we can supply it without breaking the standard
> > libibverbs install.  NOTE in Fedora, RHEL, SLES, and others we _do_ _not_
> > update libibverbs.  Thus keeping the standard distro support intact for other
> > vendors hardware.
> 
> Well only in the sense that you are on a path that makes it hard to get
> into the distros thus requiring you jump through hoops to distribute
> your software..

I'm not sure I understand how we are on a path which makes it hard to get into
the distros?

> 
> Lets focus on the actual problem :)
> 
> > > > 2.) Allow a vendor the ability to distribute their library package
> > > > separately from the bundled package.
> > > 
> > > There is nothing stoping this, it is trivial for the vendor to make a
> > > .spec file for rdma-plumbing that just produces a rpm with the single
> > > vendor provider (after doing the full build).
> > > 
> > > If you really want an example I will show you.
> > 
> > That could be an alternative.
> > 
> > > 
> > > > 3.) Allow the ability for a vendor to distribute an update package
> > > > that just contains their library code to replace the version of that
> > > > code that is in the bundled package. I think that OFI, for example,
> > > > has something like this to avoid this kind of mess.
> > > 
> > > Certainly, we can make this even easier as well. Mainly what is needed
> > > is some way for the vendor to drop in a override .driver file in
> > > /etc/ibverbs.d/
> > > 
> > > It would not be hard to make a patch that does that, if that is all it
> > > takes to alleviate your concern I can add it to the todo list.
> > 
> > Agreed.  FWIW I would just add such external updates to an "updates" directory
> > so that users can easily see that something extra was installed.  But this is a
> > minor point.
> 
> I'll write a patch to enable 'run from build' in a way which should
> make this even more straight forward.

Sounds good...

Ira

> 
> However, things are already fine today, you just drop your driver in
> /opt/intel-opa/lib/libhfi1.so and customize
> /etc/libverbs/hfi1verbs.driver with an absolute path to the .so (I
> wrote the absolute path patch for this years ago for exactly this
> reason)
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
