From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] IB/core,rdmavt,hfi1,opa-vnic: Send OPA cap_mask3 in
 trap
Date: Mon, 5 Jun 2017 09:17:55 +0300
Message-ID: <20170605061755.GI6868@mtr-leonro.local>
References: <1496361842-58389-1-git-send-email-niranjana.vishwanathapura@intel.com>
 <20170604164600.GE6868@mtr-leonro.local>
 <20170605061321.GA62566@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ISKrrfpKsPiF35CV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605061321.GA62566-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Michael N. Henry" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ISKrrfpKsPiF35CV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 04, 2017 at 11:13:21PM -0700, Vishwanathapura, Niranjana wrote:
> On Sun, Jun 04, 2017 at 07:46:00PM +0300, Leon Romanovsky wrote:
> > On Thu, Jun 01, 2017 at 05:04:02PM -0700, Vishwanathapura, Niranjana wrote:
> > > --- a/drivers/infiniband/hw/hfi1/mad.c
> > > +++ b/drivers/infiniband/hw/hfi1/mad.c
> > > @@ -260,6 +260,7 @@ void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num)
> > >  	data.issuer_lid = cpu_to_be32(lid);
> > >  	data.ntc_144.lid = data.issuer_lid;
> > >  	data.ntc_144.new_cap_mask = cpu_to_be32(ibp->rvp.port_cap_flags);
> > > +	data.ntc_144.cap_mask3 = cpu_to_be16(ibp->rvp.port_cap3_flags);
> > >
> > >  	send_trap(ibp, &data, sizeof(data));
> > >  }
> > > @@ -704,11 +705,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
> > >  	buffer_units |= (dd->vl15_init << 11) & OPA_PI_MASK_BUF_UNIT_VL15_INIT;
> > >  	pi->buffer_units = cpu_to_be32(buffer_units);
> > >
> > > -	pi->opa_cap_mask = cpu_to_be16(OPA_CAP_MASK3_IsSharedSpaceSupported |
> > > -				       OPA_CAP_MASK3_IsEthOnFabricSupported);
> > > -	/* Driver does not support mcast/collective configuration */
> > > -	pi->opa_cap_mask &=
> > > -		cpu_to_be16(~OPA_CAP_MASK3_IsAddrRangeConfigSupported);
> > > +	pi->opa_cap_mask = cpu_to_be16(ibp->rvp.port_cap3_flags);
> > >  	pi->collectivemask_multicastmask = ((HFI1_COLLECTIVE_NR & 0x7)
> > >  					    << 3 | (HFI1_MCAST_NR & 0x7));
> > >
> > > diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
> > > index 5aa3fd1..a4e2506 100644
> > > --- a/drivers/infiniband/hw/hfi1/mad.h
> > > +++ b/drivers/infiniband/hw/hfi1/mad.h
> > > @@ -115,7 +115,7 @@ struct opa_mad_notice_attr {
> > >  			__be32	lid;		/* LID where change occurred */
> > >  			__be32	new_cap_mask;	/* new capability mask */
> > >  			__be16	reserved2;
> > > -			__be16	cap_mask;
> > > +			__be16	cap_mask3;
> >
> > Did I miss the usage of that cap_mask3 field?
> >
>
> It is being set in mad.c above in this patch before sending the trap.

Yes, thanks, I missed it.

At least, we will have one user who writes enum from this ib_port_modify_flags.

Thanks

>
> Niranjana
>

--ISKrrfpKsPiF35CV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk095IACgkQ5GN7iDZy
WKcn3A//ZXCKWcE0T9oxBwX+tkrAdJ/b0gsCSptJriHrCrvQjHiBopEnnSHudASP
1QpbVjXB1OdGYFszYzMP1gdnwHx7yLOrHR2AWXpCszcl0hDI9RzMLU5yewt3wKmq
fAMwFI+laTDeVK6DL7QKnvXIhP1bZQCsqaLWSp1XQlu8UqD3ol4hSbw+2sSwZGOv
7AzhRyc9Dr7I7XEPnnJCqxSctu0VGX0kMqcVwSqKaDbU1yGR2O9MOgR5cV2LIjO9
C/UWCVuEL0WHbw88RSHGU7SK1o2UWhsY5RBhlMguISu1ivelOt9aJrtrWc7sbpAK
2XFJLhETgAQS2860lZ0eocU9f9yqYGqRxASTxwhVFOVmEESZn/VEEFipWRjiZiw6
yf8iG+RJBcWR0RJRooiTn1NLWY/W8xosUiitbicpjxTKWf5RRslGLvFNAIYnw6hw
p7cGdS/dRErUtuOqhMNHeR1D1R9dADZLs/R6ZAHGB9UsTcu65oizvkQgxjXIpDND
IpPvc0nzcCv4LRch1ND5BuSrwvhidl3Srrt1EE3QCfKCcDpLdw8tKaGRGbVwr0lx
rvjjFmmMS5lsy4ptyu17NRpsQ9igwuSY8HmeTwcrdgYdv6Z4nzX9EAC6xMYuB1Fr
SEbKp/o6OIlA3n4CSK1cQzUJ2crBXuxuKPG/95UurtEmwLtg3Sk=
=IZm6
-----END PGP SIGNATURE-----

--ISKrrfpKsPiF35CV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
