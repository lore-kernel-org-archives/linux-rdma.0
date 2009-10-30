From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add configurable retries for transactions
Date: Fri, 30 Oct 2009 22:17:38 +0200
Message-ID: <20091030201738.GC5829@me>
References: <20091024140538.GA5213@comcast.net>
 <20091030025541.GU20136@me>
 <f0e08f230910300848i3a36ceedh4472478b6f492a7d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910300848i3a36ceedh4472478b6f492a7d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:48 Fri 30 Oct     , Hal Rosenstock wrote:
> >> @@ -819,6 +821,13 @@ osm_vendor_bind(IN osm_vendor_t * const p_ven=
d,
> >> =A0 =A0 =A0 p_bind->send_err_callback =3D send_err_callback;
> >> =A0 =A0 =A0 p_bind->p_mad_pool =3D p_mad_pool;
> >> =A0 =A0 =A0 p_bind->port_guid =3D port_guid;
> >> + =A0 =A0 if (p_vend->timeout =3D=3D -1) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_bind->timeout =3D p_user_bind->timeout=
;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_bind->max_retries =3D p_user_bind->ret=
ries;
> >> + =A0 =A0 } else {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_bind->timeout =3D p_vend->timeout;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_bind->max_retries =3D p_vend->max_retr=
ies;
> >> + =A0 =A0 }
> >
> > Hmm, shouldn't we respect user requested data? Something like:
> >
> > =A0 =A0 =A0 =A0p_bind->timeout =3D p_user_bind->timeout ? p_user_bi=
nd->timeout :
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p_ve=
nd->timeout;
> > =A0 =A0 =A0 =A0p_bind->retries =3D p_user_bind->retries ? p_user_bi=
nd->retries :
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p_ve=
nd->retries;
> >
> > ?
>=20
> The -1 is for the new ABI.

Could you elaborate?

> >> @@ -983,6 +989,11 @@ int main(int argc, char *argv[])
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 opt.sm_sl =3D (uint8_t=
) temp;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(" SMSL =3D %d\n=
", opt.sm_sl);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 case 8:
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 opt.transaction_retries =
=3D strtol(optarg, NULL, 0);
> >
> > Please use strtoul().
>=20
> OK. What about transaction_timeout ?

Yes, the same is applicable here.

> >> @@ -392,8 +393,7 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_=
t * p_osm,
> >> =A0 =A0 =A0 if (status !=3D IB_SUCCESS)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto Exit;
> >>
> >> - =A0 =A0 p_osm->p_vendor =3D
> >> - =A0 =A0 =A0 =A0 osm_vendor_new(&p_osm->log, p_opt->transaction_t=
imeout);
> >> + =A0 =A0 p_osm->p_vendor =3D osm_vendor_new(&p_osm->log, -1);
> >
> > Why to not make p_opt->transaction_timeout as default for newly
> > allocated vendor object?
>=20
> To support old and new ABI.

What do you mean? OpenSM will run against older vendor?

Even if so how '-1' is helpful? Likely it will break things, no?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
