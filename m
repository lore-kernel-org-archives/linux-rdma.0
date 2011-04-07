From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm/osm_pkey_mgr.c: In pkey_mgr_update_peer_port,
 better last block handling
Date: Thu, 07 Apr 2011 14:31:13 -0400
Message-ID: <4D9E02F1.3090609@dev.mellanox.co.il>
References: <4D9B59D1.9010209@dev.mellanox.co.il> <20110407164642.GD21920@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110407164642.GD21920-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 4/7/2011 12:46 PM, Alex Netes wrote:
> Hi Hal,
>=20
> On 14:05 Tue 05 Apr     , Hal Rosenstock wrote:
>>
>> PKey table capacities are not required to be multiples of the PKey t=
able block
>> size (32 entries of 16 pkeys).

                        ^^^^^^^
                        16 bit pkeys

>>
>> Current code could enable partition enforcement on the peer switch p=
ort
>> even if the last partition table block were truncated. In this case,=
 it's
>> better to disable partition enforcement on those ports.
>>
>=20
> What is the motivation for this patch?

The policy question is what to do when that occurs.

> In case where there are more pkeys than sw->switch_info.enforce_cap I=
 guess
> enforcement won't be applied on pkeys > sw->switch_info.enforce_cap.

The SM shouldn't set any such entries in the PKey table per 14.2.5.7
P_KEYTABLE p. 842 line 37:

The AttributeModifier is divided in two halves:
=95 The least significant 16 bits are a pointer to a block of 32 P_Key
entries to which this Attribute applies.  Valid values are 0 - 2047, an=
d
are further limited by the size of the P_Key table for that node
(specified by the PartitionCap for CAs, routers, and switch management
ports or PartitionEnforcementCap for external ports on switches).

so a conforming SMA should reject such a set.

> This is a user configuration issue.=20

Yes.

> Why issue a warning message to a log isn't enough?

That's the minimum that should be done. The question then becomes
whether it's better to enforce for some subset of the partitions or
disable enforrcement. I was trying to avoid another config option for t=
his.

-- Hal

> --Alex

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
