From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libhns: Update the size and member order of
 hns_roce_create_qp structure
Date: Sat, 30 Sep 2017 19:05:15 +0300
Message-ID: <20170930160515.GG2965@mtr-leonro.local>
References: <1506761477-47350-1-git-send-email-oulijun@huawei.com>
 <20170930154518.GA14152@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DNUSDXU7R7AVVM8C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170930154518.GA14152-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--DNUSDXU7R7AVVM8C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 30, 2017 at 09:45:18AM -0600, Jason Gunthorpe wrote:
> On Sat, Sep 30, 2017 at 04:51:17PM +0800, Lijun Ou wrote:
> > In order to keep the size and member order with the
> > hns_roce_ib_create_qp sturcture of the kernel driver,
> > it need to update hns_roce_create_qp's structure
> > members. Otherwise, it will run fail.
>
> What?
>
> Did you break the uapi? What kernel patch does this match with?
>
> Generally structs in the u_abi.h headers cannot be changed like this.

Jason,

It was my suggestion to change rdma-core, because before they tried to
change kernel.

https://patchwork.kernel.org/patch/9975329/


>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--DNUSDXU7R7AVVM8C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnPwLsACgkQ5GN7iDZy
WKdY9xAAn58ey0LL/zqL5iG4jB8q7qhPl247GAEck3A7rkqhnoSnux+OjW84JM6r
RSgbT+qb1BzgLNNs9v88YKVlZvrY5My3GpdFf++QgagyAf+oWRz2DcK+Mz0xbdL9
jnow2VrcehufnWXxCBh/H3XztMPbytVBfp0v7wSm41iiBOTkf9J194ZyiBfk8H74
ImW5FMbgJkJnRaYOPCF+ege4mE7IXwHF5DY8ztOzvNFE25ZV7abu0wwsvZjgOclB
FezPaQ03h9NkMBD0f0hOIU1JQkYPgwW09tQAdPq7vrrUYGynG0wWVw0/f2duojm7
B+srbqc6IDRue8SE8RAeY0tEU9Ky5XYn+Xy2rlhgLRSKSVCokUWhbHVAyEEnJPJV
zCxoS6Qm2FJ1K/Q7j51oSCQ4W2ZYumHNhG3qNUngWAvbf6JcIbL+Ahd1+gh87BI8
3LzHVan5o3uBhCoyUdFdUlRTxlcDTjY8iLdlCRFirDN/5qAyC2VDNlP+ZoqtWo7G
YM1nBP/CrhJ4QsW4V0NFnAIVY6RDJEvoljTxP6QoWqETIEE2VOdMwo0hlWayWn+w
oeuQF/F1xw48EI2ELSiTUR1PYuH/aSWVC7jP6d2Xp1+Nw9lc0HV49nsZq8hsAMyF
uAkYrjLP5RtrNK/ignhcNBE58qzQCHc3IdP3+JzR52OoJsY3Ves=
=MOhI
-----END PGP SIGNATURE-----

--DNUSDXU7R7AVVM8C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
