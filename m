From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ib_types.h moving [was: Re: [ofa-general] [RFC] 3/5: IB ACM:
	libibacm]
Date: Fri, 2 Oct 2009 13:58:42 -0400
Message-ID: <f0e08f230910021058o69b27e45rae0a2bc5260f4d5@mail.gmail.com>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com>
	 <20090917101804.12e9e5ce.weiny2@llnl.gov>
	 <FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com>
	 <20090917132050.041b077d.weiny2@llnl.gov> <20090925130908.GD26931@me>
	 <20090930183126.0011af7c.weiny2@llnl.gov>
	 <20091001025752.GA22310@obsidianresearch.com>
	 <20091001155007.5bdf73f1.weiny2@llnl.gov>
	 <20091001233915.GC5191@obsidianresearch.com>
	 <20091002104538.b1362887.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091002104538.b1362887.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 2, 2009 at 1:45 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Thu, 1 Oct 2009 17:39:15 -0600
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
>> On Thu, Oct 01, 2009 at 03:50:07PM -0700, Ira Weiny wrote:
>> > On Wed, 30 Sep 2009 20:57:52 -0600
>> > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> >
>> > > On Wed, Sep 30, 2009 at 06:31:26PM -0700, Ira Weiny wrote:
>> > >
>> > > > > Now I likely would agree with Ira that moving ib_types.h to =
libibumad
>> > > > > is a least painful option. Do we have a better ideas?
>> > > >
>> > > > So far I can only think of 2 "correct" options.
>> > > >
>> > > > =C2=A0 =C2=A01) Make ib_types.h into a new library and have li=
bibverbs, libibmad,
>> > > > =C2=A0 =C2=A0 =C2=A0 opensm, and MPI's use the constants and h=
elper functions there. =C2=A0This of
>> > > > =C2=A0 =C2=A0 =C2=A0 course would force some dependencies.
>> > >
>> > > You are going the wrong way.. libibverbs is the 'fundamental' lo=
west
>> > > level library. Everything should build on it, not re-invent its =
stuff.
>>
>> > I agree, however, I think others do not. =C2=A0In particular is Ro=
land ready to
>> > accept a significant portion of ib_types.h? =C2=A0I don't have any=
 problem
>> > requiring libibverbs for anything IB related. =C2=A0OTOH, I am not=
 so against
>> > having many libraries as long as they are well defined and well kn=
own.
>>
>> Well, I'm not so sure a significant amount of ib_types.h belongs in
>> ibverbs either, alot of that is just OSM junk, and it needs some
>> cleanup to be part of a stable ABI library
>>
>> Lets just browse here..
>>
>> - RMPP stuff, libibumad, libibumad would also have the low level RMP=
P
>> =C2=A0 kernel/user interfacing
>> - QPN numbers, well known values, (PKEY, QKEY, LIDS, MCAST, SUBNET P=
ERFIX) sounds
>> =C2=A0 like good ibverbs material if it isn't there since it is usab=
le for some of the
>> =C2=A0 ibverbs calls
>> - ib_gid_t (alike, but different) is already in ibverbs, gid
>> =C2=A0 processing functions belong in ibverbs ib_gid_is_multicast
>> =C2=A0 ib_mgid_get_scope ib_mgid_set_scope ib_gid_set_default
>> =C2=A0 ib_gid_get_subnet_prefix =C2=A0ib_gid_is_link_local ib_gid_is=
_site_local ib_gid_get_guid
>> - MTU constants duplicates ibverbs constants
>> - ib_path_rec_t is part of ibverbs, ib_path_* could be in ibverbs to=
o
>
> Except for the RMPP stuff you list first, this is all moving to (or a=
lready
> duplicated by) ibverbs. =C2=A0I have not counted the lines of code bu=
t this seems
> like more than an insignificant change to ibverbs. =C2=A0Furthermore,=
 it would mean
> significant build changes to OpenSM and the diags. =C2=A0Mind you, th=
is is not
> insurmountable but I think there is some work to be done here.
>
>>
>> - Random IB MAD processing junk, random choosen things like:
>> =C2=A0 IB_NODE_NUM_PORTS_MAX IB_SUBNET_PATH_HOPS_MAX
>> =C2=A0 IB_PKEY_MAX_BLOCKS IB_MCAST_BLOCK_ID_MASK_HO IB_PKEY_BASE_MAS=
K =C2=A0IB_MCLASS_BM
>> =C2=A0 IB_MCLASS_VENDOR_HIGH_RANGE_MAX ib_class_is_vendor_specific_l=
ow
>> =C2=A0 IB_MAD_METHOD_RESP_MASK IB_MAD_METHOD_SET IB_MAD_ATTR_NOTICE
>> =C2=A0 IB_MAD_ATTR_P_KEY_TABLE IB_PR_COMPMASK_SERVICEID_MSB
>> =C2=A0 general mad containers and related
>> =C2=A0 ib_class_port_info_t,ib_sm_info_t, ib_smp_t ib_port_info_t =C2=
=A0..
>> =C2=A0 can go in libibmad ib mad decoding
>>
>> From about line 9175 to the end I'd say that duplicates ibverbs and
>> should refer to ibverbs versions, or go away entirely (dead code?)
>
> Yep! =C2=A0I don't see anyone using it anyway.

I think this is used in Windows and may be used by out of tree users.
I know this can move but it is a consideration (at least IMO).

> Perhaps a first step is to start
> removing dead code?
>
>>
>> > If the only solution is to have one massive libib library, so be i=
t! =C2=A0I don't
>> > have a problem with that. =C2=A0But I think the maintainer of this=
 lib is going to
>> > have a hard job. =C2=A0And perhaps some (switch vendors?) might wa=
nt at least a
>> > little more break down of functionality to pick and choose what is=
 required?
>>
>> The nice thing about libraries is you don't have to include everythi=
ng
>> in them in your embedded applications - there are multiple technique=
s
>> for using only the subset of object files that you actually use. Wha=
t
>> is important is that the library has sensible .o file selection so
>> that these schemes work. For instance a library with several
>> orthogonal API groupings should at least put each grouping in a
>> seperate .o file.
>>
>> But ultimately this is all fairly static code, the IBA doesn't chang=
e
>> very much and all the MAD processing goop is nice and constant.
>
> I get all that... =C2=A0I just did not want to rock the boat too much=
, lest I get
> thrown out... =C2=A0;-) =C2=A0Perhaps I am past that point already?
>
>>
>> > > libibumad should not have device discovery and handling function=
s!
>> > > It should use ibv_device and ibv_context identifiers from libibv=
erbs.
>> >
>> > I also agree, however, ib_types does not have any device discover =
functions.
>> > I was only speaking of where to put the ib_types functionality. =C2=
=A0Not about
>> > other problems which may exist. =C2=A0;-)
>>
>> It does have =C2=A0stuff like ib_ca_attr_t ib_port_attr_t which are =
part of
>> a discovery thingy (dead code?) :)
>
> :-/ =C2=A0not dead... =C2=A0But specific to the vendor layer in opens=
m.

=46or at least umad vendor layer, the discovery code could be changed t=
o
use verbs rather than the current umad calls for this. It sounded like
Sean already did this for Windows. I wonder whether those changes can
readily be transferred to Linux.

>=C2=A0So leave that
> in the OpenSM tree for now, until we can determine if the other vendo=
r layers
> are used and by whom. =C2=A0I see some more work to be done in this a=
rea but I am
> unsure of the current use of the vendor layer. =C2=A0Hal often asks t=
he list and
> no one replies to him... =C2=A0:-/ =C2=A0It seems that Windows is on =
board with using
> libibumad and I don't know of any other OpenSM user who does not.
> Furthermore, I don't know why OpenSM could not use libib[u]mad defini=
tions
> internally even if the vendor layer is suppling wire packets from som=
e other
> vendor defined structure. =C2=A0I don't care if vendors want to defin=
e their own
> proprietary versions of these definitions and structs. =C2=A0;-) =C2=A0=
Well as long as
> they follow the spec, of course.
>
>>
>> > Ok, ok. =C2=A0Once again I was only speaking of where to put the i=
b_types stuff. =C2=A0I
>> > think you would agree that adding ib_types stuff to libibumad is t=
he wrong
>> > direction, right?
>>
>> Well, I bring this all up because ib_types is a huge file and it nee=
ds
>> to go into alot of different places. It is impossible to really judg=
e
>> where to put things without a clear vision of what the net result
>> should look like.
>
> Agreed.
>
>>
>> Something like:
>> =C2=A0- ibverbs controls the device access, naming and base IB types=
 for
>> =C2=A0 =C2=A0LID, GID and PKEY addressing
>> =C2=A0- libumad provides a thin user layer for the kernel QP0 and QP=
1 special
>> =C2=A0 =C2=A0QPs, including access to the kernel RMPP engine.
>> =C2=A0- libibmad provides all the structure parsing and message proc=
essing
>> =C2=A0 =C2=A0code
>> =C2=A0 =C2=A0libibmad provides a sane IB address resolution layer (t=
hink getaddrinfo but for IB)
>> =C2=A0- libibcm provides interfaces that are bolt together compatibl=
e with all
>> =C2=A0 =C2=A0the above libraries.
>>
>> Now maybe some of those layers get smushed together, libibcm and
>> libumad are both excessively small libraries :)
>
> Agreed. =C2=A0I am more than willing to create patches and work throu=
gh this.
> However, I want to agree on a plan first.[*] =C2=A0Then we can keep t=
he thrashing of
> large and complex patches to a minimum.
>
>>
>> > > Two libraries are probably not needed, one library containing bo=
th
>> > > layers (with architectural purity), or putting the umad access l=
ayer
>> > > in libibverbs would be best. We have too many libraries.
>>
>> > Ok, as I said one massive libib library is fine with me. =C2=A0Are=
 Roland and Sasha
>> > ready to accept this?
>>
>> I think the stuff that would want to be added in libibverbs is prett=
y
>> minor, mostly some addressing helpers and additional constants that
>> are fairly static. There isn't really a long term churn there.
>
> I hope not. =C2=A0And I tend to agree with you. =C2=A0But I fear thin=
gs I don't
> understand like ibutils. =C2=A0I don't know what it needs or where it=
 draws what
> from. =C2=A0We might seriously break them. =C2=A0Maintainers of other=
 projects need to
> know this is happening and, at a minimum, understand why. =C2=A0I thi=
nk things will
> go much easier if they do.
>
>>
>> Next, I think strategies to get the libraries to the above kind of
>> layered state need to be devised. Ie for libumad I'd say crank the
>> SONAME and start again. It is small enough that is very easy, and th=
e
>> current API really has nothing worth keeping.
>>
>> Not sure what approach works for libibmad..
>
> [*]How about this for a plan:
>
> =C2=A0 1) remove dead and duplicated code from ib_types.h
> =C2=A0 2) combine libibmad and libibumad into new libibumad2
> =C2=A0 =C2=A0 =C2=A02a) leave dead/outdated code out of libibumad2
> =C2=A0 3) move verbs ib_types functionality into libibverbs
> =C2=A0 =C2=A0 =C2=A03a) adjust OpenSM and vendor layers as appropriat=
e
> =C2=A0 4) Move MAD ib_types functionality into libibumad2
> =C2=A0 =C2=A0 =C2=A04a) convert upper vendor layer and OpenSM to use =
new MAD defines in
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0libibumad2
> =C2=A0 5) remove ib_types.h
>
> I am probably missing something.

What about ibsim for one ?

-- Hal

>>
>> Also like I said, I have some stuff that is a different approach tha=
n
>> ib_types, that is much easier to use (bit fields, vs explicit bit
>> bashing) if it ports properly to Windows MS VC it might be worth
>> considering going that route instead.
>
> That sounds interesting. =C2=A0I just don't want to see further dupli=
cation. =C2=A0It's
> just too confusing. =C2=A0I know that my brain is the smallest of the=
 bunch here.
> So maybe that is why I am suffering the most with the current complex=
ity...
> :-/ =C2=A0???
>
> Ira
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
