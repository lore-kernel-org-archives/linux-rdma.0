From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 2/7] RDMA/core: Add helper function to
 create named QPs
Date: Fri, 12 Jan 2018 08:42:43 +0200
Message-ID: <20180112064243.GK15760@mtr-leonro.local>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-3-leon@kernel.org>
 <1515700219.2752.55.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AptwxgnoZDC4KQWS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515700219.2752.55.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--AptwxgnoZDC4KQWS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 11, 2018 at 07:50:21PM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 17:31 +0200, Leon Romanovsky wrote:
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -1141,6 +1141,12 @@ struct ib_qp_init_attr {
> >         u8                      port_num;
> >         struct ib_rwq_ind_table *rwq_ind_tbl;
> >         u32                     source_qpn;
> > +
> > +       /*
> > +        * Name of entity which created this QP, empty string means that
> > +        * it will be taken automatically from task_struct.
> > +        */
> > +       char comm[TASK_COMM_LEN];
> >  };
>
> Why is "comm" a char array instead of a const char pointer or dynamically
> allocated memory (kstrdup())? Can we get rid of the strncpy() calls in code
> that fills in this data structure?

Yes, we can, initially, I didn't want to bother with corner cases of
failure in allocations, but in last version of code it is already easy
to deal, so I'll replace.

>
> Thanks,
>
> Bart.
>

--AptwxgnoZDC4KQWS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpYWOMACgkQ5GN7iDZy
WKduxg//U4WLvyf2mKezYjmv/OSUeDnaKfqCmGpRBHcNBgqNGZ+ZNYV/sH9u3tgY
HXXorP18zk4xKJW2dE3OVoBzN4H11KWrkLlbAEQTeDwCgc2NlIYJKlUcpKaziqy2
5VrhG2Uwq+7UZ7n9EbJaGvcJXbNP/P6hvJ1T48mJ12lPMwVr19CAfKoRoMw22k6U
NpX9ntyiV1IIPqTCIVsiM3HkuF7kTuoe+g0+WGX0+D7CnoBLpQ4rfv2C1bO5ck6L
P523gLGCQR4P10zggmDPabIdng1mPJTNFuMeB7ExyC4UTK9MsAACeV/ZxWw0E9Yw
3+WagZCf+tl5HeWf5XzmzZfe7dH16J3ybnMXa0Id0hdYpD5zaHyP/5FsSHuRtfGa
xipHhi16imsgmZS6tjGk4O4m5U6nbbO303bxalBocb07YDGyBRNmnooS8rw/S0Z+
n7GYfIb3LmQMlhaXITnqOniu/zhhJ0WANHUD4uNhQjDHzTHkSgbcl0QWf/ENucu9
Qyio0JvTwUi9zTkZm4l4oD7sW1RjYJ8k6/6A2dQ63VZTuOpSvnuCrDwuC3YGZwst
fBccVoai8eyKHTeU19P6v8qBMoMe6Pb0dmkV6t6CAn9nvwQOiP9F+jFpz/soLJEL
LIWO1dj/VjHcKHyowCXX/+RGdT3OKijKxm4FJGnrCzwFE9azqKQ=
=yywR
-----END PGP SIGNATURE-----

--AptwxgnoZDC4KQWS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
