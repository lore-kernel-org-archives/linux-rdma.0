From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Reduce heap consumption by unicast routing tables
	(LFTs)
Date: Wed, 30 Sep 2009 14:38:27 -0400
Message-ID: <f0e08f230909301138y64595e9dj47bdec4a47d80f99@mail.gmail.com>
References: <20090927193258.GG26931@me>
	 <1719052465.9944581254135649449.JavaMail.root@sz0074a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1719052465.9944581254135649449.JavaMail.root-m8vEhog2yEGs1RcX6exeh1Wh7bxQi8rYbcbDuTDi3LmGxX56iWlbXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Somehow this message didn't make it to the general list.

> Hi Hal,
>
> On 11:30 Sat 29 Aug =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Heap memory consumption by the unicast and multicast routing tables =
can be
>> reduced.
>>
>> Using valgrind --tool=3Dmassif (for heap profiling), there are coupl=
e of
>> places that consume most of the heap memory:
>> ->38.75% (11,206,656B) 0x43267E: osm_switch_new (osm_switch.c:134)
>
> What fabric size was used for such measurements?
>
> Assuming that maximal LFT size is less than 50K you may need > 200
> switches in order to eat almost 11M memory.

Yes, this was done with around 200 switches.

> And what about memory consumption for lid matrices?

This didn't show up in the heap profiling. My understanding is that
LID matrices are already optimized. The arrays of ports are allocated
for each LID (in host order) on demand:

cl_status_t osm_switch_set_hops(...)
{
       ...
       if (!p_sw->hops[lid_ho]) {
               p_sw->hops[lid_ho] =3D malloc(p_sw->num_ports);
               if (!p_sw->hops[lid_ho])
                       return -1;
               memset(p_sw->hops[lid_ho], OSM_NO_PATH,
p_sw->num_ports);
       }
       ...
}

>> ->12.89% (3,728,256B) 0x40F8C9: osm_mcast_tbl_init (osm_mcast_tbl.c:=
96)
>>
>> osm_switch_new (osm_switch.c:108):
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_sw->lft =3D malloc(IB_LID_UCAST_END_HO =
+ 1);
>>
>> From ib_types.h
>> =C2=A0#define IB_LID_UCAST_END_HO 0xBFFF
>
> Which is 49152 bytes per switch, not so terrible IMHO.

=46or embedded systems, 50KB per switch is not so small.
Also, a similar thing happens with MFTs, so these 50KB turn
into something even bigger.

>
>>
>> The LFT can be allocated in smaller chunks. If there is a LID that
>> exeeds the current LFT size, LFT is reallocated with an increased si=
ze.
>
> Is such chunk-driven flow really needed?
>
> After subnet discovery and LIDs =C2=A0assignment you know exactly how=
 many
> lid entries are needed for LFT. So would not it be better, faster and
> simpler to just prealloc switches' LFT buffers for this required and
> already optimal size at beginning of the LFT calculation phase?

Yes, that seems like a better approach.

>> This reduces performance and increases memory fragmentation,
>
> Also code's size, complexity and maintainability.
>
>> so this
>> tradeoff is made optional based on new build and config options (see
>> below).
>
> And assuming that we will have a simpler approach, will we need those
> config options?

The config options would not be needed but build options might be.
That would depend on whether you want the current behavior (allocation
during osm_switch_new) preserved or not. Do you ?

-- Hal

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
