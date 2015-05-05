From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-rdma repository url
Date: Tue, 05 May 2015 13:47:40 -0400
Message-ID: <1430848060.2407.246.camel@redhat.com>
References: <EE7902D3F51F404C82415C4803930ACD5DC493FD@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-VChups+ukJeEw0w9OzMY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC493FD-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-VChups+ukJeEw0w9OzMY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-05 at 07:01 +0000, Devesh Sharma wrote:
> Hi Doug,
>=20
> =20
>=20
> Pardon me if it=E2=80=99s a repeated question for you, what is the git ur=
l to
> clone and cut patches for posting on linux-rdma community. Roland used
> to maintain it on kernel.org.

I added linux-rdma to this email because this is a question I need to
answer generally.

I've been chatting with Linus and while he'll accept pull requests from
github repos, because of the open nature of github and therefore the
lower security, he does prefer kernel.org.  I've filed a ticket with
kernel.org to get an account, so when they get around to creating it and
giving me repo space there, I'll update the MAINTAINERS file to point to
that url.  For now, I'll keep using github though.

This brings up an issue I wanted to let people know about.  Good git
hygiene is for a maintainer to never rebase a tree.  This is all well
and good, but as people have seen by watching Michael's cleanup patch
set, sometimes a rebase is inevitable.  So, in order to fullfill the
role of both a maintainer with good git hygiene and the need of
someplace for people to see forward looking state, I will be maintaining
*both* the kernel.org and my personal github kernel repos with the
understanding that nothing will appear in kernel.org until I am
essentially ready to send the pull request for it (although that's an
oversimplification, more accurate would be once it lands in kernel.org,
no further changes to the existing patches will be possible, updates
will need to be done as incremental patches on top of whatever is there,
aka fast forward updates only to my branches on kernel.org), and things
will appear in my github repo sooner, but may later change or get
rebased (although I will try to keep that to a minimum, but sometimes it
can't be avoided).

With that in mind, I've put up a new push of the tree to the current
github repo (git://github.com/dledford/linux.git).  It has the changes I
have queued for the 4.1-rc cycle.  People can see what I have queued up
by pulling either the for-linus tag, or the k.o-for-4.1-rc branch.

I also want to take a minute and let people know that I plan on doing a
standard for-<version>-rc branch on each release.  I'll create the
branch once the <version>-rc2 kernel tag is available.  Unless the rc2
tag is unstable, in which case I'll pick another one.  That will be
where I put any patches for problems found during rc cycles and it will
stay constant with only rdma related fix patches added until the end of
the rc cycle.  So if people want to know when and what kernel to start
rc phase testing on, that's going to be it on each release.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-VChups+ukJeEw0w9OzMY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVSQI8AAoJELgmozMOVy/dEFEQAI/vnMKI/NOTZ34+E74AZoKq
dSW/rEC/y7nCx9iF+Bw8RGem9Kr+Hhtw5k9LPrZLhUsVcEPKQZgLvMxGRj63L7Wq
EEdv231x7yN1WXwIn3mSC2/5D/SoEF0o4BogHf61aXQpMfwAMKOHV88e+UoRmsG4
4WYJIoEdzskwMRs6LMs1cCXp4sHTq31lLscEtLbKrehRZBcFAiJ1l7KXkvQrCPO+
k24KnocoM8hrr7ExBwQK923efWFv6PpN7NyFzo2WU2eMwPNRICvhab2+8EhA9hT6
QWXCYD5+y3RE/TCeeljfl/DUQ6YWTbRp+i4dNniF5W3EYSvx9vDhU86zssWXirAK
iTrCl0u8si6hCRa7Hf9lcci9mn3NhuxCcNGxC0fehQx6i9tMMo8SMFuothmYmVID
X9/mub50vLnqWHyk8jmnihwrgqgOjGG1Su4gXWZeHq5GqMdbksX/dAo/9o36LYL8
Ks8sfxzP6yoWM1R0cvLurH2Z0rok58l3itLXwENlmfEcS4bj44QLefi8qClqOy6v
n0HRxz4pYdnkU/qKOTnyRsnY8R9X1Rycd0YkCeKq8YJH/xrzLi6hWKffPGAC58rW
v+R6RIBYhT8GxfGgztt7QsbRt+FX0iDHRvJjI8fGkPV3zPO5hIvQCGXAwj9mcqPX
hIrMX9VSTBFwQtkzlTyO
=V8m7
-----END PGP SIGNATURE-----

--=-VChups+ukJeEw0w9OzMY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
