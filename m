From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
Date: Wed, 28 Sep 2016 17:11:24 -0400
Message-ID: <57EC31FC.4040200@redhat.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-12-git-send-email-jgunthorpe@obsidianresearch.com>
 <57EC0B75.3000101@redhat.com> <20160928184708.GA31472@obsidianresearch.com>
 <07810a28-9db1-6dca-0666-d811fe246b7e@sandisk.com>
 <20160928210137.GB2533@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="lQ6tdVOL5kLqfPrg4pBaBgFvP1Vp3r9xo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160928210137.GB2533-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lQ6tdVOL5kLqfPrg4pBaBgFvP1Vp3r9xo
Content-Type: multipart/mixed; boundary="6qoeqH1mmQFt85EWfHUWNO4RCnTNvehXp";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <57EC31FC.4040200-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
References: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1474658228-5390-12-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <57EC0B75.3000101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <20160928184708.GA31472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <07810a28-9db1-6dca-0666-d811fe246b7e-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <20160928210137.GB2533-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160928210137.GB2533-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--6qoeqH1mmQFt85EWfHUWNO4RCnTNvehXp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/16 5:01 PM, Jason Gunthorpe wrote:
> On Wed, Sep 28, 2016 at 01:18:51PM -0700, Bart Van Assche wrote:
>> On 09/28/2016 11:47 AM, Jason Gunthorpe wrote:
>>> To be clear, there is already an initscript that (perhaps?) is for
>>> RedHat - but it isn't even close to the Debian version. So this patch=

>>> introduces two scripts for srp_dameon, which I hated doing..
>>
>> The existing init script works reliably on multiple versions of RHEL, =
SLES,
>> Fedora and openSuSE. It is not specific to Red Hat distro's. So I'm
>> surprised that a separate initscript is needed for Debian?
>=20
> I suspect not being distro specific is the entire problem,

Indeed...

> eg the
> Debian initscript is using /etc/default/srptools to configure
> how the daemon is launched and it uses the start-stop-daemon tool.
>=20
> A good initscript should consistently follow the distro policies for
> initscripts..

Exactly why we often don't use the ones in the upstream package.  Try to
be generically good, and you will be universally, generically bad for
any specific distro.  If you want to provide one as an example, that's
fine.  If you want to provide one that's actually used, then you need
one per distro (or a means of generating a distro specific one from a
template or some such).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--6qoeqH1mmQFt85EWfHUWNO4RCnTNvehXp--

--lQ6tdVOL5kLqfPrg4pBaBgFvP1Vp3r9xo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7DH8AAoJELgmozMOVy/dBmIP/jSFCWjW/4w3o6Rw0m1OjtYr
y77X/TTDF0QxrYLp7AQgWcZ/+T48Y2+eukelPf9Jj7zCYE9NURTIwS0f0DS0Vka5
SGDaSutDWpaojCBO0aqKkj4ztkCHkUfGegaDhdboV5sULMDZIqiPGdSxm1fLswnu
icYnHhJ3xvx9Jlx50NDJxD2pcqaLqCbGGtxiHEagknBvMKY+K5lf0pXi33ktrtvS
8EuoV199Q/SWW6BO2bBWOQ1w6UVER5stzuBmNe4PtOh3w4Y1UWZn3FpbKvlurmhI
XNkL8y1xoSVYb6QQsnR5eyaK3XJpmEJmndTixrgA91OlgIjiIU4NUrNpFdMcTxKE
CtX/4fKGy0X4hPEV1LZnTaqg3LBthlVXqFldSCwmtN7AGxqqT9npmq5bRvx5uxLR
RZBpctlPx4w0467fnlDgrAmXdXovegp1wOKUhqk0/6Sgbvvkp8LzB2d32ha3vGbc
xNw+ZnzvEh5U5vNll5aBR2ObfEQwEFYJcfG3sjMkCWHaYfa14TqBDcmFCzrk00t3
3UgjK45in0PpQdeICehKXiXpzPlvrv966D8/xw4lc4MZX9Z2TVxPqhZehAnfd44H
OTVRRvrWVRv8VJTL7/+NM5KEpgXj+GoiF3rqPnZZUcoD6vDo+RDPl4qDXb96OJjD
BrZWzHTs/Wmex5e0kolW
=YCLB
-----END PGP SIGNATURE-----

--lQ6tdVOL5kLqfPrg4pBaBgFvP1Vp3r9xo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
