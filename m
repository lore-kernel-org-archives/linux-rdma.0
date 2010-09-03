From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OFED 1.5.2: libibumad.so version bump
Date: Fri, 3 Sep 2010 16:18:33 -0400
Message-ID: <AANLkTim_MqVuso1_-bV2jiBvyw+KpKU3FpUJetSHzjKC@mail.gmail.com>
References: <4C7CCB01.909@dev.mellanox.co.il>
	<20100831124915.ac4dc1bd.weiny2@llnl.gov>
	<AANLkTim1_D5+GMWX80X0afu8A8_kizbQUq1KUhxxSLpz@mail.gmail.com>
	<20100902140502.62489af7.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100902140502.62489af7.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OpenFabricsEWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Mark A. Grondona" <mgrondona-i2BcT+NCU+M@public.gmane.org>, "Moody, Adam T." <moody20-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 2, 2010 at 5:05 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Thu, 2 Sep 2010 13:35:44 -0700
> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hi Ira,
>>
>> On Tue, Aug 31, 2010 at 3:49 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>> > On Tue, 31 Aug 2010 02:27:29 -0700
>> > Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> Hi all,
>> >>
>> >> In order to support RoCEE, a while ago I've added
>> >> a new field to umad, thus introduced an ABI change.
>> >>
>> >> There already was a discussion on the linux-rdma list,
>> >> but due to the proximity of the upcoming OFED 1.5.2
>> >> release these concerns were raised again.
>> >>
>> >> So my question is, other that *general* concerns about
>> >> changing ABI, is anybody aware of the *actual* problem
>> >> that will be caused by this? Any customer/3rd party
>> >> solution that would be affected by this?
>> >
>> > Because our MVAPICH depends on umad, libibumad.so.1 to be exact.[*=
] =C2=A0These ABI
>> > changes (to v2 and v3) would have forced our users to recompile th=
eir codes.
>> > We are maintaining the old ABI here until our next major release o=
f CHAOS[#]
>> > to prevent this.
>> >
>> > I think the thing to remember is that many people are using Open F=
abrics
>> > software, but are _not_ using "OFED". =C2=A0What is tested with OF=
ED is not the
>> > only thing which might be using these libraries. =C2=A0Our version=
 of MVAPICH is a
>> > good example.
>> >
>> > I am certainly not the expert in this area and I know that many pe=
ople have
>> > tried to make this point in the past, but I will say it here again=
=2E =C2=A0Each of
>> > these Open Fabrics packages _must_ be maintained to stand on their=
 own.
>> > Roland did this a long time ago with ibverbs.
>> >
>> > I think now is a good time to start discussing breaking up the "ma=
nagement" git
>> > tree so that these libraries can live on their own.
>>
>> How does breaking up the "management" git tree help with this issue =
?
>
> Creating and tracking of branches to maintain ABI would be easier wit=
h
> separate git trees. =C2=A0Furthermore, separate trees will help "forc=
e" the use of
> consistent ABI's and interfaces.
>
> For example, if I currently want OpenSM version 3.3.6 I get a managem=
ent tree
> with version libibumad 1.3.5. =C2=A0But this last ABI change to umad =
was only
> required for the latest infiniband-diags (ibstat utility). =C2=A0Why =
do I get all
> this "cruft" when pulling the latest OpenSM?

That's a totally different issue than which packages a particular OFED
release picks up.

>
>> To me, that's the admin part and is separate from the ABI issue
>> raised.
>
> Yes it is separate. =C2=A0That is why I created another thread to dis=
cuss those
> issues.
>
>>
>> The ABI compatibility is not achieved by administrative means
>> (separate repos, etc.) but rather than review and discipline to
>> achieve this as a unmutable goal.
>
> I agree that ABI compatibility will require more discipline. =C2=A0Th=
at is what
> made me think of the separate git trees. =C2=A0I feel it will be _eas=
ier_ to
> maintain this discipline when the trees are separate.

Call me a skeptic but I think the same thing would've occurred with
separate git trees.

I have no real preference one way or the other. In fact, this was
discussed in the early days which are long forgotten. The libraries
are small and umad is a lot more stable than mad. It would just mean a
lot of busy work for everyone with internal trees.

-- Hal

>
> Ira
>
>>
>> -- Hal
>>
>> > I will write a separate email regarding this.
>> >
>> > Ira
>> >
>> > [*] We are looking into removing the dependency.
>> > [#] Shameless plug: http://*code.google.com/p/chaos-release/wiki/C=
HAOS_Description
>> >
>> >>
>> >> -- Yevgeny
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
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =C2=A0http://*vger.kernel.org/majordomo-inf=
o.html
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
