From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next 3/3] rdma: Add an option to rename IB
 device interface
Date: Mon, 29 Oct 2018 12:30:46 +0200
Message-ID: <20181029103046.GQ3974@mtr-leonro.mtl.com>
References: <20181018115120.17893-1-leon@kernel.org>
 <20181018115120.17893-4-leon@kernel.org>
 <c1896e09-2081-858a-70fd-6fe9c998efa0@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c1896e09-2081-858a-70fd-6fe9c998efa0@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 21, 2018 at 10:02:43AM -0600, David Ahern wrote:
> On 10/18/18 5:51 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Enrich rdmatool with an option to rename IB devices,
> > the command interface follows Iproute2 convention:
> > "rdma dev set [OLD-DEVNAME] name NEW-DEVNAME"
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  rdma/dev.c | 35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >
> > diff --git a/rdma/dev.c b/rdma/dev.c
> > index e2eafe47..760b7fb3 100644
> > --- a/rdma/dev.c
> > +++ b/rdma/dev.c
> > @@ -14,6 +14,7 @@
> >  static int dev_help(struct rd *rd)
> >  {
> >  	pr_out("Usage: %s dev show [DEV]\n", rd->filename);
> > +	pr_out("       %s dev set [DEV] name DEVNAME\n", rd->filename);
> >  	return 0;
> >  }
> >
> > @@ -240,17 +241,51 @@ static int dev_one_show(struct rd *rd)
> >  	return rd_exec_cmd(rd, cmds, "parameter");
> >  }
> >
> > +static int dev_set_name(struct rd *rd)
> > +{
> > +	uint32_t seq;
> > +
> > +	if (rd_no_arg(rd)) {
> > +		pr_err("Please provide device new name.\n");
> > +		return -EINVAL;
> > +	}
>
> This is redundant with rd_exec_require_dev which is the required path to
> get to this point.

Sorry for being slow in response, I was on vacation.
----------

This print is intended to warn about missing "new name" and it is not
checked by rd_exec_require_dev()

To emphasize it:

diff --git a/rdma/dev.c b/rdma/dev.c
index 760b7fb3..468ae686 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -246,6 +246,7 @@ static int dev_set_name(struct rd *rd)
        uint32_t seq;

	if (rd_no_arg(rd)) {
+               pr_err("hello world\n");
                pr_err("Please provide device new  name.\n");
		return -EINVAL;
	}

Produces the following output:
[leonro@server iproute2]$ ./rdma/rdma dev set mlx5_0 name
hello world
Please provide device new name.

So how will we progress from here? Should I respin?

Thanks

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb1uFWAAoJEORje4g2clinxKcQALeH1XeJkqDrdH63fPj66OA+
5xM21hdHGzs4q6kc53KhTnqH2lc2LthmgzbFeFP2BCXhVBgzh0xIJvz5ocwCbosx
DTuqRJFgmXuPNjFQyVWmWcNlW4iKkP2dxgWsS94Bn26glA9c+aAxzuiDQ0VSVI9x
az0toHgDiZpnj1J+S40Z/mirLH+ypP92i5wVyOdqm2b4fBAGertzEEK0tO6KA4dJ
i1/7urXxKeDUkvmeHMIyhMgHo50Pw3JUjXzJUP6ie+tNYeriT/TAm/wkuW8B2grK
I3rJRkU86GinojBMkhcviFsz4/XmoivJK472YX0cd04QjidzyfwjGepIDAtXqe1e
g/AcpXV7JyZ/4Oh9ar8D5WIXyWZFAHMNMJhjhPgcJEaUZQtovlFQkeCyfRFiBfm4
8H13gXouUGPV90jky/pFjwHmWsk4WfOInBeuPhREl3raMNszQoA7hWGC3MOAlHT3
0npPfyq+nQGazKPL6LPWjOzvQGIq8oLJeaUVK9qT5hfsYPrtyC4sOR0O2jR7AIfN
0lZkYRCyhOf4GKoUCXae7EbHTd0KwWb39Vr3gQCAtmWeX5AXYaiHm0Gk739Ywson
67zG386l7AyKroRNtZvOvAyg4+rYW1LIGuSjqnglrRppA073aA/nfogXHQQFiZUZ
gR272CnvcNiDdYQoFl+S
=jKZ2
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
