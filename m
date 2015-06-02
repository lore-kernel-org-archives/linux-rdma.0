From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Tue, 02 Jun 2015 14:51:23 -0400
Message-ID: <1433271083.40123.1.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <20150601164322.GA14391@obsidianresearch.com>
	 <1433255724.114391.225.camel@redhat.com>
	 <20150602180844.GD17776@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-geTt6ILFUmzdYg3YStie"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150602180844.GD17776-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-geTt6ILFUmzdYg3YStie
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-02 at 12:08 -0600, Jason Gunthorpe wrote:
> On Tue, Jun 02, 2015 at 10:35:24AM -0400, Doug Ledford wrote:
>=20
> > So, just so everyone is clear on this point: the current user space
> > implementation of this feature creates an unversioned, newly named
> > ibv_wc_ex struct that is ibv_wc with a 64bit timestamp tacked on at the
> > end (not 64bit aligned either).  If we ever wanted to have a different
> > extension to our ibv_wc struct, there is no good way to do that.
>=20
> No, if they followed (I didn't check yes) the extension scheme then the
> poll call is
>=20
>  struct ibv_wc_ex wcs[num_wcs]
>  ibv_poll_wc_ex(&wcs,num_wcs,sizeof(wcs[0]));
>=20
> And the drivers decide what to do based on the 3rd argument, which is
> essentially the ABI version.

Ick.  OK.  I would *much* prefer something done akin to the routines in
packer.c of the kernel, but that's not my call to make, the decision on
the ABI/API extension mechanism was made long ago.  It does, however,
mean that extensions are serial and not modular, and that's a shame.

> > Jason, when the XRC and flow steering extensions were added to
> > libibverbs, you complained loudly that they were not added in the agree=
d
> > upon format and cited a previous on list discussion.  Do you have a lin=
k
> > to that discussion?
>=20
> Not off hand, but that was different, that was a misuse of comp_mask,
> IIRC.
>=20
> Or, the question in my mind based on looking at the UAPI patches is
> what things should be driver private and what should be general.
>=20
> Broadly my thoughts:
>  - Should the frequency and mask be general, or driver private? If the
>    cycles->ns conversion is a function they should be driver private.
>    Even if they are general at libibverbs, they don't *have* to be in
>    the kernel's general query response.
>  - Should frequency even be frequency? Most clocks are expressed
>    accurately as a period in picoseconds. Frequency is more often
>    imprecise. (eg ethernet is 3200 ps or 312.5MHz)
>    However FDR/EDR is fractional for both (4693.33333333 ps vs
>    213.0681818181818 MHz)
>    Precision is very important for time conversions, so a
>    multiply-divide scheme would be ideal.
>    This is suggesting to me these details really are not
>    general.
>  - There should be much better definition on what all this stuff is,
>    units for frequency? When is the timestamp applied?
>  - Should an app even be exposed to mask? This is very difficult
>    to use correctly in the general case. Only cases where an app is
>    restarted more often than a wrap period are trivial to use properly.
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-geTt6ILFUmzdYg3YStie
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVbfsrAAoJELgmozMOVy/daasP/A5gXgmwkP4Wb4skjKe8zAVI
crM+q0LVFpWfSmHZL/iCHq/VjDyxs3MJ46E6KuGxugXufa85teIr4ei5UUNwpDT7
eER0gq4MNoeHrKLJuc9jcrob3I+Dd8SgH7oWkW1J58PqAKmKhjc1HBRuZPUNnO4f
Kxb/ciQ5PrnyqxpWsMVo1FFfO3Nu18x9JbAJqMaNPZBxbcxApAwxW3XqIYUnzPCo
cU9na3WTGwxpMJuoznG3Qy5Nz1eIylW4WxnYOVWEFvGaAV47iRwS+7je0TfbQJ0e
OYwWFpSHXudSH8uLyR6m0PybaV02r9aCvcNKCwEkDKnYPETzZubxzhqlzuBzDHFj
8+oGRhQsV4UV9NJCXQDLhNIWSI1qrWyKi0bZLiJiJM4V4SoUV0ggixQpu72g2jgz
h56GMb+M9z5h3yu406MWXxl7P4UMzLg4aw8N0gsERBTNrY0O/9kOAwIYZjuue0aT
HE/JJyGkTz3bSWegVQC3TrqVpIzSdZi2lvY+WbmSze1617nDBZ/xUzXfgQ1JCWy6
EYwmj0xvxVNhJbk+K6bAVJWLwdmsaKDZORg6WgXemLcfNEEEf71MNh5KTaMCweDJ
izmaZPAbAyiig9jV+Vz7rDJZT2JVIoF6GRJe06nhvKAycLAo935mzTBJ8b7d5dZA
yB9kI7saz1F/1XkNBCaz
=H9J8
-----END PGP SIGNATURE-----

--=-geTt6ILFUmzdYg3YStie--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
