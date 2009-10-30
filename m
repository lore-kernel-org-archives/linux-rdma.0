From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add configurable retries for transactions
Date: Fri, 30 Oct 2009 23:48:26 +0200
Message-ID: <20091030214826.GG5829@me>
References: <20091024140538.GA5213@comcast.net>
 <20091030025541.GU20136@me>
 <f0e08f230910300848i3a36ceedh4472478b6f492a7d@mail.gmail.com>
 <20091030201738.GC5829@me>
 <f0e08f230910301351o3f81d787g5e177be10da72319@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910301351o3f81d787g5e177be10da72319-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 16:51 Fri 30 Oct     , Hal Rosenstock wrote:
> On Fri, Oct 30, 2009 at 4:17 PM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
> > On 11:48 Fri 30 Oct =A0 =A0 , Hal Rosenstock wrote:
> >> >> @@ -819,6 +821,13 @@ osm_vendor_bind(IN osm_vendor_t * const p_=
vend,
> >> >> =A0 =A0 =A0 p_bind->send_err_callback =3D send_err_callback;
> >> >> =A0 =A0 =A0 p_bind->p_mad_pool =3D p_mad_pool;
> >> >> =A0 =A0 =A0 p_bind->port_guid =3D port_guid;
> >> >> + =A0 =A0 if (p_vend->timeout =3D=3D -1) {
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_bind->timeout =3D p_user_bind->time=
out;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_bind->max_retries =3D p_user_bind->=
retries;
> >> >> + =A0 =A0 } else {
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_bind->timeout =3D p_vend->timeout;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_bind->max_retries =3D p_vend->max_r=
etries;
> >> >> + =A0 =A0 }
> >> >
> >> > Hmm, shouldn't we respect user requested data? Something like:
> >> >
> >> > =A0 =A0 =A0 =A0p_bind->timeout =3D p_user_bind->timeout ? p_user=
_bind->timeout :
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p=
_vend->timeout;
> >> > =A0 =A0 =A0 =A0p_bind->retries =3D p_user_bind->retries ? p_user=
_bind->retries :
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p=
_vend->retries;
> >> >
> >> > ?
> >>
> >> The -1 is for the new ABI.
> >
> > Could you elaborate?
>=20
> In order to be able to deal with combinations of old/new opensm/vendo=
r layer.

I see, you are trying to protect old OpenSM <-> new vendor case.

Such combination will not work for many reasons (we changed OpenSM/vend=
or
interaction couple of times in past few years, including configuration)
and it is better to avoid such usage.

> >> >> @@ -392,8 +393,7 @@ ib_api_status_t osm_opensm_init(IN osm_open=
sm_t * p_osm,
> >> >> =A0 =A0 =A0 if (status !=3D IB_SUCCESS)
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto Exit;
> >> >>
> >> >> - =A0 =A0 p_osm->p_vendor =3D
> >> >> - =A0 =A0 =A0 =A0 osm_vendor_new(&p_osm->log, p_opt->transactio=
n_timeout);
> >> >> + =A0 =A0 p_osm->p_vendor =3D osm_vendor_new(&p_osm->log, -1);
> >> >
> >> > Why to not make p_opt->transaction_timeout as default for newly
> >> > allocated vendor object?
> >>
> >> To support old and new ABI.
> >
> > What do you mean? OpenSM will run against older vendor?
> >
> > Even if so how '-1' is helpful? Likely it will break things, no?
>=20
> -1 is not a valid timeout so can't this be used in this manner ? How
> will it break things ?

Old vendor will not work with '-1'. OTOH this enforces all vendor users
to set all parameter explicitly, and ignores those values when a value
other than '-1' was used in vendor creation. In fact it enforces using
'-1' and effectively makes it to be mandatory part of vendor API. Seems
too messy for me.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
