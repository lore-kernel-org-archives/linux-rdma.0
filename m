From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Demux IB CM requests in the rdma_cm module
Date: Thu, 30 Jul 2015 11:30:55 -0400
Message-ID: <55BA432F.7030201@redhat.com>
References: <1438267826-32155-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ClgJ1gg3H3L44BKUQsgkA1VRglFCbsXgw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438267826-32155-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ClgJ1gg3H3L44BKUQsgkA1VRglFCbsXgw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 10:50 AM, Haggai Eran wrote:
> I'm sending the patchset again with the rwsem patch and rebased over Do=
ug's
> to-be-rebased/for-4.3 tree.

Thanks for rebasing, I was able to apply them this time.

>=20
> Regards,
> Haggai
>=20
> Changes from v3:
> - rebase over github.com/dledford/linux to-be-rebased/for-4.3
> - add rwsem patch
>=20
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
> Haggai Eran (12):
>   IB/core: Add rwsem to allow reading device list or client list
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
>  drivers/infiniband/core/cma.c             | 646 ++++++++++++++++++++++=
--------
>  drivers/infiniband/core/device.c          | 134 ++++++-
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
>  18 files changed, 1040 insertions(+), 312 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ClgJ1gg3H3L44BKUQsgkA1VRglFCbsXgw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVukMvAAoJELgmozMOVy/dAKYP/jGM+dlqBmLPColKsbKfmDba
CYEUbLW4F4xhYNdsSansrFvsL5dGzqFBp1/61rXnXecwHnQxaH715xZjz/+p6yFM
F0RDd0S6oPTm6IQx/UMnb7JorWkkYfxqVzSEkrTKO7maBCoC6H2okXw6Fxz3ZDMB
+LodBduCMITfAEDtNTlyvPkumE9qRpLdaTeOOoOQFkLWTlgWssEEkxtpggF/2HVE
xJLCLJq/b7kfonJElHlArt52NONTBDpChGxVwfcb8QLyIEmg05ICWn9LbYwjgVE+
c2SY8TONI8sYK2nbgjimOK0XV00ZIG8cADfkcfL3MR2Pe88wOgwa+pxRBoXNkkJh
JjL5Q05ww/GyCXflaOeqIRJPRRfWE4aL0y7pBOweapZ+PoT7+lA2yz3ip77ezmSY
zYOWyIefU0/v/q4Dc+PeyHo88SMD4E93n3XzoBm68ICCpIAZN3MMyfA+KN2MwAVj
GVGTGGUsnk3nZFOylx5LES3oBNSG+poo/6n7cJuokqP/gupt+Jdz23G6slsXco3k
mvv0J6yRXKqGSGAH2LE38zLs1jl9Qh2JYQDIDPc70N6lVznaynhZah3WlGxf+1HA
DLmIFYiFQhJSL0Xf9qXMfdQH93+cB0BmgwYwdMqDkOPrutnj9Cc+0G6zQdG8lgfF
4q+yeqhZ4Ki/RyR2qF77
=A6Ds
-----END PGP SIGNATURE-----

--ClgJ1gg3H3L44BKUQsgkA1VRglFCbsXgw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
