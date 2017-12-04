From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-16 has been tagged/released
Date: Mon, 4 Dec 2017 07:11:59 +0200
Message-ID: <20171204051158.GD2110@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eheScQNz3K90DVRs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eheScQNz3K90DVRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here's the information from the tag:

tag v16
Tagger: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date:   Mon Dec 4 06:50:59 2017 +0200

rdma-core-16

Updates from version 15:

- mlx5: Report tunneling offloads capabilities
- mlx5: Add tunnel offloads support in direct verbs
- verbs: Add support in RSS of the inner packet
- debian: Update changelog to include Debian uploads
- debian: Mark libraries as Multi-Arch: same
- debian: Add m68k as non-coherent DMA architecture
- libhns: Add rereg mr interface in userspace
- check-build: strip version infos from ABI references
- mlx5: Allow creation of a Multi-Packet RQ using direct verbs
- mlx5: Report Multi-Packet RQ capabilities through mlx5 direct verbs
- Add a helper function to verify 64 bit comp mask
- libhns: Add rq inline data support for hip08 RoCE user mode
- Documentation: update stable doc about ABI reference generation
- buildlib: check ABI compliance from travis container
- libibumad: Move common enums, defines, and helpers to umad_sa.h
- libibumad: Add umad_sa_mcm_rereg_test.c to tests
- libibumad: Add umad_sa_mcm.h for umad SA MCMemberRecord support
- cxgb4: Add missing null termination of hca_table
- Eliminate BEGIN_C_DECLS and END_C_DECLS macros in libibverbs and libibumad headers
- Update MAINTAINERS
- debian: Do not require valgrind on x32
- debian: Add alpha, hppa, sh4 as non-coherent DMA archs
- libhns: Filter for zero length of sge in hip08 userspace
- libhns: Make the provider sparse clean
- ibacm: Use MONOTONIC time base to avoid timer expiration issues
- ibacm: Fix a retry loop calculation race condition
- ibacm: Calculate correct tv_nsec value in event_wait()
- ibacm: Fix an incorrect expiration check for the retry timer
- mlx4: Add a report of RSS capabilities in ibv_query_device_ex
- vmw_pvrdma: Add SRQ support
- vmw_pvrdma: Update rdma-core to latest kernel pvrdma-abi.h header
- librdmacm: mckey test support for send only full member
- librdmacm: Add support for extended join multicast API
- debian: Include architecture.mk for DEB_HOST_ARCH definition
- debian: Don't install disabled providers on archs that miss coherent DMA
- debian: Run wrap-and-sort
- debian: Drop lintian overrides for false positives
- debian: Bump Standards-Version to 4.1.1
- debian: Relax dh-systemd build dependency
- debian: Replace priority extra by optional
- debian: Let libibverbs1 16 break ibverbs-providers 15
- verbs: Enable QP and WQ creation with PCI write end padding option
- verbs: Report the device's PCI write end paddding capability
- mlx5: Support padded CQE by mlx5dv_create_cq
- mlx5: Expose 128B padded CQE capability in direct verb
- mlx5: Expose 128B CQE compression capability
- debian: Update changelog to include Debian upload
- debian: Do not require valgrind if not available
- debian: Do not build ibacm for non-Linux architectures
- Documentation: add documentation about stable branches
- suse: use python3 by default
- buildlib: use cmake to find python
- Fix compilation warnings when NDEBUG is set
- Revert "vmw_pvrdma: Add SRQ support" because it causes build failures
- libhns: Modify the usage of cmd_sn in hip08 RoCE userspace
- libhns: Set owner bit of SQWQE in user mode
- bnxt_re/lib: increment psn in case of 0 length packets
- bnxt_re/lib: fix the memory barrier call during poll-cq
- mlx4: Cleanup upon fatal in the destroy flow
- Align flow steering commands with other objects
- buidlib: validate tumbleweed instead of leap 42.3
- cbuild: disable curl-mini usage for tumbleweed env
- cbuild: allow envs to pass custom options to rpmbuild
- suse: add a bcond to disable usage of curl-mini
- librdmacm: Make return value from ucma_init consist
- verbs: Do not block QP attr_masks used by older kernels
- buildlib/cbuild: Add Ubuntu artful
- travis: Add RedHat and SuSE rpmbuild support
- suse: Bump OpenSUSE version to 42.3
- librdmacm: Remove unneeded condition
- libibumad/umad.c: In get_port, ignore sysfs rate file errors
- mlx5: Add support for CQ moderation
- mlx4: Add support for CQ moderation
- verbs: Add support for CQ moderation
- verbs: Expose CQ moderation capabilities
- libqedr: fix inline data copy
- mlx5: Fix wrong bitmap table allocation size calculation
- vmw_pvrdma: Add SRQ support
- mlx5: Use non-cached mapping when Blueflame is not used
- mlx5: Update mlx5dv_query_device man page
- mlx5: Report SW parsing capabilities through mlx5 direct verbs
- mlx5: Tag matching receive implementation
- verbs: Tag matching receive interface
- verbs: Tag matching send interface
- mlx5: Tag matching list operation completions
- mlx5: Tag matching post list operation
- verbs: Tag matching list manipulation interface
- ibacm: In acm_util.c:acm_if_iter_sys, try IPv4 if IPv6 doesn't find any appropriate interfaces
- ibacm: In acm.c:acm_open_providers, cosmetic change to log message
- ibacm: acm_util.c: Better log message when ioctl fails in acm_if_iter_sys
- libhns: Update consolidate repo for userspace library of hip08 RoCE
- libhns: Reimplement verbs of post_send and post_recv for hip08 RoCE
- libhns: Introduce CQ operations referred to hip08 device
- libhns: Introduce QP operations referred to hip08 RoCE device
- libhns: Add new PCI device matching for hip08
- verbs: Fix declaration of C++ include file in C-block
- providers/i40iw: Refactor queue depth calculation
- mlx5: Add support to tag matching SRQ type
- verbs: Introduce tag matching SRQ
- verbs: Expose tag matching capabilities
- verbs: Hardware tag matching
- ibacm: Incorrect list used for subnet list causes a segfault
- ibacm: Incorrect usage of BE byte order of MLID attach/detach_mcast()
- iwpmd: Return existing mapping if port reused on active side
- verbs: Fix C++ compilation break
- providers/i40iw: Do not generate CQE for RTR on QP flush
- librdmacm: Fix compilation warnings
- hns: Fix create QP structure layout
- verbs: fix compilation error with ICC
- rxe: Use VERBS_NAME_MATCH to match the rxe device
- hns: Use the generic modalias matcher
- cxgb: Use the new common PCI matching infrastructure
- providers: Use the new common PCI matching infrastructure
- verbs: Provide common code to match providers against kernel devices
- verbs: Remove the init_device entry point
- providers: Use the new match_device and allocate_device ops
- verbs: Split init_device into a match and alloc/bind step
- cxgb4: Move sysconf up to driver_init
- verbs: Change verbs_register_driver to accept the ops struct directly
- debian: Move perl:Depends from ibverbs-providers to rdma-core
- debian: Let lintian ignore example udev rule
- ibacm: Close MAD port when umad_register fails
-----BEGIN PGP SIGNATURE-----

iQJEBAABCAAuFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlok1UMQHGxlb25Aa2Vy
bmVsLm9yZwAKCRDkY3uINnJYp5SND/9msLKhAaQLuVBzKcJR8P8pDlwyPrX45x6b
1BXM+CW22j6dO7seuxSCr76YMdsEAqYqgUEf1Ld+yJMUY5f3vbtPw6ZLy50P62h0
UhunGa7CYJTNUhwu6wm3AFkfI1Oyd1kxnpfLq8fK7JWNY0mwjMQLUIGGWLAoJDRU
fgyVZPrp0OTu+AT5ip89p/Ysex6EhExxKZs3T5sfuBBVeHRjubtgH9/Uj3Ntv2KD
TkNhbExzm7aFAjIqs4QyzqCHPTIhrthYXJB8C5fFk76EdyDitABGvUJSDoG0RfCW
GZkXddXpEwiUm2zkf6lhm31s2vZocmakhGhOVD+5JHasjz7raV1+48Ggra0r+DWm
osDln3JIdlTEWsIsLnzOGYYsJVT62TqTNgf0jpWMag60Z3apfujjAhmgqg8nYPQ1
Z2l9AShVqBqYnUTakTyOEcg/frbnxZXGXZPvIafBD6rBkeh5r34NyrGc4k8vFW43
5sItkrBwGTHnn9Bb1gsZ2ITesD/B5TAem+c+JoOOoFl+AOthMOxtQ+q6Rr/jFpa3
KtJWK3NDllvo9D2FBu5qkNMSbmKyQ+CanMK972izDB9J7UQldeCV30Vkj7FzXnoK
fi3myVN5k2iNmANyVZBGJG7u/9f3BWsy2F5rn0dPbTQ2Bidwd0hAVvkY9rvUCff6
M6xtpPgwxw==
=ihDT
-----END PGP SIGNATURE-----

It's available at the normal places:

git://github.com/linux-rdma/rdma-core
https://github.com/linux-rdma/rdma-core/releases

Thanks

--eheScQNz3K90DVRs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlok2R4ACgkQ5GN7iDZy
WKcLFQ//YVWT9molfMUiTefLyUdPTbOxp8w2v3dvuotSB3v3sKgWA5O6wEe5OeJm
T3tysIk/Q8UMidy/aNcd1IPLnFezJ6YwiD3+dGsOA/NXriGIpn4snqNLCqoTx4MZ
3gByhvergPQWUoj8lN32Yhmoac5tFU7OZETIvrj42VG/cvQgCsqxX0xF6NOK3kyQ
5RIGlGMiFqUruyoxEjOxHkd52aPQIWVcnTGlLssWptey4zrU/oaELMAlVLG4D2bz
5Y8WTsRKRjKPZ/8L5BLupU0RuIws1B1IKx4TZ+GgQYf6Zo26zIHGNT923Dg2BYXi
pAOm6MeNCNEPQCB8VJ1jh8mjXTv27CkRx7CLZjksthbMUZe4adT6VJTOfgT++84D
8Cyel82tkLFta15vEQeCOtonG0O0C3Tih1N9V2PJJNUdBP3vlHgac4TeCuDC0jMm
Xk2iHL9JB6L23kk1XVCHUdIERAKaWEAOkOHfb1VqHSwOSvRJJ69AcuHGOXcpT3xU
XmYQgcTewIgJLbCBxu3I4Tzg8HDTzSj8gchRHn2DJ+8zX88fkMbsPGObuHBPD7Hv
AAtdlqpDNXxGWmqTZn3l/5rAtCYPKTgOV39FU43tZx7N6ZPa8DXXoo+G976hCtpg
oGBegJCjb7ByGLPYRqv6UpiKgMktNMMxGRJFErFkvM+nBVp4f0c=
=+3mt
-----END PGP SIGNATURE-----

--eheScQNz3K90DVRs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
