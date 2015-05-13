From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] Documentation/infiniband: Add docs for rdma-helpers
Date: Wed, 13 May 2015 11:11:54 -0400
Message-ID: <1431529914.2377.22.camel@redhat.com>
References: <1431523472-10888-1-git-send-email-yun.wang@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ytDWGO4Rd5EWWFNzlcwr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431523472-10888-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ytDWGO4Rd5EWWFNzlcwr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-05-13 at 15:24 +0200, Michael Wang wrote:
> This is the following patch for:
>   https://lkml.org/lkml/2015/5/5/417
> which try to document the settled rdma_cap_XX().
>=20
> Highlights:
>   There could be many missing/mistakes/misunderstanding, please don't
>   be hesitate to point out the issues, any suggestions to improve or
>   complete the description are very welcomed ;-)
>=20
> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  Documentation/infiniband/rdma_helpers.txt | 76 +++++++++++++++++++++++++=
++++++
>  1 file changed, 76 insertions(+)
>  create mode 100644 Documentation/infiniband/rdma_helpers.txt
>=20
> diff --git a/Documentation/infiniband/rdma_helpers.txt b/Documentation/in=
finiband/rdma_helpers.txt
> new file mode 100644
> index 0000000..abc75ec
> --- /dev/null
> +++ b/Documentation/infiniband/rdma_helpers.txt
> @@ -0,0 +1,76 @@
> +RDMA HELPERS
> +
> +  For core layer, below helpers are used to check if a paticular capabil=
ity
> +  is supported by the port.

The following helpers are used to check the specific capabilities of a
particular port before utilizing those capabilities.

> +
> +    rdma_cap_ib_mad		- Infiniband Management Datagrams.
> +    rdma_cap_ib_smi		- Infiniband Subnet Management Interface.
> +    rdma_cap_ib_cm		- Infiniband Communication Manager.
InfiniBand Connection Management
> +    rdma_cap_iw_cm		- IWARP Communication Manager.
iWARP Connection Management
> +    rdma_cap_ib_sa		- Infiniband Subnet Administration.
> +    rdma_cap_ib_mcast		- Infiniband Multicast.
InfiniBand Multicast join/leave protocol
> +    rdma_cap_read_multi_sge	- RDMA Read Multiple Scatter-Gather Entries.
RDMA Read verb supports more than 1 sge in the work request
> +    rdma_cap_af_ib		- Native Infiniband Address.
> +    rdma_cap_eth_ah		- Ethernet Address Handler.
Queue Pair is InfiniBand transport, but uses Ethernet address instead of
native InfiniBand address (aka, this is a RoCE QP, and that means
ethertype 0x8915 + GRH for RoCEv1 and IP/UDP to well known UDP port for
RoCEv2)
> +
> +USAGE
> +
> +  if (rdma_cap_XX(device, i)) {
> +	/* The port i of device support XX */
> +	...
> +  } else {
> +	/* The port i of device don't support XX */
> +	...
> +  }
> +
> +  rdma_cap_ib_mad
> +  ---------------
> +    Management Datagrams (MAD) is the prototype of management packet
> +    to be used by all the kinds of infiniband managers, use the helper
> +    to verify the port before utilize related features.
Management Datagrams (MAD) are a required part of the InfiniBand
specification and are supported on all InfiniBand devices.  A slightly
extended version are also supported on OPA interfaces.

I would drop all instances of "use the helper to verify..." as that's
redundant.  This whole doc is about using the helpers to verify things.

> +
> +  rdma_cap_ib_smi
> +  ---------------
> +    Subnet Management Interface (SMI) will handle SMP packet from SM
> +    in an infiniband fabric, use the helper to verify the port before
> +    utilize related features.
> +
> +  rdma_cap_ib_cm
> +  ---------------
> +    Communication Manager (CM) will handle the connections between
       ^Connection Manager (CM) service, used to ease the process of
connecting to a remote host.  The IB CM can be used to connect to remote
hosts using either InfiniBand or RoCE connections.  iWARP has its own
connection manager, see below.
> +    adaptors, currently there are two different implementation,
> +    IB or IWARP, use the helper to verify whether the port using
> +    IB-CM or not
> +
> +  rdma_cap_iw_cm
> +  ---------------
> +    IWARP has it's own implemented CM which is different from infiniband=
,
      iWARP connection manager.  Similar to the IB Connection Manager,
but only used on iWARP devices.
> +    use the helper to check whether the port using IWARP-CM or not.
> +
> +  rdma_cap_ib_sa
> +  ---------------
> +    Subnet Administration (SA) is the database built by SM in an
> +    infiniband fabric, use the helper to verify the port before
> +    utilize related features.
> +
> +  rdma_cap_ib_mcast
> +  ---------------
> +    Multicast is the feature for one QP to send messages to multiple
> +    QP in an infiniband fabric, use the helper to verify the port before
> +    utilize related features.

InfiniBand (and OPA) use a different multicast mechanism than
traditional IP multicast found on Ethernet devices.  If this capability
is true, then traditional IPv4/IPv6 multicast is handled by the IPoIB
layer and direct multicast joins and leaves are handled per the
InfiniBand specifications.

> +
> +  rdma_cap_read_multi_sge
> +  ---------------
> +    RDMA read operation could support multiple scatter-gather entries,
> +    use the helper to verify wthether the port support this feature
> +    or not.

Certain devices (iWARP in particular) have restrictions on the number of
scatter gather elements that can be present in an RDMA READ work
request.  This is true if the device does not have that restriction.

> +  rdma_cap_af_ib
> +  ---------------
> +    RDMA address format could be ethernet or infiniband, use the helper
> +    to verify whether the port support infiniband format or not.

Many code paths for traditional InfiniBand and RoCE links are the same,
but need minor differences to accommodate the different addresses on the
two types of connections.  This helper is true when the address of the
specific connection is of the InfiniBand native variety.

> +
> +  rdma_cap_eth_ah
> +  ---------------
> +    Infiniband address handler format is special in ethernet fabric, use
> +    the helper to verify whether the port is using ethernet format or no=
t.

This helper is true when the address of the specific connection is of
the Ethernet (RoCE) variety.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-ytDWGO4Rd5EWWFNzlcwr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVU2m6AAoJELgmozMOVy/dEX4QAIQ90B6Rl71P6vFjRek/WNCi
sTOfuWXQcHQAHWjW9Ujh8OKn0ghVaPs2vJLfoxjbzoLLE7bdrX/0hm3cCdtgKVd/
XXwteuWO9GkbwGrTpNs+2bqxuOuDoPaPOBRV7xDBFTKt5rO53UDYN4H8mYRxGm6k
ZI38+pGnntXVQnA+w/xDoQDyE/1R8jwFibnO0lEmK/ZEz9RySha6gp1gf1JjcvcL
2GPBPgIzPk2duF1NfbbDQACyL1VqgdVftX1oJqq7IhhXI6LkzlBNdK/gmnXaZsZh
p5WR52NAnLN1G0gsXayynhz5hn1CSy59C+aVt3G14wcq9P4AiSDg+v3msLTw/8P/
hqPYiR7REVV8tMRtW7UyIkreEWmE1SjQ8Di78QIDHdWSh3pRF5yYSQTW/iPTlGwO
QanRG3yVEXLrAtSS32Poc4z4o+x2mWuy/w4kheFC7IFxYM29XVQnHNMPdPMySirK
CUK1qP2Bl6lwo1rc/pQdwcgsS8TQdyUYffKtmXj0N5LBLlrf7VUVrEwONpJDUj5c
BUpholZFEpC1pWh4wdBvykQC4I1OYqz/+QCwo8C1xI/VA3nfOJ3TAAzqZeDpgY83
ChdCPMm4T9jIqqyO3J0N4Aj+jLCan+P2f0B3oagXuOB+2XEB/bN4KmnKNj38gBzO
9TjwAwc3ZtQX6d3OhoI5
=T4xc
-----END PGP SIGNATURE-----

--=-ytDWGO4Rd5EWWFNzlcwr--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
