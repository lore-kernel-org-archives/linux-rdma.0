From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 13/47] RDMA/cxgb4: Declare a local variable 'static'
Date: Tue, 10 Oct 2017 06:59:09 +0300
Message-ID: <20171010035909.GI1252@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-14-bart.vanassche@wdc.com>
 <01ba01d33eef$d3ed5a90$7bc80fb0$@opengridcomputing.com>
 <1507591219.2674.58.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o7gdRJTuwFmWapyH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507591219.2674.58.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--o7gdRJTuwFmWapyH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 11:20:20PM +0000, Bart Van Assche wrote:
> On Fri, 2017-10-06 at 17:09 -0500, Steve Wise wrote:
> > >
> > > Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> > > Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/cxgb4/cm.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/infiniband/hw/cxgb4/cm.c
> >
> > b/drivers/infiniband/hw/cxgb4/cm.c
> > > index 2331e7d57704..49d9f9b870e5 100644
> > > --- a/drivers/infiniband/hw/cxgb4/cm.c
> > > +++ b/drivers/infiniband/hw/cxgb4/cm.c
> > > @@ -99,7 +99,7 @@ module_param(enable_tcp_window_scaling, int, 0644);
> > >  MODULE_PARM_DESC(enable_tcp_window_scaling,
> > >  		 "Enable tcp window scaling (default=1)");
> > >
> > > -int c4iw_debug;
> > > +static int c4iw_debug;
> > >  module_param(c4iw_debug, int, 0644);
> > >  MODULE_PARM_DESC(c4iw_debug, "obsolete");
> >
> > Can we just remove this now?  IE has it been 1 release since it was obsoleted?
>
> That's a good question but I'm not sure what would be a good time to remove
> this. I think the answer depends on how likely it is that people use this
> variable in scripts or /etc/modprobe.d configuration files because in that
> case removing the module parameter would break setups.

It is unlikely to happen, for many reasons. It is marked as obsolete for
a long time, the proper infrastructure (dynamic prints) already for a decade
with us and no adequate user is running debug system in production.

Another thing that we do remove visible to user interfaces from time to time
and the rule is "try to remove it and see if someone screams about it".

There are a lot of commits which do such thing and latest one is 0d0c71b31720
("btrfs: obsolete and remove mount option alloc_start")

It is safe to remove c4iw_debug module parameter.

Thanks

>
> Bart.

--o7gdRJTuwFmWapyH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlncRY0ACgkQ5GN7iDZy
WKe66w/7BUjmIZZRUj8zbQ8/bownQAEFxULvatX72a8b8DqU2Mb9nf4v5ft//sTS
42wBJOmWcwa8RK05IYc/WqoukPTlqobwnXNuXVCIAvCH2F3qXTkRoj/1dGhylek2
CSAa5pviUlVzVIViKKzj14wcRQYhjhl36NoCZFo8dULytqR9eTg8eLiW9+UX8TVN
6KaX1sgUJM61FqPquj72V3oCzMI42K/G+0x+yrhjGC2WU/o3nk9aUhuOxjKpOqak
oIhgZFI4pZhn9Id8ISNrkXPzvJUt+svj/wKW2jmSNnW8yGsus5KlNfj1uCOIz28Z
1cC+yCkfzG9hdzTAZdvhXkxzZov94/aoXzRMwzrc1LNvPf2CSW1zuSyqBVYu+2vT
SA5VmhBQQYAj+PyRfzMmpudyKTVlMxNVd/boK0gy6tJq6cB8MAN/24Qis6qCljfJ
PM2uxt8sYyqEhpb+3zsvhFU8XREyM7JC+gFbmYyuPiEL/BYUj1HRaHDvqAf3sR7P
l0KwQEYFim76dazLN4na0HX8HEIZst10L8uBnN0bjNajcTVp0gRnHpAxgaHNb2Ce
kmDFuEOdusPHhc0E3JRJMVmXcFT62jb38WUrQGMjwNbVSpRtvyC1SwjISB54rE41
t/cb5wLWU+d9XXWwCdYlcVfJzZigIVUbIIwK5Kjw/C0OW0dYAZk=
=P+8q
-----END PGP SIGNATURE-----

--o7gdRJTuwFmWapyH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
