From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/8] IB/srp bug fixes
Date: Sun, 19 Feb 2017 09:21:23 -0500
Message-ID: <1487514083.86943.119.camel@redhat.com>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FTd1wxfFg3c4MNCtKZcC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214185636.29250-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-FTd1wxfFg3c4MNCtKZcC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-14 at 10:56 -0800, Bart Van Assche wrote:
> Hello Doug,
>=20
> The patches in this series are the initiator patches I came up with
> while
> testing the SRP initiator and target drivers. Please consider these
> patches
> for inclusion in the upstream kernel.
>=20
> The changes compared to the previous version of this series are:
> - Left out the "Use the IB_DEVICE_SG_GAPS_REG HCA feature if
> supported" patch.
> - Added a patch to stop using memory regions with gaps since Laurence
> ran
> =C2=A0 into an issue with these memory regions that cannot be explained b=
y
> =C2=A0 analzying the SRP initiator code only.
> - Addressed Leon's comments about patch "Avoid that duplicate
> responses
> =C2=A0 trigger a kernel bug" and "Add support for draining IB_POLL_DIRECT
> =C2=A0 completion queues".
>=20
> The patches in this series are:
>=20
> Bart Van Assche (8):
> =C2=A0 IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
> =C2=A0 IB/srp: Avoid that duplicate responses trigger a kernel bug
> =C2=A0 IB/srp: Fix race conditions related to task management
> =C2=A0 IB/srp: Document locking conventions
> =C2=A0 IB/srp: Make a diagnostic message more informative
> =C2=A0 IB/srp: Improve an error path
> =C2=A0 IB/core: Add support for draining IB_POLL_DIRECT completion queues
> =C2=A0 IB/srp: Drain the send queue before destroying a QP
>=20
> =C2=A0drivers/infiniband/core/cq.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A04 +-
> =C2=A0drivers/infiniband/core/verbs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 35 +=
+++++--------
> =C2=A0drivers/infiniband/ulp/srp/ib_srp.c | 92 ++++++++++++++++++++++++--=
-
> ----------
> =C2=A0drivers/infiniband/ulp/srp/ib_srp.h |=C2=A0=C2=A01 +
> =C2=A04 files changed, 77 insertions(+), 55 deletions(-)
>=20
> Thanks,
>=20
> Bart.

Thanks Bart, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-FTd1wxfFg3c4MNCtKZcC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqanjAAoJELgmozMOVy/dVYsQAMHmLmr2AiR0GPxfGQVdukKx
bFprULhk4IpF9QJq3INJ8OA8TUAshl2M0XXPfv4Oez7dl+GHGPxBBOWdENR4hWXo
dP3/cV27XyfXyA/RXAjPmZI05NwTCOyj+ga+OGk0d10UgzgyYUtizy/YD3XkOCFq
m6LeJtIhQYfRmigMhfzBeOahgoxa2HnvqqO19CbEmBGZIUQhNBw7WKh9Sx27TRE1
zJZLeORUqg7oeBgxh4yloLRsrgbmVR2omMiAMYbCiPf0NkOYrz2fwXIEb1UoGAmk
LQFADEorwbU8/mVr3nYolUKss27qs+T4BkSG0olyLUaxo1HxHjVyf4ZhDRKIx7jU
ageEHYpotncPeV7lZKQoD+YCUOG12uXzNeoOmH+lrr+0xOMxMhEShMpIkjBY9HSU
ucPM8zKM5jNMPmSTOyv8n4MwIvDz+rARwrS+3FPLoQHyTgNn98u9t0xeKHnzkWSw
wR3xdxzzagsGm8KpRAK8yLhLzvVlwfX/EzjPJMW1rqIJWnfuotzzy2vt/HccxABu
h+EsgWo43Rmg4gTe5p0C5RfN4YIU/4IzeLUUWPfFrx8kn6/RNU8opB9IdxXYTX35
iMpC7N2tflEN8Qf5fsGetWJPhVueOWPDqhmbD2OLzjHpo+8nuZLMoWINXtoclmju
a5Kkz6XBlUmYzlknHwhp
=UiRw
-----END PGP SIGNATURE-----

--=-FTd1wxfFg3c4MNCtKZcC--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
