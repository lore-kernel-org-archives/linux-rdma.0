From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 20:30:35 +0300
Message-ID: <20160415173035.GC10689@leon.nu>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160415040126.GB10689@leon.nu>
 <20160415161754.GA21549@rhel>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415161754.GA21549@rhel>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2016 at 12:17:55PM -0400, Ira Weiny wrote:
> On Fri, Apr 15, 2016 at 07:01:26AM +0300, Leon Romanovsky wrote:
> > On Thu, Apr 14, 2016 at 01:48:31PM -0400, Ira Weiny wrote:
> > > On Thu, Apr 14, 2016 at 10:45:50AM -0600, Jason Gunthorpe wrote:
> > > > On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
> > > > > This patch series removes the write() interface for user access i=
n favor of an
> > > > > ioctl() based approach. This is in response to the complaint that=
 we had
> > > > > different handlers for write() and writev() doing different thing=
s and expecting
> > > > > different types of data. See:
> > > >=20
> > > > I think we should wait on applying these patches until we globally =
sort out
> > > > what to do with the rdma uapi.
> > > >=20
> > > > It just doesn't make alot of sense for drivers to have their own pe=
rsonal
> > > > char devices. :(
> > >=20
> > > I'm afraid I have to disagree at this time.  Someday we may have "1 c=
har device
> > > to rule them all" but right now we don't have any line of sight to th=
at
> > > solution.  It may be _years_ before we can agree to the semantics whi=
ch will
> > > work for all high speed, kernel bypass, rdma, low latency, network de=
vices.
> >=20
> > You didn't ever try to come and work on the solution. We talked about
> > finite time frame (_months_) which is doable based on knowledge that us=
er
> > space parts are developed by the same companies and all our future chan=
ges
> > will be in one subsystem.
>=20
> How can you say that I am not working on a solution?
>=20
> We spent most of last week discussing possible solutions and I am in supp=
ort of
> a more common core.

Great, did you show it to other RDMA stakeholders except Intel?
I saw nothing posted on ML or proposed for initial discussion, which
will be held in the next week or two.

It is a great opportunity to you guys to start and respect Linux kernel
collaboration development model and to stop to try to do it in your
corporate way.

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXESU7AAoJEORje4g2clinmVkP/jGDBvARho812IwArhXVjV0W
OY4+XLkZ3LgMuMz+jpp9QxJkLEG6f7IZx0+YBGjI5EtxUHlF0OUPQRI9eq4UFTI2
qQwAvtkvUBgUdAqCJfdlgpuNHlv/xafiACc3CTl1RfSHXjjAZ7DOn3XgKzuyz6YB
wzbnGlS1GNcsnVzM/HvxLj4sH8ag7T+A8e6wh+PpSbZoTRjbJ9+vlg3SvW8CSufs
H4DySgPh6b6ahRKUDTBbF6Sv8v9jaHq25vf9dF2aZd/KnijotKKBHAmwSWBomLEA
zGhOACmOB/fki0fr8aoCFYTg1RWmT2jQRn2dTiI8K3PAPTgnXGM1ZaHfl/LGJu0q
2TfSHvA649TGEojIHsejv76Xt7yLvq0NMG9qDWzOSAmWaa7ZCLeuaW8S1SxqiopT
xVheJe2E28R0iLxIx30SaSVMGUfvawlLblcAQJQ07ppjohrPZbiEiPPiHdROM3PH
2Xogm8G7A31yDUMZ7EHKJ92u+px2kB32fE0gcZXuR1Wja0L3DR55tGULDeAFlo3A
8OxZGU1Ik8Ue8n/EiAjwROLD9lNxirB02ipM1k0OZRN/Unhky7FRw6HEm0HEassf
JjthoyxM3UZTLRmHstfPixHa5xlu+v26uYCB414SvSYozMBN/ydFQpxo35pwsFdx
s9F6wdULYQqvUcHRX18K
=bT+E
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
