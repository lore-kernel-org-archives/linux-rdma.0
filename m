From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 01/12] IB/core: Guarantee that a local_dma_lkey is
 available
Date: Fri, 14 Aug 2015 20:58:02 -0400
Message-ID: <55CE8E9A.9020504@redhat.com>
References: <20150805201445.GA30271@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6qqcpTMIPfeTmXINxhnMEqaVkmvbBUQtX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150805201445.GA30271-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6qqcpTMIPfeTmXINxhnMEqaVkmvbBUQtX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/05/2015 04:14 PM, Jason Gunthorpe wrote:
> Every single ULP requires a local_dma_lkey to do anything with
> a QP, so let us ensure one exists for every PD created.
>=20
> If the driver can supply a global local_dma_lkey then use that, otherwi=
se
> ask the driver to create a local use all physical memory MR associated
> with the new PD.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Reviewed-by: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Acked-by: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Tested-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

=2E..and then I switched it up for this one ;-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--6qqcpTMIPfeTmXINxhnMEqaVkmvbBUQtX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzo6aAAoJELgmozMOVy/d4zQP/A+Ua9d6ItcCS8AX8m9uUUN/
73QW+owRPldxMTQIlpsZImn+ZYmXeYfvcpOZNEOV0Yo9AUwk0fMMUHSro8m2H0nU
/MipeHqt7lC+9Vu42E+lQ84ZfhISYXel75cmcI2WXOzJT8bI/vYIthQSzRQh5pV9
u3UPj70mOKJls74vugqoXtIhWG26FYsoYsoJehl1s08wVCErDbf1bILS7cVmd3o1
YsU4w7Lf5BGgWKs2sr4cP1cFYLuQwLe4jIJ0XdI1spZxsyhdQaIADmJmOf98EnL6
XoHymPUQu5cbpM6uZNsR2j/iEmWFL3HwrgtuSQmYsE/IfnYHNilcriouLJMjD5Q0
Pn4/LcDMKzT4DOIR3gCVDipxAqTYWgk2OoHB44ZJa6KXEVFx1saF1Jly+s968A1M
QkInOj3Itm5vCGU6X758XmbTl2lmFUXOxqEdK7rxJS4WSQnsErc6tmqbydjnkzIu
mi7ol0o5RlD70dQKoGpChdy+A3iuun5ulYpW3uqucE5g2le1EmYXeTnk5hxVwCcI
Q1BcS9W+gXwKvu6z6k9tkpRnDPpWv022U1VsWtqMS0PPqFtKvRJBf5XnebbHWrWj
uNFAHPZYfB6Z23f50R6uZ2oiHCBgHbM8VpVYK7q4aLsY07fq8ombbljzSmlA/eDD
3p0BuFv16QkCJh/958RY
=RRXz
-----END PGP SIGNATURE-----

--6qqcpTMIPfeTmXINxhnMEqaVkmvbBUQtX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
