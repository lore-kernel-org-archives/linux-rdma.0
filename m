From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 14 Nov 2017 11:56:05 +0200
Message-ID: <20171114095605.GU18825@mtr-leonro.local>
References: <20171113144024.26655-1-leon@kernel.org>
 <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local>
 <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QoiSMj+lAls+FAFy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--QoiSMj+lAls+FAFy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 10:51:31AM +0200, Or Gerlitz wrote:
> On Tue, Nov 14, 2017 at 10:05 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon, Nov 13, 2017 at 12:24:32PM -0700, Jason Gunthorpe wrote:
> > > On Mon, Nov 13, 2017 at 04:40:24PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > CMA statistics were exposed to users through netlink interface long time
> > > > ago, but it wasn't exposed using netlink extensibility approach. The
> > > > current implementation was based on struct and not attributes.
> > > >
> > > > Let's remove it, before anyone is actually start to use it and prevents us
> > > > to write it properly.
> > >
> > > You should describe why you think it is safe to remove a uAPI from the
> > > kernel in the commit message.. When was it introduced? Why was a uAPI
> > > added with no users??
> >
> > I didn't want to invest time before I actually see that it is possible.
> > The purpose of this RFC is to hear feedback and see if anyone cares enough
> > about that code.
> >
> > The code was introduced a long time ago [1]
>
>
> missing ref

http://linux-rdma.vger.kernel.narkive.com/EMsWPDF2/patch-v4-0-6-ib-netlink-interface-and-rdma-cm-exports

>
> >
> > as an attempt to provide netstat-like information. It had simple demo application, which didn't
> > work for me
>
>
>
> what didn't work exactly?

Started from compilation, continued to wrong data presented.
There is no need to carry 7-years old code, which no one cares about it.

>
> This is UAPI, if you want to remove it, make sure to provide a good
> replacement and see
> if/what is the upstream procedure for UAPI changes/removals,

So, are you going to fight removal of DECnet support from netdev?
https://patchwork.ozlabs.org/patch/837484/
It is going to break user experience of Debian and Ubuntu 9.10 lovers.
http://retrocmp.com/decnet/decnet-on-ubuntu-setup

> I guess there is such, sending
> email to a subsystem list doesn't seem enough to me.

Maybe for you it is not enough, for Linus it is enough and for other
subsystems which removed user visible changes is enough too.
https://patchwork.kernel.org/patch/9788849/
https://www.spinics.net/lists/linux-btrfs/msg66769.html

Thanks

>
>
> >
> > before I started to refactor ib_netlink.
> >
> > Also latest fixes from Parav in the actual callback implementation support
> > my feelings that the kernel part is broken too.
> >
> > Is it enough to proceed with the submission of actual patch?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--QoiSMj+lAls+FAFy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloKvbUACgkQ5GN7iDZy
WKcUoxAAqkns9fMHPEwzmzp8k6kVYCaMRExcwGa/Qf6XTPthTINN685W7YzRNvvO
yLV/g5CVknwZe5ZKIm+pY1XMUe/9ZkVVAfH35ssZkSgH7vFz6FjUGzQgC/mpWZq6
Lg8jpgINxFZIDtfsseVQh+RlfytvvdMFKUS89ZCGQ5M1kNeYNBA7QQ4huyEW8Z9k
6G7oAFjt57vSfrfCH8xvtoxVAISJf9XAhgzXTtAPMBF04skjKcT21OHwfmwlVznp
OHoiZ1YsIiYgFkwsjjVxtHZG9tMhCGN1POtQgreOFQP8TgC2qJVgruVrloag0JgR
CnC7rf/BIBh9zxSgA76XVWo1UmxoCoAcF5UDdaTXUCgwAqtnuz1kKka+kzAc7Ha9
E51SUKqiyPOsR9Mr6ceILZOMW1KQCh51kNBNns1IQcRCfq4fEHon+y9HVpvCtbGv
LwNMX3EnI6H1/wVObucsNfU3spSc9ALq5C6kbVv8Vpc4kYwwkIFA2m8vPtdK9Jhl
bP3uY2yW8j748r2xJ0ZQfqcaaHLFWH/NWlFivBgb4hmxQwIxALccN0cozTPBFA1I
DvZ9UZAIKVNe84odAH1ZbEjPXO5l9cChr/DGAGcIFyccMTZDeBwhkqSDIltPwQO+
EKRzvjjb/13T6+IBF0nYFPZXCr+ny3JX5ai0X2zzO/BQa5H6Q58=
=xEHf
-----END PGP SIGNATURE-----

--QoiSMj+lAls+FAFy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
