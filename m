From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 0/6] Refactor RDMA IOCTL declarations
Date: Fri, 23 Sep 2016 13:34:35 -0400
Message-ID: <f03ed222-dc50-2f7f-b79f-843f604f3c07@redhat.com>
References: <1472988635-31463-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X5jJ5IxbHN9l2Xnw2i5tsPTUOVDQ4PSaH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472988635-31463-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X5jJ5IxbHN9l2Xnw2i5tsPTUOVDQ4PSaH
Content-Type: multipart/mixed; boundary="xC6k8kTJhN9aKmPsGAisDlHEdR8mLRRdL";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <f03ed222-dc50-2f7f-b79f-843f604f3c07-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 0/6] Refactor RDMA IOCTL declarations
References: <1472988635-31463-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1472988635-31463-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--xC6k8kTJhN9aKmPsGAisDlHEdR8mLRRdL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/4/2016 7:30 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> This patch set refactors RDMA IOCTL declarations, unifies their
> location, moves all current IOCTL exporters to one place and renames
> them to fix the differences in coding style.
>=20
> IOCTLs commands need to export the size of their data for their transfe=
r
> which is usually declared as a struct defined in relevant submodule.
> These structures should be visible at the linkage stage.
>=20
> There are number of possible solutions to overcome this limitations.
>=20
> One of the options is to declare anonymous variable which will be visib=
le
> during the linkage. As a downside, such option won't allow direct use o=
f
> this header by other parts of code without their specific includes of
> other logically unrelated submodules.
>=20
> Another possible option will be to move declarations of that structures=

> to that common header file. Such move will cause to bloat this file
> with different submodules declarations.
>=20
> Our decision was to choose direct include of other exported files with
> declarations of such structures to simplify future usage of this file.
> There is no change for legacy applications and libraries.
>=20
> Changes v2->v3:
>  * Added Jason's Reviewed-by
>  * Open-ceded ioctl indexes
>=20
> Changes v0->v2 (v1 was skipped):
>  * Update commit messages of patch number 3 and 6.
>=20
> Available in the "topic/ioctl-header" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/ioctl-header
>=20
> Thanks
>=20
> Leon Romanovsky (6):
>   RDMA/core: Commonize RDMA IOCTL declarations location
>   RDMA/core: Move legacy MAD IOCTL declarations to common file
>   RDMA/hfi1: Avoid redeclaration error
>   RDMA/core: Move HFI1 IOCTL declarations to common file
>   RDMA/core: Rename RDMA magic number
>   RDMA/core: Unify style of IOCTL commands
>=20
>  include/uapi/rdma/Kbuild            |   1 +
>  include/uapi/rdma/hfi/Kbuild        |   1 +
>  include/uapi/rdma/hfi/hfi1_ioctl.h  | 173 ++++++++++++++++++++++++++++=
+++++++
>  include/uapi/rdma/hfi/hfi1_user.h   | 175 +---------------------------=
--------
>  include/uapi/rdma/ib_user_mad.h     |  14 +--
>  include/uapi/rdma/rdma_user_ioctl.h |  87 ++++++++++++++++++
>  6 files changed, 264 insertions(+), 187 deletions(-)
>  create mode 100644 include/uapi/rdma/hfi/hfi1_ioctl.h
>  create mode 100644 include/uapi/rdma/rdma_user_ioctl.h
>=20
> --
> 2.7.4
>=20

Series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--xC6k8kTJhN9aKmPsGAisDlHEdR8mLRRdL--

--X5jJ5IxbHN9l2Xnw2i5tsPTUOVDQ4PSaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX5WerAAoJELgmozMOVy/dWoYQAMS6K4MRwMLfvZSjJObF+GvN
mXAdyAoQoyHMM23bA+zFsVX/VOkRQLzh337w4C3w5Q3mDIs74yyT78mqGX5WM4qi
/v7nLerSV6oK8MMiD3SiSGeZzGJe8CfyNznRiPyDccy15ibB0pI6IReFMorgkKHL
U2EmaqA1F3mvrW6W8wbRmhC1LLdfJVtsGICHrSgzChT5QUYJq875fXqSZ2WciCLb
dTBR6yvuHSXHDHVfGMcWMRbD5lnoj0JXxJrmAj/I7zu9hlsZOeKwpv1NmA8abO8J
NTzfw9YplbgU7nB40EXdSdxlpbwlUj1z+xy/qToqF/OnPxGr5gfunQ/v5y+1jpv6
hPJlB+QjpdFFQH5SX0jNyoFkZcef0jkPjRUeiMvAixU/Y8+SWD3HgUtr6yRp2A8t
8PhAJrdDx1CU+OP4JfUC9UnF/Jzu4DlEX9X5Pv9trCUGBjHEhF+pfM2Ld+hP2wUP
Xqua+K8+YN2oqi3VMEOUJAxpVcjxZRBdxlvv+YgkrtM1L0AiHxHYp48gPqv1Ynii
6RNK2BlnR3r6uLDMIhXtkc5/oNdKj5yPf8Qo8gee59I+KHXyxVrcUFtqafeIQ7ED
+1KnqoHFhF7nLOOf9JmaEfCvqGil/Hm8+uWOZpgZFaiqBFSNJyBz/2lTnSsPFK9+
TbYkUUiQAii2KCu71lxP
=VKE8
-----END PGP SIGNATURE-----

--X5jJ5IxbHN9l2Xnw2i5tsPTUOVDQ4PSaH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
