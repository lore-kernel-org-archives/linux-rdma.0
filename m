From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: rdma-core in Dabian
Date: Wed, 10 May 2017 13:47:20 -0500
Message-ID: <016d01d2c9bd$dae5f070$90b1d150$@opengridcomputing.com>
References: <20170507064349.GM22833@mtr-leonro.local> <1494351789.3752.5.camel@profitbricks.com> <20170509180517.GA9715@obsidianresearch.com> <1494408947.3739.2.camel@profitbricks.com> <20170510155005.GB1007@obsidianresearch.com> <20170510160201.GD1839@mtr-leonro.local> <20170510163341.GA25041@obsidianresearch.com> <004001d2c9ad$7a141f70$6e3c5e50$@opengridcomputing.com> <20170510165858.GG1839@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170510165858.GG1839-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Talat Batheesh' <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Noa Spanier' <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Wed, May 10, 2017 at 11:50:06AM -0500, Steve Wise wrote:
> > > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > >
> > > On Wed, May 10, 2017 at 07:02:01PM +0300, Leon Romanovsky wrote:
> > >
> > > > > I've been thinking we should patch the kernel to solve this problem
> > > > > instead of using this ugly userspace solution.
> > > >
> > > > Can it be related to the fact that mlx5 core calls to
> > > > request_module_nowait for mlx5_ib and chelsio doesn't do it?
> > >
> > > Yeah, maybe we should update chelsio kernel drivers instead of using
> > > these strange modprobe files...
> > >
> > > Steve?
> >
> > Under what criteria would cxgb4 want to request its Upper Layer Drivers
(ULDs)
> > to be loaded?  You wouldn't want to load the iwarp and iscsi drivers if they
> > aren't going to be used, would you?
> 
> If you don't want them, you will blacklist them. There is nothing wrong
> with ready-to-use approach.

Ok...

> 
> >
> >
> >
> > >
> > > > > Maybe Leon's team will try to tackle some of this? It is complicated,
> > > > > the RH scripts do quite a bit stuff :\
> > > >
> > > > I would be happy to help, but I'm not sure that I understand what should
> > > > be done :(
> > >
> > > I'm not totally clear either, TBH. The overall topic is to move files
> > > out of redhat/ and into the common directory. This requires removing
> > > the redhat-isms and making sure the redhat solution is what we really
> > > want upstream.
> > >
> > > eg it seems rdma.cxgb[3]4.sys.modprobe is probably best done by patching
> > > the kernel instead, not copying the modprobe files.
> > >
> > > rdma.kernel-init does:
> > >  - Load extra ULP modules
> > >     * /etc/rdma/rdma.conf is not appropriate for Debian
> > >     * 'TECH_PREVIEW' is a RedHat concept
> > >  - Obsolete mttr/errata stuff. This is in the kernel now (delete it)
> > >  - Yet another go at loading extra driver kernel modules (move to
> > >    kernel)
> > >  - Something about SRIOV (?)
> > >
> > > For ULP modules, I think we are loading too many by hand, again, the
> > > kernel really needs fixing to autoload our stuff on first use. So, I
> > > suggest a quick pass over that idea to see how much kernel code can be
> > > fixed up.
> > >
> > > So the stuff to move to common user space code might just be the port
> > > configuration and sriov? But someone needs to study this entire topic
> > > with a broad view including the kernel.
> > >
> > > Jason
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
