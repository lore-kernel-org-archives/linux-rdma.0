From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/1] infiniband: Remove redundant NULL check before kfree
Date: Tue, 7 Jul 2015 14:53:16 -0400
Message-ID: <6C49D012-DBBD-4AE8-B3A2-944B7823378E@redhat.com>
References: <1435302547-40904-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C4276367-BD6E-455B-8D4B-C2ED2F7E8F34"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435302547-40904-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maninder Singh <maninder1.s@samsung.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, David Miller <davem@davemloft.net>, roland@purestorage.com, Matan Barak <matanb@mellanox.com>, Moni Shoua <monis@mellanox.com>, jackm@dev.mellanox.co.il, Yishai Hadas <yishaih@mellanox.com>, eranbe@mellanox.com, Ira Weiny <ira.weiny@intel.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, pankaj.m@samsung.com
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_C4276367-BD6E-455B-8D4B-C2ED2F7E8F34
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jun 26, 2015, at 3:09 AM, Maninder Singh <maninder1.s@samsung.com> =
wrote:
>=20
> kfree(NULL) is safe and this check is probably not required
>=20
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Reviewed-by: Akhilesh Kumar <akhilesh.k@samsung.com>
> ---
> drivers/infiniband/hw/mlx4/main.c |    6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c =
b/drivers/infiniband/hw/mlx4/main.c
> index 067a691..4e60b39 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -2676,10 +2676,8 @@ static void do_slave_init(struct mlx4_ib_dev =
*ibdev, int slave, int do_init)
> 		dm[i] =3D kmalloc(sizeof (struct mlx4_ib_demux_work), =
GFP_ATOMIC);
> 		if (!dm[i]) {
> 			pr_err("failed to allocate memory for tunneling =
qp update work struct\n");
> -			for (i =3D 0; i < dev->caps.num_ports; i++) {
> -				if (dm[i])
> -					kfree(dm[i]);
> -			}
> +			for (i =3D 0; i < dev->caps.num_ports; i++)
> +				kfree(dm[i]);
> 			goto out;
> 		}
> 	}
> --
> 1.7.9.5
>=20

If you are going to change this, you might as well make it 100% correct:

i=E2=80=94-;
while (i >=3D 0)
	kfree(dm[i]);

Then you don=E2=80=99t have to worry about whether kfree works on NULL, =
every item you free will be guaranteed to be non-NULL.

=E2=80=94
Doug Ledford <dledford@redhat.com>
	GPG Key ID: 0E572FDD






--Apple-Mail=_C4276367-BD6E-455B-8D4B-C2ED2F7E8F34
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVnCAcAAoJELgmozMOVy/d+EQQAKCvZI4vQ0JIuWUaZxtnt3Rx
Hg1FPubWMrX+7kFd9QU/4hVqUMFb6DxyRkZnDq18dk1ksWtJyboA+edNKuVNYU0M
f7aCrppkvdP2p0Rab4pTJ+dCDnoaWD9NUr007+rFNPm8SKcTIU2gUfV7xRrYN2BB
C2k37Wsb3LQgTuTM0mfJcA++fvJ6Cm1kGKaNdIh6d35sWkbwaTniRGpDX/mGYmyv
LwL3Rd0zIVNFPx505qG24bdqaiNOzWQ4MIdEYHIKk0dYy6tr68daIFI5VPCwAs/H
9ZtzUkW1dP2bMETeyXmIt0tSiP8YQy+aYrk59NfNOGgi7/CxGYeG8mgGYZRkqP9a
N13MOEqwsvysUMu8Wr7o9dUfEYLIUGG74Pm+DERsWdK83Ng2UvREFBqjJFjaWHus
undYC7LYkqwzM52d2d0iV3qgOBsfmhXffOhoebFfsih5XQbp2+fQBgGSwdtQ1Gea
BMXCQkvffjom1ou6J0fCIpwVV67Q9LaQ280l9O8m6dSdy4G8DnAc7jEHkSTjy5c/
zxhgmt2hmqBYnQzyzPxCUiRBWvgA3ZB1lg+BpEhKmy6f5T6HejhPHwfHPz2gtyaz
pz03uSjm9ZRe5bEnhlMrTYRqng1qT9Z46fh4w9KrEM2iREsTRnDbFFWKsdeRs4uS
qGeGN92jdvc0kh9ZDv3p
=hnAX
-----END PGP SIGNATURE-----

--Apple-Mail=_C4276367-BD6E-455B-8D4B-C2ED2F7E8F34--
