From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Sun, 4 Jun 2017 08:36:35 +0300
Message-ID: <20170604053635.GD6868@mtr-leonro.local>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <1496261429.2608.15.camel@sandisk.com>
 <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170602162849.GA28660-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org" <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 02, 2017 at 11:28:49AM -0500, Shiraz Saleem wrote:
> On Wed, May 31, 2017 at 02:10:31PM -0600, Bart Van Assche wrote:
> > On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> > > > 5. I proposed a solution -> go and fix your user space program.
> > >
> > > This is a kernel patch you are trying to revert, you are breaking existing
> > > kernel functionality.  Nothing to do with user space.
> > >
> > > Bottom line, come up with a solution that will address both port mapper
> > > functionality and your issue.
> >
> > Hello Shiraz,
> >
> > Sorry that this means additional work for you, but I agree with Leon that
> > user space software should not assume that netlink sockets are a reliable
> > communication mechanism.
>
> Hi Bart - Thank you for your response.
>
> The original problem was that ibnl_unicast, which is used to send nl messages from
> portmapper kernel space to user-space, would occasionally and momentarily fail under stress.
> We could have retried the call for a certain amount of time, but since netlink_unicast has a
> nonblock/block parameter, we chose to use the blocking option with a timeout. So we thought we
> did account for deadlocks with this timeout.

Not really, you just reduced the chances. In very large scale, you will
have a very large chances of such deadlocks.

Thanks

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkznGMACgkQ5GN7iDZy
WKczGA//Xdk7Vgpt1rpc1fX4F/hbikKYevHIJGm2SlFsrcf60IGye/kIpV4OAkLs
kpxqtgKoJxIE/6ukAIy2ZIchKBQ28HdWrEKIoMZCllveRsn2QmvAnhkLhPHWVJVG
JPdT5DUefFlXyR4oAXt6JszBm7QulCp/1qZKq0ZP9EoK1sKlqjOjhGFup5V/3kP4
OFHOstlrPUp8G0gkHlj6M7yNkUP/rc6AZ3apGPjDyKII3y3XOjZ2WTrD2IphARaM
YWpZfpxAsuxFCv023pjtwZvwF25hO7gfJc4n9Pk17rCkTr07mb+5ssVMVA5LzrGA
mAI/noD8PKfgb+3IfYY92tVpe9ZGQyY9nIFTM2/iz77ByEuojtWcFEtIcvCzo7v3
umYdkFJE1258zZ5H2qSU10E7bsGuccGoaiaT3fcBYjGa9iZDWh8Nz2SyX2daEvBn
iWi+sGbP0dEdSPNRK6SoFsH/FxR3l4oWQsvNb1vwf8IT8gXrz+KPmgj4KXSj4MFt
4DAbG0cZXOmkFyvjjI6RE6YZTBceadCnlP5u5OrJQEh4rMSIf+QzYKCwX6z3z3LO
FjcCsL3aoZiD25znWISH3ci2/bpT/i1fi39OQBvMjN5ADsDV2EtrPoVEfGbyKu6w
y+mOdVgxBylWzKUUA/9ufoNKNq6/l4AVhQRmNJglbqTIobszw2o=
=YjcV
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
