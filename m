From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Mon, 12 Dec 2016 16:38:57 -0500
Message-ID: <f4591b41-019b-d55f-cede-d8f9eb72c3bd@redhat.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gfhOJrD47EX6aACVslQhoiotFCkXuau4R"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479910651-43246-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gfhOJrD47EX6aACVslQhoiotFCkXuau4R
Content-Type: multipart/mixed; boundary="apaDITKQ14oBgj4V25p46COVEDhGo12hB";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org,
 paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <f4591b41-019b-d55f-cede-d8f9eb72c3bd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
References: <1479910651-43246-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1479910651-43246-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--apaDITKQ14oBgj4V25p46COVEDhGo12hB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/23/2016 9:17 AM, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Infiniband applications access HW from user-space -- traffic is generat=
ed
> directly by HW, bypassing the kernel. Consequently, Infiniband Partitio=
ns,
> which are associated directly with HW transport endpoints, are a natura=
l
> choice for enforcing granular mandatory access control for Infiniband. =
QPs may
> only send or receives packets tagged with the corresponding partition k=
ey
> (PKey). The PKey is not a cryptographic key; it's a 16 bit number ident=
ifying
> the partition.
>=20
> Every Infiniband fabric is controlled by a central Subnet Manager (SM).=
 The SM
> provisions the partitions by assigning each port with the partitions it=
 can
> access. In addition, the SM tags each port with a subnet prefix, which
> identifies the subnet. Determining which users are allowed to access wh=
ich
> partition keys on a given subnet forms an effective policy for isolatin=
g users
> on the fabric. Any application that attempts to send traffic on a given=
 subnet
> is automatically subject to the policy, regardless of which device and =
port it
> uses. SM software configures the subnet through a privileged Subnet Man=
agement
> Interface (SMI), which is presented by each Infiniband port. Thus, the =
SMI must
> also be controlled to prevent unauthorized changes to fabric configurat=
ion and
> partitioning.=20
>=20
> To support access control for IB partitions and subnet management, secu=
rity
> contexts must be provided for two new types of objects - PKeys and IB p=
orts.
>=20
> A PKey label consists of a subnet prefix and a range of PKey values and=
 is
> similar to the labeling mechanism for netports. Each Infiniband port ca=
n reside
> on a different subnet. So labeling the PKey values for specific subnet =
prefixes
> provides the user maximum flexibility, as PKey values may be determined=

> independently for different subnets. There is a single access vector fo=
r PKeys
> called "access".
>=20
> An Infiniband port is labeled by device name and port number. There is =
a single
> access vector for IB ports called "manage_subnet".
>=20
> Because RDMA allows kernel bypass, enforcement must be done during conn=
ection
> setup. Communication over RDMA requires a send and receive queue, colle=
ctively
> known as a Queue Pair (QP). A QP must be initialized by privileged syst=
em calls
> before it can be used to send or receive data. During initialization th=
e user
> must provide the PKey and port the QP will use; at this time access con=
trol can
> be enforced.
>=20
> Because there is a possibility that the enforcement settings or securit=
y
> policy can change, a means of notifying the ib_core module of such chan=
ges
> is required. To facilitate this a generic notification callback mechani=
sm
> is added to the LSM. One callback is registered for checking the QP PKe=
y
> associations when the policy changes. Mad agents also register a callba=
ck,
> they cache the permission to send and receive SMPs to avoid another per=

> packet call to the LSM.
>=20
> Because frequent accesses to the same PKey's SID is expected a cache is=

> implemented which is very similar to the netport cache.
>=20
> In order to properly enforce security when changes to the PKey table or=

> security policy or enforcement occur ib_core must track which QPs are
> using which port, pkey index, and alternate path for every IB device.
> This makes operations that used to be atomic transactional.
>=20
> When modifying a QP, ib_core must associate it with the PKey index, por=
t,
> and alternate path specified. If the QP was already associated with
> different settings, the QP is added to the new list prior to the
> modification. If the modify succeeds then the old listing is removed. I=
f
> the modify fails the new listing is removed and the old listing remains=

> unchanged.
>=20
> When destroying a QP the ib_qp structure is freed by the decive specifi=
c
> driver (i.e. mlx4_ib) if the 'destroy' is successful. This requires sto=
ring
> security related information in a separate structure. When a 'destroy'
> request is in process the ib_qp structure is in an undefined state so i=
f
> there are changes to the security policy or PKey table, the security ch=
ecks
> cannot reset the QP if it doesn't have permission for the new setting. =
If
> the 'destroy' fails, security for that QP must be enforced again and it=
s
> status in the list is restored. If the 'destroy' succeeds the security =
info
> can be cleaned up and freed.
>=20
> There are a number of locks required to protect the QP security structu=
re
> and the QP to device/port/pkey index lists. If multiple locks are requi=
red,
> the safe locking order is: QP security structure mutex first, followed =
by
> any list locks needed, which are sorted first by port followed by pkey
> index.

Ack for the IB parts.  Do we have a vote on the SELinux parts from the
security people?

> ---
> v2:
> - Use void* blobs in the LSM hooks. Paul Moore
> - Make the policy change callback generic. Yuval Shaia, Paul Moore
> - Squash LSM changes into the patches where the calls are added. Paul M=
oore
> - Don't add new initial SIDs. Stephen Smalley
> - Squash MAD agent PKey and SMI patches and move logic to IB security. =
Dan Jurgens
> - Changed ib_end_port to ib_port. Paul Moore
> - Changed ib_port access vector from smp to manage_subnet. Paul Moore
> - Added pkey and ib_port details to the audit log. Paul Moore
> - See individual patches for more detail.
>=20
> v3:
> - ib_port -> ib_endport. Paul Moore
> - use notifier chains for LSM notifications. Paul Moore
> - reorder parameters in hooks to put security blob first. Paul Moore
> - Don't treat device name as untrusted string in audit log. Paul Moore
>=20
> v4:
> - Added separate AVC callback for LSM notifier. Paul Moore
> - Removed unneeded braces in ocontext_read. Paul Moore
>=20
> v5:
> - Fix link error when CONFIG_SECURITY is not set. Build Robot
> - Strip issue and Gerrit-Id: Leon Romanovsky
>=20
> v6:
> - Whitespace and bracket cleanup. James Morris
> - Cleanup error flow in sel_pkey_sid_slow. James Morris
>=20
> Daniel Jurgens (9):
>   IB/core: IB cache enhancements to support Infiniband security
>   IB/core: Enforce PKey security on QPs
>   selinux lsm IB/core: Implement LSM notification system
>   IB/core: Enforce security on management datagrams
>   selinux: Create policydb version for Infiniband support
>   selinux: Allocate and free infiniband security hooks
>   selinux: Implement Infiniband PKey "Access" access vector
>   selinux: Add IB Port SMP access vector
>   selinux: Add a cache for quicker retreival of PKey SIDs
>=20
>  drivers/infiniband/core/Makefile     |   3 +-
>  drivers/infiniband/core/cache.c      |  57 ++-
>  drivers/infiniband/core/core_priv.h  | 115 ++++++
>  drivers/infiniband/core/device.c     |  86 +++++
>  drivers/infiniband/core/mad.c        |  52 ++-
>  drivers/infiniband/core/security.c   | 709 +++++++++++++++++++++++++++=
++++++++
>  drivers/infiniband/core/uverbs_cmd.c |  20 +-
>  drivers/infiniband/core/verbs.c      |  27 +-
>  include/linux/lsm_audit.h            |  15 +
>  include/linux/lsm_hooks.h            |  35 ++
>  include/linux/security.h             |  50 +++
>  include/rdma/ib_mad.h                |   4 +
>  include/rdma/ib_verbs.h              |  49 +++
>  security/Kconfig                     |   9 +
>  security/lsm_audit.c                 |  16 +
>  security/security.c                  |  59 +++
>  security/selinux/Makefile            |   2 +-
>  security/selinux/hooks.c             |  86 ++++-
>  security/selinux/ibpkey.c            | 245 ++++++++++++
>  security/selinux/include/classmap.h  |   4 +
>  security/selinux/include/ibpkey.h    |  31 ++
>  security/selinux/include/objsec.h    |  11 +
>  security/selinux/include/security.h  |   7 +-
>  security/selinux/selinuxfs.c         |   2 +
>  security/selinux/ss/policydb.c       | 129 ++++++-
>  security/selinux/ss/policydb.h       |  27 +-
>  security/selinux/ss/services.c       |  81 ++++
>  27 files changed, 1886 insertions(+), 45 deletions(-)
>  create mode 100644 drivers/infiniband/core/security.c
>  create mode 100644 security/selinux/ibpkey.c
>  create mode 100644 security/selinux/include/ibpkey.h
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--apaDITKQ14oBgj4V25p46COVEDhGo12hB--

--gfhOJrD47EX6aACVslQhoiotFCkXuau4R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTxjxAAoJELgmozMOVy/dQkgP/RtLZ1y5yr8vC6ExttGiZMLq
9HXG5d9EDkITMSH470VVvBN4HirjyoO2M8QR5tG0eh3LzqoumEGBekqeSyaWeu5l
/qK0RoJJnxhYnROA77it6X0pb2OBChe+yuFYTVl7rGikHUS4Gs7MP2IBS6LKU+aC
Fvy592xFneIH/1OLSaebkv2CXd9OTDONWeo8xqhJvRRenT8hEMPijSioeYCqsRfo
iDn9TkQIoPtaT7UyKFZtP8utMI2LbxoSCmfDQxKzKflD0HkWHlNSzAYDLI0oh+kJ
uNriYA0u6DFeY/0rbeYbu33uqXRgStjNpM8sXDsztrwBalnNzVDc98vjTvzu5vGU
+QmGFAZfxGYpc44tHymuwquUbrsuPDw1YvIvxBvIFStXJOmAToMIO6JBE2FNYwGr
iZvrm7ak5AZEI3MejvE5W/Ob61HhKDiRBknZPH8N3fzSwfE+d3dANhO+zDxDKI8D
nfc8t9v8Lc1UHMdfj1GHojQcXCr8BRaTRs2I57edRkdZqU5mbulpDVW27tLOvk/v
rfeUsY5xfUTFZLRCQH+3QYY50sp9WtLnM1XqWlb9tQT7RxokGKQldmYvhqOCxJhT
say2q9/leAisdQArRMchf7mWJu3Z3WdI1vRVkxRw/u3K5TSLGvoqTxwSWjtZCN6w
BCQkpLeawT2mRAG94XRr
=sChk
-----END PGP SIGNATURE-----

--gfhOJrD47EX6aACVslQhoiotFCkXuau4R--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
