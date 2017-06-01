From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/9] IB/core, rdmavt, hfi1: Send OPA cap_mask3
 in trap
Date: Thu, 1 Jun 2017 08:55:42 +0300
Message-ID: <20170601055542.GQ5406@mtr-leonro.local>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
 <20170526123536.8158.237.stgit@scvm10.sc.intel.com>
 <20170529161407.GB17751@mtr-leonro.local>
 <2fc7a7d6-9ba3-2365-45e3-946f56827dd9@intel.com>
 <20170531043235.GH5406@mtr-leonro.local>
 <20170531175821.GA29853@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8RsyD0KswhpoK73Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531175821.GA29853-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Henry, Michael N" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8RsyD0KswhpoK73Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 31, 2017 at 10:58:21AM -0700, Vishwanathapura, Niranjana wrote:
> On Wed, May 31, 2017 at 07:32:35AM +0300, Leon Romanovsky wrote:
> > On Tue, May 30, 2017 at 11:32:22AM -0700, Henry, Michael N wrote:
> > > On 5/29/2017 9:14 AM, Leon Romanovsky wrote:
> > > > On Fri, May 26, 2017 at 05:35:37AM -0700, Dennis Dalessandro wrote:
> > > > > From: Michael N. Henry <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > >
> > > > > Provide the ability for IB clients to modify the OPA specific
> > > > > capability mask and include this mask in the subsequent trap data.
> > > > >
> > > > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > > > > index 785e927..6c4f6da 100644
> > > > > --- a/include/rdma/ib_verbs.h
> > > > > +++ b/include/rdma/ib_verbs.h
> > > > > @@ -576,7 +576,8 @@ struct ib_device_modify {
> > > > >   enum ib_port_modify_flags {
> > > > >   	IB_PORT_SHUTDOWN		= 1,
> > > > >   	IB_PORT_INIT_TYPE		= (1<<2),
> > > > > -	IB_PORT_RESET_QKEY_CNTR		= (1<<3)
> > > > > +	IB_PORT_RESET_QKEY_CNTR		= (1<<3),
> > > > > +	IB_PORT_OPA_MASK_CHG		= (1<<4)
> > > > How will this flag be set?
> > > >
> > > This flag can be set as the port_modify_mask when calling ib_modify_port(..)
> >
> > My question is more general. I'm as a representative of these "IB
> > clients" would like to know when and why should I use this flag.
> >
>
> Hi,
> We have an OPA VNIC use case (patch coming up) to set/clear OPA capmask as
> below.
>
> pm.set/clear_port_cap_mask = OPA_CAP_MASK3_IsEthOnFabricSupported;
> ib_modify_port(hca, port, IB_PORT_OPA_MASK_CHG, &pm);
>
> This patch support such usecase and we want to get comments early (if any)
> for that, hence this patch.

The comment is pretty simple, please don't post patches which are not
backed up by actual usage.

Right now, we have IB_PORT_SHUTDOWN, IB_PORT_INIT_TYPE and
IB_PORT_RESET_QKEY_CNTR are not written in any place. We don't want to
see another one.

And semantic of usage are more than welcomed.

Thanks

>
> Niranjana
>

--8RsyD0KswhpoK73Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkvrF4ACgkQ5GN7iDZy
WKeJtQ/9HUO6qi9xJMSi+D055mrlszMEE3q7zk/VDkWz8bceoOt8kFRNIFUWd0r8
LOJ4cFdAPtVOAuhZke6DULMzDv3s5eQ9yKYdvq9cTPU5d3mfVbgyvF77giY2EDCU
EBH751ZN6TBmAJ73vhY+Sn2LFyocsY1ZVHUWHb82umDT0QUp9bFHuQDZOA56ldFH
JbOue5p8sXETWrgzNwVmKpWMoJ+h0LhT3T6J7cGWe5fA2Y4dxjmJBv7zIC2jffG1
K11PHcZDkat+GxWJS22Q1fFU2DWFhxVDKMALPliJ9mRZvuuyUdxM1so9rxQtg4y9
WsAjGFZ2AM68AS+Wr/AQ7/6Ly5wEGQ9uQ2ljiI8gEW2uk4xc879Rc0K8oS+hSs1x
eiH/ie88XfJ7ujgTxw+vVwyLtIrRXffP/KkeuUkr2NI4EpFM4NOVXNKbh3cYc5U7
5a6f/0VXWmQvKZKhDKUibe0iX2f3zcI7roSPJJMopGrP+XFs41OZC3nEENx3Wusg
a4cxScxcrjot6fJHSNGzhvAJbNgoEIVGSuwR4Z158FKtrBOBIeUu5iSRVMiGfRSZ
DC82C9GYuMnujHF4cSjgC9YosI06kAfT3VQjEtQ/zyPIOV1ZO6F7dT7QyME04U81
Cytsmr3t9WKB5WMLCkEpY5KaqvtRIcyWDZ6uSp1LICZZ9zQmvYQ=
=UXIB
-----END PGP SIGNATURE-----

--8RsyD0KswhpoK73Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
