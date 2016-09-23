From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/23] rdma-core Trivial fixes and documentation updates
Date: Fri, 23 Sep 2016 11:54:19 -0400
Message-ID: <8f23999e-6b84-4c40-60a8-c8b472b7f6e9@redhat.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ggf0Qo4oFW8QppaA423Hx7SahTMNq5C2a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ggf0Qo4oFW8QppaA423Hx7SahTMNq5C2a
Content-Type: multipart/mixed; boundary="Isjeui7lhBCC5phhh0JugeAH2qWTFt3MM";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <8f23999e-6b84-4c40-60a8-c8b472b7f6e9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/23] rdma-core Trivial fixes and documentation updates
References: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--Isjeui7lhBCC5phhh0JugeAH2qWTFt3MM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/21/2016 6:08 PM, Jason Gunthorpe wrote:
> This is the next batch of fixes, the 23 patches are all straight forwar=
d and
> should be uncontroversial. Most are documentation updates, plus a few
> obviously correct fixes from static checkers.
>=20
> Please forward Acks and I will apply this to the github soonish.
>=20
> The tree is here:
>  https://github.com/linux-rdma/rdma-core
>=20
> View the patches on github:
>  https://github.com/linux-rdma/rdma-core/pull/2
>=20
> Christoph Hellwig (6):
>   Add reporting bugs and submitting patches sections to README.md
>   verbs: Move documentation to Documentation/
>   rdmacm: Move documentation to Documentation/
>   ibcm: Move documentation to Documentation/
>   rxe: Move documentation to Documentation/
>   srp_daemon: Move documentation to Documentation/
>=20
> Jason Gunthorpe (16):
>   Consolidate the .gitignore files
>   Move the AUTHORS files into MAINTAINERS
>   mlx5: Add cmake options to replace --with-mlx5_debug/mw_debug
>   ipathverbs: Recognize bashisms in truescale-serdes.cmds
>   nes: Fix clang 3.6 warning
>     -Wtautological-constant-out-of-range-compare
>   ocrdma: Fix incorrect type of ibwc_status
>   ocrdma: Fix incorrect enum constant
>   verbs: Fix incorrect type of len
>   verbs: Use inttypes.h format string macros
>   rdmacm: Use correct format specifier for size_t
>   rdmacm: Fix leading \'s in rcopy man page
>   rdmacm: Fix typos
>   umad: Replace .nl with .sp in man pages
>   iwpmd: Install ancillary files for iwpm
>   iwpmd: Remove syslog.target from service file
>   srp_daemon: Use SRP_DEFAULT_START/STOP for substitution
>=20
> Steve Wise (1):
>   iwpmd: Add man pages

Series looks good.  I pushed it to rdma-core master.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Isjeui7lhBCC5phhh0JugeAH2qWTFt3MM--

--ggf0Qo4oFW8QppaA423Hx7SahTMNq5C2a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX5VAwAAoJELgmozMOVy/d/hQP/1DkUKNUt/HUv0YeUQ9abN+i
wnCFLi7FYXccQHDx61kY6ZWxIw33XSzGu6Zj6kNFE/Bs3xFkVsEnHpXr4PELgyGz
n+ZSYEjnCHlE0XOldMPoNqWjUPLiseP2qNq2ERsmQYNLpGH1f0xk3iKKwZFMZ/RR
NuwwAwuDiVyz6a+jAkFiEH588kYe4AVLOjv0RRJiFK/qnlHYxal0XgXheP2MX+Te
wPGePfwSJL3ovuQwXkSmmtLlNEGCp0PJNibzkPT+6Ceuathc1LT7A/+EvzA96obm
6J3ELNHSJZPPAV1299K+42utxXuaTUTprN1XToi8+NM/tUYlJF1bm+J1fmE/nbl+
+ogyuZOEoW249zLEg8TT8YoFwkuwn4v1yw3ko+E6bhjNJYpLYHfxEltQoFGSqQeX
LEEq+s1eLhX6X8Fzj5Z6Nqr+MdA46YwZiYoTsoACXih79OLQ2KwHkoAr0h3/bOEk
78tAJRpdtnGGQz1CvJARtr219KP24s+eTYw6ueQKWnMwPeR/sWJAJEKV+u9chYMF
ekzwOGhM/E9RQ8CmIUlbGOHd5JIyOHckJGDPtS1WlthtzKNyfcWB7QFYMcNiuQ+B
wS2ng4mX9140cqaiTR/++Li6AkEDrx5Dj6sWTNHInBDtm6mp7rxaImSR4YV/o7QF
twHfpYN25T1mkx+NdYxY
=Je8p
-----END PGP SIGNATURE-----

--ggf0Qo4oFW8QppaA423Hx7SahTMNq5C2a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
