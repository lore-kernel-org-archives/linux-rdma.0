From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP
 information
Date: Wed, 10 Jan 2018 09:17:22 +0200
Message-ID: <20180110071722.GF7368@mtr-leonro.local>
References: <20180102081832.5264-1-leon@kernel.org>
 <20180102081832.5264-8-leon@kernel.org>
 <20180109200917.GF4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109200917.GF4518-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 09, 2018 at 01:09:17PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 02, 2018 at 10:18:32AM +0200, Leon Romanovsky wrote:
>
> > +	/* PID == 0 means that this QP was created by kernel */
> > +	if (qp->res.pid && nla_put_u32(msg,
> > +				       RDMA_NLDEV_ATTR_RES_PID, qp->res.pid))
>
> This is returning a pid in the init name space, obtained here:
>
> +		res->pid = task_pid_nr(current);
>
> And since the netlink user is not running in the init name space this
> will return the wrong pid #, and worse potentially pids the current
> name space should not see.
>
> This API also needs to filter the results and only return pids
> visible, and translate the pids as well..

Correct, PID namespace wasn't taken into account, exactly as it wasn't
taken in CMA. So, right now, CMA netlink statistics is returning wrong
and unfiltered PIDs. How do you want to progress with that part of the code?

I personally have no plans to fix CMA netlink code and for my opinion it
should be removed, instead of beating that dead horse.

>
> I also suspsect this needs to be a netlink array of pids for future,
> as we have hope someday to have RDMA uobjects shared between multiple
> processes?

Not really, there is no such feature yet and once it will be introduced
the authors will need to update netlink interface and rdmatool to
support multiple PID option. They will add new netlink attribute and
fill it for their shared objects. For most users of RDMA stack, this
shared object thing is not needed and better to avoid from
over-engineering.

>
> > +	if (nla_put_string(msg,
> > +			   RDMA_NLDEV_ATTR_RES_PID_COMM, qp->res.task_comm))
> > +		goto err;
>
> Feels odd to return the content of /proc/XX/comm in netlink?
>

It was just to save extra syscalls for every object. I'll remove it for
the user created objects to simplify PID namespaces support.

> Jason

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpVvgIACgkQ5GN7iDZy
WKdIGRAAj0j2/37ffVzY0KYr9p6pA331qSnK3gsnz+b5qGrS5sPP8nSuW6nncJYo
peNG3jd3ujw6ecbjnA9FRa/bMQRSeaYBOsBq7nk8EDdByHTqMogxu5WYgELAwONI
ce4bKYDv7yO/mGSCzASZytYDMw60KelF6CP3ipzVpNOyXy2CvXLy8IRfzrxplG0L
pGaG5j9YzMFlmPjghs+SU0a3qfG2HcrDSFoGyemTHdtrZ5zFJ5P5gDa/Qk70e/GX
WxKa2OUhAoYh2KjScnQW5b+sA1nlP/1tbTghpRYUbLUGeTNz2g5nBaR5wf5MYC0C
DMECXru34Gd7VXTq46lB80oRTx+gIOGXJEJDYUVfb/zuRpQVZxADkmDQeYzuysNK
CgykivP/rDSiIbDTREvzY97nAtk0/gTRZqHw6pqqC+nK6mhGF2f8c3lf136NdSw+
mTAf2z6t385gB+UDq5M39ToeBzbMP5jRW7woDIzN4tGxAaG9rhtiD9AYfBe1wxCX
DlLgUDd003KBStGHrpaSClsvOVnnwnbLoNc/DVHW7/0B4g70ikErlPy1w6lZGfWU
wqJomG8BBT4xXNuhc5493bcSQZF3OstSQ3whHHYe7EVc6GYO08yYvThUCNqolo2h
scUR3DQnd7UwOabiLByAJFDCxD9WZCnBCyrmIZyz2GnqqYiJONk=
=KY9W
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
