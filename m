From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 07/22] RDMA/core: Remove unimplemented node_types and
 node transport
Date: Sat, 12 Aug 2017 09:32:37 +0300
Message-ID: <20170812063237.GM24282@mtr-leonro.local>
References: <20170811105003.7661-1-leon@kernel.org>
 <20170811105003.7661-8-leon@kernel.org>
 <36aea320-a018-040d-c44a-3a23d54771cd@dev.mellanox.co.il>
 <72f3047f-8b29-435d-57bf-be0734606368@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="boAH8PqvUi1v1f55"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <72f3047f-8b29-435d-57bf-be0734606368-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--boAH8PqvUi1v1f55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 11, 2017 at 02:13:01PM -0400, Dennis Dalessandro wrote:
> On 8/11/2017 12:46 PM, Hal Rosenstock wrote:
> > On 8/11/2017 6:49 AM, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > There is no need to carry code, which is not implemented in any
> > > underlying hardware. This patch removes unimplemented node_types and
> > > their respective node transport layers.
> >
> > We have supported IB switches and routers since day 1 of OpenIB and
> > linux-rdma. Although not the original intent, there are still no in-tree
> > consumers, but there are several out of tree ones. Every time this issue
> > has come up in the past, it has been decided to continue to support
> > them. Effectively, IB routers and switches are grandfathered.
>
> I swear I remember having this exact conversation but can't find it in my
> mail. Figures. Well regardless...

I posted it as material for -rcX and at that time we discussed it in
regards of bnxt_re unimplemented functions.

Thanks

--boAH8PqvUi1v1f55
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmOoQUACgkQ5GN7iDZy
WKchGxAA0r4BFLynUNPa/9akEdw/GSQ1k4XpYGX+GMovP7LHPBl1MizsmG+f/O5M
aaj6YUqvm9pVnQWH5oTmPn4GvL3kQ5f+Y5Bx0hUFzscFZpRSGMLBHhCJTan+Su8z
ptuwGGjeyk6mqQDuCNWVmnsnrl1uI9JMG7M/YJAk6Bzi0fOkakQei0NwNlQ2lRhM
6animj3wKGhnbid8WOlNJVxOQSVeEUnlEqig4LHCdap82nIQ5xGr9DFAr5pKi7AL
OZQqFWv43pW0bDU3vxgU5U2J8Myb3x+mAkRCu52ctn0Ddcvvjua/Jqgt+WM0GcE4
vbKccEJCkV3m75fMUkAQbdb3CtKfSKAsFlmZc6FLjVZgDqZV2VgGkZqCeG4ylEcg
PTfJOvY7p+CCwQPy1Aem/aEjLZxw1Pmwixu3TxuefBaeIrfD/vA7HbXUdWUJdRWx
pRXRlAcltSdaQGUEi+KSAPNKNupBlxHj2JmljryxP3KjYp4i3E3oM1T+/IxXP+Eq
QJBjXvEb+cCBquQh3ToZqDAwHJ/loHssTP+vIfd0BDxRiVKzWgrOzCk+tbewJLmH
IfFO98J3iwVJzNpuqbR0hGaT81yJ3CiGRqOC4OZdCltrF7sijtAGIflzPy0tUelM
a1oEdV/PyaKUj8XwpgyOzbRVRIv2qlYDpMMwhvBgZIAaNJ2vr3s=
=uQYN
-----END PGP SIGNATURE-----

--boAH8PqvUi1v1f55--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
