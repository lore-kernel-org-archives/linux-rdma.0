From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Why don't we always check that attr->port_num is valid?
Date: Tue, 3 Oct 2017 19:50:25 +0300
Message-ID: <20171003165025.GC25829@mtr-leonro.local>
References: <20171002113431.lqkf4ilmimjfouc7@mwanda>
 <20171002152033.GB12331@obsidianresearch.com>
 <20171003052159.GB26055@mtr-leonro.local>
 <20171003155606.GA12560@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171003155606.GA12560-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 03, 2017 at 10:56:06AM -0500, Chien Tin Tung wrote:
> On Tue, Oct 03, 2017 at 08:21:59AM +0300, Leon Romanovsky wrote:
> > On Mon, Oct 02, 2017 at 09:20:33AM -0600, Jason Gunthorpe wrote:
> > > On Mon, Oct 02, 2017 at 02:34:31PM +0300, Dan Carpenter wrote:
> > >
> > > > We deliberately allow invalid attr->port_nums if IB_QP_PORT is not set.
> > > > Why must we do that?  From a kernel hardening perspective it would be
> > > > better to ban invalid values all together...
> > >
> > > It is part of the user ABI, so it has to stay that way...
> >
> > Can we pre-process all invalid parameters at the kernel entry points to
> > ensure that drivers receive clean input?
>
> Which side?  I hope you meant the kernel side. I certainly wouldn't want
> kernel to trust user input...

Yes, Chien, kernel side ("kernel entry points"), it goes without saying.

>
> Chien

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnTv9AACgkQ5GN7iDZy
WKdCpg/+KvzPUW2u6fcoLJKxRXai3KERr+YtOXtfSxJo/Ncolia9a551jSJUwIA1
/B+F5DcjWtqJQYBszK5gMOeCnxlAAMxbo6qJnn55ArkjLKnGIGryJcBIWWu3ATdY
gQy5auGBFmE0yTd7e+nMLxV0osKL98Lq4YBbORQ/XxvZfz45ZkMI64ziAlTjbxDP
0DtrSw4SWJrDnjV4OX7tB2RKeZ/NKgEY3RvZK6QE2+cycjuOIxoU6uyZ6/eSAV1o
VltEBdHhpShYqrLYofEDxrK7+TQ9H735e0+/AG+INS9NSob1O30At82Nv4HLKczM
3h/jV+DefCctXll2FMcCXpTo251FHyB4i5RONJIN+gwg5b2ccY5FXzVLHPpqyYH2
yuQbZl6qvTH8NzD8TCbDe1ibW0DdSWIlU65yU9hepsbuaWec1nlvgVJtSXe01M6i
7j4zRMJ4Bcs6NasBKSZS9jcYILn3BFDCjRjHC+ouewSA8U8lJ7d41K+5IIC6MBeo
+ptjjOIk2v0JZtYVMCKErX5gGY3wr/CFh+2WXzpgICwsiePGGPMUWEo3cEV/jwhz
KTj6WBYpRTGvJAvUoUpzAnN8xDGibmwcRz2ST65hKdthqUuD6L1MsVJRNzUDjsQ7
JEMdBdrrVZfGR9/7v198G123lV/kXIGwy15+iGOZ/wcZVIXfnnQ=
=0CaD
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
