From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm/osm_pkey_mgr.c: In pkey_mgr_update_peer_port,
 better last block handling
Date: Sun, 10 Apr 2011 10:51:16 +0300
Message-ID: <20110410075116.GH21920@calypso.voltaire.com>
References: <4D9B59D1.9010209@dev.mellanox.co.il>
 <20110407164642.GD21920@calypso.voltaire.com>
 <4D9E02F1.3090609@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D9E02F1.3090609-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:31 Thu 07 Apr     , Hal Rosenstock wrote:
> Hi Alex,
>=20
> On 4/7/2011 12:46 PM, Alex Netes wrote:
> > Hi Hal,
> >=20
> > On 14:05 Tue 05 Apr     , Hal Rosenstock wrote:
> >>
> >> PKey table capacities are not required to be multiples of the PKey=
 table block
> >> size (32 entries of 16 pkeys).
>=20
>                         ^^^^^^^
>                         16 bit pkeys
>=20
> >>
> >> Current code could enable partition enforcement on the peer switch=
 port
> >> even if the last partition table block were truncated. In this cas=
e, it's
> >> better to disable partition enforcement on those ports.
> >>
> >=20
> > What is the motivation for this patch?
>=20
> The policy question is what to do when that occurs.
>=20
> > In case where there are more pkeys than sw->switch_info.enforce_cap=
 I guess
> > enforcement won't be applied on pkeys > sw->switch_info.enforce_cap=
=2E
>=20
> The SM shouldn't set any such entries in the PKey table per 14.2.5.7
> P_KEYTABLE p. 842 line 37:
>=20
> The AttributeModifier is divided in two halves:
> =E2=80=A2 The least significant 16 bits are a pointer to a block of 3=
2 P_Key
> entries to which this Attribute applies.  Valid values are 0 - 2047, =
and
> are further limited by the size of the P_Key table for that node
> (specified by the PartitionCap for CAs, routers, and switch managemen=
t
> ports or PartitionEnforcementCap for external ports on switches).
>=20
> so a conforming SMA should reject such a set.
>=20
> > This is a user configuration issue.=20
>=20
> Yes.
>=20
> > Why issue a warning message to a log isn't enough?
>=20
> That's the minimum that should be done. The question then becomes
> whether it's better to enforce for some subset of the partitions or
> disable enforrcement. I was trying to avoid another config option for=
 this.
>=20

Makes sense.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
