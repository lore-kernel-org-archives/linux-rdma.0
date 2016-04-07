From: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RFC PATCH v2 09/13] ib/core: Enforce PKey security when
 modifying QPs
Date: Fri, 8 Apr 2016 00:10:56 +0300
Message-ID: <20160407211056.GD12844@leon.nu>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-10-git-send-email-danielj@mellanox.com>
 <20160407163100.GA5808@leon.nu>
 <DB5PR05MB11113874870EBBE896E0D601C4900@DB5PR05MB1111.eurprd05.prod.outlook.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB5PR05MB11113874870EBBE896E0D601C4900-8IvNv+8VlcBJTpKhoUy7I9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2016 at 09:02:43PM +0000, Daniel Jurgens wrote:
> On 4/7/2016 11:31 AM, Leon Romanovsky wrote:
> > On Thu, Apr 07, 2016 at 02:33:54AM +0300, Dan Jurgens wrote:
> >=20
> >> +	if (sec->qp =3D=3D sec->qp->real_qp) {
> >> +		/* The caller of this function holds the QP security
> >> +		 * mutex so this list traversal is safe
> >> +		*/
> >=20
> > Did the comment below pass checkpatch.pl?
>=20
> It did.
>=20
> >> +		list_for_each_entry(shared_qp_sec,
> >> +				    &sec->shared_qp_list,
> >> +				    shared_qp_list) {
> >=20
> > Is this list always needed to be protected by lock?
> > In general, I prefer to see lock/unlock operations near protected code.
> > Otherwise, it is hard to follow all lock/unlock paths.
>=20
> The mutex is required, and I'm not sure how to push it lower safely.
> Consider the situation where a QP is being modified concurrently with an
> open_shared_qp. Unless the lock is held the entire time for each
> operation open_shared_qp could check permission using a ib_qp_security
> struct in a partially modified state, i.e. there could be a mix of new
> and old settings for the port/pkey index/alternate path.  Shared QPs use
> the port and pkey setting for the underlying real QP with the shared qp
> q_security.

Common flow is to do everything in one place:
1. lock
2. check permissions
3. change
4. release lock

Your flow is much broader.
1. lock
2. check permission
3. do work
4. change
5. do work
6. release lock.

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXBszgAAoJEORje4g2clinNKgP/0qMQlhd4RS6mCRkAXk+g0OO
2CkMZ6MqzsbtWAHI08dsXpOl/iX/ZH9yKLllwpLPGcRpBQFh2QX+nxg3Pj5gBw/P
QKrSyc9EEZUh1/cPWLMP0KWs03fbe3mqwTXWFYcEJNZwJRyIsd8qLYZgqUOuUnV6
Ty0g4MvSF6Wlf4uqflPHga5PSGgHSJl7yWk5kS208k1TJeEGph3CFxRmtMyZ+dXW
SKSJBanxvgT4yDWG3us45779GSvNyQ+n9wWtUFk7MQkRRj8wCRWsh50IIskpZ3pH
+/Y+T7l+cvqMBmrwKePgDOfhskEpH8cx3utdfdopNlNyFgdkPScw+F07Epmbb7si
d/THPslrUF/aOmTkoHluiVSTfZlrVuQ/Rul5XFIy1qTipg1zWnuXPE4u7x1uyFdH
sBVKO9z+yyg9YqVnMgyKcUPAB1tl++7lETT3I49HwoK0SnRfd/8s+OSpZ5em/hzo
fL/JfSy4/sPSuSEpMGPCxVTqkYflQs+dPj55hJQsvzb9PmPyDSWAMbJ4pbcuMNyD
gfufLMuGQljEe9LMdx50DdqXJdpv7wfygrbsNbFTLLqafTgUExxW6mrnC0121kjL
3eD4MrdJQEE8es+Be0LHSDBSRig0mRjScqmToFkhohRZYxWBEx7WJ7OY1j5cR2mH
613pczeUjTPpXAxePbFI
=mrD4
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
