From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH][next] RDMA/nes: remove redundant check on udata
Date: Thu, 7 Mar 2019 10:23:28 +0000
Message-ID: <815dea03-ef9a-39c0-3ec5-cdd58a545911@canonical.com>
References: <20190302230637.8624-1-colin.king@canonical.com>
 <20190304063623.GA15253@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="myIfY0JvAYSBM2eA8Dl78STvQBfRD0KHQ"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304063623.GA15253@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--myIfY0JvAYSBM2eA8Dl78STvQBfRD0KHQ
Content-Type: multipart/mixed; boundary="V9KKqdNrC9BAndZvoI3I7vIj8KsaMunRc";
 protected-headers="v1"
From: Colin Ian King <colin.king@canonical.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford
 <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <815dea03-ef9a-39c0-3ec5-cdd58a545911@canonical.com>
Subject: Re: [PATCH][next] RDMA/nes: remove redundant check on udata
References: <20190302230637.8624-1-colin.king@canonical.com>
 <20190304063623.GA15253@mtr-leonro.mtl.com>
In-Reply-To: <20190304063623.GA15253@mtr-leonro.mtl.com>

--V9KKqdNrC9BAndZvoI3I7vIj8KsaMunRc
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 04/03/2019 06:36, Leon Romanovsky wrote:
> On Sat, Mar 02, 2019 at 11:06:36PM +0000, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The non-null check on udata is redundant as this check was performed
>> just a few statements earlier and the check is always true as udata
>> must be non-null at this point. Remove redundant the check on udata
>> and the redundant else part that can never be executed.
>>
>> Detected by CoverityScan, CID#1477317 ("Logically dead code")
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/infiniband/hw/nes/nes_verbs.c | 73 +++++++++++++-------------=
-
>>  1 file changed, 34 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniban=
d/hw/nes/nes_verbs.c
>> index 828e4af3f951..526092d435df 100644
>> --- a/drivers/infiniband/hw/nes/nes_verbs.c
>> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
>> @@ -1039,53 +1039,48 @@ static struct ib_qp *nes_create_qp(struct ib_p=
d *ibpd,
>>  				}
>>  				if (req.user_qp_buffer)
>>  					nesqp->nesuqp_addr =3D req.user_qp_buffer;
>> -				if (udata) {
>> -					nesqp->user_mode =3D 1;
>=20
> It was single place where user_mode was set, you should continue and
> remove all code which depends on "if (nesqp->user_mode)".

This is not the only place where user_mode is being set; we currently hav=
e:


        if (udata) {
                if (ib_copy_from_udata(&req, udata, sizeof(struct
nes_create_qp_req))) {
                        nes_free_resource(nesadapter,
nesadapter->allocated_qps, qp_num);
                        kfree(nesqp->allocated_buffer);
                        nes_debug(NES_DBG_QP, "ib_copy_from_udata()
Failed \n");
                        return ERR_PTR(-EFAULT);
                }
                if (req.user_wqe_buffers) {
                        virt_wqs =3D 1;
                }
                if (req.user_qp_buffer)
                        nesqp->nesuqp_addr =3D req.user_qp_buffer;
                if (udata) {
                        nesqp->user_mode =3D 1;
			...


and I'm just removing the redudant 2nd if (udata) check, so the
nesqp->user_mode =3D 1 assignment is still being kept hence it's not
correct to remove all the if (nesqp->user_mode) releated code.


>=20
> I looked on the change which triggered Coverity warning and looks like
> your commit message should include this Fixes line:
> Fixes: 899444505473 ("IB/{hw,sw}: Remove 'uobject->context' dependency =
in object creation APIs")

Can that be added to the patch before it's applied?

>=20
> Thanks
>=20

Colin


--V9KKqdNrC9BAndZvoI3I7vIj8KsaMunRc--

--myIfY0JvAYSBM2eA8Dl78STvQBfRD0KHQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEcGLapPABucZhZwDPaMKH38aoAiYFAlyA8SEACgkQaMKH38ao
AiZLhg/8DCRIoCDwHqdfnn7+FxVJzm2jnhm/Dm43Pygc4v6bIVuMiNtIKYcoj/S8
XvZri29vTgth8VZBLx9oeAwkEWD/8QOVEPpvf6IBFZljEWlwRNyLKl/dkSsnOt3a
IGH5TZntsieXELKeyFD8FStjOlU8A0klSakB3x57a1uvsOrT905ui/852ONi0/rg
DPLnHdmMNxJdNGHbOFALMDDXiWthHX07Rj0c9P2WYgauTE80++uln08PfrVgYLZ9
Jz6xTDb/RXhc75RRofLUGaBgfJlhI97UyfNBCXR3JdEUGGwsZkLyqbBSEOrkvBVX
Nj0Vk5zRE1q/ilwwLfX6MbWEeHY4tZG2vh+nVUMFKwnSbqlLo2PBzWCMBK0b2/4i
7W1MaVXxWYPkt1NqtfLbkVJlhND9rFIcgAfe5YQkGVkoSXqqp92t06EXrudfkVXX
H6kYvAy8is3btUXVMKts1MJcF3XdQJ2Iua88Yeq3SpQefts8fU74HGCej6bQ0cV+
oQO0p4sTWd6d8kqvSZvAr03VgJYa3XK9Wxz6FK3KpxXfVQVBJ+OTzNF/l1Zq5uvh
/R9EvTNur4Bc/FIQVmgPtpcJov1CFuE9YvTBAE8fDnSj0HJ51Zg3ANKyd7YXGuij
CGpkr5m/q1DE5pfh8YHJaQRsU99PEomeeMvlfp8uSj64vfMJxss=
=F1uf
-----END PGP SIGNATURE-----

--myIfY0JvAYSBM2eA8Dl78STvQBfRD0KHQ--
