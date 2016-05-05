From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] RDMA/iw_cxgb4: Fixes various cleanups during
 failures
Date: Thu, 5 May 2016 16:09:32 -0400
Message-ID: <82ed6ae3-3ff6-e9f9-96ff-d381a1f78a01@redhat.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="w2oGpBHJ6Rs4eLamxkPQW4TERvTANxTwo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w2oGpBHJ6Rs4eLamxkPQW4TERvTANxTwo
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/04/2016 03:57 PM, Hariprasad Shenai wrote:
> Hi
>=20
> The patch series fixes all kinds of ep leaks, if there are any failures=

> during connection establishment process and during arp failures. Also g=
et
> rid of abort_connection() and make use of c4iw_ep_disconnect() so that =
we
> can properly cleanup in case of abort failures. Move QP to error state =
in
> case of fatal disconnect errors. Also takes care of resource cleanup if=
 we
> fail to send flowc.
>=20
> This patch series has been created against Doug Ledford's linux tree an=
d
> includes patches on iw_cxgb4 driver.
>=20
> We have included all the maintainers of respective drivers. Kindly revi=
ew
> the change and let us know in case of any review comments.
>=20
> Thanks
>=20
> Hariprasad Shenai (9):
>   RDMA/iw_cxgb4: release ep resources on accept arp failure
>   RDMA/iw_cxgb4: stop ep timer on close failure
>   RDMA/iw_cxgb4: ensure eps don't get freed while the mutex is held
>   RDMA/iw_cxgb4: remove connection abort from process_mpa_reply
>   RDMA/iw_cxgb4: free resources when send_flowc() fails
>   RDMA/iw_cxgb4: remove abort_connection() usage from accept/reject
>   RDMA/iw_cxgb4: don't use abort_connection in process_mpa_request()
>   RDMA/iw_cxgb4: move QP -> ERROR on fatal disconnect errors
>   RDMA/iw_cxgb4: remove abort_connection() usage from ep_timeout()
>=20
>  drivers/infiniband/hw/cxgb4/cm.c | 252 +++++++++++++++++++++++++++----=
--------
>  1 file changed, 175 insertions(+), 77 deletions(-)
>=20

These all look fine to me.  Applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--w2oGpBHJ6Rs4eLamxkPQW4TERvTANxTwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXK6h9AAoJELgmozMOVy/dHhsQAImrzB75jqDJBYbNs1Vw6dCZ
CsjY+6lL5Wspboxn8anIWLb9yRyt3/ORgRM0p4twkvFinKJoA8VO/ZKiMkPQDspP
28Ee7J+RbBKXodJ9kRey8KILV0edpSq/91rgoG8sO7htbmDlhXWCFIDwHac309jt
6wumeSfCD4tbdTAF1AEAkvsVE9lb2+FNYbGCuwziaPvz8EEZGG51Puh8/pgSMxKE
o2HFsBmve4uHLAEC8abFv2coUqCVdN+e+mBqceV5Cz4pyWtPT29vRStQYqXzC3gp
vpD2eYrNM1x+GFRJz6yFtuqmK+YU8mFvh+N1O7jBPT1L92VE9pRhhmP31i/BRrry
XRAhvTI4mirGVJ/kmxa/iZ6do2AFGDHOV+CiS/Uh6p9WSRGj9t/utsQuj06Bjhmc
GVHD9fR1oILoLYB8BQBaPAFpDy3O5DPMk0FCc/S1LrF+WcDAIEp/lc4ecz4ZDI/0
T7MPQ61gIdvXUAZlIKULe3OMp3dMQyfWeAcWS9Jpt8UTTdiRv79sv9OlW+YMFlxo
v83g/fHg0DjXhe7/YfK9jjfD/nz5e630jTHIgZsLVrwcuKsQzWS69iw0UM/xDw+t
uDtbr6xeQILxnB/IKtde/gmgXqxZrnt8WRXJSklXVbA/oU4mlHwaTT1JovhtypxQ
ix3j5SS1OBG73w5vY0CQ
=4VJy
-----END PGP SIGNATURE-----

--w2oGpBHJ6Rs4eLamxkPQW4TERvTANxTwo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
