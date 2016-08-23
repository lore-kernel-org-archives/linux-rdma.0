From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] IB/hns: Fix return value check in
 hns_roce_get_cfg()
Date: Tue, 23 Aug 2016 13:59:26 +0300
Message-ID: <20160823105926.GG15065@leon.nu>
References: <1470445284-28970-1-git-send-email-weiyj.lk@gmail.com>
 <20160807053115.GQ27667@leon.nu>
 <087f4381-d830-fc57-ea5d-c516a1b160b5@gmail.com>
 <20160807131419.GS27667@leon.nu>
 <57AC56D4.3050401@huawei.com>
 <c27a3c5f-9604-546a-5ac7-e70613d93d50@redhat.com>
 <57BBAD65.6000108@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57BBAD65.6000108-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2016 at 09:56:53AM +0800, Wei Hu (Xavier) wrote:
>=20
>=20
> On 2016/8/23 2:15, Doug Ledford wrote:
> >On 8/11/2016 6:43 AM, Wei Hu (Xavier) wrote:
> >>Hi,  Doug Ledford
> >>
> >>   Can you give me a suggestion that what we should do? Thanks very muc=
h!
> >I still have a branch for your driver, the hns-roce branch in my tree
> >(only available via my github repo for now).  Now that Dave Miller has
> >taken in the most recent patch to add the needed reset function to the
> >hns net driver, I rebased your branch in my tree on his net-next branch.
> >  I'll submit it in the next merge window.  I then applied this patch on
> >top of that branch.  So, future patches to your driver need to be
> >against my hns-roce branch in my github repo, at least until I merge it
> >into my official k.o/for-4.9 branch.
> Hi, Doug Ledford
>     Can you provide us your hns-roce branch in github repo?

https://github.com/dledford/linux/tree/hns-roce

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXvCyOAAoJEORje4g2clink2cP/i/cl7kXQLLRERRWIDo+rBzU
72kWbnSDu+sp/DA/lYzj0XDV+6cszKebLKY6gxyubI4bfH5ghk9xJcpqn/hZ4lcn
YHqyGx/LbyUhhJFkrhXPDZU5ga0Cl5jQGKD5nd6PjRM475aQ8od1UIdI4rf5SPsy
zQEYDtWmYQpFGUMvjRmQIMQzY1tnLBexmZXaYTP3BqLxWpcO8N1ZkXPCgaEFPJSv
biOKRYZPSiQfDsbifTLuiAyQ1ujNQYv/j68G5NQ5etwtU5vUuBXhWJRwHOxcvM64
EYSoWp+oXy5M4KNOAdUHXoUp3UTg6R+YjxyYNaJ1iG7Cke45FidllutiNEMqLhs5
lIcDOm/5sPJUpqCBSTKiWcNrB5aEHIoFAzxHbCiRBa10AW1nQT1dfm4RuSlAbEp8
B4OEuMWfzmWOKsQaoWRvdV/pHs7kkTaDVAK2DdqHwTu7iUvGHDa2Ne5O54vPa5Bg
RKaa3gW7H8vLC8BJXLRYmMkIa0XGEwQECh/ziBk7yYisWTa9wPeMVad3MgQxOsUQ
oRJjkB/wqCj9rYKfHTPGocfGriJVmBKL9y/7LfqGelBLWt903XVBrwdPqjTVcion
65Yi7qvMHqQjRZVhMR/txTZflPPV3i+hsG0zRTdQYOO06jWsmF0fyNXAf9jEW85H
01BQXNZkNkvA3K4S1NSF
=UVsQ
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
