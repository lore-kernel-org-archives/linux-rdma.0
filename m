From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/hns: Use 64-bit arithmetic instead of 32-bit
Date: Mon, 29 Oct 2018 12:07:44 +0200
Message-ID: <20181029100744.GP3974@mtr-leonro.mtl.com>
References: <20181018080258.GA1720@embeddedor.com>
 <20181018110155.GH5007@mtr-leonro.mtl.com>
 <4bf459e9feb559270983530d2e3720e78a167b05.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4bf459e9feb559270983530d2e3720e78a167b05.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 18, 2018 at 08:17:10PM -0400, Doug Ledford wrote:
> On Thu, 2018-10-18 at 14:01 +0300, Leon Romanovsky wrote:
> > On Thu, Oct 18, 2018 at 10:02:58AM +0200, Gustavo A. R. Silva wrote:
> > > Cast *max_num_sg* to u64 in order to give the compiler complete
> > > information about the proper arithmetic to use.
> > >
> > > Notice that such variable is used in a context that expects an
> > > expression of type u64 (64 bits, unsigned) and the following
> > > expression is currently being evaluated using 32-bit
> > > arithmetic:
> >
> > And what is wrong with that?
> > Please fix static analyzer tool instead of fixing proper C code.
>
> Judging on the static analyzer tool's message, I don't see anything
> wrong with it.  The code contains a potential unintentional overflow
> error.  The author might have been well aware of the overflow and not
> cared and in that case this is valid C, but the analyzer has no way of
> knowing that, so it flags it for review.  To silence the checker you
> could either cast the arithmetic to u64, or cast length to u32.  Either
> would clear up the ambiguity.  I guess I'm not seeing why you would
> blame the static checker in this case, it did the best it is possible
> for it to do.

You are right, static analyzer tools have no way to understand that this
overflow isn't possible. I was over excited to go to my vacation hence my
response. Sorry about that.

Thanks

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb1tvwAAoJEORje4g2clinayQP/R70uw4wTtRmMPCkAZCm75H0
nyENuFu+rQxYOy+08ebBtp1b+jBfstb/fUR3/Qwy/bbORPNnomeD/aZM/fR4pRmc
ZEeRpMh666+9d4ZJ+VW2x71n0X+rQvE+tG55au75Bxl4fh/vKKWX0GjMlyo0lwBv
FpJ+5rn372QBiXo71wfVq3HtAU1Hu+wkqNY32pMQkko/YbsI+zyaX7YNo+214qD9
tNUEgk4uzZH0vTvnQZt0C+8KxSJBy1Qsatj+G1XfPIXfgXfSq/jqsV0klaSo4zpl
QaXo3l3738IvUrJbEOGEBRDGlnmsG6TmiNHMQlcupgwKGbi1pY2beVW1vTJ12s36
/88y8r9TjOFHikEM8Gv6in5Cw6v61iVSbqiTsMPRRgTy7C2iIxrIwSx6cqYzcQk8
aJguQqDlzEJW72JYSxo0/rDzD3aP+OMyXPvp5YiHbBK9UbNSZrx2bK9g1222y2Bd
UTtCkBuIIrQfJGT8Fk9ZyCdVk8bu8p9Gsvvm/U6mKdbtUR/jIJinyGdTUoyhNSUi
zeuQD+FzLdkgbL+NZWmN7JmzQuygjAQp3wXfn6l+D/DxQL+T7AcnzSI3Uly0S1sl
iodzUYEfYVHi22gIyGKo6fZ5wyByXD2VBrwF+aoWD4Fjpn6oLAqb7OQd4Up42ED5
jDbEgNcsCaVK66PfgwKg
=4bu2
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
