From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: VERBOSE flags
Date: Tue, 20 Sep 2016 13:56:42 +0300
Message-ID: <20160920105642.GI26673@leon.nu>
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ@mail.gmail.com>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30@redhat.com>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q@mail.gmail.com>
 <0a26585a-2e54-1c24-d212-0e2469afb8d8@redhat.com>
 <20160919061558.GG3273@leon.nu>
 <1474288178.6520.12.camel@intel.com>
 <20160919132518.GH3273@leon.nu>
 <1474292075.6520.28.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IR1Y5IvQhrKgS4e6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474292075.6520.28.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--IR1Y5IvQhrKgS4e6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 01:34:39PM +0000, Dalessandro, Dennis wrote:
> On Mon, 2016-09-19 at 16:25 +0300, Leon Romanovsky wrote:
> > On Mon, Sep 19, 2016 at 12:29:43PM +0000, Dalessandro, Dennis wrote:
> > > On Mon, 2016-09-19 at 09:15 +0300, Leon Romanovsky wrote:
> > > > The function pointers will cause us to create two similar
> > > > functions
> > > > (debug/regular) for every important function. It will leave to
> > > > code
> > > > duplication and/or introducing of new code to fill additional
> > > > fields
> > > > in returns to debug functions, so they will be able to print it.
> > >
> > > I do sort of like Doug's idea. It means you can easily instrument
> > > the
> > > heck out of a routine and have it always available. It provides
> > > more
> > > flexibility in what you can do in a debug version.
> > >
> > > You do make a valid point though about duplicating code. Perhaps
> > > that
> > > can be alleviated to some extent just by refactoring and adding
> > > inlines, etc. =A0
> >
> > At the end, we will invent tracepoints :)
> >
> > >
> > > > I wanted to propose to use tracepoints to provide debug
> > > > information
> > > > in
> > > > data paths. The tracepoints infrastructure uses hooks in the code
> > > > with
> > > > minimal impact on performance.
> > >
> > > This is so far the path we have chosen for hfi1. We have a number
> > > of
> > > tracepoints in various parts of the code. Again it's available on
> > > demand without special kernels or boot/driver options.=A0
> >
> > CONFIG_SDMA_VERBOSITY ????
>
> Yes we do have that, which illustrates that trace points can not do
> everything. I had hoped to deprecate that at some point. Regardless,
> sometimes you want additional code to be added or to do something
> slightly different. You can't do that with a tracepoint.

Can you elaborate more on this topic? Which limitations did you see
in tracepoints?

In regards of other discussion in KS 2016, "tracepoints and ABI
stability warranties" [1]. Are you strict with this tracepoints ABI?

>
> You can see we use tracepoints pretty extensively and that is our main
> vehicle for debugging. Here is where all the definitions are:
>
> $ ls trace_*
> trace_ctxts.h=A0=A0trace_dbg.h=A0=A0trace_ibhdrs.h=A0=A0trace_misc.h=A0=
=A0trace_rc.h=A0=A0t
> race_rx.h=A0=A0trace_tx.h

+1 :)

[1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2016-Septem=
ber/003850.html

--IR1Y5IvQhrKgS4e6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4RXqAAoJEORje4g2clinYQIP/14B0O+3kfRJ3tUe2l6NB3TN
sn1MpN6JAZmoCJzUioE+g8yyKOZfFe5kUXDF60tsxerzwaeqTZ9N+7B6Idc8qudZ
fstzThriKzMS5ccBkpPBM8miQ8piEVOQLmn3ulK7jxMblNHn63++8z1Zn7nTWhQ2
svI2ONh+IN0RjvsV8+CwTz43HQ0OTVd4sRREwIRH2FzNJJhGQvnfkndrFljipb6X
Wpi+4ajhWMtwf6IX5PDWP+UFeRfHM23fvKbAFqLYJ1wUz+/Q7ulMvsHkqZxy0c0v
YY/jgeb9WriRBnT/rF5OE3DEOcI7DHJ7pLrZWVJxEKEzIPhxPUgONQ76go30ZbfN
3OpVYvp4ZlSJpsuZKtwaH0HWqMigsiRNTUnE5TCosShKEk+R2LlBd/KSLccYzxm5
9eSEJJCNU4nHTOUwc9wnPET0xg4CFTW+qrCgYAk/Pm5BdJwZa0ZqlYzgtyi0mfZR
swB1QxbRLj0yTiIukJ2kc1lQUi6OAOmC+lsywxNUDYdSnFIw2bXz95kERniZGaKN
36wNgO0yiVzgEzFQ7r6xEz24TEKiyDWWD96YsHpHsz9tAwDvY6yOKceTIG7boA/Y
Gc1AsX0kwBKA322ugHxo2Rzw075hw6//3GiR4y+EovM/v6w7Njx6IjXvKd94Bwas
RjdmDSDj/E98Kgsx9Mc1
=7Cog
-----END PGP SIGNATURE-----

--IR1Y5IvQhrKgS4e6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
