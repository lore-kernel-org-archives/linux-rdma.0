From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2] opensm: Reduce heap consumption by multicast routing
	tables (MFTs)
Date: Wed, 14 Oct 2009 15:46:15 -0400
Message-ID: <f0e08f230910141246r273555f6teed717711511b0d5@mail.gmail.com>
References: <20091014155224.GA21566@comcast.net> <20091014162526.GE13830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091014162526.GE13830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2009 at 12:25 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> On 11:52 Wed 14 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Heap memory consumption by the unicast and multicast routing tables =
can be
>> reduced.
>>
>> This patch is analagous to the previous patch doing this for the uni=
cast
>> routing tables (LFTs).
>>
>> Using valgrind --tool=3Dmassif (for heap profiling), there are coupl=
e of place
>> ->38.75% (11,206,656B) 0x43267E: osm_switch_new (osm_switch.c:134)
>> ->12.89% (3,728,256B) 0x40F8C9: osm_mcast_tbl_init (osm_mcast_tbl.c:=
96)
>>
>> osm_mcast_tbl_init (osm_mcast_tbl.c:96):
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->p_mask_tbl =3D malloc(p_tbl->num_=
entries *
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(IB_MCAST_POSIT=
ION_MAX +
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1) * IB_MCAST_=
MASK_SIZE / 8);
>>
>> num_entries above is set based on the switch's MulticastFDBCap
>> (indicated in it's SM class SwitchInfo attribute).
>>
>> MFTs are only be increased in size and are never reduced in size. If=
 a realloc
>> for MFT fails, it is treated as a fatal error and OpenSM is exited.
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> Changes since v1:
>> MFT allocation based on actual MLID requests
>
> I meant not just this.
>
> When first LFT allocation size reducing patch was posted we discussed
> and agreed that it is better to allocate tables using already known a=
nd
> needed sizes before routing calculation cycle start (as part of the
> preparation to this) and not at any table access attempt. Any reason =
why
> should this be different with MFTs?

Seems to me that the equivalent (to LFT) is to invoke the table
(re)allocation from osm_mcast_mgr_process/process_mgroups. Is that
what you mean ?

-- Hal

> Sasha

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
