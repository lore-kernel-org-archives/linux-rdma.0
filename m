From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Mon, 17 Jul 2017 17:54:22 +0300
Message-ID: <20170717145422.GH3259@mtr-leonro.local>
References: <20170627050028.17902-1-leon@kernel.org>
 <20170627050028.17902-2-leon@kernel.org>
 <7285b9b9-360f-5157-1148-1554db2f4a2c@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7285b9b9-360f-5157-1148-1554db2f4a2c-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 17, 2017 at 10:02:07AM -0400, Dennis Dalessandro wrote:
> On 6/27/2017 1:00 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > RDMA netlink has complicated infrastructure to add and remove netlink
> > clients to NETLINK_RDMA family. This complicates the code and not in
> > use because not many clients are available (3 clients) and most of them
> > (2 clients) are statically compiled together with netlink.c.
>
> So here you say there are three clients.
>
> > -	struct ibnl_client *cur;
> > -	struct ibnl_client *nl_client;
> > +	static const unsigned int max_num_ops[RDMA_NL_NUM_CLIENTS - 1] = {
> > +				  RDMA_NL_RDMA_CM_NUM_OPS,
> > +				  RDMA_NL_IWPM_NUM_OPS,
> > +				  0,
> > +				  RDMA_NL_LS_NUM_OPS,
> > +				  0 };
> >
> > -	nl_client = kmalloc(sizeof *nl_client, GFP_KERNEL);
> > -	if (!nl_client)
> > -		return -ENOMEM;
> > +	/*
> > +	 * This BUILD_BUG_ON is intended to catch addition of new
> > +	 * RDMA netlink protocol without updating the array above.
> > +	 */
> > +	BUILD_BUG_ON(RDMA_NL_NUM_CLIENTS != 6);
>
> Yet we are checking for 6? Can you elaborate here.

This check is needed to ensure that the array is properly initialized.

The clients were exposed in include/uapi/rdma/rdma_netlink.h, in the
following enum:

  6 enum {
  7         RDMA_NL_RDMA_CM = 1,
  8         RDMA_NL_IWCM,
  9         RDMA_NL_RSVD,
 10         RDMA_NL_LS,     /* RDMA Local Services */
 11         RDMA_NL_I40IW,
 12         RDMA_NL_NUM_CLIENTS
 13 };

First of all it starts from 1, second we have RDMA_NL_RSVD and
RDMA_NL_NUM_CLIENTS which exposed, but are not real clients, because
nothing is handled them

It leads for RDMA_NL_NUM_CLIENTS == 6 and this is why I'm checking for 6.

>
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllsz54ACgkQ5GN7iDZy
WKdaaA//ZZ+HqaK9GK8oN3o84Hke7kuXyfaWbNywWq0tT1hzouvYTWPJBGbOaiaB
faD9Y/kTydqcVo7rIf5gW1B74er5b6FwUEQ+xEKLNBq+Mhz3pTeaIirgbaYPIlqw
pqlCpY2kDvhYGJFq+kdVyG8X3uQ9FU5Rh+EH/BPa3KDDm1UM9CE7EbB6+rqLwIT+
PiLXBBpM67b1osnSEDqQmaFohkTcGziHwM2z2Z47/3aYP72euDXhEqLPiHsVnHP9
OsdUCaQpCMhOFlPBfkoBRAWoUSITreRHXp86XOO5V0uoXMWKLJdGPwOvZ4Pubbk2
WaHWoNjtyHB/6eo9uNqJHAqIV7EvJM7egAWPPxdgWdeoMmfs19SkW28f80+uaZgc
88XFqaYsEsb122Ucsjmz4cKEp74N77+PFuuAlqbXHEpS3kzZ4IT4y1BNOF8ZpUN7
2jl2oZZvZ8oW8KuaX1siqGstFX/q1cAmNgucZjrMaPOIedlo1eW9QnMtku8mXmGu
2klv+6yzItUgGCy8VDhzQh4G69BtPWYG0CqRDgK0fXhBD9ZvCgOdXtPrILUMrm/4
vN9WrK0WJZ/CpLiPlveo1Z6qHF9Ed9WLcbTtiH7xBSgf8MiER3n4XyjG1STZ4Xqv
tp8LJNmGSX6DAUawO8RmISH5V9xEUf0iULGBU4OrOjDdh64asAU=
=xPZY
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
