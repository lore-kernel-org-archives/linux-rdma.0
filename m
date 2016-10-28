From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V5 07/10] IB/core: Support getting IOCTL header/SGEs
 from kernel space
Date: Fri, 28 Oct 2016 18:33:06 +0300
Message-ID: <20161028153306.GO3617@leon.nu>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-8-git-send-email-matanb@mellanox.com>
 <20161028065943.GA10418@infradead.org>
 <20161028151606.GN3617@leon.nu>
 <20161028152138.GA16421@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yLaBmHMi4cq+C/u4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028152138.GA16421-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--yLaBmHMi4cq+C/u4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 28, 2016 at 08:21:38AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 28, 2016 at 06:16:06PM +0300, Leon Romanovsky wrote:
> > And it is indeed happen for new code. This magic is needed to allow legacy
> > write interface to be converted to new ioctl interface internally in
> > kernel.
>
> You just added these statements which are by defintion new code.
> Don't do that - create a clean kernel internal interface instead.
>
> The canonical one would be to only pass kernel pointers in the internal
> interface.

Just to summarize, to be sure that I understood you correctly.

---------    --------------------
| write | -> | conversion logic | ---
---------    --------------------   |      ----------------------
                                    -----> | internal interface |
---------                           |      ----------------------
| ioctl | ---------------------------
---------

Am I right?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--yLaBmHMi4cq+C/u4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYE2+yAAoJEORje4g2clinGWsQAJZwWKqPAKXT1tYT/RedWksi
o0z3gmpsbfztoMRN4/lZQ0CDLmzuSj+vSGPA7X0xTqF9pEK2IodV5Il6jnU4HeYa
8wO7gEPGh7zjEMZWO94sq+g0zmGcPxm7SWbccPB7GuwWMKgeNJ7hjq/FxLwJHo27
ZqTeWjK1hdh18nAb1pBB1M688ABROpCFudQuHCYyNMsxMOuMqfoWucWeegL+Jfas
WbNmFsaA9UgpF4U4Nu5kk+zDMiO3YuwSzk4EbLU02fsAjmd7sQ+pUmXdFbsrVHww
UjLBz67PJG5VJSrOshQUPwxG1DwAiejMCXGY+VC9fU7heQyXUVCJT7/ESzRQHrKH
E2djcs1CPlk53VCxDdsRyPyxzTX6DWjng7EMAU6Z2V2Ah7ZyRuPc0/uJlIyAvehS
PPMXrRsHfvuu/p/pqrJbCPgWHQ+c58wcu7uZMzFgpbNsofETmCyS+vrgwywfN9x8
CFc3Ahkzd/0QwyAHdMCfGfywSbHyogZyfZbudsQA7JyNLBP252HGKB/CuJ0cCZVy
NRT/Bg4SU8XNc2QD6YHqs2Sg2thVMpumIekr6n6YOB+ECPJqkMobk3ZkL9dNzIZH
E2kBq2dYjiJGdNuwDLO411RDjzyCY5iCQtWK2vuvIH9gIpgXmjU6W2ONN2FCckUw
psAhm3J/r25lYGwOfRdX
=ajWL
-----END PGP SIGNATURE-----

--yLaBmHMi4cq+C/u4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
