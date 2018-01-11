From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP
 information
Date: Thu, 11 Jan 2018 07:37:34 +0200
Message-ID: <20180111053734.GL7368@mtr-leonro.local>
References: <20180102081832.5264-1-leon@kernel.org>
 <20180102081832.5264-8-leon@kernel.org>
 <20180109200917.GF4518@ziepe.ca>
 <20180110071722.GF7368@mtr-leonro.local>
 <20180110225622.GQ4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2fjX3cMESU3XgGmZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180110225622.GQ4518-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2fjX3cMESU3XgGmZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 10, 2018 at 03:56:22PM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 10, 2018 at 09:17:22AM +0200, Leon Romanovsky wrote:
> > On Tue, Jan 09, 2018 at 01:09:17PM -0700, Jason Gunthorpe wrote:
> > > On Tue, Jan 02, 2018 at 10:18:32AM +0200, Leon Romanovsky wrote:
> > >
> > > > +	/* PID == 0 means that this QP was created by kernel */
> > > > +	if (qp->res.pid && nla_put_u32(msg,
> > > > +				       RDMA_NLDEV_ATTR_RES_PID, qp->res.pid))
> > >
> > > This is returning a pid in the init name space, obtained here:
> > >
> > > +		res->pid = task_pid_nr(current);
> > >
> > > And since the netlink user is not running in the init name space this
> > > will return the wrong pid #, and worse potentially pids the current
> > > name space should not see.
> > >
> > > This API also needs to filter the results and only return pids
> > > visible, and translate the pids as well..
> >
> > Correct, PID namespace wasn't taken into account, exactly as it wasn't
> > taken in CMA. So, right now, CMA netlink statistics is returning wrong
> > and unfiltered PIDs. How do you want to progress with that part of the code?
>
> It should be fixed or deleted.

So, should I proceed with this patch? Remove CMA statistics?
https://patchwork.kernel.org/patch/10056129/

>
> > I personally have no plans to fix CMA netlink code and for my opinion it
> > should be removed, instead of beating that dead horse.
>
> What is so wrong with it you can't use it anyhow?

In addition to posted in the CMA statistics removal RFC thread, it is
now very clearly seen that CMA statistics returns wrong PID in not
initial PID namespace.

Thanks

>
> Jason

--2fjX3cMESU3XgGmZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpW+B4ACgkQ5GN7iDZy
WKcZjA//biwu3Yjv7HxeTrEjx/MUN4XDZSPw/4pWZ5LCzyLLsJY5aLbADZXENIdp
wZAFOa3GsyH9OZDDcHVXUN09piHh9hkDPVXvceRc4qd9iLJ3wrg6Mg2go7NuBI21
1feuhFOV2HqyNeIvLw9h2j29EMiN/AEMm0cY8XeA+UPD8G3r9blJNOSuJeO2IquP
tNLkubF5BdChochlhL70XrHYLYnm18wMxkXMldjCqcf9G+/jy+/GTgPVaYjHvnKE
J1VC5C+MmaC4IhczFiK4CunWZ2UQRTM3h7yufSuxS1vIi/Ftyho+1Sou1ipnlbRn
LfYUDZmSzHU7mgeRZcM5MmrqjiAzocQqKlgSMBxQuqWzO/QdTNK+PzYysADBtwSK
OGUxl4vi8ths36iRyVMh8MuJYoM8VWDf837PDNl8NnJKCtUJxSnz2vkt76S9uucD
ih+gAXtwrWqUWaotboWo49Gs899SJeG7XhuFXVVuaJocNWY60E5b6lIdRoHcRsot
IeYwSXEB23BrpjtQlMVM53/VT37y33ztF4AUQB5MClzlryNRi3RcmMO41S52EiD0
n5aauV41g4d7UbHowBTPWGJF+QDb27JpXLJgaFYrTSnr2TH9jb9mu4K2+4TASn+I
7gekqy8n2v1dgjiZ53axUoMuEOA+QfLBS2Rw907ZWPT5Q5kh3TQ=
=bQwO
-----END PGP SIGNATURE-----

--2fjX3cMESU3XgGmZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
