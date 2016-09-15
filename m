From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 0/7] RSS support
Date: Thu, 15 Sep 2016 14:19:00 -0400
Message-ID: <82a5d950-aa53-ef12-c54c-8043d026d046@redhat.com>
References: <1473943691-3087-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4dmvUkiJvmSk60l3Ou2Urf22cfGU2rEr3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473943691-3087-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4dmvUkiJvmSk60l3Ou2Urf22cfGU2rEr3
Content-Type: multipart/mixed; boundary="CeoeGBRiM0NP7wdbf4K79tHAP8w1K1WWB";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Message-ID: <82a5d950-aa53-ef12-c54c-8043d026d046-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 0/7] RSS support
References: <1473943691-3087-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1473943691-3087-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--CeoeGBRiM0NP7wdbf4K79tHAP8w1K1WWB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/15/2016 8:48 AM, Yishai Hadas wrote:
> Hi Doug,
>=20
> Sending V2 to align the map file with the GCC syntax, details below.
> No other changes from V1.
>=20
> The series was tested successfully with mlx5 driver (lib, kernel) and c=
an be
> accessed also from my openfabrics GIT at:
> git://openfabrics.org/~yishaih/libibverbs.git branch: rss_v2
>=20
> This patch-set exposes to user space the required objects and verbs in =
order to
> allow verbs based solution to utilize the RSS offload capability.
>=20
> The kernel part for the 5 first patches was already accepted into 4.8, =
the
> capabilities patch (#6) was sent few weeks ago into 4.9, reviewed by Sa=
gi
> Grimberg and waits to your acceptance. The last patch adds and updates =
relevant
> man pages.
>=20
> Yishai
>=20
> In General:
> RSS (Receive Side Scaling) technology allows to spread incoming=20
> traffic between different receive descriptor queues.
> Assigning each queue to different CPU core allows to better load=20
> balance the incoming traffic and improve performance.
>=20
> Extra details can be found in each commit message.=20
>=20
> Patches:
> #1: Introduces Work Queue object and its verbs.
> #2: Introduces Receive Work Queue indirection table and its verbs.
> #3: Extends create QP to get a Receive-Work-Queue-indirection table.
> #4: Extends create QP to get RX hash data.
> #5: Tracks asynchronous events on a work queue.
> #6: Exposes RSS related capabilities.
> #7: Updates man pages for RSS usage.
>=20
> Changes from V1:
> patch #1: Align the map file around IBVERBS_1.3 to match the GCC syntax=
 as described in below wiki:
>           https://gcc.gnu.org/wiki/SymbolVersioning.
>=20
> Changes from V0:
> patches 1 & 2: Use IBVERBS_1.3 as the symbol label.
>=20
> Yishai Hadas (7):
>   Introduce Work Queue object and its verbs
>   Introduce Receive Work Queue indirection table and its verbs
>   Extend create QP to get a Receive Work Queue indirection table
>   Extend create QP to get RX hash data
>   Track asynchronous events on a work queue
>   Expose RSS related capabilities
>   Update man pages for RSS usage
>=20
>  Makefile.am                    |  10 +-
>  examples/devinfo.c             |  24 ++++
>  include/infiniband/driver.h    |  23 ++++
>  include/infiniband/kern-abi.h  |  92 +++++++++++++-
>  include/infiniband/verbs.h     | 282 +++++++++++++++++++++++++++++++++=
+++++++-
>  man/ibv_create_qp_ex.3         |  14 +-
>  man/ibv_create_rwq_ind_table.3 |  58 +++++++++
>  man/ibv_create_wq.3            |  59 +++++++++
>  man/ibv_modify_wq.3            |  43 +++++++
>  man/ibv_query_device_ex.3      |  10 ++
>  src/cmd.c                      | 213 ++++++++++++++++++++++++++++++-
>  src/device.c                   |  15 +++
>  src/libibverbs.map             |   9 ++
>  13 files changed, 842 insertions(+), 10 deletions(-)
>  create mode 100644 man/ibv_create_rwq_ind_table.3
>  create mode 100644 man/ibv_create_wq.3
>  create mode 100644 man/ibv_modify_wq.3
>=20

Series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--CeoeGBRiM0NP7wdbf4K79tHAP8w1K1WWB--

--4dmvUkiJvmSk60l3Ou2Urf22cfGU2rEr3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX2uYgAAoJELgmozMOVy/dWjsP+gJbQMadmkEUJBL9rP9AoNkJ
YtqecqDlOpF1oZsQSXedOwJsUhRQk/+j74xL69tAMOF485Xrqe1mSW/WBjO1gjtU
XjexZGaKqBNOYqGoFNViuGHrGd+k40loILfER8/IrPA5dCcpEMWBa+jFZVdLEHLL
OZgLKbbyD7UVfYnDnzvb/3dOHYvPjE57mUEzs2LWdNPEf1aNUKeDMsdMNaSxVqxW
eZIq33J+fWYtp32hj090ZyfCQQ7VRQUlQIiOizNEMQyGHqyANV7qfw+iSoY6oA1U
PfNpqN133OpmhAqPSI8vZJJFfy86lGE6I5pWQGXtgmbZezKsM/KOOIQ5LTrX+kxn
/uPzV4tsYDqLGSi3P3kydPMCIEoVc2Jd4ZcO4G3TfTqChJYbaofTnieQNMaMFPsT
Jf5jHhycxr/PzAmb+Wj+we2AiGqHnGe8EniqEjJO47v5HIzXanMVcpvz11p/8Fvj
WU/u/fwOXVbBKjMh5H6KQ6NS75wq0UpM/xKXRuzyH17bTeginyxTWUt238u0hh7q
wJbryyZvaVqD+sCkbrAdi+t94m1Dx6R6dG0EG894pk551dgWrLloS2VSbtVcvmly
bxnaOni/ZjXT2zN4kQ1cG2JlMqzyNQZqDMcqaPdno9SzMawLx2luJ1BJt0YzZPoy
bAlY1YN39UUCRqKhD+fq
=T7xb
-----END PGP SIGNATURE-----

--4dmvUkiJvmSk60l3Ou2Urf22cfGU2rEr3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
