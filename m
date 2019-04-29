From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [GIT PULL] Please pull rdma.git
Date: Mon, 29 Apr 2019 21:00:55 +0300
Message-ID: <20190429180055.GX6705@mtr-leonro.mtl.com>
References: <48cbd548d153d1d2a1cf6c4f2127a6cef5d55deb.camel@redhat.com>
 <CAHk-=wiYHXxkHrbDACc1-5bqJPuiMnmwbStSYBYo82zsO=gstQ@mail.gmail.com>
 <a532d88432b2fd581d39faf12ce3c3c31015b45a.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a532d88432b2fd581d39faf12ce3c3c31015b45a.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Gunthorpe, Jason" <jgg@ziepe.ca>
List-Id: linux-rdma@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 29, 2019 at 01:13:01PM -0400, Doug Ledford wrote:
> On Mon, 2019-04-29 at 09:48 -0700, Linus Torvalds wrote:
> > On Mon, Apr 29, 2019 at 9:29 AM Doug Ledford <dledford@redhat.com> wrote:
> > >
> > >  drivers/infiniband/core/uverbs_main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > This trivial one-liner is actually incorrect.
> >
> > It should use 'vmf->address', because the point of the ZERO_PAGE
> > argument is to pick the page with the right virtual address alias for
> > broken architectures that need those kinds.
> >
> > I'm actually surprised s390 wants it, usually it's just MIPS that has
> > the horribly broken virtual address translation stuff. But it looks
> > like for s390 it's at least only a performance issue (ie it causes
> > some aliases in L1 that cause cacheline ping-pong rather than anything
> > else).
>
> That's what I get for listening to Jason ;-)
>
> Well, since you have just essentially re-written the patch to be
> correct, you are now the developer of origin.  Do you want to commit the
> fix directly or shall I respin it for you to pull?

Linus already committed it.

The whole breakage is mystery for me, the patch which introduced
breakage, got successful build report from 0-build.

Thanks

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcxzvXAAoJEORje4g2clinNg0P/04kAMArpOP6S4eKNROZLfoO
wgoAQXtUOrLXPlcEmi4fbZ7N254b/PxHaXx0PAXu8xdnGZ263KYByRbzTK4WqWH5
RpPEdQGbi1wwGBxnycsxhubJBFZxjULjQNivOBEq1tpQ8jjgBsIp1QfmX5j5Vq+P
TexksU4wpTs4/XEaJWwEaThHeVnk/wW4W7MeSc52qkgU0UI1V2ziuaMOneZ4xk7j
2F4QsyCV4dU2VWYuu9Y76e14sQ8nKV7cvL5uTfiQ6Y9jhTKwnLJGQWCbR+gM2pAf
s9b/U9l/izJwjD+P1U+bwAjLZEJv5SzXziZuzSnRzYi8lkaF9lC4Crz4LSHDNcPv
pX9ooUfMDBAczvSG2wDUhhohSB4cPBu74ZkOO4u7aWq6tM2XzE0VFqErSQJ80wIk
6DRNqrtR1l7z50lrSbSaRcG8UpHZDScsPBk88Fw5HDDuptZqMnZz6dwXekDbNdNT
R4VO508NMLIVlfpkjHc5Qs0ieeiclwt4NQt+PpkR02lm1U443hQFGViVsHZD3mQU
8GppR/rHJRX0aUUEaFVDhQkkwud85cyUQVtkqSCPW0oK1+TpGEKwV6R80Pe+MBwC
LPCHK9Pn3hK1aiFXOYkc22LT3ubG+Ga081c0PqUH8toCCveXBas11u2Q/eWvVW5D
yzkWI2tDNdY+l99ak7s6
=5kYY
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
