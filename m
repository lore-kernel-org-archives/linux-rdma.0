From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Mon, 5 Jun 2017 20:08:25 +0300
Message-ID: <20170605170825.GP6868@mtr-leonro.local>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <alpine.DEB.2.20.1706051141230.26831@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wmhq21yAGFMoSpeN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1706051141230.26831-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--wmhq21yAGFMoSpeN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 05, 2017 at 11:44:00AM -0500, Christoph Lameter wrote:
> On Wed, 10 May 2017, ahmad omary wrote:
>
> > We have considered using mmap(), but As the size of device memory may be limited
> > ,the way to access it from host cpu may differ from vendor to vendor, due to
> > the 4K (page) aligment limitation of mmap() and the need not to directly
> > allow user to access the device memory, there is a need for a wrapper access
> > methods API that allows allocating and managing chunks that are smaller than
> > 4KB and not necessarily aligned to 4KB (page size).
>
> Why are 4k sized chunks a problem given that there are megabytes of memory
> in these devices? We are using various adapters already with an mmapped
> solution here.

Ahmad presented use case where he needs access to small objects
(semaphores) in large scale (MPI). 1MB in the granularity of 4k will give us
256 chunks only, and it is definitely not enough.

>
> And I would prefer direct user space access to the memory. Fast access to
> the data stored in the NIC is important and it would be best not to have
> an intermediate layer that requires memcpy.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wmhq21yAGFMoSpeN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk1kAkACgkQ5GN7iDZy
WKcCnBAAoJShYkj/v6BxNBVgN6kqc8t9sKEwYIt2KztZsV3ei1r/RtsVG6IL+4Zj
z3dyqmyuh9NNXetEbv/mjASqpxdNazRr2Gu7qKlw6ykXItgo6b+iChE7tl03qbJ4
NLENJNvLKC2uOe4HoS3/GYLLpI8Vzxc8n10VfKmq4X5Nr17ULe/Kj0Z7qru7KTc6
OmjuXtWv6xtRjgLzp5XKO3Jqz/otnoqfubg8kWDPQ+u1iQdgZzmtQl2m2TtlaCvG
kTDSzcXIFQnCQHDIAga6SIFhHJDedJmFA787ysDNO8/3inZCMetKyWb+xm0SoaSJ
HcnHxLFGLEb0HITDLoR1wL81V4x1JBddWRVm62To/g0vZ8so6IAOZXrB5Jy7XOxk
aiFN0hreVmiSh2mN98J21wF5ZKcMpX7SJjqW1OLIKDv3by3jzl+5x2WsuwcPW1Ry
T40CaVKMU57gsy4psW0v1L2uaGGjRCsh9S4LMubZ252IYijVBxxe9Faq0lq7Gg1D
elUq5kR0Qif5Gv3lb5yCF/Tk7Kvf5D/0bmg05JMZrAc5HpPyW96xi/QHKBz0BjqY
PfOnHr1Qdx76uaBYAxPrKhek7yyNcsAGU9nj6usUKYIlJHzZhu4wQCL+E8zaFX00
ZDn8qfG6OemosNF7rvrQMF+k1c8kzDVVtciDm6acwEOmNiMEfhk=
=p4E9
-----END PGP SIGNATURE-----

--wmhq21yAGFMoSpeN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
