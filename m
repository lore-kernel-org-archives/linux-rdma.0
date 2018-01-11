From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP
 information
Date: Thu, 11 Jan 2018 07:41:41 +0200
Message-ID: <20180111054141.GM7368@mtr-leonro.local>
References: <20180102081832.5264-1-leon@kernel.org>
 <20180102081832.5264-8-leon@kernel.org>
 <20180109200917.GF4518@ziepe.ca>
 <20180110071722.GF7368@mtr-leonro.local>
 <20180110225622.GQ4518@ziepe.ca>
 <016201d38a6a$ca49d880$5edd8980$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="F55Y67F01HNW3AgB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <016201d38a6a$ca49d880$5edd8980$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--F55Y67F01HNW3AgB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 10, 2018 at 05:28:58PM -0600, Steve Wise wrote:
> >
> > On Wed, Jan 10, 2018 at 09:17:22AM +0200, Leon Romanovsky wrote:
> > > On Tue, Jan 09, 2018 at 01:09:17PM -0700, Jason Gunthorpe wrote:
> > > > On Tue, Jan 02, 2018 at 10:18:32AM +0200, Leon Romanovsky wrote:
> > > >
> > > > > +	/* PID == 0 means that this QP was created by kernel */
> > > > > +	if (qp->res.pid && nla_put_u32(msg,
> > > > > +				       RDMA_NLDEV_ATTR_RES_PID, qp-
> > >res.pid))
> > > >
> > > > This is returning a pid in the init name space, obtained here:
> > > >
> > > > +		res->pid = task_pid_nr(current);
> > > >
> > > > And since the netlink user is not running in the init name space this
> > > > will return the wrong pid #, and worse potentially pids the current
> > > > name space should not see.
> > > >
> > > > This API also needs to filter the results and only return pids
> > > > visible, and translate the pids as well..
> > >
> > > Correct, PID namespace wasn't taken into account, exactly as it wasn't
> > > taken in CMA. So, right now, CMA netlink statistics is returning wrong
> > > and unfiltered PIDs. How do you want to progress with that part of the
> code?
> >
> > It should be fixed or deleted.
> >
> > > I personally have no plans to fix CMA netlink code and for my opinion it
> > > should be removed, instead of beating that dead horse.
> >
> > What is so wrong with it you can't use it anyhow?
> >
>
> We certainly need to be able to get detailed cm_id information.  At least
> cm_id bound device, cm_id state, port num, qp-id associated with this cm_id,
> and src/dst ipaddrs/ports.  However, it could be fetched and added to qp
> attributes.  Ala iw_cxgb4's debugfs "qps" file:
>
> [root@stevo3 stevo]# cat /sys/kernel/debug/iw_cxgb4/0000\:04\:00.4/qps
> rc qp sq id 1136 rq id 1137 state 1 onchip 0 ep tid 12028 state 7
> 172.16.4.3:58725/58725->172.16.4.4:7174/7174
>
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It can be one option, another is to add new RDMA_RESTRACK_CMA object and
expose all relevant information with rdmatool, e.g. "rdma resoruce cma link cxgb4/1".

Thanks

>
> Steve.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--F55Y67F01HNW3AgB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpW+RUACgkQ5GN7iDZy
WKeEow//V73fsfC7iwp9Al0SQ2ve6MZ2zHR3sL6eHcfyZTBaz81Le4j8/gj+MGDC
n9WRzrc8WPMnAI4niQFmm+rN6qxEOxNjnOIL2GgNHo4ytQF9JEef2JGj5tBJobxH
7cYaALSpxHl0SO6hmJffXJ/Q8G58tB+9QjyvnQ/8PDo5jT0kOoDe0BI81KDMJNpj
xDYmLut+WK8snknhbcaGWbQVuVYuf4LIxO0QDvcuVbLz9jEi4YGrHtA+UM/IOLVM
E4FWY+5Q+FFYOelrGifU6Ou2Q32LgvKuKYKhzco1gLPTbAqBhYgsPWl2BXF8cNu0
6i0N+yu0Krt6HqWHUjhMxGOoFdrX2wQyowortocKjMMCEfMqTGLgVQ7pj47Z3GxH
Pwz3TmT7M62xT3neu01HMf4BhhdFRzIw6mH111sr1f1fMMf6kjf+a9+c/vQS8N8Y
+FVIA8HvmW+cryq+WT3f4fkAYacQkV4IEXETvM43QQ+oBeBl8R/LC/axLZLkz+7u
l73u0gNBbJYUwgdM6CDYMKjDKo5fdZqb0B0HsL0f6VVW283GY2/hYTaEP8QggkSi
70wtCm9bpV5qa8EeUEHYy/Kpubwzm/BfaXHDipgEYlfxnaZ5Ff+Yb1GOaNRKFnGn
JLvMb9DIJHZiaACXj3pcVlhHY5NxPZxtvX9pm+/ITJP2JFr/9xA=
=I0Yv
-----END PGP SIGNATURE-----

--F55Y67F01HNW3AgB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
