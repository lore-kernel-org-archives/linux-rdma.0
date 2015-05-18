From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH RFC v2] Documentation/infiniband: Add docs for
 rdma-helpers
Date: Mon, 18 May 2015 11:21:25 -0400
Message-ID: <1431962485.3114.8.camel@redhat.com>
References: <1431938505-31779-1-git-send-email-yun.wang@profitbricks.com>
	 <CAJ3xEMgkrUgSvRV7m_M9CE4w66Wyk-Svnfejvavj38iTNyH9HQ@mail.gmail.com>
	 <5559B997.1030502@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-hVZq7hQxgqwxlnTxbhq/"
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5559B997.1030502@profitbricks.com>
Sender: linux-doc-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Or Gerlitz <gerlitz.or@gmail.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: linux-rdma@vger.kernel.org


--=-hVZq7hQxgqwxlnTxbhq/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-18 at 12:06 +0200, Michael Wang wrote:
> Hi, Or
>=20
> On 05/18/2015 11:47 AM, Or Gerlitz wrote:
> [snip]
> >> Highlights:
> >>   There could be many missing/mistakes/misunderstanding, please don't
> >>   be hesitate to point out the issues, any suggestions to improve or
> >>   complete the description are very welcomed ;-)
> >=20
> > Michael, none of what you wrote above belongs to the change-log which
> > is going to stay for-ever in the upstream git repo. You should put it
> > all belong the --- line after your S.O.B and add proper change log
> > telling what this patch is about
>=20
> Thanks for point out this for me :-)
>=20
> I'll put the highlights and changelog under '---' in next version, is it
> looks like this?

We're still missing Jason's feedback request though.  Specifically, he
pointed out that kdocs are usually not done in Documentation/*, they are
done in the .c files where the function is (or the .h file if the
function is an inline, which these all are).  So, you included some
limited documentation for each of these items in your original patches
that added them.  His request was that you put this expanded information
not in Documentation/infiniband where someone has to go looking for it,
but as part of the kdoc header for each of the various helpers in
ib_verbs.h itself.

Just because I want to move this along versus waiting for another
respin, I'm going to copy and paste these into those locations and clean
up the changelog when I integrate this patch.

>=20
> Subject: [PATCH RFC v3] Documentation/infiniband: Add docs for rdma-helpe=
rs
>=20
> This is the following patch for:
>   https://lkml.org/lkml/2015/5/5/417
> which try to document the settled rdma_cap_XX().
>=20
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> ---
> Highlights:
>   There could be many missing/mistakes/misunderstanding, please don't
>   be hesitate to point out the issues, any suggestions to improve or
>   complete the description are very welcomed ;-)
>=20
> v2:
>   * Merge the descriptions from Doug:
>     http://www.spinics.net/lists/linux-rdma/msg25172.html
>=20
> v3:
>   ...
>=20
>  Documentation/infiniband/rdma_helpers.txt | 79 +++++++++++++++++++++++++=
++++++
>  1 file changed, 79 insertions(+)
>  create mode 100644 Documentation/infiniband/rdma_helpers.txt
>=20
> diff --git a/Documentation/infiniband/rdma_helpers.txt b/Documentation/in=
finiband/rdma_helpers.txt
> new file mode 100644
> index 0000000..be9416d
> --- /dev/null
> +++ b/Documentation/infiniband/rdma_helpers.txt
>=20
> Regards,
> Michael Wang
>=20
> >=20
> >>
> >> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> >> ---
> >>  Documentation/infiniband/rdma_helpers.txt | 79 ++++++++++++++++++++++=
+++++++++
> >>  1 file changed, 79 insertions(+)
> >>  create mode 100644 Documentation/infiniband/rdma_helpers.txt
> >>
> >> diff --git a/Documentation/infiniband/rdma_helpers.txt b/Documentation=
/infiniband/rdma_helpers.txt
> >> new file mode 100644
> >> index 0000000..be9416d
> >> --- /dev/null
> >> +++ b/Documentation/infiniband/rdma_helpers.txt
> >> @@ -0,0 +1,79 @@
> >> +RDMA HELPERS
> >> +
> >> +  The following helpers are used to check the specific capabilities o=
f a
> >> +  particular port before utilizing those capabilities.
> >> +
> >> +    rdma_cap_ib_mad            - Infiniband Management Datagrams.
> >> +    rdma_cap_ib_smi            - Infiniband Subnet Management Interfa=
ce.
> >> +    rdma_cap_ib_cm             - Infiniband Communication Manager.
> >> +    rdma_cap_iw_cm             - IWARP Communication Manager.
> >> +    rdma_cap_ib_sa             - Infiniband Subnet Administration.
> >> +    rdma_cap_ib_mcast          - Infiniband Multicast Join/Leave Prot=
ocol.
> >> +    rdma_cap_read_multi_sge    - RDMA Read Work Request Support Multi=
ple SGE.
> >> +    rdma_cap_af_ib             - Native Infiniband Address.
> >> +    rdma_cap_eth_ah            - InfiniBand Transport With Ethernet A=
ddress.
> >> +
> >> +USAGE
> >> +
> >> +  if (rdma_cap_XX(device, i)) {
> >> +       /* The port i of device support XX */
> >> +       ...
> >> +  } else {
> >> +       /* The port i of device don't support XX */
> >> +       ...
> >> +  }
> >> +
> >> +  rdma_cap_ib_mad
> >> +  ---------------
> >> +    Management Datagrams (MAD) are a required part of the InfiniBand
> >> +    specification and are supported on all InfiniBand devices.  A sli=
ghtly
> >> +    extended version are also supported on OPA interfaces.
> >> +
> >> +  rdma_cap_ib_smi
> >> +  ---------------
> >> +    Subnet Management Interface (SMI) will handle SMP packet from SM
> >> +    in an infiniband fabric.
> >> +
> >> +  rdma_cap_ib_cm
> >> +  ---------------
> >> +    Communication Manager (CM) service, used to ease the process of c=
onnecting
> >> +    to a remote host.  The IB-CM can be used to connect to remote hos=
ts using
> >> +    either InfiniBand or RoCE connections, iWARP has its own CM.
> >> +
> >> +  rdma_cap_iw_cm
> >> +  ---------------
> >> +    iWARP Communication Manager (CM), Similar to the IB-CM, but only =
used on
> >> +    iWARP devices.
> >> +
> >> +  rdma_cap_ib_sa
> >> +  ---------------
> >> +    Subnet Administration (SA) is the database built by SM in an
> >> +    infiniband fabric.
> >> +
> >> +  rdma_cap_ib_mcast
> >> +  ---------------
> >> +    InfiniBand (and OPA) use a different multicast mechanism rather t=
han
> >> +    traditional IP multicast found on Ethernet devices.  If this is t=
rue, then
> >> +    traditional IPv4/IPv6 multicast is handled by the IPoIB layer and=
 direct
> >> +    multicast joins and leaves are handled per the InfiniBand specifi=
cations.
> >> +
> >> +  rdma_cap_read_multi_sge
> >> +  ---------------
> >> +    Certain devices (iWARP in particular) have restrictions on the nu=
mber of
> >> +    scatter gather elements that can be present in an RDMA READ work =
request,
> >> +    this is true if the device does not have that restriction.
> >> +
> >> +  rdma_cap_af_ib
> >> +  ---------------
> >> +    Many code paths for traditional InfiniBand and RoCE links are the=
 same,
> >> +    but need minor differences to accommodate the different addresses=
 on the
> >> +    two types of connections.  This helper is true when the address o=
f the
> >> +    specific connection is of the InfiniBand native variety.
> >> +
> >> +  rdma_cap_eth_ah
> >> +  ---------------
> >> +    Queue Pair is InfiniBand transport, but uses Ethernet address ins=
tead
> >> +    of native InfiniBand address (aka, this is a RoCE QP, and that me=
ans
> >> +    ethertype 0x8915 + GRH for RoCEv1 and IP/UDP to well known UDP po=
rt for
> >> +    RoCEv2), this is true when the address family of the specific que=
ue pair
> >> +    is of the Ethernet (RoCE) variety.
> >> --
> >> 2.1.0
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD


--=-hVZq7hQxgqwxlnTxbhq/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVWgN1AAoJELgmozMOVy/dwLIQAIK4ycj6M36Oi7cb9Tz4nt5x
TW6VJ8Zc+BTTJrcpV0XA/88gLSLeVHYqKyKWGe8nOKSocWssY+hL0VoUivlQgBxz
9UYtnS33cbGlqtUpIKpHHbCW3MLEa9MhPCEVHbvzXUKgUyuOCv0D0K4N/h+9PT7d
WLmY3aUN6BLe5uPcVG1xVM1/RG7cP5dlMzZTY75Oldl0duWPw0l3yCEJkVXHJiK9
/MUs68RkuXUpiwQAPiAXsJ8z1k/FRoV+tAErLG6bf9VAnlbXrDgAgRXmvSeutIR8
QuB/duzl10JIrIB5ZY0unxeK6jYA1/J6hCyV5sZE5GT3g8cBi2+xinXMnj1uwUym
7LRm4yr85jFtyP1niBfJW4BtYRyLHp3yoB9w14CKyF1TdpF3J/i1rW8iaWBFGfY7
FpditXV93VdERkN613yG3A3j1gZrtnG/3KLANzA+elWkL/X92R4R+uvpoD8fGfcd
qVnF8+gaFDRG+40p9U1oCP5qzOvIXLyASb6O84Lbju68xbnNCUdxDFx1J1/Wn5lO
kKTG2xHUneJbedsMT5wKl4df3bcCEEya5BaLEepleh/mpFCGf+jKDlr8SIvBdtmd
7GXYH8Xt2SEFDsjYkd45SpWZ4v4cSF03HvbSXzRWQxvBvumyMnyNHpU9VNOnvp3L
1c0kePg0GjH79Uwd63t0
=xjdK
-----END PGP SIGNATURE-----

--=-hVZq7hQxgqwxlnTxbhq/--

