From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/17] RDMA/iw_cxgb4: Misc. fixes and
 enhancements for iw_cxgb4
Date: Thu, 12 May 2016 15:22:30 -0400
Message-ID: <4e114ad9-01b5-ed97-92e7-0cc0b26ce999@redhat.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a94C59UkCKXOBGesQrigRkPE3ejxdoVeh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a94C59UkCKXOBGesQrigRkPE3ejxdoVeh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/06/2016 12:47 PM, Hariprasad Shenai wrote:
> Hi
>=20
> This patch series corrects the RFC number of MPA, fixes endpoint leaks =
in
> lot of failure paths, adds code to handle return values for c4iw_ofld_s=
end,
> c4iw_l2t_send and process_mpa_reply. Adds code to lookup and reference =
the
> endpoints atomically. Some fixes related to endpoint timer during MPA
> negotiation. Pass correct FID value in DSGL command.
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
> Hariprasad Shenai (17):
>   RDMA/iw_cxgb4: Add few history bits for ep
>   RDMA/iw_cxgb4: Correct RFC number of MPA
>   RDMA/iw_cxgb4: set the correct FID value in DSGL commands
>   RDMA/iw_cxgb4: parent_ep has to be dereferenced in case of passive
>     accept failure
>   RDMA/iw_cxgb4: Do not stop timer in case of incomplete messages
>   RDMA/iw_cxgb4: stop_ep_timer() after MPA negotiation
>   RDMA/iw_cxgb4: handle return value of c4iw_l2t_send() and
>     send_mpa_req()
>   RDMA/iw_cxgb4: in process_timeout() don't move ep state to ABORTING
>   RDMA/iw_cxgb4: Handle return value of c4iw_ofld_send() in
>     abort_arp_failure()
>   RDMA/iw_cxgb4: atomically lookup ep and get a reference
>   RDMA/iw_cxgb4: Free skb in case of arp failure in _c4iw_free_ep()
>   RDMA/iw_cxgb4: Release ep for for FPDU_MODE and MPA_REQ_RCVD in
>     process_timeout
>   RDMA/iw_cxgb4: Handle ULP accept/reject during ABORTING
>   RDMA/iw_cxgb4: atomic find and reference for listening endpoints
>   RDMA/iw_cxgb4: Handle ret value of process_mpa_reply() in rx_data
>   RDMA/iw_cxgb4: Always wake up waiter in c4iw_peer_abort_intr()
>   RDMA/iw_cxgb4: Add arp failure handlers to send_mpa_reply/reject()
>=20
>  drivers/infiniband/hw/cxgb4/cm.c            | 371 ++++++++++++++++++--=
--------
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |   9 +-
>  drivers/infiniband/hw/cxgb4/mem.c           |   5 +-
>  drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |   4 +
>  4 files changed, 257 insertions(+), 132 deletions(-)
>=20

Series looks good, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--a94C59UkCKXOBGesQrigRkPE3ejxdoVeh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNNf2AAoJELgmozMOVy/d2gcP/3kqazyzpzhZAurgMSaEmR8L
lDN51DmJSyWRq4fRJfNejGPxEm7hDz1nA3koKlgL2jRVbxaSvEjzkPKtjvxMVjgO
f/vkeMW4nn6yXu7UmLWLYE5bh7RF/Q1ne34d1M1ojQSdeopC0jBxfBF/z9VzSX1b
PBWcv2IZv6v+CkfJre9n/K+uMs3mGg7hBa644PqeFhPWZWoEw8rcngwm3sSdsqua
P2VWkJbTqfkjHQzyzj3xoCNEleyM0BioQgVCg66aFYXd9hPGrHr2MNo2hM52vik8
hFYvJiCT753ht15nGiFc5ckINu0xQHcmNFqGkQbv2MuOdRMiab+qbbpJB20CmJQD
p3vuKlujflP43GeTer81nVCRoHQJbBKb8GsBoM4ACDgOhB2DnrCQrygLbdf1e79l
PMPCcR1Tslphr4QH52E8u1v4LnLSAmfTx954KZ2gDaOG45Y1FfU3s/sAG/jiSDp1
bgBzADragh92LRV33DCeTc8A4OErOrwBl/1Zvz7fM490AHrlUniHINZI1v5UGSO0
FAnyLG4M89l0SNIbd7R7MZ5IsQf95ZioG09N3440EYBCFUNFBKCDTUoTcoXI1Miw
BGxp4zXtrWqc6+wDELRt+mOIoduHtxoyHLncM6fXs2oeN8vaoQMrlrWK+HsoOVaD
2fwoL13wAmm/jVVgvruU
=ZVmm
-----END PGP SIGNATURE-----

--a94C59UkCKXOBGesQrigRkPE3ejxdoVeh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
