From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v8 00/23] IB/Verbs: IB Management Helpers
Date: Tue, 12 May 2015 10:24:27 -0400
Message-ID: <1431440667.43876.23.camel@redhat.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
		 <20150511234910.GA20027@phlsvsds.ph.intel.com>
	 <1431390420.43876.4.camel@redhat.com> <5551B280.5040905@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-b7MlidVCnQYfFbTkfLk9"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5551B280.5040905@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: "ira.weiny" <ira.weiny@intel.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org


--=-b7MlidVCnQYfFbTkfLk9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 09:57 +0200, Michael Wang wrote:
>=20
> On 05/12/2015 02:27 AM, Doug Ledford wrote:
> > On Mon, 2015-05-11 at 19:49 -0400, ira.weiny wrote:
> >> I have run with this series and the only issue I have found is not wit=
h this
> >> patch set directly.
> >>
> >> This patch:
> >>
> >>>   IB/Verbs: Use management helper rdma_cap_ib_mad()
> >>
> >> causes an error when you actually use the port passed from the ib_umad=
 module.
> >> I have a patch to fix that which I found while trying to build on this=
 series
> >> for the use of a bit mask.
> >>
> >> Doug, I don't know what you would like to do for this fix.  I am submi=
tting it
> >> shortly with a new version of the core capability bit patches.  If you=
 want to
> >> just add it after this series or force Michael to respin with the fix?
> >=20
> > As I recall, there was a comment from Or requesting to squash some of
> > the individual patches down, but I no longer have that email in my Inbo=
x
> > to double check.  And it seemed like there was one other review comment
> > not yet addressed.  Do I have that right Michael?  And if so, are you
> > working on a v9?
>=20
> AFAIK Or was asking to merge the #15~23, and want to reserve the changelo=
g
> meanwhile reply the cover of prev version (I'm still confused on that...)=
,
> I've replied but get no respond yet.
>=20
> I can make a v9 to merge the #15~#23 if that could benefit the maintainab=
ility,
> please let me know your opinion :-)

I don't think it would make a significant difference.  I've pulled the
v8 patchset out of patchworks and I'll throw a new branch with it
included up to my github repo sometime today.

> About the Bug, if it was not introduced in this series, maybe including t=
he
> fix in next series would be better?
>=20
> Regards,
> Michael Wang
>=20
> >=20
> >>   Frankly
> >> I vote for the former because as it stands this series does not break =
directly.
> >> It was only after I changed the implementation of rdma_cap_ib_mad that=
 it
> >> broke.
> >>
> >>
> >> For the rest of the series.
> >>
> >> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> >> Tested-by: Ira Weiny <ira.weiny@intel.com>
> >> 	-- Limited to mlx4, qib, and OPA (with additional patches.)
> >>
> >>
> >> On Tue, May 05, 2015 at 02:50:17PM +0200, Michael Wang wrote:
> >>> Since v7:
> >>>   * Thanks to Doug, Ira, Devesh for the testing :-)
> >>>   * Thanks for the comments from or, Doug, Ira, Jason :-)
> >>>     Please remind me if anything missed :-P
> >>>   * Use rdma_cap_XX() instead of cap_XX() for readability
> >>>   * Remove CC list in git log for maintainability
> >>>   * Use bool as return value
> >>>   * Updated github repository to v8
> >>>
> >>> There are plenty of lengthy code to check the transport type of IB de=
vice,
> >>> or the link layer type of it's port, but actually we are just specula=
ting
> >>> whether a particular management/feature is supported by the device/po=
rt.
> >>>
> >>> Thus instead of inferring, we should have our own mechanism for IB ma=
nagement
> >>> capability/protocol/feature checking, several proposals below.
> >>>
> >>> This patch set will introduce query_protocol() to check management re=
quirement
> >>> instead of inferring from transport and link layer respectively, alon=
g with
> >>> the new enum on protocol type.
> >>>
> >>> Mapping List:
> >>> 		node-type	link-layer	transport	protocol
> >>> nes		RNIC		ETH		IWARP		IWARP
> >>> amso1100	RNIC		ETH		IWARP		IWARP
> >>> cxgb3   	RNIC		ETH		IWARP		IWARP
> >>> cxgb4   	RNIC		ETH		IWARP		IWARP
> >>> usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
> >>> ocrdma  	IB_CA		ETH		IB		IBOE
> >>> mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
> >>> mlx5    	IB_CA		IB		IB		IB
> >>> ehca    	IB_CA		IB		IB		IB
> >>> ipath   	IB_CA		IB		IB		IB
> >>> mthca   	IB_CA		IB		IB		IB
> >>> qib     	IB_CA		IB		IB		IB
> >>>
> >>> For example:
> >>> 	if (transport =3D=3D IB) && (link-layer =3D=3D ETH)
> >>> will now become:
> >>> 	if (query_protocol() =3D=3D IBOE)
> >>>
> >>> Thus we will be able to get rid of the respective transport and link-=
layer
> >>> checking, and it will help us to add new protocol/Technology (like OP=
A) more
> >>> easier, also with the introduced management helpers, IB management lo=
gical
> >>> will be more clear and easier for extending.
> >>>
> >>> Highlights:
> >>>     The long CC list in each patches was complained consider about th=
e
> >>>     maintainability, it was suggested folks to provide their reviewed=
-by or
> >>>     Acked-by instead, so for those who used to be on the CC list, ple=
ase
> >>>     provide your signature voluntarily :-)
> >>>
> >>>     The 'mgmt-helpers' branch of 'git@github.com:ywang-pb/infiniband-=
wy.git'
> >>>     contain this series based on the latest 'infiniband/for-next'
> >>>
> >>>     Patch 1#~14# included all the logical reform, 15#~23# introduced =
the
> >>>     management helpers.
> >>>
> >>>     Doug suggested the bitmask mechanism:
> >>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23765.htm=
l
> >>>     which could be the plan for future reforming, we prefer that to b=
e another
> >>>     series which focus on semantic and performance.
> >>>
> >>>     This patch-set is somewhat 'bloated' now and it may be a good tim=
ing for
> >>>     staging, I'd like to suggest we focus on improving existed helper=
s and push
> >>>     all the further reforms into next series ;-)
> >>>
> >>> Proposals:
> >>>     Sean:
> >>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23339.htm=
l
> >>>     Doug:
> >>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23418.htm=
l
> >>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23765.htm=
l
> >>>     Jason:
> >>> 	https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg23425.htm=
l
> >>>
> >>> Michael Wang (23):
> >>>   IB/Verbs: Implement new callback query_protocol()
> >>>   IB/Verbs: Implement raw management helpers
> >>>   IB/Verbs: Reform IB-core mad/agent/user_mad
> >>>   IB/Verbs: Reform IB-core cm
> >>>   IB/Verbs: Reform IB-core sa_query
> >>>   IB/Verbs: Reform IB-core multicast
> >>>   IB/Verbs: Reform IB-ulp ipoib
> >>>   IB/Verbs: Reform IB-ulp xprtrdma
> >>>   IB/Verbs: Reform IB-core verbs
> >>>   IB/Verbs: Reform cm related part in IB-core cma/ucm
> >>>   IB/Verbs: Reform route related part in IB-core cma
> >>>   IB/Verbs: Reform mcast related part in IB-core cma
> >>>   IB/Verbs: Reform cma_acquire_dev()
> >>>   IB/Verbs: Reform rest part in IB-core cma
> >>>   IB/Verbs: Use management helper rdma_cap_ib_mad()
> >>>   IB/Verbs: Use management helper rdma_cap_ib_smi()
> >>>   IB/Verbs: Use management helper rdma_cap_ib_cm()
> >>>   IB/Verbs: Use management helper rdma_cap_iw_cm()
> >>>   IB/Verbs: Use management helper rdma_cap_ib_sa()
> >>>   IB/Verbs: Use management helper rdma_cap_ib_mcast()
> >>>   IB/Verbs: Use management helper rdma_cap_read_multi_sge()
> >>>   IB/Verbs: Use management helper rdma_cap_af_ib()
> >>>   IB/Verbs: Use management helper rdma_cap_eth_ah()
> >>>
> >>>  drivers/infiniband/core/agent.c              |   2 +-
> >>>  drivers/infiniband/core/cm.c                 |  20 ++-
> >>>  drivers/infiniband/core/cma.c                | 257 +++++++++++------=
----------
> >>>  drivers/infiniband/core/device.c             |   1 +
> >>>  drivers/infiniband/core/mad.c                |  43 +++--
> >>>  drivers/infiniband/core/multicast.c          |  12 +-
> >>>  drivers/infiniband/core/sa_query.c           |  30 ++--
> >>>  drivers/infiniband/core/ucm.c                |   3 +-
> >>>  drivers/infiniband/core/ucma.c               |  25 +--
> >>>  drivers/infiniband/core/user_mad.c           |  26 ++-
> >>>  drivers/infiniband/core/verbs.c              |   6 +-
> >>>  drivers/infiniband/hw/amso1100/c2_provider.c |   7 +
> >>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |   7 +
> >>>  drivers/infiniband/hw/cxgb4/provider.c       |   7 +
> >>>  drivers/infiniband/hw/ehca/ehca_hca.c        |   6 +
> >>>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |   3 +
> >>>  drivers/infiniband/hw/ehca/ehca_main.c       |   1 +
> >>>  drivers/infiniband/hw/ipath/ipath_verbs.c    |   7 +
> >>>  drivers/infiniband/hw/mlx4/main.c            |  10 ++
> >>>  drivers/infiniband/hw/mlx5/main.c            |   7 +
> >>>  drivers/infiniband/hw/mthca/mthca_provider.c |   7 +
> >>>  drivers/infiniband/hw/nes/nes_verbs.c        |   6 +
> >>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   1 +
> >>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   6 +
> >>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |   3 +
> >>>  drivers/infiniband/hw/qib/qib_verbs.c        |   7 +
> >>>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |   1 +
> >>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   6 +
> >>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |   2 +
> >>>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |  15 +-
> >>>  include/rdma/ib_verbs.h                      | 167 +++++++++++++++++
> >>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |   4 +-
> >>>  net/sunrpc/xprtrdma/svc_rdma_transport.c     |  45 ++---
> >>>  33 files changed, 477 insertions(+), 273 deletions(-)
> >>>
> >>> --=20
> >>> 2.1.0
> >>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD


--=-b7MlidVCnQYfFbTkfLk9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUg0bAAoJELgmozMOVy/dlg0QAIDsfTcwbcn/8tOg3XEi8sCI
J7ySZ6loE9ypYihRfFTD+vg6xuXnMUiIr2uWNCyqgCGvIK5S1kVQ844yRQk8ZbEt
9IpS7q6bCFxR8VAdKb9qFD0oNvU1Z+6hqcejl5jR2gUlQfLkg8JLl2yZ/N1aryxK
ehpAfKwPi8Q2e5ctPKalR81DRm7g2XfeKDRfPujYytxXJ2+JGovTT4GasMQBUUN0
m7PlpIbDwqwalFazvENE4hGl7WfEMy39cLhZ9q51f7LkCsqKsmEq5wf52Pfk0iu4
mLZNLqvdcJqaRQTn9McqfPf+u7MKDNfgGhhXEtO7ZXn/epZlfIm4zpF7PdkCEqsv
ThzgcX68lKNEsQa6+28lUe9MiUNvq4PQzEvjea2/Hdxv0U1j7QnQ9dy8n6Nmw8g0
8AZG6tzw7sZFVEPlh6EsUSo1FusMV32WKtQed7shmxorHR0nmyek0ND6Jy21sd6m
sgb3zoeRsQVRVmkSEy5dw7DqaFd5hbDfPF7RI/EW5IMeTDxHmm1zWvhALZRK8i/P
n+mepwrbxT/e/Wq9T1djd3Cut9kQdsKQCCgk3sVRbzRVLxr6MxMMqV5j8mre6aX9
1Mx7guuZlr+lly2LHPMCZQheUn97HUIS+xVtQt6PB5PzZxiScGuJP3DQjsvSKNi3
WoeWHg5xR++mZEiGoZ5s
=wxzO
-----END PGP SIGNATURE-----

--=-b7MlidVCnQYfFbTkfLk9--
