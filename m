From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Using multi-smps on the wire in libibnetdisc
Date: Fri, 5 Feb 2010 07:27:05 -0500
Message-ID: <f0e08f231002050427r37d326b4w4c188e30992579ac@mail.gmail.com>
References: <20100202164514.bf2b152a.weiny2@llnl.gov>
	 <f0e08f231002040619y34784bauec6a25d31e7d229b@mail.gmail.com>
	 <20100204100045.4d2aa9aa.weiny2@llnl.gov>
	 <f0e08f231002041201y2b48aa30nc33d2816ed11b1bf@mail.gmail.com>
	 <20100204161325.c4481bfe.weiny2@llnl.gov>
	 <20100204181852.f175d968.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100204181852.f175d968.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 4, 2010 at 9:18 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Thu, 4 Feb 2010 16:13:25 -0800
> Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>
>> On Thu, 4 Feb 2010 15:01:32 -0500
>> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > On Thu, Feb 4, 2010 at 1:00 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>> > > On Thu, 4 Feb 2010 09:19:39 -0500
>> > > Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > >
>> > >> On Tue, Feb 2, 2010 at 7:45 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wro=
te:
>> > >> > Sasha,
>> > >> >
>>
>> [snip]
>
> [snip]
>
>> > >>
>> > >> Is there a speedup with 4 rather than 2 ?
>> > >
>> > > There is a bit of a speed up (~0.5 to 1.0 sec). =C2=A0But my mai=
n reason to want to
>> > > go to 4 is that if there are issues on the fabric, unresponsive =
nodes etc.; 4
>> > > will give us better parallelism to get around these issues. =C2=A0=
I have not had
>> > > the chance to test this condition with the new algorithm but the=
 original
>> > > ibnetdiscover would slow way down when there are nodes which hav=
e unresponsive
>> > > SMA's. =C2=A0If there are only 2 outstanding this will not give =
us much speed up.
>> > > This was the main motivation I had for improving the library in =
this way.
>
> Ok, I found a fabric with just 2 nodes which were unresponsive... =C2=
=A0A quick
> test shows...
>
> Original ibnetdiscover:
>
> 18:12:29 > time ./ibnetdiscover > foo
> ibwarn: [26993] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dl=
id 0; 0,1,24,11,9)
> src/ibnetdisc.c:457; Query remote node (DR path slid 0; dlid 0; 0,1,2=
4,11,9) failed, skipping port
> ibwarn: [26993] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dl=
id 0; 0,1,24,24,18,7,6)
> src/ibnetdisc.c:457; Query remote node (DR path slid 0; dlid 0; 0,1,2=
4,24,18,7,6) failed, skipping port
>
> real =C2=A0 =C2=A00m9.073s
> user =C2=A0 =C2=A00m0.137s
> sys =C2=A0 =C2=A0 0m0.172s
>
> 18:12:43 > time ./ibnetdiscover > foo
> ibwarn: [31111] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dl=
id 0; 0,1,24,11,9)
> src/ibnetdisc.c:457; Query remote node (DR path slid 0; dlid 0; 0,1,2=
4,11,9) failed, skipping port
> ibwarn: [31111] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dl=
id 0; 0,1,24,24,18,7,6)
> src/ibnetdisc.c:457; Query remote node (DR path slid 0; dlid 0; 0,1,2=
4,24,18,7,6) failed, skipping port
>
> real =C2=A0 =C2=A00m9.103s
> user =C2=A0 =C2=A00m0.046s
> sys =C2=A0 =C2=A0 0m0.046s
>
>
> *New* ibnetdiscover with different outstanding SMP's.
>
> 18:12:14 > time ./ibnetdiscover -o 2 > foo
> src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,11,9 Attr 0=
x11:0) bad status 110; Connection timed out
> src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,13,7,7,6 At=
tr 0x11:0) bad status 110; Connection timed out
>
> real =C2=A0 =C2=A00m9.746s
> user =C2=A0 =C2=A00m6.559s
> sys =C2=A0 =C2=A0 0m3.156s
>
> 18:13:00 > time ./ibnetdiscover -o 4 > foo
> src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,11,9 Attr 0=
x11:0) bad status 110; Connection timed out
> src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,13,7,7,6 At=
tr 0x11:0) bad status 110; Connection timed out
>
> real =C2=A0 =C2=A00m4.668s
> user =C2=A0 =C2=A00m3.043s
> sys =C2=A0 =C2=A0 0m1.601s
>
> 18:13:10 > time ./ibnetdiscover -o 8 > foo
> src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,11,9 Attr 0=
x11:0) bad status 110; Connection timed out
> src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,13,7,7,6 At=
tr 0x11:0) bad status 110; Connection timed out
>
> real =C2=A0 =C2=A00m4.360s
> user =C2=A0 =C2=A00m2.891s
> sys =C2=A0 =C2=A0 0m1.451s
>
>
> Note that 2 does not give much speed up, where 4 does. =C2=A0Obviousl=
y this could
> have to do with the fact there were 2 nodes which were bad (so if you=
 had
> 100's of nodes unresponsive a higher value might be worth using)

It depends on the number of unresponsive nodes being same or higher
than number of outstanding/parallel SMPs. In a sense, the number of
outstanding SMPs is a measure of how many unresponsive nodes one is
willing to tolerate before slowing down/waiting for timeouts. In some
environments, unresponsive nodes are a normal case.

-- Hal

> but as a
> default compromise I think 4 is good.
>
> Ira
>
>> > >
>> > > Also, I think you are correct that we should increase OpenSM's d=
efault from 4
>> > > to 8. =C2=A0For the same reason as above. =C2=A0Some of our clus=
ters have worked better
>> > > with 8 when we are having issues. =C2=A0But right now we are sti=
ll running with 4.
>> >
>> > I'm concerned about just increasing ibnetdiscover to 4 rather than=
 2.
>> > I've seen a number of clusters with SMP dropping with the current
>> > lower defaults.
>>
>> So OpenSM is seeing dropped packets? =C2=A0With 4 SMP's on the wire?=
 =C2=A0I do see some
>> VL15Dropped errors (maybe 2-3 a day) but I did not think that would =
be an
>> issue. =C2=A0What kind of rate are you seeing?
>>
>> The other question is; do people regularly run the tools which are u=
sing
>> libibnetdisc (ibqueryerrors, iblinkinfo, ibnetdiscover)? =C2=A0We do=
=2E =C2=A0If others
>> are not then I would say this change would have less impact as they =
would want
>> the diags to have some priority for debugging. =C2=A0The other optio=
n is to change
>> the patch to be a default of 2 and allow user to change it depending=
 on what
>> they are trying to do. =C2=A0If you think that is best I will change=
 the patch.
>>
>> Ira
>>
>> >
>> > -- Hal
>> >
>> > > Ira
>> > >
>> > >>
>> > >> -- Hal
>> > >>
>> > >> >
>> > >> > The first patch converts the algorithm and the second adds th=
e ibnd_set_max_smps_on_wire call.
>> > >> >
>> > >> > Let me know what you think. =C2=A0Because the algorithm chang=
ed so much testing this is a bit difficult because the order of the nod=
e discovery is different. =C2=A0However, I have done some extensive dif=
fing of the output of ibnetdiscover and things look good.
>> > >> >
>> > >> > Ira
>> > >> >
>> > >> > --
>> > >> > Ira Weiny
>> > >> > Math Programmer/Computer Scientist
>> > >> > Lawrence Livermore National Lab
>> > >> > 925-423-8008
>> > >> > weiny2-i2BcT+NCU+M@public.gmane.org
>> > >> > --
>> > >> > To unsubscribe from this list: send the line "unsubscribe lin=
ux-rdma" in
>> > >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > >> > More majordomo info at =C2=A0http://**vger.kernel.org/majordo=
mo-info.html
>> > >> >
>> > >> --
>> > >> To unsubscribe from this list: send the line "unsubscribe linux=
-rdma" in
>> > >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > >> More majordomo info at =C2=A0http://**vger.kernel.org/majordomo=
-info.html
>> > >>
>> > >
>> > >
>> > > --
>> > > Ira Weiny
>> > > Math Programmer/Computer Scientist
>> > > Lawrence Livermore National Lab
>> > > 925-423-8008
>> > > weiny2-i2BcT+NCU+M@public.gmane.org
>> > >
>> >
>>
>>
>> --
>> Ira Weiny
>> Math Programmer/Computer Scientist
>> Lawrence Livermore National Lab
>> 925-423-8008
>> weiny2-i2BcT+NCU+M@public.gmane.org
>
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
