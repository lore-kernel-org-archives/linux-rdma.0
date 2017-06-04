From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Sun, 4 Jun 2017 08:31:23 +0300
Message-ID: <20170604053123.GC6868@mtr-leonro.local>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <20170601041022.GM5406@mtr-leonro.local>
 <20170602162103.GA12468@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170602162103.GA12468-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 02, 2017 at 11:21:03AM -0500, Chien Tin Tung wrote:
> On Thu, Jun 01, 2017 at 07:10:22AM +0300, Leon Romanovsky wrote:
> > On Wed, May 31, 2017 at 12:42:45PM -0500, Shiraz Saleem wrote:
> > > On Wed, May 31, 2017 at 07:04:37AM +0300, Leon Romanovsky wrote:
> > > > On Tue, May 30, 2017 at 04:24:31PM -0500, Shiraz Saleem wrote:
> > > > > On Mon, May 29, 2017 at 11:24:23AM +0300, Leon Romanovsky wrote:
> > > > > > From: Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>
> > > > > >
> > >
> > > > 3. The commit cea05eadde made libnl library (basic block of user-space part of netlink)
> > > > to work incorrectly and not according to _blocking/_nonblocking semantics.
> > >
> > > How? Is libnl calling ibnl_unicast? As far we can understand ibnl_unicast is only called
> > > by portmapper kernel code.
> >
> > Yes, libnl is calling to ibnl_unicast() and this is why it brought my
> > attention to regression caused by commit which I'm reverting.
> >
> > Bottom-up flow:
> > 						ibnl_unicast
> > 					send_nlmsg_done
> > 				iwpm_send_mapinfo
> > 			iwpm_mapping_info_cb
> > 		[RDMA_NL_IWPM_MAPINFO] = {.dump = iwpm_mapping_info_cb}
> > 	ibnl_rcv_msg
> > netlink_rcv_skb(skb, &ibnl_rcv_msg);
> > -----
> > libnl:
> > nl_recvmsgs()
>
> Assuming your stack trace is correct, it is showing the normal use case of ibnl_unicate()
> by portmapper from the iWARP side.  I'm still waiting on evidence of this patch breaking
> rest of RDMA as you so claimed.

I think that I understand the differences between our views on the subject. The main
difference is if iWARP portmapper is part of large ecosystem (my view) or some
standalone feature (your view).

I see iWARP as an integral part of IB core and I do expect that all consumers of
NETLINK_RDMA will be complied to libnl library and work in similar manner to whole
network stack. I do expect that newcomer won't learn in hard way that
his non-blocking calls to netdev NETLINKs and NETLINK_RDMA work except
for iWARP portmapper part.

>
> > > > 4. Reverting is a common practice in Linux kernel. Patches are not
> > > > carved in stones.
> > >
> > > Reverting a patch that's introduced during RC cycle is fine, introducing
> > > regression is NOT and that is what you are doing by simply proposing to revert
> > > this patch.  Reverting this patch will introduce a REGRESSION error with respect to
> > > port mapping functionality for all iWARP vendors.
> >
> > Interesting and how did all these iWARP vendors survive before your
> > patch?
>
> We are all still here. :-)  But if we let you simply revert a patch that fixes portmapper
> for all iWARP vendors then we may be not.

It is not really fixing but hiding, and it is not related to vendors which want
or don't want, it is related to the community and to the right infrastructure for
everyone, so everyone will benefit from it.

>
> > > > 5. I proposed a solution -> go and fix your user space program.
> > > This is a kernel patch you are trying to revert, you are breaking existing
> > > kernel functionality.  Nothing to do with user space.
>
> Here is a better solution.  Post a patch to the kernel that will not introduce a regression
> and fix whatever the probelm you think there is, then I will personally review the patch.

You got proposal, which is not related to kernel.

>
> Chien

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkzmyoACgkQ5GN7iDZy
WKdoNw/9H2+He4QWqv9bv6PYWS19uOL70hDA24tb4z4Whdc9JPqcDAt8SgjS9dyG
FR+3H/bmHRZ2lRTGAyYSSgEuqeZPBM665m0q6QsyGtW+PWFc3iVo3bJmc+5bDB9L
FGJznLzooG5PvynEte5KdNyDRkg8wHlbyBGojXsgpan+6V9WdMDk+SzbavTdHmx8
zKZOKaxDOHzU1rWmq7C5Mm2BiAJfPTe6XVDdi5DUy9bHqqcCaEHwSAkJ+4DLolSz
v+Db3MA5cN6lAEGfbHUlLUbUoHa+eS6XMx08GcH20BIg4piGeBf48aRo/KPbG1ks
fnyDyWIjZ/tIF4l0UNTb/0rTa8wT+Z2AL20KT5RtYHrCF5QRvlvTI7AWul83zHdm
vIuWNkhz1Rc88TRSGb78DvtbeIOfEh7DsqIwdq8c3VxkEauUWs6OsZvYl5Z+cbe4
fPP9DFCGUkY1zVpTendnJI4vTTPBO9JU9siKRo3hE/4uetFjd8e9hm4XtnsD1Ix3
CD92zr6nfulNcD6byrEOnuuZCREkSSIRB0cmUikvLgm+5xi3WrIW2RYBQkdoOEmx
RJCFtnUHNnfQDs9dgiJYEP90FaWeuRnR16r5iu0l7Xtg3ybyNj56J3X0kyuy6vI8
twx5xkJuadL36oN0s194VIOGTwJj8el7cOrUN5wn8wxZCEBm9nk=
=0LcQ
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
