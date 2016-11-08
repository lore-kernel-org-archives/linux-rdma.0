From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] libhns: Add initial main frame
Date: Tue, 8 Nov 2016 14:54:41 +0200
Message-ID: <20161108125441.GB27883@leon.nu>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-2-git-send-email-oulijun@huawei.com>
 <20161026162053.GE24898@obsidianresearch.com>
 <5811776F.20908@huawei.com>
 <20161027145139.GD6818@obsidianresearch.com>
 <58130573.4010902@huawei.com>
 <20161028164030.GA17289@obsidianresearch.com>
 <5813F869.7010606@huawei.com>
 <20161107231532.GB7002@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161107231532.GB7002-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 07, 2016 at 04:15:32PM -0700, Jason Gunthorpe wrote:
> On Sat, Oct 29, 2016 at 09:16:25AM +0800, oulijun wrote:
>
> > We hope that the only one userspace library file named
> > libhns-rdmav2.so will be used for the different hardware
> > version(hip06, hip07, ...), because there are only little change
> > between their userspace drivers. So we need to distinguish hardware
> > version.
>
> I guess that makes sense, but you still need to be able to parse dt
> compatible strings that are lists.

IMHO, it can be easily done as follow up patches.

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYIcsRAAoJEORje4g2clinFY4QAKi4FG1TaI4KgPKtO6kaOb8u
DhUm8xSvnzmS9PBiS9OmtZQrNM3SH5GbUDNKgmt2q0/tE2G5neKhTST/tDrgpVTO
OL0emLfXiMnc55x0n/FhrXvL5cB+ewoZLPt1Bb9krsYHcwU2rZbB4alRTupa/hty
ByQtjfhwWs5Rpp6XjdtyxcV1W4eyKGCfdupWOVoRliKr8zNR/WFBPaOjCZdYHMJ9
KU29yGBCS3ZJ+tkWZff6tSqYgGY0eqAyF6QIr1HE+QquGH17kR/LrzlYLT5JFtt3
q0e2RIfzEp04//+ovMJBM+mnZjl38zDtuUEyQjVjYBT+AwRLoM8+5APomjp7zeF0
vhJ0BtnX5oYmOfv8375fwdk15lpJ7VlJx72XsFo/oPnvlsrAT+awJdxaLuQvtefW
KxIzhUiVeszQ9CLm11Hi0XwcvV1ffvxN+9gXEPAgv+D8fa096JyeV/d1S4KAnw1H
9dL9udkqlat4kGWjSERwwmtwffsWIO7OxCNC8PdaVSdZW5HnCenZt9N60ph368JB
pgQvZPYULe/0E0nJPGF1Nwli4vIKdCHC3W+7bzapK310M8R41d2LOz2VXM/OBjAB
lgs5bw7sA3yWLzl7+bMU+YlbIDuVSXUMD/5USqmPlksOMGp+bpUS5u+IWr/KVsYk
Q0NyH+23AXy+UvqbFG4V
=ixKx
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
