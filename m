From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value returned
 when the port is down
Date: Mon, 02 Apr 2012 14:45:48 -0400
Message-ID: <4F79F3DC.7060900@dev.mellanox.co.il>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com> <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com> <4F79D558.1000908@dev.mellanox.co.il> <4F79D826.9070605@mellanox.com> <1828884A29C6694DAF28B7E6B8A823734519A40B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823734519A40B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 2:39 PM, Hefty, Sean wrote:
>> On 4/2/2012 7:35 PM, Hal Rosenstock wrote:
>>> Rather than always overwriting active_speed in this case, wouldn't =
it
>>> be better to only do that for invalid values?
>>
>> Yes, I have thought about that, however, spotting invalid values wou=
ld
>> make the code a bit ugly, so I took this approach, Roland?
>=20
> Does the active speed even make sense if the port is down? =20

When a port is DOWN, the only PortInfo components that are not
vendor dependent are PortState and PortPhysicalState:

IBA 1.2.1 vol 1 p.830 line 16 states:
C14-24.2.1: If PortInfo:Portstate=3DDown, then
=95 a SubnGet(PortInfo) shall produce valid data for PortInfo:PortState
and PortInfo:PortPhysicalState; whether any other component has
valid data is vendor-dependent

> If not, should we assume that any value returned by the FW is correct=
?

A reserved value should never be returned though so not all values are
"correct". Of course, it has limited meaning in this state.

-- Hal

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
