From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next v1 02/19] rdma: Remove duplicated print code
Date: Thu, 21 Feb 2019 17:39:38 +0200
Message-ID: <20190221153938.GC23561@mtr-leonro.mtl.com>
References: <20190220072136.3840-1-leon@kernel.org>
 <20190220072136.3840-3-leon@kernel.org>
 <c6f27ca0-55d6-4d3b-e498-ed700eb00844@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c6f27ca0-55d6-4d3b-e498-ed700eb00844@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2019 at 10:23:01AM -0500, David Ahern wrote:
> On 2/20/19 2:21 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > There is no need to keep same print functions for
> > uint32_t and uint64_t, unify them into one function.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  rdma/res.c | 22 +++++++---------------
> >  1 file changed, 7 insertions(+), 15 deletions(-)
> >
> > diff --git a/rdma/res.c b/rdma/res.c
> > index 6b0f5fe3..87865ec8 100644
> > --- a/rdma/res.c
> > +++ b/rdma/res.c
> > @@ -808,28 +808,20 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
> >  	return MNL_CB_OK;
> >  }
> >
> > -static void print_key(struct rd *rd, const char *name, uint32_t val)
> > +static void print_key(struct rd *rd, const char *name, uint64_t val)
> >  {
> >  	if (rd->json_output)
> >  		jsonw_xint_field(rd->jw, name, val);
> >  	else
> > -		pr_out("%s 0x%x ", name, val);
> > +		pr_out("%s 0x%" PRIx64 " ", name, val);
> >  }
>
> what's the plan to move rdma tool to iproute2's json functions?
>
> I realize rdma tool inherited this from devlink, but this command does
> not need to continue managing this.

I can work on this next cycle, after I'll finish to code some obligations
in rdma-core.

Thanks

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcbsY6AAoJEORje4g2clinlPMP/1JmbbUOh0rG7tpii5bN4MxT
rXMBrNsECetzSFc4fG61aTp2IXbPTkrcH5MnxFNyfU6DoFWhK+bQLj2fUOY2EXv8
4EZ2X9PJ2h9OUf1w1ftqkfDpwBrNvcNOt8gVgbi0bWpe5A+gdTyPNrSx5m6/9x6f
deEbvTJvN3JpIKTBRLGt/5lTy8lKgPDbp94nKNnWLIFZRT6Q4fAoXOSLllbtTL/T
rAfGMIDkdjwznjB2X8NrkUxX1f3AIwblS6Bd55Y8oKkCAxtNbPJmkUeX02He4KWq
lxojt1X+IHYQMsEXX42qEh63gNO7D/ojhKopGbLv89dZ+ykiEXXyxS7hkx1u/jj+
9Lx3YPW4QIwPJlT93WixgBegjNJ4Y7NRjfHTw2/1lE4/e/TnXSIckde4AFy1T17s
Em8O9cNNiroedbnnaOHAQ356Q/xuGWywPDEnvQzp9FZD5Of5CWFAWRdAWg905qA9
+xtQdmWBGhQjRglhqn1CPKcDxRHMpPdYwxyc/LAHXp/nbQKT9KBysaMuSD6YuzUb
T5ok7b95JHJ0NdUUtt089YLxQMDVBfIMZAyarkBCR7Hsi8SZn0xYrJrDMPOr+uJK
EZhJPnVVLz/iK8WC0O3smJdC/efxrdwgTkMRYrXfpfP/+qT6Q7d9GWptCpNWkrhK
+ldSqF7frULxIHAtYy/2
=ei2+
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
