From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] update ocrdma to dual license
Date: Wed, 08 Jul 2015 15:33:03 -0400
Message-ID: <559D7AEF.6070405@redhat.com>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com>	<20150630060631.GA21105@infradead.org>	<CANjDDBh3pxLFe2o08KzAtw8dtVq94GK04x4YZ0nXA+YnVh5Bng@mail.gmail.com>	<20150701072120.GB31381@infradead.org> <CANjDDBinTi43KTt14C7cJ0Uo=Do8Vt3G6bXutLbsViUFUG=jRg@mail.gmail.com> <2807E5FD2F6FDA4886F6618EAC48510E110A880D@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8SCc6OcureIwQEHXJBTwGD9kuXuU41oIM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E110A880D-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8SCc6OcureIwQEHXJBTwGD9kuXuU41oIM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/03/2015 11:38 AM, Weiny, Ira wrote:
>>
>> Christoph,
>>
>>
>> Apologies, I misspoke in my response to you.  There was a study of the=
 code and
>> we thought it was reasonable to post.  However, in retrospect we shoul=
d have
>> used more due diligence.  We're going back to seek explicit consent fr=
om key
>> contributors.
>=20
> I'm no legal expert, but don't you need consent from _all_ contributors=
?

I am not a lawyer, but this has been explained to me on numerous
occasions, so I relay the layman's interpretation here:

No, you don't always need everyone's approval.  There are contributions
that are not legally copyright worthy.

Anyone with questions should speak to a copyright/trademark specialist
attorney and discuss things such as the Merger Doctrine (I think that's
what it's called).  My memory is clear enough to know that exceptions
exist, but my memory of the name of the principle under which these
exceptions exist might be wrong.

As far as it would apply to the ocrdma driver though, you either have to
default to asking each contributor for permission, or each contributor's
patches would need to be analyzed by a competent attorney in this area
and all of the contributors with patches that are not exempted would
have to be contacted.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--8SCc6OcureIwQEHXJBTwGD9kuXuU41oIM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnXrvAAoJELgmozMOVy/djsAQAJcNa5A/R4LOkI3LMEcg16rC
BdByQ1VjeDH9myp4uRkqNa/I+O1XMiAbXj2fCB5n/3ZPhEbIvVJ9CLl0wCqAO57w
F7ywCm6mCMhAu/9UAoCxwfno+0AXzN79zUQazsKJKco/XH+ZMOA8nTGLgWBrWCmq
XLCpB/MGlZ4MKF7bb0qArsbBfiOVwRwn/Smln8N6dKQr+EPpwVi3sez0acUNr04i
gThg97zDyOTcg1FA/VL35PptXQv02jgaKonhurx/9vX3XdfuW3M8W/zZQxEIFI9K
9ptuvMxCqPwsSfrXe1s/fqSF4dX8/KgMzp+pnhM4RR3JK0SmBaWt7Y657elXfzUa
l264KrpHpqVPbrtSZgiKEQ7UnS3+NAAvJFR3XbyplqcEPtfEgfq/DT9cpGZUxOy4
6P6YYQUjB55yKO20kX/ugGd2TtWxY/QFvIHaDcczSAUyVeBVZ6VzMMM/LDNXlknE
q7XvtTFHBLdQmf5D02lRJsWWiKH7daeO1TkpXiK+kP5b1N9bn+pHwxFXuQIrJDm2
dEfoWk0Watstj6kqIhI0iSPuva4aK876mhEctyX7TA3fnwYdbovGELi//PrOyl1W
hl3SfB6ng8yDE5OkSy2/ECRSGKf9SLmA/XNe92Q86vSKzBaBizUlGh4KNfWKIxpn
aIZrohyTdkLeetAtaFkW
=4oQ/
-----END PGP SIGNATURE-----

--8SCc6OcureIwQEHXJBTwGD9kuXuU41oIM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
