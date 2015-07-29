From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Demux IB CM requests in the rdma_cm module
Date: Wed, 29 Jul 2015 10:49:26 -0400
Message-ID: <55B8E7F6.2030603@redhat.com>
References: <1438167991-17211-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EGdMW9a57KvA1pIQBOrOatNsJ293Rfu7o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438167991-17211-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EGdMW9a57KvA1pIQBOrOatNsJ293Rfu7o
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/29/2015 07:06 AM, Haggai Eran wrote:
> Here's an updated patchset with the changes requested by Sean and Jason=
=2E Thanks
> for your comments.

Hi Haggai,

This doesn't apply on to a clean 4.2-rc4 kernel tree.  Can you please
rebase against either that or my to-be-rebase/for-4.3 branch of my
github repo?

> Changes from v2:
> - added missing reviewed-bys
> - Patch 5: remove service_mask as a parameter from ib_cm_insert_listen(=
)
> - Patch 9:
>   * move cma_req_info struct near other structs
>   * put GID by value in the struct
>=20
> Changes from v1:
> - Patch 1: mark ib_client_data as going down instead of removing all cl=
ient
>   contexts during de-registration.
> - Patch 2:
>   * move kdoc to the function definition
>   * do not call get_net_dev_by_params() on devices/clients that are goi=
ng
>     down
>   * pass client data directly to the callback
> - Patch 3:
>   * pass client data directly to callback
>   * fix a lockdep warning in ipoib_match_gid_pkey_addr()
>   * remove a debugging print left over
>   * set a rate limit to the duplicated IP address warning
> - Patch 5:
>   * change atomic_dec(&id->refcount) to cm_deref_id()
>   * always update listen_sharecount under the cm.lock spinlock
> - Patch 6: handle AF_IB requests by getting parameters from the listene=
r
> - Patch 8: new patch to expose BTH P_Key from ib_cm to rdma_cm
> - Patch 9:
>   * get P_Key used for de-mux from the BTH
>   * use -EAFNOSUPPORT in cma_save_ip_info to designate a possible AF_IB=

>     connection request
>   * pass a NULL netdev for AF_IB requests
> - Patch 11: handle AF_IB connections by filling connection information =
from
>   the listener id instead of from the net_dev
> - Patch 12: fix mention of the old ib_cm_id_create_and_listen function =
in
>   the changelog entry.
>=20
> Changes from v0:
> - Added a patch to prevent a race between ib_unregister_device() and
>   ib_get_net_dev_by_params().
> - Removed the patch that exported a UD GMP packet's GID from the GRH, a=
nd
>   related code.
> - Patch 3:
>   * Add _rcu suffix to ipoib_is_dev_match_addr().
>   * Add helper function to get the master netdev for bonding support.
>   * Scan for matching net devices in two phases: first without looking =
at
>   * the IP address, and then looking at the IP address only when the fi=
rst
>     phase did not find a unique net device.
> - Patch 5:
>   * Do not init listen_sharecount =3D 1 for non-listening ib_cm_ids.
>   * Remove code that sets a CM ID's state to IB_CM_IDLE right before
>     destruction.
>   * Rename ib_cm_id_create_and_listen() to ib_cm_insert_listen().
>   * Do not increase reference counts when failing to add a shared CM ID=
 due
>     to having a different handler callback.
> - Patch 9: Clean IPv4 net_dev validation function.
> - Added patch 10: new patch to use the found net_dev in IB/cma for
>   eliminating unneeded calls to cma_translate_addr.
> - Patch 12: Remove the lock argument to __ib_cm_listen().
>=20
> The rdma_cm module relies today on the ib_cm module to demux incoming
> requests based on their service ID and IP address. The ib_cm module is =
the
> wrong place to perform this task, as it can also be used with services =
that
> do not adhere to the RDMA IP CM service as defined in the IBA
> specifications. It is forced to use an opaque private data struct and m=
ask
> to compare incoming requests against.
>=20
> This series moves that demux task responsibility to the rdma_cm module.=
 The
> rdma_cm module can look into the private data attached to a CM request,=

> containing the IP addresses related to the request. It uses the details=
 of
> the request to find the net device associated with the request, and use=

> that net device to find the correct listening rdma_cm_id.
>=20
> The series applies against Doug's for-v4.2 tree with the patch adding a=

> rwsem to IB core [2] applied.
>=20
> The series is structured as follows:
> Patch 1 prevents a possible race between ib_client.remove() callbacks f=
rom
> ib_unregister_device(), and ib_client callbacks that rely on the
> lists_rwsem locked for read, such as ib_get_net_dev_by_params(). Both
> callbacks may call ib_get_client_data(), and the patch makes sure that =
the
> remove callback doesn't free the client data while it is being used by =
the
> other callback.
>=20
> Patches 2-3 add the ability to lookup a network device according to the=
 IB
> device, port, P_Key, GID and IP address. They find the matching IPoIB
> interfaces, and return a matching net_device if one exists.
>=20
> Patches 4-5 make necessary changes in ib_cm to allow RDMA CM get the
> information it needs out of CM and SIDR requests, and share a single
> ib_cm_id with multiple RDMA CM listeners.
>=20
> Patches 6-7 do some preliminary refactoring to the rdma_cm module. They=

> allow extracting information out of incoming requests instead of retrie=
ving
> them from a listening CM ID, and add helper functions to access the por=
t
> space IDRs.
>=20
> Finally, patches 8-12 change rdma_cm to demultiplex requests on its own=
, and
> patch 13 cleans up the now unneeded code in ib_cm to compare against th=
e
> private data.
>=20
> This series contains a subset of the RDMA CM namespaces patches [1]. Th=
e
> changes from v4 of the relevant patches are:
> - Patch 1
>   * in addition to the IB device, port, P_Key and IP address, pass
>     also the GID, to make future IPoIB devices with alias GIDs to uniqu=
e.
>   * return the matching net_device instead of a network namespace.
> - Patch 2: use IS_ENABLED(CONFIG_IPV6) without ifdefs.
> - Patch 5:
>   * rename sharecount -> listen_sharecount.
>   * use a regular int instead of atomic for the share count, protected =
by
>     the cm.lock spinlock.
>   * change id destruction and shared listener creation to prevent the c=
ase
>     where an id is found but it is under destruction.
>=20
> [1] [PATCH v4 for-next 00/12] Add network namespace support in the RDMA=
-CM
>     http://www.spinics.net/lists/linux-rdma/msg25244.html
> [2] [PATCH for-next V5 02/12] IB/core: Add rwsem to allow reading devic=
e list or client list
>     http://www.spinics.net/lists/linux-rdma/msg25931.html
>=20
> Guy Shapiro (1):
>   IB/ipoib: Return IPoIB devices matching connection parameters
>=20
> Haggai Eran (11):
>   IB/core: lock client data with lists_rwsem
>   IB/cm: Expose service ID in request events
>   IB/cm: Share listening CM IDs
>   IB/cma: Refactor RDMA IP CM private-data parsing code
>   IB/cma: Helper functions to access port space IDRs
>   IB/cm: Expose BTH P_Key in CM and SIDR request events
>   IB/cma: Add net_dev and private data checks to RDMA CM
>   IB/cma: Validate routing of incoming requests
>   IB/cma: Use found net_dev for passive connections
>   IB/cma: Share ib_cm_ids between rdma_cm_ids
>   IB/cm: Remove compare_data checks
>=20
> Yotam Kenneth (1):
>   IB/core: Find the network device matching connection parameters
>=20
>  drivers/infiniband/core/cache.c           |   2 +-
>  drivers/infiniband/core/cm.c              | 215 ++++++----
>  drivers/infiniband/core/cma.c             | 644 ++++++++++++++++++++++=
--------
>  drivers/infiniband/core/device.c          |  99 ++++-
>  drivers/infiniband/core/mad.c             |   2 +-
>  drivers/infiniband/core/multicast.c       |   7 +-
>  drivers/infiniband/core/sa_query.c        |   6 +-
>  drivers/infiniband/core/ucm.c             |   9 +-
>  drivers/infiniband/core/user_mad.c        |   6 +-
>  drivers/infiniband/core/uverbs_main.c     |   6 +-
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c   |   2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 236 ++++++++++-
>  drivers/infiniband/ulp/srp/ib_srp.c       |   6 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c     |   7 +-
>  include/rdma/ib_cm.h                      |  25 +-
>  include/rdma/ib_verbs.h                   |  33 +-
>  net/rds/ib.c                              |   5 +-
>  net/rds/iw.c                              |   5 +-
>  18 files changed, 1012 insertions(+), 303 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--EGdMW9a57KvA1pIQBOrOatNsJ293Rfu7o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuOf2AAoJELgmozMOVy/d1REQAKSSfNwtTx96oUb9XfqHbAD1
/HnqfOrZnZ2JkxRwWz6V+OuPqx256GvYpayGmyXyg0lnCrTc9oSBuKAGG5KSocbk
Fy8SqmjWrSRjbCszrktqJHrn+4Aah+WVSQTeh09h0EkhFenCTbH8mQOwu4+YOPrQ
OA/EK2nuB9MTPCJn8w06fd3WMTeqQxGvF1442ZjWQHr9NQSTcTejbSzr+zTH3daS
S2zePUKiFaVA0vSQJYNE7sWjJtQrIhdqW/xc1OsSb98MR9xIQZd+HSIb5nIitVKO
HU1W+uXq+m8yc6JPvJ5nIVefIs3WZ373JT9MbDeL5o7XuFsIn7uCT+4Vr12FBKQy
nl22HYpDRLLespJAYCdo0GfVdpakr8/GJuuqp2QpoQO7Gi/bzx9xn6YXxRS8Fpj7
SKS5ZOcHqofNMrLlGRXEdaqWXwuYZglKlvRILTxpI5ZNME/J10t70wOJ7WtUUIuQ
cyEJEHm5gbT5Bv9kGP/IMCMkFp8IydoG8J+AUblyHmZhdkL7YfT4Gjl+bkb0wioC
6BxUbqADPQh1eQKZWX8MUz258+3R9QlcTT6FO0muEGLLcGsis08XXGns5mxQ3mMP
JuwUUuKnO9kMLop7QwD+6boB65LKFzjpEvzE09eHbvQbpsqvpdrjWdYfcfEqdF+5
FMHA4DBs/G4m41Ca/e8c
=Xhql
-----END PGP SIGNATURE-----

--EGdMW9a57KvA1pIQBOrOatNsJ293Rfu7o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
