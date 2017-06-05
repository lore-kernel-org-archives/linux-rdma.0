From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Mon, 5 Jun 2017 07:00:30 +0300
Message-ID: <20170605040030.GG6868@mtr-leonro.local>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <1496261429.2608.15.camel@sandisk.com>
 <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
 <20170604053635.GD6868@mtr-leonro.local>
 <20170605022313.GB18172@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GLp9dJVi+aaipsRk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605022313.GB18172-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org" <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GLp9dJVi+aaipsRk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 04, 2017 at 09:23:13PM -0500, Chien Tin Tung wrote:
>  Sun, Jun 04, 2017 at 08:36:35AM +0300, Leon Romanovsky wrote:
> > On Fri, Jun 02, 2017 at 11:28:49AM -0500, Shiraz Saleem wrote:
> > > On Wed, May 31, 2017 at 02:10:31PM -0600, Bart Van Assche wrote:
> > > > On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> > > > > > 5. I proposed a solution -> go and fix your user space program.
> > > > >
> > > > > This is a kernel patch you are trying to revert, you are breaking existing
> > > > > kernel functionality.  Nothing to do with user space.
> > > > >
> > > > > Bottom line, come up with a solution that will address both port mapper
> > > > > functionality and your issue.
> > > >
> > > > Hello Shiraz,
> > > >
> > > > Sorry that this means additional work for you, but I agree with Leon that
> > > > user space software should not assume that netlink sockets are a reliable
> > > > communication mechanism.
> > >
> > > Hi Bart - Thank you for your response.
> > >
> > > The original problem was that ibnl_unicast, which is used to send nl messages from
> > > portmapper kernel space to user-space, would occasionally and momentarily fail under stress.
> > > We could have retried the call for a certain amount of time, but since netlink_unicast has a
> > > nonblock/block parameter, we chose to use the blocking option with a timeout. So we thought we
> > > did account for deadlocks with this timeout.
> >
> > Not really, you just reduced the chances. In very large scale, you will
> > have a very large chances of such deadlocks.
>
> Please stop using the word deadlock until you can prove that the deadlock exists with the timeout
> in place.

Can you please post the whole list of forbidden words? It will be great to
have it accompanied with technical response to my and Bart's claims, and
to summarize it, it is very simple: "netlink receive should be
non-blocking and asynchronous".

It will allow for all libnl functions, like nl_socket_set_nonblocking,
nl_recvmsgsa and nl_wait_for_ack, work correctly with ALL NETLINK_RDMA
clients.

Thanks

>
> Chien
>
>

--GLp9dJVi+aaipsRk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk0114ACgkQ5GN7iDZy
WKfM/RAAq9HegcrCbaFc3zWpg5d7WZ4nKtjnf02bWSEuuyQDnIKTiJ+WuP34EezR
rUNfuwIWPNHzi9ptvWVIQXum0liuK6r/NBykSRzGcU5BKbT2DA/RCy7nmYlzxNOW
1guvBJGA48z/8qZ6DZWM5ud6CiHStt5oQG8n7CV/C0zmLhGbhC+aOuplvLnj3wR/
j9kdpZxV7RrU8c6hD1y6nX0e1yI0Y/gK9I22X913ypzaE+VXQKvvYh16QbNocMs/
m0ZjUkue6kemqs5ixNVtB/sRXLszUicI0kGs9lMvJQtU1dvxK9Ppf+6IDj3KsQ2f
EIZ6mXVSE08OQEbtcHHANA2dzCkgR4xYwyYdm1V4XHGgJLGIgEga1a7QhrBVc1SL
VGtE/sNsrkEF6S1w1pejknFmnRptwt9pNn37OYLrqrFOd0CyTfwK8GIPds38kbHu
x4jg3i2vLsOuoidYcEY1PR9NINxGKTY/1+/TcUwlzRqq+E47rpxOJFQQrqeyLxfM
6TX1KvBsLHYfriK5o9mrGQMNKHSm5Z6Fue10+tZPZqz7y1Z1qg0xVzNV9q6Ax8K4
6KdeDvMDXQbpLz/JEfy4U0SuQ++/+FHM5XvUX6wBrGSTcbRg8r3TL7nTPMLduxnG
0NlaIFc9fdwTQjUTZjXlKe+mKZoQ3tW3NkjiXdhcOwm3S+ID+hQ=
=x9cC
-----END PGP SIGNATURE-----

--GLp9dJVi+aaipsRk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
