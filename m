From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] IB/CM: Create appropriate path records
 when handling CM request
Date: Tue, 16 May 2017 09:08:52 +0300
Message-ID: <20170516060852.GO3616@mtr-leonro.local>
References: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458598-6911-3-git-send-email-dasaratharaman.chandramouli@intel.com>
 <20170513113936.GM3616@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB11DB23@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ijywFOGgtBfiIjQx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB11DB23-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ijywFOGgtBfiIjQx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 05:44:54PM +0000, Hefty, Sean wrote:
> > > +			if (ib_is_opa_gid(&req_msg->primary_local_gid) &&
> > > +			    rdma_cap_opa_ah(work->port->cm_dev->ib_device,
> > > +					    work->port->port_num))
> >
> > Why isn't ib_is_opa_gid enough?
>
> It may be in reality, but that implies that IB and OPA are sharing GID space definitions.

I understood from Ira's presentation [1] that it is the case.
And doesn't it need to be "||" and not "&&"?

>
> It looks like rdma_cap_opa_ah() is basically being used as a check to see if the code is handling the OPA CM protocol or IB CM protocol.  (Even though the two protocols are nearly identical).

Where can I read the difference between these protocols?

[1] https://www.openfabrics.org/images/eventpresos/2016presentations/104rdmaaltfabs.pdf

Thanks

--ijywFOGgtBfiIjQx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkal3QACgkQ5GN7iDZy
WKfzRQ//UCfRE4mQCDrwrnTq0ZEzBVmxKmVn5qIwJ/krxxMzVLBmaIN/d23LKl+J
5F5bvgHl9T//SeH2VOzZd50VDopIpDKUpHFHztbiF2jw5qwZ3R1ZABm+gBI1tUpd
MWcIu0BJH33qbShunsJK5/2nOXsKO3HNixrfOk7cXvqRCGUCU5lI6c5uDmqgHtiG
VE7rg1cCwTbprP645iXWkW3ZdSuW/BjKvetfRT5+jpC3c5oY0LFBlwqCdOK3SEqH
xx0O/KJepq7IL5gohEbiMMZZvX4UDKUmekuxJYtzpc6uUOXGY31C6Z7jGK1dPW0q
kmbXFuB8poVPEB8JlkAPo6wjZ2CsEUhCBmU/0KXhsBfKVYDJEGw3vK+hoifMr1jf
agvAe5+sVHBuffKNU3CRG3lK3+xJZOAwRX2lZSjxW3/r0rchTQFVfxoph50jSz12
CP+zRb+QSnX2TnzL79zckMmSREarvB6Bsh/h3vIzEP+XsARYTlvzL7k9XjIDolh8
BlQFpyWbSR3HPoLRBI94F25U7Qy3oOxFQl/9vM+r8dbsvL+jFr98DlqCIU/fPcTM
ORNtK1x6UpZq8eexbCtzyM+IFC6aWgRHGmXV3EPuA90K0XR76TeQhYNxG8+Ocx0/
SLpOBddxMjVxtIwM5QsTvM48jHmarhFBBPs81qaXahrn5CyKCsg=
=275y
-----END PGP SIGNATURE-----

--ijywFOGgtBfiIjQx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
