From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-next 05/14] IB/hfi1: Use after free race condition
 in send context error path
Date: Wed, 09 May 2018 10:38:52 -0400
Message-ID: <1525876732.11756.372.camel@redhat.com>
References: <20180502133831.20730.42677.stgit@scvm10.sc.intel.com>
         <20180502134249.20730.78919.stgit@scvm10.sc.intel.com>
         <20180504183839.6wexn5phhiyo6xra@ziepe.ca>
         <add45f95-61e0-aa96-6738-08c15a234f33@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+uo9LjxAIskht2C96nrh"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <add45f95-61e0-aa96-6738-08c15a234f33@intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-+uo9LjxAIskht2C96nrh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-05-04 at 16:01 -0400, Dennis Dalessandro wrote:
> On 5/4/2018 2:38 PM, Jason Gunthorpe wrote:
> > On Wed, May 02, 2018 at 06:42:51AM -0700, Dennis Dalessandro wrote:
> > > From: Michael J. Ruhl <michael.j.ruhl@intel.com>
> > >=20
> > > A pio send egress error can occur when the PSM library attempts to
> > > to send a bad packet.  That issue is still being investigated.
> > >=20
> > > The pio error interrupt handler then attempts to progress the recover=
y
> > > of the errored pio send context.
> > >=20
> > > Code inspection reveals that the handling lacks the necessary locking
> > > if that recovery interleaves with a PSM close of the "context" object
> > > contains the pio send context.
> > >=20
> > > The lack of the locking can cause the recovery to access the already
> > > freed pio send context object and incorrectly deduce that the pio
> > > send context is actually a kernel pio send context as shown by the
> > > NULL deref stack below:
> > >=20
> > > [<ffffffff8143d78c>] _dev_info+0x6c/0x90
> > > [<ffffffffc0613230>] sc_restart+0x70/0x1f0 [hfi1]
> > > [<ffffffff816ab124>] ? __schedule+0x424/0x9b0
> > > [<ffffffffc06133c5>] sc_halted+0x15/0x20 [hfi1]
> > > [<ffffffff810aa3ba>] process_one_work+0x17a/0x440
> > > [<ffffffff810ab086>] worker_thread+0x126/0x3c0
> > > [<ffffffff810aaf60>] ? manage_workers.isra.24+0x2a0/0x2a0
> > > [<ffffffff810b252f>] kthread+0xcf/0xe0
> > > [<ffffffff810b2460>] ? insert_kthread_work+0x40/0x40
> > > [<ffffffff816b8798>] ret_from_fork+0x58/0x90
> > > [<ffffffff810b2460>] ? insert_kthread_work+0x40/0x40
> > >=20
> > > This is the best case scenario and other scenarios can corrupt the
> > > already freed memory.
> > >=20
> > > Fix by adding the necessary locking in the pio send context error
> > > handler.
> > >=20
> > > Cc: <stable@vger.kernel.org> # 4.9.x
> > > Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > > Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> > > Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > > ---
> > >   drivers/infiniband/hw/hfi1/chip.c |    4 ++++
> > >   1 files changed, 4 insertions(+), 0 deletions(-)
> >=20
> > Why are you sending this to for-next not for-rc?
>=20
> I went back and forth on this one. In the end decided against it because=
=20
> we've lived with it for so long, note stable tag is all the way back to=
=20
> 4.9, that and the fact that it's extremely unlikely to occur. I would be=
=20
> fine including it with the -rc though. I think a case could be made=20
> either way.
>=20
> -Denny
>=20
>=20
>=20

I went ahead and pulled this into for-rc instead of for-next.  Thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-+uo9LjxAIskht2C96nrh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrzB/wACgkQuCajMw5X
L93RDQ//enJTyRTpz0nfg7bCGZtO2W+N/ftkRYaxve4bTAjrc+6YKfcg2Z1s5xdr
dZxq94xO3FLBrkURfvp9Hw22hLGD3vKo75fK3mggcAmDN/31C37m43JcTMcEooKl
sjJ1zNKk6S+rRP9n31Yk1wgw+y3gsmK8SYzJnnuifaNNmhptJAnBQI0/RGkf75PC
eKNweN7aoGtPjHuT23aK+JTKeIUG87gJzo0Kfv56PGJpvv7D7UDk1Uendr36WpbE
KeXlZZBUzlbyNwEoJoEZXyO0dHbXNGaZ24IglJ6Fw1cf/PSAjTUpZOKAXmuDzdO4
Hwgox6GTAZZ7Rc+/gjyh3qkIYH+KYIKVc/ZI/jLlnwQbbpOVvl3qGMFaA80TQJSY
OI9sf6eyqfUMTbI+DPdeu5vL+cy19w4duIQQYObzVU3k/Z0VJin4IC9yTUdeUh5X
bzm9DCaHY/kKQ8gVK3LWzzblumZs8MZ6aFGND19wzDzRcp0TkLnsNxr0xVn1BQv+
VBGRrVYkmowqQN9ScIuxhDWZwppa9ekkDSUJcaUZREBsbSsZuuF8RQarfDkU26uB
FPuw/FQeFavcS0GKFp3Kz+Ncvdhicf/9VjcsEPs3ybQXnvs/N/QJuXksOZ4I8vGG
QQyN1dCm0g/ducmvh3UAg2ZTbO49jlzfH9E94izl34V6SNQUB4A=
=kNzC
-----END PGP SIGNATURE-----

--=-+uo9LjxAIskht2C96nrh--
