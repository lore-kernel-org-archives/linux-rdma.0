From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/4] new ib_drain_qp() API
Date: Wed, 17 Feb 2016 16:09:57 -0500
Message-ID: <56C4E1A5.40409@redhat.com>
References: <cover.1455741336.git.swise@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bOd8jKa2g5Dao8kKLQE5MX9RaFA0fxr63"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1455741336.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bOd8jKa2g5Dao8kKLQE5MX9RaFA0fxr63
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/17/2016 03:35 PM, Steve Wise wrote:
> This series creates new helper API functions for draining a queue pair.=

> It is a rework of an original patch created by Christoph Hellwig as
> part of the CQ API rework and was dropped to be resubmitted by me with
> iw_cxgb4 support.
>=20
> Original thread: http://www.spinics.net/lists/linux-rdma/msg30296.html
>=20
>=20
> Changes since v3:
>=20
> - WARN_ONCE() if the CQ is using IB_POLL_DIRECT context.
>=20
> - added iser patch to use ib_drain_sq().
>=20
> - fixed up function comments to specify caller requirements
>=20
> - checkpatched
>=20
>=20
> Changes since v2:
>=20
> - created 3 drain API functions: ib_drain_rq(), ib_drain_sq(), and
> ib_drain_qp()
>=20
> - add provider-specific drain function pointers for the sq and rq
>=20
> - refactored the code a bit
>=20
> - support for IB_DIRECT_POLL CQs
>=20
>=20
> Changes since v1:
>=20
> - added comments to the ib_drain_qp() function header specifying the
> consumer requirements
>=20
> - in __ib_drain_qp(), if the ib_post_send() fails, still wait for the
> recv wr to drain since we already posted it.
>=20
> - CC the SRP maintainer, bart.vanassche-XdAiOPVOjtvowKkBSvOlow@public.gmane.org
>=20
> ---
>=20
> Steve Wise (4):
>   IB: new common API for draining queues
>   iw_cxgb4: add queue drain functions
>   IB/srp: Use ib_drain_rq()
>   IB/iser: Use ib_drain_sq()
>=20
>  drivers/infiniband/core/verbs.c              | 164 +++++++++++++++++++=
++++++++
>  drivers/infiniband/hw/cxgb4/cq.c             |   9 +-
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |   4 +
>  drivers/infiniband/hw/cxgb4/provider.c       |   2 +
>  drivers/infiniband/hw/cxgb4/qp.c             |  16 +++
>  drivers/infiniband/ulp/iser/iscsi_iser.h     |   7 --
>  drivers/infiniband/ulp/iser/iser_initiator.c |   7 --
>  drivers/infiniband/ulp/iser/iser_verbs.c     |  15 +--
>  drivers/infiniband/ulp/srp/ib_srp.c          |  40 +------
>  include/rdma/ib_verbs.h                      |   5 +
>  10 files changed, 205 insertions(+), 64 deletions(-)
>=20

Series looks good now, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bOd8jKa2g5Dao8kKLQE5MX9RaFA0fxr63
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxOGlAAoJELgmozMOVy/dOhUP/1RRUiKUI2qpoaiwMohcRF+T
w6XtBzVGaGkoONrnbvBl71mcEMTga3i8hs5uXe4SbofqQR+FZxw1A/ZAUINGAaxZ
/oGBR0jOIqVer1XkkFSwDtOPmuPvk7uq0DJFNMR6WkaLMZGr+TtMTwA5h6TonzSi
Osl1CVti1JGmUla2lf9MsSuvB7zSOxIO26jxQV2TvYZ+mYTTdH9Xt9UEopWEZVzs
VTjcE3ocF8W/9xHJnQgb0lrBlWFjrTJlevOQ3BDBwrghNvkOchLUjDtcXDEQMFUK
yT34Am2aPornOBNhaes4HdHwso2Jwmr0qfVz1WcR+4ifcvQbs2zws5pBW8yJ19SH
tqjM+IPlHckqLcLvr7lfmG2z/CwYf238ASIfTR2KR6FkEbLXcU+8pjvbkFD9K04t
BHatdFOWwWsXllq2n4KvuMAv52gAJ2xRv5OLfih3TlieyQRf28Gmmam6gtQdct/9
Q0T8eg3bnAQMNT2xq7Di7AfOOambaTpYyfa6mKcjiNo/IHHlojwfV+whr5DoM8Nf
fpjhKnnZM5uoxNmSoxd1TIFVHVVOuxGdPVfoHoBxx5SQbrxOnJlRheJ4NvfTZAQQ
2u1Q6N0k3UBaM98Rq7o39T2BiJaWzW3E7/um/B9HNXHn7BlX6u8vjuBzQ6OEDltl
2ZEFVcBSHoHRHjvxGfhK
=TDJD
-----END PGP SIGNATURE-----

--bOd8jKa2g5Dao8kKLQE5MX9RaFA0fxr63--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
