From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] rdma/core: Don't dereference device->get_link_layer
 directly
Date: Fri, 22 Sep 2017 22:13:11 +0300
Message-ID: <20170922191311.GV5788@mtr-leonro.local>
References: <1505908483-29641-1-git-send-email-sagi@grimberg.me>
 <F3529576D8E232409F431C309E29399336CD902F@CRSMSX102.amr.corp.intel.com>
 <20170920134723.GO5788@mtr-leonro.local>
 <1506101002.5172.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jPC/Tkukgh9ZDT79"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506101002.5172.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jPC/Tkukgh9ZDT79
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 22, 2017 at 01:23:22PM -0400, Doug Ledford wrote:
> On Wed, 2017-09-20 at 16:47 +0300, Leon Romanovsky wrote:
> > On Wed, Sep 20, 2017 at 12:33:39PM +0000, Estrin, Alex wrote:
> > > Patch for this issue was already posted about 3 weeks ago.
> > > https://patchwork.kernel.org/patch/9932505/
> >
> > Yeah, exactly.
> > I had a dejavu while I read the "crash IPoIB" report.
> >
> > I assume that it didn't make to Linus, because it was posted after
> > Doug
> > went to vacation.
>
> I wouldn't call it "vacation" ;-).  I had no internet as I was moving
> homes.  It was hardly the peaceful, relaxing experience one hopes to
> get on vacation! :-)

Nowadays, every day without internet is called "vacation" now :).

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--jPC/Tkukgh9ZDT79
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnFYMcACgkQ5GN7iDZy
WKddpA/9HwJkABoqS+er14NTUe9D8litUgsnhqtzJsRQKkwuDe4ybTIVNK4cdf9E
GJWy1pbMb10tpRS0PhFVoFQT9agPmetox9zvnf+OtcdXOL/i6hj8ZJW961f0KYVx
2qaCp3um+YfdiBOxRO8vslJbEtJJ5L0lveggmrYQmc4DDtq1vtIPpbODamnEs4He
yxRtd6kB2KoxgGBogSA2F0DmMKVetkj0468cv4hSVJOLdVp/JAGfZDprrLYaAIx6
ueVuw9jbs3fXzXVNzgsq01nvc8KDvXwSCYgQnbgFubvawC3ywscWzIlcO80c50Mi
DXmg+BjaUofmkq35xPmZcH8quIjzRQL9DzNcnA454LyzlxNG0r0owtPavGyrLWJL
lYBJkFcbd0LvrkWW8yyMlCn74Ph3XYFaivutU8TGSrC72LQpfOPDDqHE8xw7LTFT
eEWdU7cQaKMMiHxaTyxFoREAHeDGZxZXPto4cqLdRjYkUPrKlOXDe8zkopw+9Q0K
fw54z+ZCejQXO0iSes5vVE5k2ATYsqZ7AVDdebV21+8o3jTPk3UYcEkASbO8bNRP
st76xfkCtO1g9DIfJ5dd/Kaeh04QXpz/z+++94FhPjOObsbdni6YORCD65C9S51W
Mf3A3Fy6XvHPOU+m7I2cP01R7FQPqKGWdBpJ1nYcLzFEzXcXIhw=
=78nC
-----END PGP SIGNATURE-----

--jPC/Tkukgh9ZDT79--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
