From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ibnetdiscover issue with multiported CA (or router) with multiple
 ports on same subnet
Date: Wed, 1 Sep 2010 09:47:56 -0400
Message-ID: <AANLkTi=RuZukS=kNkZVxax3CP8oZROqYxe71GQfuV2Rx@mail.gmail.com>
References: <AANLkTi=54yw-YcpXNvWmsCFybZhTZX6Hp6=KW6Gz9KLH@mail.gmail.com>
	<20100901134344.GC12172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100901134344.GC12172@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Wed, Sep 1, 2010 at 9:43 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> Hi Hal,
>
> On 13:27 Wed 25 Aug =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> I'm seeing an issue with ibnetdiscover from a CA port where it appea=
rs
>> to extend a path at a "remote" CA port (it's actually another port o=
n
>> the same CA) to query NodeInfo of the next hop beyond it. I get the
>> following error message:
>>
>> src/query_smp.c:188; umad (DR path slid 0; dlid 0; 0,1,20,2 Attr
>> 0x11:0) bad status 110; Connection timed out
>>
>> where smpquery -D nodeinfo of 0,1,20 is a CA which can also be seen
>> from the topology.
>>
>> It appears to stem from the following code snippet from
>> libibnetdisc/src/ibnetdisc.c:recv_port_info
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (port_num && mad_get_field(port->info=
, 0, IB_PORT_PHYS_STATE_F)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=3D IB_PORT_PHYS_STATE_=
LINKUP
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 && ((node->type =3D=3D IB_=
NODE_SWITCH && port_num !=3D local_port) ||
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (node =3D=3D=
 fabric->from_node && port_num =3D=3D local_port))) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_portid_t =
path =3D smp->path;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (extend_d=
path(engine, &path, port_num) > 0)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 query_node_info(engine, &path, node);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> This makes sense for me.
>
>>
>> that was introduced by:
>> commit fcb8d5e7588e38508a8e354c37009d73c0a3889f
>> Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>> Date: =C2=A0 Sat Apr 10 02:43:24 2010 +0300
>>
>> =C2=A0 =C2=A0 libibnetdisc: no backward NodeInfo queries
>>
>> =C2=A0 =C2=A0 Then switch is reached via port N we don't need to que=
ry back via this
>> =C2=A0 =C2=A0 port - source node is discovered already. Finally this=
 saves some amount
>> =C2=A0 =C2=A0 of unnecessary MADs.
>>
>> =C2=A0 =C2=A0 Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>
>> and subsequently modified by:
>> commit 49d149c63a44d99259f516a15af53d8cf3f0e7c9
>> Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>> Date: =C2=A0 Tue Apr 13 19:54:45 2010 +0300
>>
>> =C2=A0 =C2=A0 libibnetdisc: don't try to cross discovery over CA
>>
>> =C2=A0 =C2=A0 When discovery is running from CA node it shouldn't tr=
y to cross over
>> =C2=A0 =C2=A0 all ports, but only via local one (send over non-local=
 ports will fail
>> =C2=A0 =C2=A0 since CA doesn't route MADs).
>>
>> =C2=A0 =C2=A0 Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>
>> due to the (node =3D=3D fabric->from_node && port_num =3D=3D local_p=
ort)
>> clause being TRUE.
>
> But I don't see how those patches are actually related to the story. =
An
> original (before patches) condition was:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (port_num && mad_get_field(port->info, =
0, IB_PORT_PHYS_STATE_F)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=3D IB_PORT_PHYS_STATE_LI=
NKUP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&& (node->type =3D=3D IB_NOD=
E_SWITCH || node =3D=3D fabric->from_node))
>
> , which has the described bug as I can understand this.

I thought this used to work and those changes looked related to me.
Maybe the fix is right but that part of the problem description isn't.
Do you want a revised patch without that part of the description ?

-- Hal

>
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
