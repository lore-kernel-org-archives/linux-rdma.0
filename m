From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Using multi-smps on the wire in libibnetdisc
Date: Fri, 5 Feb 2010 07:24:30 -0500
Message-ID: <f0e08f231002050424o4e8e037ay9922e8fa9ccf828f@mail.gmail.com>
References: <20100202164514.bf2b152a.weiny2@llnl.gov>
	 <f0e08f231002040619y34784bauec6a25d31e7d229b@mail.gmail.com>
	 <20100204100045.4d2aa9aa.weiny2@llnl.gov>
	 <f0e08f231002041201y2b48aa30nc33d2816ed11b1bf@mail.gmail.com>
	 <20100204161325.c4481bfe.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100204161325.c4481bfe.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 4, 2010 at 7:13 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Thu, 4 Feb 2010 15:01:32 -0500
> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Feb 4, 2010 at 1:00 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>> > On Thu, 4 Feb 2010 09:19:39 -0500
>> > Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Tue, Feb 2, 2010 at 7:45 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote=
:
>> >> > Sasha,
>> >> >
>
> [snip]
>
>> >> >
>> >> > real =C2=A0 =C2=A00m2.249s
>> >> > user =C2=A0 =C2=A00m1.244s
>> >> > sys =C2=A0 =C2=A0 0m0.936s
>> >> >
>> >> > 14:40:59 > time ./ibnetdiscover -o 4 --node-name-map /etc/opens=
m/ib-node-name-map -g > new
>> >> >
>> >> > real =C2=A0 =C2=A00m2.170s
>> >> > user =C2=A0 =C2=A00m1.160s
>> >> > sys =C2=A0 =C2=A0 0m0.933s
>> >> >
>> >> > 14:41:10 > /usr/sbin/ibqueryerrors =C2=A0-s RcvErrors,SymbolErr=
ors,RcvSwRelayErrors,XmtWait -r --data
>> >> > Suppressing: RcvErrors SymbolErrors RcvSwRelayErrors XmtWait
>> >> > Errors for 0x66a00d90006fb "SW19"
>> >> > =C2=A0 GUID 0x66a00d90006fb port 9: [VL15Dropped =3D=3D 3] [Xmt=
Data =3D=3D 25187379] [RcvData =3D=3D 25196688] [XmtPkts =3D=3D 349861]=
 [RcvPkts =3D=3D 349954]
>> >> > =C2=A0 =C2=A0 =C2=A0 Link info: =C2=A0 =C2=A0139 =C2=A0 9[ =C2=A0=
] =3D=3D( 4X 5.0 Gbps Active/ =C2=A0LinkUp)=3D=3D> =C2=A00x0002c9030001=
d736 =C2=A0 =C2=A0864 =C2=A0 =C2=A01[ =C2=A0] "hyperion1" ( )
>> >> >
>> >> > Note that there were no additional VL15Dropped packets on the f=
abric. =C2=A0I think 4 seems to be a good compromise. =C2=A0I have not =
tested when there are errors on the fabric. =C2=A0(Right now things see=
m to be good!)
>> >>
>> >> Is this just with the SM doing light sweeping ?
>> >
>> > Yes.
>>
>> That's not a lot of SMP stress from the SM side. SMP consumers are S=
M,
>> diags, and the unsolicited traps.
>
> Agreed. =C2=A0I hope to test this more next week.
>>
>> >
>> >>
>> >> Is there a speedup with 4 rather than 2 ?
>> >
>> > There is a bit of a speed up (~0.5 to 1.0 sec). =C2=A0But my main =
reason to want to
>> > go to 4 is that if there are issues on the fabric, unresponsive no=
des etc.; 4
>> > will give us better parallelism to get around these issues. =C2=A0=
I have not had
>> > the chance to test this condition with the new algorithm but the o=
riginal
>> > ibnetdiscover would slow way down when there are nodes which have =
unresponsive
>> > SMA's. =C2=A0If there are only 2 outstanding this will not give us=
 much speed up.
>> > This was the main motivation I had for improving the library in th=
is way.
>> >
>> > Also, I think you are correct that we should increase OpenSM's def=
ault from 4
>> > to 8. =C2=A0For the same reason as above. =C2=A0Some of our cluste=
rs have worked better
>> > with 8 when we are having issues. =C2=A0But right now we are still=
 running with 4.
>>
>> I'm concerned about just increasing ibnetdiscover to 4 rather than 2=
=2E
>> I've seen a number of clusters with SMP dropping with the current
>> lower defaults.
>
> So OpenSM is seeing dropped packets?

OpenSM is seeing timeouts and there are VL15 drops in the subnet.

> With 4 SMP's on the wire?

Yes.

> I do see some
> VL15Dropped errors (maybe 2-3 a day) but I did not think that would b=
e an
> issue. =C2=A0What kind of rate are you seeing?

> The other question is; do people regularly run the tools which are us=
ing
> libibnetdisc (ibqueryerrors, iblinkinfo, ibnetdiscover)?

These tools are being used (at least ibnetdiscover and ibqueryerrors).

> We do. =C2=A0If others
> are not then I would say this change would have less impact as they w=
ould want
> the diags to have some priority for debugging. =C2=A0The other option=
 is to change
> the patch to be a default of 2 and allow user to change it depending =
on what
> they are trying to do. =C2=A0If you think that is best I will change =
the patch.

=46WIW I think 2 is better until we have more exhaustive experience wit=
h
4. The other alternative would be to make it 4 and then see if people
start noticing (more) VL15 drops and possibly other issues.

-- Hal

> Ira
>
>>
>> -- Hal
>>
>> > Ira
>> >
>> >>
>> >> -- Hal
>> >>
>> >> >
>> >> > The first patch converts the algorithm and the second adds the =
ibnd_set_max_smps_on_wire call.
>> >> >
>> >> > Let me know what you think. =C2=A0Because the algorithm changed=
 so much testing this is a bit difficult because the order of the node =
discovery is different. =C2=A0However, I have done some extensive diffi=
ng of the output of ibnetdiscover and things look good.
>> >> >
>> >> > Ira
>> >> >
>> >> > --
>> >> > Ira Weiny
>> >> > Math Programmer/Computer Scientist
>> >> > Lawrence Livermore National Lab
>> >> > 925-423-8008
>> >> > weiny2-i2BcT+NCU+M@public.gmane.org
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux=
-rdma" in
>> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> > More majordomo info at =C2=A0http://**vger.kernel.org/majordomo=
-info.html
>> >> >
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
dma" in
>> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> More majordomo info at =C2=A0http://**vger.kernel.org/majordomo-i=
nfo.html
>> >>
>> >
>> >
>> > --
>> > Ira Weiny
>> > Math Programmer/Computer Scientist
>> > Lawrence Livermore National Lab
>> > 925-423-8008
>> > weiny2-i2BcT+NCU+M@public.gmane.org
>> >
>>
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
