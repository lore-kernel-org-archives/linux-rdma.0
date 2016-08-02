From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iSER-Target: Release connection resources
 properly when receiving RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Tue, 02 Aug 2016 13:49:52 -0400
Message-ID: <1470160192.18081.23.camel@redhat.com>
References: <20160727191511.18122-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-IyDdlByoicsgZOojFY3J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727191511.18122-1-rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-IyDdlByoicsgZOojFY3J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-07-28 at 00:45 +0530, Raju Rangoju wrote:
> When the low level driver exercises the hot unplug they would call
> rdma_cm cma_remove_one which would fire DEVICE_REMOVAL event to all
> cma
> consumers. Now, if consumer doesn't make sure they destroy all IB
> objects created on that IB device instance prior to finalizing all
> processing of DEVICE_REMOVAL callback, rdma_cm will let the lld to
> de-register with IB core and destroy the IB device instance. And if
> the
> consumer calls (say) ib_dereg_mr(), it will crash since that dev
> object
> is NULL.
>=20
> In the current implementation, iser-target just initiates the cleanup
> and returns from DEVICE_REMOVAL callback. This deferred work creates
> a
> race between iser-target cleaning IB objects(say MR) and lld
> destroying
> IB device instance.
>=20
> This patch includes the following fixes
> =C2=A0 -> make sure that consumer frees all IB objects associated with
> device
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0instance
> =C2=A0 -> return non-zero from the callback to destroy the rdma_cm id

This patch is missing a Signed-off-by: line and can not be accepted as
it is. =C2=A0Please resubmit with the proper attribution. =C2=A0Also please
reword your commit subject as it's too long. =C2=A0I suggest something like=
:

IB/isert: Properly release resources on RDMA_CM_EVENT_DEVICE_REMOVAL

which is still too long, but not as bad as what you have now.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-IyDdlByoicsgZOojFY3J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoN1AAAoJELgmozMOVy/d8TIQAJ7I3eZbCmRGukV16npxfnsR
E5BybQKQNXVOPDRkkaWnxss9Crh6KmRZOsNzHZOCh2ZSYGLY50IFSq1RpAYIfwoa
Q3UZt8Gz11kyuF2KoSXG7fnpeclNnMBkGSYh9MIQhRqI3rTL6NQPVxEKODRKX8qV
xE4utQIMM8zRiEZtnTj3rY5KjUKtEg12fwNib5MGFwk/nOhoSZbRP0RLRWBRnf8+
cWwR4+ZLHQ6+SCasDlC92f2h1C5dKjkzzq/oatqglWu5mYtWa2jJLek3hyOM9mQJ
YdMJ/yJxOaZGUvKPFVt8PG6lTniKLNrgk8qCpStxL63658Ty6HI/JFI5ud6vqGTc
U9SuW2CSJQ+J1laHOf8MSEr40MPEOeXJOXywM0bUOBB0Wa4PhQvIO+IGDuXdP8Yu
J+ueMhvXRXDlU0Pan7hgu0oxrT4Ao1sfctr+Q5Zs1+flk7LCLe/Efk1tDH+WW0F9
y0pEWelJW8e6PzpA8qDnUEOACoJMfs52ON6PaJ0dPGbn0EdlsievGKklK0opFEao
cyIYY9UzVSfGeoeiTDMxSgHS9+MK91iEKjFP2wDen4oCr7wpSEIi0nK+fxRFHzN5
6VFk1/HmL25qacugx7TXyih9E4jOE24Z4ZAXgHBgPvSF+3V1WEou+qRwDyGa5d7F
H1ozisHMutfEQ+SH5p3r
=Yb2O
-----END PGP SIGNATURE-----

--=-IyDdlByoicsgZOojFY3J--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
