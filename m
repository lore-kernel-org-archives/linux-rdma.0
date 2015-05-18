From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Change rdma_protcol_iboe to roce
Date: Mon, 18 May 2015 11:08:56 -0400
Message-ID: <1431961736.3114.3.camel@redhat.com>
References: <1431630106-28829-1-git-send-email-ira.weiny@intel.com>
	 <1431702851.4214.3.camel@opteya.com>
	 <2807E5FD2F6FDA4886F6618EAC48510E1107F5B2@CRSMSX101.amr.corp.intel.com>
	 <1431725566.11477.15.camel@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-hnyVCxXV271+N5m+waXq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431725566.11477.15.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-hnyVCxXV271+N5m+waXq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-15 at 23:32 +0200, Yann Droneaud wrote:

> I think "It has been decided that ROCE should be used within" is not
> enough to justify the change.
>=20
> But "Most people in the community refer to this as "RoCE" so that name
> was chosen to move to." sound a bit better as an explanation.

Which was more or less the conclusion of the discussion about the
naming.  It's not a big deal, but we did reach a general consensus to
move to roce as the standard name instead of iboe.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-hnyVCxXV271+N5m+waXq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVWgCIAAoJELgmozMOVy/dsRsQALW4/+FOK6kK7DdwF7a/nnGz
CFdpmng6knLL7yatJo98xVenyDYsthaWxXySkbe3y6mWCsnTnDnqiwcicBIqSCfq
zs6UCiCx78GjyjJeS/M7cDe4LwEyc7r0TidmbXPYv4in8acKoCfqerZe8ZbNkzSK
tZ2aJpE6X5SWr8jU/1mDI1ldxHC0CJIhNLwolbegArehPV85IDN6gbDCXO29BjB0
gaQ9HF9Gxox+bnbmCMt0t+s4vIjx6rKAGwLMIBZyxKm4+bCjwUVjDvSog0kax6aF
xdMpvqX4QdU08lvpmstO8QhoMKOVjH/IF696bY0YmgqMkFkEyKVKVEnq+dgdznkT
ZOY89ws+cNBVVfWNa7Q5pytkQqoRCCcg7p9qaDTICnBgVgKqRAam+k2JqyepFcaX
X+Hq8o//oH2dzytP22QqL10LZyAFL0//r28KmYzOOTZrtHEXpJUkcp/GGXTrNFyq
YqeREsmPqk1/sHK27y7cc1QTy6VdXE4HSY7toD6Q7V2BomggsASW062WpUIauRui
ptvcAgWCAE0PhH809lwPJvCKNcKYQNgwN0Ay5LDy1dSexrqMRtWngXFrxeFI4ru1
wxpCu4P6NJpx55n+ITzZTvVPZ2D7x4isWcyfRd77X+UCQySL6rWop5TMdeeBJLij
IrHH2KCJX0tl67sL37Zl
=cfLZ
-----END PGP SIGNATURE-----

--=-hnyVCxXV271+N5m+waXq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
