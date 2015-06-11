From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 0/2] Adds support for user mode bar2 mapping and
 bar2 qid density
Date: Thu, 11 Jun 2015 01:01:21 -0400
Message-ID: <1433998881.71666.147.camel@redhat.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-QZs4EUtOrdOdSEeLjmqu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433854392-6531-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-QZs4EUtOrdOdSEeLjmqu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-09 at 18:23 +0530, Hariprasad Shenai wrote:
> Hi,
>=20
> This patch series adds support for user mode bar2 mappings for T4 adapter
> and also adds  support for bar2 qid densities exceeding page size.
>=20
> This patch series has been created against Doug's github tree 'for-4.1'
> branch and includes patches on cxgb4 and iw_cxgb4 driver.
>=20
> We have included all the maintainers of respective drivers. Kindly review
> the change and let us know in case of any review comments.

I didn't catch this in my original responses to this thread.  But, your
subject calls this out for 4.1.  You do realize that 4.1 is already at
4.1-rc7.  Did you really mean for a patchset this large to go in at this
late stage of the rc cycles?  And if so, what's the justification?

Otherwise, I fixed up the cast issue I brought up and have this ready to
apply to 4.2.  But if you *really* mean 4.1, speak up with the problem
this solves and why it's so bad it can't wait.

> Thanks
>=20
> Hariprasad Shenai (2):
>   cxgb4: Support for user mode bar2 mappings with T4
>   iw_cxgb4: support for bar2 qid densities exceeding the page size
>=20
>  drivers/infiniband/hw/cxgb4/cq.c                | 22 ++++-----
>  drivers/infiniband/hw/cxgb4/device.c            | 16 ++-----
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h          |  5 +-
>  drivers/infiniband/hw/cxgb4/qp.c                | 64 ++++++++++++++++---=
------
>  drivers/infiniband/hw/cxgb4/t4.h                | 60 +++++++++++++++----=
----
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |  1 +
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  4 +-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h  |  1 +
>  drivers/net/ethernet/chelsio/cxgb4/sge.c        |  4 +-
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      |  7 +--
>  10 files changed, 109 insertions(+), 75 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-QZs4EUtOrdOdSEeLjmqu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeRYhAAoJELgmozMOVy/dj6wP/0ZJ0s3gjjQ0jC/+TqHLAc0f
eSoptxZLlQDK/RCaCAQSfexS8yO+sR1E1Q6JWeyllZYD7XRbrHeRXVmJ+FyoY2Cv
1+m2xhEpJ7Zcte23dbhxsSv8lJeSWL60nWi5PGD/7x80MzBziEdAXHsxyQBwZfGG
y7s5pjdKaqxzWMaFX0e2/FHvqqQjQJcTbauVZ6wIMBFJNuVx8wGtUp0dyuwyep81
iCotwsw9Z9/7rkDhRmlDCUulJXT0c/8WDYOWxf8poH5PmARfRB1MPdcx0pJfNw5M
4AN4r0Jj9Bqom71fKuuXYpZV0pptWj54EwBJTwjgKL4WfVXhQx5bZWf9tZngi0uE
C3/h+kgthQcDa4iqddMYoMo2HcTnWH6dWuqbHlY3JfurEC5OL9AdH9nhRu52a3cx
UK58rCzZ4uQwGJEnhAwu25NiuhksJHHS3wrkKYxwXvYjkbvI07hDwBIBzmMJ6DPT
c2Fr8apxyAGO2j16yQp7AuX27E9b0lNXNlcw/y7+DBPyFIV2DosF9u9uofuSRqr0
U4dIobgVRKDXuTyNluoUy62vFOiCMACNg/wW89IBjGigWWq4/5BbvNUOO9GLt4Pi
TDX+FqpEhk7dw90je30hFRGbCG1kUY64TQhKfpSppnU3t8EfVwcJseRnLL5qyMfJ
ql4xqOvJ6DbxogWKnOv/
=tTTB
-----END PGP SIGNATURE-----

--=-QZs4EUtOrdOdSEeLjmqu--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
