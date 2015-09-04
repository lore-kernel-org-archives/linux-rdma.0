From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Fri, 4 Sep 2015 16:23:05 -0400
Message-ID: <55E9FDA9.3090709@redhat.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qw7qB5GllESNXXqQ2q0dAnmfuxB6h9erF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441292199-8371-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Gunthorpe, Jason" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qw7qB5GllESNXXqQ2q0dAnmfuxB6h9erF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/03/2015 10:56 AM, Haggai Eran wrote:
> This series adds userspace support for on-demand paging. The first patc=
h adds
> support for the new extended query device verb. Patch 2 adds the capabi=
lity and
> interface bits related to on-demand paging, and patch 3 adds example co=
de to
> the rc_pingpong program to use on-demand paging.

I've reviewed this series and I'm OK with it.  However, it's currently
blocked.  We need to fix the API mess that was created when the
create/destroy flow verbs were added.  I've gone back through the code,
and I'm pretty sure I know what Jason's objection to the create/destroy
flow implementation was.  In particular, we weren't supposed to have this=
:

 struct verbs_context {
        /*  "grows up" - new fields go here */
+       int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
+       int (*lib_ibv_destroy_flow) (struct ibv_flow *flow);
+       struct ibv_flow * (*drv_ibv_create_flow) (struct ibv_qp *qp,
+                                                 struct ibv_flow_attr
+                                                 *flow_attr);
+       struct ibv_flow * (*lib_ibv_create_flow) (struct ibv_qp *qp,
+                                                 struct ibv_flow_attr
+                                                 *flow_attr);

There was only supposed to be ibv_create_flow and ibv_destroy_flow, not
this silly separate drv/lib versions that just amount to wasted space
and confusion.

Our choices are: 1) Leave this in place but don't do any more extensions
this way, knowing full well that this is wrong but preserving ABI or 2)
Clean this up, but break ABI.  Just to be clear, neither solution breaks
user space app ABI, just the libibverbs/libmlx4 ABI.  Option 2 does not
require any apps be recompile, only that libibverbs and libmlx4 *must*
be upgraded together or downgraded together around the ABI break.  For
future versions beyond that, we don't have to have this requirement.

What are other people's thoughts on this?  I'm of a mind to clean it up,
but it's been since May 5th of last year that this went out.  Certainly
the largest portion of users are likely running this code.  It will mean
that their next upgrade is required to be a joint upgrade between this
and libmlx4.

> Changes from v1:
> - Patch 1:
>   * move code to revert to legacy ibv_query_device when ibv_query_devic=
e_ex
>     is missing to the inline function.
>   * add an input parameter to the ibv_query_device_ex verb for future
>     extension.
>   * add the size of the ibv_device_attr_ex struct as a parameter to the=

>     ibv_query_device_ex verb, to allow the verb to handle older
>     applications.
>   * check the validity of the input parameter and output struct size.
>   * remove reserved words from ibv_query_device_resp_ex, and remove unu=
sed
>     ibv_device_attr_ex_resp struct.
> - Patch 2:
>   * let print_odp_caps() receive a const pointer instead of a by-value
>     struct.
>   * check that the application has enough space for ODP capabilities in=
 the
>     provided ibv_device_attr_ex struct.
>=20
> Eli Cohen (1):
>   Add support for extended query device capabilities
>=20
> Haggai Eran (1):
>   Add on-demand paging support
>=20
> Majd Dibbiny (1):
>   libibverbs/examples: Support odp in rc_pingpong
>=20
>  Makefile.am                   |   3 +-
>  examples/devinfo.c            | 145 +++++++++++++++++++++++++++-------=
-------
>  examples/rc_pingpong.c        |  31 ++++++++-
>  include/infiniband/driver.h   |  10 +++
>  include/infiniband/kern-abi.h |  36 ++++++++++-
>  include/infiniband/verbs.h    |  68 ++++++++++++++++++-
>  man/ibv_query_device_ex.3     |  70 ++++++++++++++++++++
>  man/ibv_reg_mr.3              |   2 +
>  src/cmd.c                     | 147 ++++++++++++++++++++++++++++++----=
--------
>  src/libibverbs.map            |   2 +
>  10 files changed, 420 insertions(+), 94 deletions(-)
>  create mode 100644 man/ibv_query_device_ex.3
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--qw7qB5GllESNXXqQ2q0dAnmfuxB6h9erF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6f2pAAoJELgmozMOVy/dTkIQAK6cnXGf9jBi0v+pODe+4201
3RH1xgVMT+83yjiKQcxymonzLtXQ+qKXNytDLuTLdUnCKAw5jBCnlaRIIpyjhuPl
X+aFZ3sRk4nZ6TlCF3BbKU2dMsy6j8+30waJ02beFp/U4mJjRsGKQkhk7N6uuNcx
W1bHdxFiNyzekGptjQTPPVlxcYILUpOwsZ32EmD27Qc0O6J0hJOEKBqpcSeRMcTM
04PJEXq2QyyybS2BfauHts8+jCfMw7sNAaUCHkDsA8mgW5wodlg6XQ6butL8HFcC
VKU/oljkGX9dVy10Ye4sPC+ITLcisPZhqJzmgPU6ct7s2nAvTGqywNNYsYplhnSW
8NA4RuR0IZiifaJdh5YKfTKiM8qlgFhsZdaSLTyAD2ow8ShdI1bpoDsU35yggvnO
4nw/gCAPj9qf02Bd6pUXG1p10wJ2r8It7VSdWS7QitF/NC1YNjvoGwRWEH9PPk+z
RsD36DicoVWWmKdFgiNqQORmI47Bty7ETsvhcRR9j9VlyA6qN5oRHwdXxRQob1aJ
Dbk0c1NWlssBLMFH6rNbvSYs/gafWTcy5XM4ozP7Ar80PQiFJMWtA+AFrdYI/wHB
tzjS2BBJ7pzlN1ON5XAFxWTZg4h1THMF6SQ8atnaoY0UutBCkn2etqU4usxJlQFA
JYJNdmM29rs8JCU0NwyG
=F5pc
-----END PGP SIGNATURE-----

--qw7qB5GllESNXXqQ2q0dAnmfuxB6h9erF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
