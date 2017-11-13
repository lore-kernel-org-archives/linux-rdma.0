From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Fix request completion holes
Date: Mon, 13 Nov 2017 17:10:44 -0500
Message-ID: <1510611044.3735.49.camel@redhat.com>
References: <20171108100616.26605-1-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-zRk3TFdNG5bRraO2Zc5B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108100616.26605-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-zRk3TFdNG5bRraO2Zc5B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-11-08 at 12:06 +0200, Sagi Grimberg wrote:
> We have two holes in nvme-rdma when completing request.
>=20
> 1. We never wait for send work request to complete before completing
> a request. It is possible that the HCA retries a send operation (due
> to dropped ack) after the nvme cqe has already arrived back to the host.
> If we unmap the host buffer upon reception of the cqe, the HCA might
> get iommu errors when attempting to access an unmapped host buffer.
> We must wait also for the send completion before completing a request,
> most of the time it will be before the nvme cqe has arrived back so
> we pay only for the extra cq entry processing.
>=20
> 2. We don't wait for the request memory region to be fully invalidated
> in case the target didn't invalidate remotely. We must wait for the local
> invalidation to complete before completing the request.
>=20
> Note that we might face two concurrent completion processing contexts for
> a single request. One is the ib_cq irq-poll context and the second is
> blk_mq_poll which is invoked from IOCB_HIPRI requests. Thus we need the
> completion flags updates (send/receive) to be atomic. A new request
> lock is introduced to guarantee the mutual exclusion of the completion
> flags updates.
>=20
> Note that we could have used a per-queue lock for these updates (which
> would have generated less locks as we have less queues), but given that
> we access the request in the completion handlers we might benefit by havi=
ng
> the lock local in the request. I'm open to suggestions though.
>=20
> Changes from v1:
> - Added atomic send/resp_completed updated (via per-request lock)
>=20
> Sagi Grimberg (3):
>   nvme-rdma: don't suppress send completions
>   nvme-rdma: don't complete requests before a send work request has
>     completed
>   nvme-rdma: wait for local invalidation before completing a request
>=20
>  drivers/nvme/host/rdma.c | 125 ++++++++++++++++++++++++++---------------=
------
>  1 file changed, 70 insertions(+), 55 deletions(-)
>=20

Sagi, are you ready for me to take this series in?  It seemed like there
was a question as to whether you might want to try atomics instead of
spin locks, or do you want to stick with spinlocks?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-zRk3TFdNG5bRraO2Zc5B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKGGQACgkQuCajMw5X
L90pvg//cRktPI7rW4rySMIfQBR8aIfW7U9yAjUgOiO/v0Oz/QhHp/fjtzS9eiWv
QAl1CsSujCrb8Wlhrw95VwNeWhErtLWty1JxzwoEMUbqwQkzj+tOscUJwm4FVU9b
yEKj0RmSargYpcyAHo5O/N4FtyhycHiGyb/BYyPVioQwzmVy4BbpwCqp5elvgYsY
BqCE2T43zTaZCqgB2+uHoVXKvUydxJ/n6QUX8mkULyznwowzEm/C9NFdIcUAM1/m
luFPj/QWtoShpi/zBfnqIAjIvtQ3gwqcMGr1EmjWq9Q9l/tEQtHutJleBrtzIe0w
7jpatW9WpSWqNxOznUIftXI3xyB6Wty4bGX7iocmyc30MVEwX0rTcHSUpYk0Eco2
BVCEziboKZALNR6FRwzY0VUoiHoBU5Ca2DKDzXLcJMrxznfVHaRlHQLbXn4PfiU4
NYiv4GBFwKyAysgVqxgmDguk3M06Bar5h6hsupDEVrHF01VlnWabxiYHPJBCIWVa
4a0/0KUagGb859uFIxzgBV4BLZPWX8d0itMwXEZL9m7PFVwhs+4OHa+FjGQUFyR7
np8QijYAmijQexxBW5Uixk9rnWoPj3sDE0FzRptMkqZIQYI0Waiy3uaKQV2JUYMi
kB+ou1s/MJcMPaY8YFuIFjsYCXEgv/q5exDRQU4xtycjf36tOj0=
=wx62
-----END PGP SIGNATURE-----

--=-zRk3TFdNG5bRraO2Zc5B--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
