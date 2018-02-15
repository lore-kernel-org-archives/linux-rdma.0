From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 07/14] RDMA/uverbs: Refactor command header
 processing
Date: Thu, 15 Feb 2018 15:51:20 +0200
Message-ID: <20180215135120.GG2197@mtr-leonro.local>
References: <20180214123844.30321-1-leon@kernel.org>
 <20180214123844.30321-8-leon@kernel.org>
 <20180214234951.GF1718@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3wfpuDtTLg8/Vq6g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214234951.GF1718-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3wfpuDtTLg8/Vq6g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 14, 2018 at 04:49:51PM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 14, 2018 at 02:38:37PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Move all command header processing into separate function
> > and perform those checks before acquiring SRCU read lock.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/core/uverbs_main.c | 62 ++++++++++++++++++-----------------
> >  1 file changed, 32 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> > index 90e0b16aed1a..50d43c300112 100644
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -660,6 +660,29 @@ static bool verify_command_idx(__u32 command, bool extended)
> >  	       uverbs_cmd_table[command];
> >  }
> >
> > +static ssize_t process_hdr(struct ib_uverbs_cmd_hdr *hdr,
> > +			   __u32 *command, bool *extended)
> > +{
> > +	__u32 flags;
> > +
> > +	if (hdr->command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> > +				   IB_USER_VERBS_CMD_COMMAND_MASK))
> > +		return -EINVAL;
> > +
> > +	*command = hdr->command & IB_USER_VERBS_CMD_COMMAND_MASK;
> > +	flags = (hdr->command &
> > +		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
> > +
> > +	*extended = flags & IB_USER_VERBS_CMD_FLAG_EXTENDED;
> > +	if (flags & ~IB_USER_VERBS_CMD_FLAG_EXTENDED)
> > +		return -EINVAL;
>
> er..
>
> We don't need both
>
> 	if (hdr->command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> 				   IB_USER_VERBS_CMD_COMMAND_MASK))
>
> and
>
>         if (flags & ~IB_USER_VERBS_CMD_FLAG_EXTENDED)
> 		return -EINVAL;
>
> They test the same condition.

Not exactly,
~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK | IB_USER_VERBS_CMD_COMMAND_MASK)
== ~(__u32)(0xff000000u| 0xff) == 0x00ffff00

=> we are testing that middle bits of hdr->command are cleared

flags & ~IB_USER_VERBS_CMD_FLAG_EXTENDED == ((hdr->command &
IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT) &
~IB_USER_VERBS_CMD_FLAG_EXTENDED == 0xff000000u >> 24 & ~0x80 ==
0xff & 0x7F == 0x7F

=> we are testing that only extended flag is enable.

>
> So my earlier comment about needing a stronger flags check is bogus -
> we already have the stronger check. The original code was just
> checking it twice, so it doesn't need this extra if.
>
> Jason

--3wfpuDtTLg8/Vq6g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqFkFgACgkQ5GN7iDZy
WKepDA//TvXXvfAElw1PhJPhM5Vb2/szBPL+lIrBst6Uj9VV35C7qYLFPuuuY89V
Y6B5tM6nt3pYqfjd+pRDwM2F2bJwOIboWv5zmNM5qozSkDgPMZ2MIc2K5ATd8+/z
I26w1QSjx301Ejsg60x5eGiNLfZbxMWatosy4P5i31qsXx60J/B/pAvZuYuCEVcq
giI4Tvamm1NJwwQghohJOFUHnBxawdO4LgNlcBjmWURhc0RC/9nxG5q7/2slnlID
CxaJ48UBIQ6lxCEDCIyty85wHK5VkhrVRyCsav6ApQCkFG7TLQvDcnba9O9IRT34
cg9xTeNChDVhZCHflL18+R2FayziCE7rkHgN8esGXoNHDRPhVPBZfDjpSGtBq923
ZMiNOx4PQzCWXTWctQCpGEj/Rz8GE4wSzr7m2gvxSdIEUR3LkovXX5l3ZGGZWayG
bZFmJnDjbUqQ6587v/oN7wK0A1x4/g7ZtvK6S5nY8wEv9vhj5lJTcJXnkY+uXZ7X
nzccYE6zUX9HJykWNh9r/GWkWuJVflp4kFieFrFgsHVj3MHMg09MwmJslycRRvAP
jszeHQRBaYK+1qTSNX2K+P7DpD9jOUG0tcASAHk6fwrVEUs6LlGCYWwEoIcgQrWj
jQK2RY3ozlJ6OOlVLVmIf2Tdbf3RHefa1U0+bKZaG4N6nzC79sE=
=Fjeq
-----END PGP SIGNATURE-----

--3wfpuDtTLg8/Vq6g--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
