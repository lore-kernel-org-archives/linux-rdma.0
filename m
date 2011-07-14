From: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Re: [RFC v2] [OFED] libibverbs: Support both OFED verbs and ibverbs
Date: Thu, 14 Jul 2011 09:39:31 -0400 (EDT)
Message-ID: <Pine.GSO.4.40.1107140929480.314-100000@xi.cse.ohio-state.edu>
References: <FD32F2C0-80E1-4F66-9613-0BB7A604BB12@cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FD32F2C0-80E1-4F66-9613-0BB7A604BB12-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean,

Both MVAPICH1 and MVAPICH2 have XRC support for many years and are being
used by many large-scale production clusters.

For MVAPICH1, this support is available in both the standard Gen2
interface and the Hybrid (UD-RC/XRC) interface.

>From MVAPICH1 user guide (sec 4.4.1), you can find the following:

"eXtended Reliable Connnection Support (XRC): By default this support is
compiled in to allow the usage of the new scalable XRC transport of
InfiniBand. OFED 1.3 or later is required. If using an older version, then
remove the -DXRC from the CFLAGS variable."

The runtime flag is VIADEV_USE_XRC

Class: Run Time
Applicable device(s): Gen2
When MVAPICH is compiled with the XRC CFLAGS, this parameter enables use
of the XRC transport of InfiniBand available on certain adapters. Enabling
XRC automatically enables Shared Receive Queue and on-demand connection
management.

The hybrid (UD-RC/XRC) interface automatically selects the appropriate
interface at run time.

Not sure which interface (gen2 or hybrid you are using). If you are using
the gen2 interface, looks like you are not using the correct runtime flag
to enable XRC with MVAPICH1.

Thanks,

DK


On Thu, 14 Jul 2011, Jeff Squyres wrote:

> Sean pinged me last night about XRC in Open MPI last night (note that I am no longer on the linux-rdma list).
>
> Open MPI uses XRC, but in a non-default manner -- the user has to specifically ask for it at run time.
>
>
> On Jul 14, 2011, at 9:13 AM, Jack Morgenstein wrote:
>
> > Hi Sean,
> >
> > I am pleased that you are putting in the effort to enable the existing OFED user base to continue using its
> > code without changes to the XRC calls.
> >
> > Regarding XRC and MPI, see below.
> >
> > On Wednesday 13 July 2011 20:21, Hefty, Sean wrote:
> >> I was able to build and run mvapich2 successfully against libibverbs with
> >> this patch applied on top of the current XRC patches.  (The XRC patches are
> >> still undergoing work.)  I built mvapich2 using the following configure options:
> >>
> >> --with-rdma=gen2 CFLAGS=-DOFED_VERBS
> >> and
> >> --with-rdma=gen2 CFLAGS='-DOFED_VERBS -D_ENABLE_XRC_
> >>
> >> It didn't appear that mvapichs ever used XRC
> >>
> > You are correct, mvapich does not use XRC.
> > openMPI uses XRC, so hopefully you can use openMPI to test out your XRC stuff.
> >
> > You can contact Jeff Squyres for details/help.
> >
> > In the meantime, I include the following from the ewg list:
> > =============================================================
> > On 11/08/2010 08:06 PM, Jeff Squyres wrote:
> >> Steve pinged me on IM this morning and told me that you want OMPI v1.4.3 for the next OFED release.  I just logged into www.openfabrics.org
> >> and apparently the server has changed -- my entire $HOME is empty.
> >>
> >> Where do you want me to put the new OMPI SRPM?  Alternatively, anyone can grab the SRPM from the URL below
> >> -- there's nothing special about the SRPM for OpenFabrics that's not already in our community SRPM:
> >>
> >>     http://www.open-mpi.org/software/ompi/v1.4/
> >>
> >
> > Hi Jeff,
> > The place for the Open MPI on the new server is under:
> > /var/www/openfabrics.org/downloads/openmpi/   (http://www.openfabrics.org/downloads/openmpi/)
> >
> > I updated Open MPI version there to v1.4.3.
> >
> > Regards,
> > Vladimir
> > ==========================================================
> >
> > -Jack
>
>
> --
> Jeff Squyres
> jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
> For corporate legal information go to:
> http://www.cisco.com/web/about/doing_business/legal/cri/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
