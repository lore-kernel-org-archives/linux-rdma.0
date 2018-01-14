From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 2/7] RDMA/core: Add helper function to
 create named QPs
Date: Sun, 14 Jan 2018 17:55:24 +0200
Message-ID: <20180114155524.GX15760@mtr-leonro.local>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-3-leon@kernel.org>
 <1515700219.2752.55.camel@wdc.com>
 <20180112064243.GK15760@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6h64vBu9tReNbGLX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112064243.GK15760-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6h64vBu9tReNbGLX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 12, 2018 at 08:42:43AM +0200, Leon Romanovsky wrote:
> On Thu, Jan 11, 2018 at 07:50:21PM +0000, Bart Van Assche wrote:
> > On Thu, 2018-01-11 at 17:31 +0200, Leon Romanovsky wrote:
> > > --- a/include/rdma/ib_verbs.h
> > > +++ b/include/rdma/ib_verbs.h
> > > @@ -1141,6 +1141,12 @@ struct ib_qp_init_attr {
> > >         u8                      port_num;
> > >         struct ib_rwq_ind_table *rwq_ind_tbl;
> > >         u32                     source_qpn;
> > > +
> > > +       /*
> > > +        * Name of entity which created this QP, empty string means that
> > > +        * it will be taken automatically from task_struct.
> > > +        */
> > > +       char comm[TASK_COMM_LEN];
> > >  };
> >
> > Why is "comm" a char array instead of a const char pointer or dynamically
> > allocated memory (kstrdup())? Can we get rid of the strncpy() calls in code
> > that fills in this data structure?
>
> Yes, we can, initially, I didn't want to bother with corner cases of
> failure in allocations, but in last version of code it is already easy
> to deal, so I'll replace.

OK, I started to replace per-your request and found myself replacing half of
the code from dynamic allocations to be static initialization for the QP
attributes. I need to do it to avoid dealing with release path too.

And found that it is simply too much for this series, and it can come as future
optimization.

Thanks


> >
> > Thanks,
> >
> > Bart.
> >



--6h64vBu9tReNbGLX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpbfWsACgkQ5GN7iDZy
WKeAoA//QxW3tyPiBb7R1fuKIQDZoD4Wt3XcllXAVHohwK9pYDiWOVcRTqXLeRb/
A9cnCP+cgSO9SRzcgOUtyBx/OTGqCO5v9nrBOvVoWDEjUgmHGjYdKhp6LlbcdiLt
I/BbiJu2jY0mDXUn5cPvufJvXVttRnWn6UhX3GiUtv7E3nLzV1iDuVyARsaJL9pd
MxL0uwUwscjoQVii6/pxtAhHWlqbIGi90RjhSkqP/Auo1vMa6uNF+Ns6Ihxnjz/4
k8CX09iuDPCfEHHjnUazsJ2vqzmq1SZ91kqewjFqsWgPuiwpTggmvt9HTkyjzEAh
QDJ1R2k78AUrZiTSwwJbho+4vniOdloZvzqtZ8pQ7M/apFbEZ55Q01b8X2sIJRh9
v/aLasQzzOEts1F0VGGxisNEmVgsAl7zrDyJ/qY5gdrgzFOhAC2p0gt8H8lFTPPT
Vq5YVs5pgRdskcZB0CEm7jsxtDVi2LkwA5TfBQA56sxveUYZj8r/1pCTTucTwBDO
P13dUHvp9hv4LZL+nDrwNURUc6NfqawvwQaNnQIkNMmdQri6DGl6HT2WCRygcQ6m
SoKr/C4cVKgRF/WjG/MTkPzI5COKKPdmGtMm/7nNNt+EBKu62gEN9bRJBtydoEo8
TeEuAFnNK5hKY98dyIpfc7yDrm+mRxzjpB9FfJhykxnjLqEea04=
=ZOhp
-----END PGP SIGNATURE-----

--6h64vBu9tReNbGLX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
