From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
Date: Tue, 26 Apr 2016 16:06:16 -0400
Message-ID: <571FCA38.5040106@redhat.com>
References: <1461682538-19647-1-git-send-email-sagi@grimberg.me>
 <571F8D48.4020503@sandisk.com> <571FBD4B.2030102@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8h0Aam5sIJsuSNHXqEgDtwqeNFoNLAKam"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571FBD4B.2030102-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8h0Aam5sIJsuSNHXqEgDtwqeNFoNLAKam
Content-Type: multipart/mixed; boundary="caMP5oDQopF0usQGh19Kv8fmMXMhFHTIt"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
 Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Message-ID: <571FCA38.5040106-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
References: <1461682538-19647-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
 <571F8D48.4020503-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> <571FBD4B.2030102-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
In-Reply-To: <571FBD4B.2030102-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

--caMP5oDQopF0usQGh19Kv8fmMXMhFHTIt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 4/26/2016 3:11 PM, Sagi Grimberg wrote:
>=20
>>> SRQ attached QPs will fail receive work posts does not
>>> have a receive queue that needs to be drained, the receive
>>> queue is shared.
>>
>> The patch itself looks fine to me but the description of this patch is=

>> very confusing.
>=20
> Sorry for the poor change log :) I was in a hurry (just now got back)
> and quickly wrote description and sent out the patch without giving the=

> phrasing any thought.
>=20
>> How about explaining that either an SRQ or an RQ is
>> attached to a QP and hence that if an SRQ has been attached that there=

>> is no RQ attached and hence that it should not be drained?
>=20
> I'll send out a better description, thanks.

I already picked the patch up and reworded the description myself.  See
if you are happy with it.  If not, I'll reword it again before sending a
pull request.



--caMP5oDQopF0usQGh19Kv8fmMXMhFHTIt--

--8h0Aam5sIJsuSNHXqEgDtwqeNFoNLAKam
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXH8o4AAoJELgmozMOVy/dH8sP/izQJCA4dWVH5UFLOg72X5+N
6iz1iVhjpa4C19jS5IdFS5WV0Zc+5VjPm4VJk1FSbQxNJ72+kjz7YGN6530J8JmU
1u1ZtcyrshPCFE9Dy3zKhTwxmfnspC93OJhTHcA7jbd7A6pMdkAQcMVzSZ825RUe
LMztCe+z3CwpTLFj0KXX4fVUbx/eloVAgri0b6CUSdKPIsFbNg3sEghwRAOXewBD
JexPYZAznG1/nMr+AAQbjQwJXyl753775IayxLCAq3oHpk9Lg0+gnLLpdAO8Vsy+
S0Vdn4y5eNcKYlMHk8uwDb1vTIz2E2sActqo3HZXZdbZhiRodhLWrkdWBZ7qr4Km
P0oY+XOUTSeZP3+svfJh3LEcMDaGr28prCyr0e+Dm/ionyr2GgVFshKOdMEvOOWC
AOOs2jE9WcjUkekTfjWIAO+2gN/O4GSdqSHeAna2DeR2AsK59WPMhXaWMcdkwx4S
oVp2ECJeJ2Pyitu1+Sf/9fP0LkqZT9QJpQ0pO+FOmXsQZT1+wXXlwKduUhITgLv4
dfN4nXaJM2GW1UrRePxAuizAduQXEjo8/Nny9Vkcg6mYx3bizoWA4LuOKQNGcm84
19cbArihq9rsNqqkHUiEc5k8TYdFydwunn5d16UB661Ubt9L7le0bqUdoModtdp7
jHW7SBGHNAul6ouRH+9x
=7QRs
-----END PGP SIGNATURE-----

--8h0Aam5sIJsuSNHXqEgDtwqeNFoNLAKam--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
