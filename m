From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Implement Expected Receive TID Caching
Date: Thu, 18 Feb 2016 12:12:09 -0500
Message-ID: <56C5FB69.8080405@redhat.com>
References: <1454691478-15444-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rtrnEj0O27mUSi1tXuAsxmVrUNI2cm1g1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454691478-15444-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rtrnEj0O27mUSi1tXuAsxmVrUNI2cm1g1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/5/2016 11:57 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Doug,
>=20
> This was resubmitted to you as v2 and is the first series which all of =
our
> submissions are based on.  We detected that we had improperly used the =
BIT
> macro in the exported hfi1_user.h header.[1]  This resulted in us needi=
ng to
> drop a patch and rework the next patch which adds a bit to the header. =
 This
> rework is self contained within this series.  None of the other series'=
 are
> affected by this change.
>=20
> Thanks,
> Ira
>=20
> [1] I'll blame checkpatch.pl --strict but it's still my fault...  ;-)
>=20
>=20
>=20
> Expected receives work by user-space libraries (PSM) calling into the d=
river
> with information about the user's receive buffer and have the driver DM=
A-map
> that buffer and program the HFI to receive data directly into it.
>=20
> This is an expensive operation as it requires the driver to pin the pag=
es which
> the user's buffer maps to, DMA-map them, and then program the HFI.
>=20
> When the receive is complete, user-space libraries have to call into th=
e driver
> again so the buffer is removed from the HFI, un-mapped, and the pages u=
npinned.
>=20
> All of these operations are expensive, considering that a lot of applic=
ations
> (especially micro-benchmarks) use the same buffer over and over.
>=20
> In order to get better performance for user-space applications, it is h=
ighly
> beneficial that they don't continuously call into the driver to registe=
r and
> unregister the same buffer. Rather, they can register the buffer and ca=
che it
> for future work. The buffer can be unregistered when it is freed by the=
 user.
>=20
> This change implements such buffer caching by making use of the kernel'=
s MMU
> notifier API. User-space libraries call into the driver only when they =
need to
> register a new buffer.
>=20
> Once a buffer is registered, it stays programmed into the HFI until the=
 kernel
> notifies the driver that the buffer has been freed by the user. At that=
 time,
> the user-space library is notified and it can do the necessary work to =
remove
> the buffer from its cache.
>=20
> Buffers which have been invalidated by the kernel are not automatically=
 removed
> from the HFI and do not have their pages unpinned. Buffers are only com=
pletely
> removed when the user-space libraries call into the driver to free them=
=2E  This
> is done to ensure that any ongoing transfers into that buffer are compl=
ete.
> This is important when a buffer is not completely freed but rather it i=
s
> shrunk. The user-space library could still have uncompleted transfers i=
nto the
> remaining buffer.
>=20
> With this feature, it is important that systems are setup with reasonab=
le
> limits for the amount of lockable memory.  Keeping the limit at "unlimi=
ted" (as
> we've done up to this point), may result in jobs being killed by the ke=
rnel's
> OOM due to them taking up excessive amounts of memory.
>=20
>=20
> ---
> Changes from V2:
> 	Remove patch (series is now 13):
> 		uapi/rdma/hfi/hfi1_user.h: Convert definitions to use BIT() macro
> 		because exported user headers can't use the BIT macro
> 	Rework patch:
> 		uapi/rdma/hfi/hfi1_user.h: Add command and event for TID caching
> 		to not use the BIT macro
>=20
>=20
> Mitko Haralanov (13):
>   staging/rdma/hfi1: Add function stubs for TID caching
>   uapi/rdma/hfi/hfi1_user.h: Correct comment for capability bit
>   uapi/rdma/hfi/hfi1_user.h: Add command and event for TID caching
>   staging/rdma/hfi1: Add definitions needed for TID caching support
>   staging/rdma/hfi1: Remove un-needed variable
>   staging/rdma/hfi1: Add definitions and support functions for TID
>     groups
>   staging/rdma/hfi1: Start adding building blocks for TID caching
>   staging/rdma/hfi1: Convert lock to mutex
>   staging/rdma/hfi1: Add Expected receive init and free functions
>   staging/rdma/hfi1: Add MMU notifier callback function
>   staging/rdma/hfi1: Add TID free/clear function bodies
>   staging/rdma/hfi1: Add TID entry program function body
>   staging/rdma/hfi1: Enable TID caching feature
>=20
>  drivers/staging/rdma/hfi1/Kconfig        |    1 +
>  drivers/staging/rdma/hfi1/Makefile       |    2 +-
>  drivers/staging/rdma/hfi1/file_ops.c     |  458 +----------
>  drivers/staging/rdma/hfi1/hfi.h          |   40 +-
>  drivers/staging/rdma/hfi1/init.c         |    5 +-
>  drivers/staging/rdma/hfi1/trace.h        |  132 ++--
>  drivers/staging/rdma/hfi1/user_exp_rcv.c | 1208 ++++++++++++++++++++++=
++++++++
>  drivers/staging/rdma/hfi1/user_exp_rcv.h |    8 +
>  drivers/staging/rdma/hfi1/user_pages.c   |   14 -
>  include/uapi/rdma/hfi/hfi1_user.h        |   14 +-
>  10 files changed, 1373 insertions(+), 509 deletions(-)
>  create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.c
>=20

Most of this looked fine.  I had to retouch all the commit log subjects
(too long), and fix a spelling issue in one, but otherwise I've pulled
this into a branch for hfi1.


--rtrnEj0O27mUSi1tXuAsxmVrUNI2cm1g1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxftpAAoJELgmozMOVy/dXc0QALVZziKjqF5oW4VFL8rmWGMg
cwciqd9+ouoGZywfJQ4Jsds2l5RtxEDKKekJ1hmL1qjYrAcIn3j+kK2h9uOgPpAe
vbwmQLViXeDn23jpShtkK6ZqyyJ9Bnbc8tOFwDPGOAcZq/XMUOWkIdrLAiH3/+Of
olSs2cWSut4ALKkjKeFz+qtNctjIbBBbKwZufAV5IzIh2PW1CJjUMLedPrBney6r
JaLSB8m1V2DZHqglakzK13YwCnkrGPCtK5GkOWnRp6IFshLCBBd4TFEMADMd31oy
+xE7xvFlT020fbUS6ru/WDaPmMYE68/7J6wvqaNeMBDLGqfEbejtrjUhzjGtApAC
4DDjHgJHn5RDjsNRy/gBiaCkPADW22QKf4Dc2+p1OxLF9CBdR0JBNeGjSJ48Hf6W
o8PTu7dH8KD4L4GZ0kpohHmXbSzmzwIKPuo1iKOa1hz3zYIhgRjknJd9dlKZSMxv
+y1AdET6LbMO67a+Cg/UFr5OqIQU3xAKyX8IUdx/UHc7jNZNPjzTpp7m6NCkPcRB
LGwvfz8q3rHIlFPwEXp9jvZbn4FLGSAHx8z2EfKcdTVUPCqAlLmWYv/an9jOUC7q
JNZUInuwplaiiQ99tQ7hypDrpazOxUc91OHKQQcQJh5VOqdQDE+Ewr+PHdu6YZ2R
DjjSdNS3mGSC6UiDwtLm
=Dj0E
-----END PGP SIGNATURE-----

--rtrnEj0O27mUSi1tXuAsxmVrUNI2cm1g1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
