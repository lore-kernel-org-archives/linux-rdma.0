From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ib_types.h moving [was: Re: [ofa-general] [RFC] 3/5: IB ACM:
	libibacm]
Date: Thu, 1 Oct 2009 17:39:15 -0600
Message-ID: <20091001233915.GC5191@obsidianresearch.com>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com> <FCF6CB1AB515463BAB014EB7BB084FDA@amr.corp.intel.com> <20090917101804.12e9e5ce.weiny2@llnl.gov> <FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com> <20090917132050.041b077d.weiny2@llnl.gov> <20090925130908.GD26931@me> <20090930183126.0011af7c.weiny2@llnl.gov> <20091001025752.GA22310@obsidianresearch.com> <20091001155007.5bdf73f1.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091001155007.5bdf73f1.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 01, 2009 at 03:50:07PM -0700, Ira Weiny wrote:
> On Wed, 30 Sep 2009 20:57:52 -0600
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> > On Wed, Sep 30, 2009 at 06:31:26PM -0700, Ira Weiny wrote:
> > 
> > > > Now I likely would agree with Ira that moving ib_types.h to libibumad
> > > > is a least painful option. Do we have a better ideas?
> > > 
> > > So far I can only think of 2 "correct" options.
> > > 
> > >    1) Make ib_types.h into a new library and have libibverbs, libibmad,
> > >       opensm, and MPI's use the constants and helper functions there.  This of
> > >       course would force some dependencies.
> > 
> > You are going the wrong way.. libibverbs is the 'fundamental' lowest
> > level library. Everything should build on it, not re-invent its stuff.

> I agree, however, I think others do not.  In particular is Roland ready to
> accept a significant portion of ib_types.h?  I don't have any problem
> requiring libibverbs for anything IB related.  OTOH, I am not so against
> having many libraries as long as they are well defined and well known.

Well, I'm not so sure a significant amount of ib_types.h belongs in
ibverbs either, alot of that is just OSM junk, and it needs some
cleanup to be part of a stable ABI library

Lets just browse here..

- RMPP stuff, libibumad, libibumad would also have the low level RMPP
  kernel/user interfacing
- QPN numbers, well known values, (PKEY, QKEY, LIDS, MCAST, SUBNET PERFIX) sounds
  like good ibverbs material if it isn't there since it is usable for some of the
  ibverbs calls
- ib_gid_t (alike, but different) is already in ibverbs, gid
  processing functions belong in ibverbs ib_gid_is_multicast
  ib_mgid_get_scope ib_mgid_set_scope ib_gid_set_default
  ib_gid_get_subnet_prefix  ib_gid_is_link_local ib_gid_is_site_local ib_gid_get_guid
- MTU constants duplicates ibverbs constants
- ib_path_rec_t is part of ibverbs, ib_path_* could be in ibverbs too

- Random IB MAD processing junk, random choosen things like:
  IB_NODE_NUM_PORTS_MAX IB_SUBNET_PATH_HOPS_MAX
  IB_PKEY_MAX_BLOCKS IB_MCAST_BLOCK_ID_MASK_HO IB_PKEY_BASE_MASK  IB_MCLASS_BM
  IB_MCLASS_VENDOR_HIGH_RANGE_MAX ib_class_is_vendor_specific_low
  IB_MAD_METHOD_RESP_MASK IB_MAD_METHOD_SET IB_MAD_ATTR_NOTICE
  IB_MAD_ATTR_P_KEY_TABLE IB_PR_COMPMASK_SERVICEID_MSB
  general mad containers and related
  ib_class_port_info_t,ib_sm_info_t, ib_smp_t ib_port_info_t  ..
  can go in libibmad ib mad decoding

>From about line 9175 to the end I'd say that duplicates ibverbs and
should refer to ibverbs versions, or go away entirely (dead code?)

> If the only solution is to have one massive libib library, so be it!  I don't
> have a problem with that.  But I think the maintainer of this lib is going to
> have a hard job.  And perhaps some (switch vendors?) might want at least a
> little more break down of functionality to pick and choose what is required?

The nice thing about libraries is you don't have to include everything
in them in your embedded applications - there are multiple techniques
for using only the subset of object files that you actually use. What
is important is that the library has sensible .o file selection so
that these schemes work. For instance a library with several
orthogonal API groupings should at least put each grouping in a
seperate .o file.

But ultimately this is all fairly static code, the IBA doesn't change
very much and all the MAD processing goop is nice and constant.

> > libibumad should not have device discovery and handling functions!
> > It should use ibv_device and ibv_context identifiers from libibverbs.
> 
> I also agree, however, ib_types does not have any device discover functions.
> I was only speaking of where to put the ib_types functionality.  Not about
> other problems which may exist.  ;-)

It does have  stuff like ib_ca_attr_t ib_port_attr_t which are part of
a discovery thingy (dead code?) :)

> Ok, ok.  Once again I was only speaking of where to put the ib_types stuff.  I
> think you would agree that adding ib_types stuff to libibumad is the wrong
> direction, right?

Well, I bring this all up because ib_types is a huge file and it needs
to go into alot of different places. It is impossible to really judge
where to put things without a clear vision of what the net result
should look like.

Something like:
 - ibverbs controls the device access, naming and base IB types for
   LID, GID and PKEY addressing
 - libumad provides a thin user layer for the kernel QP0 and QP1 special
   QPs, including access to the kernel RMPP engine.
 - libibmad provides all the structure parsing and message processing
   code
   libibmad provides a sane IB address resolution layer (think getaddrinfo but for IB)
 - libibcm provides interfaces that are bolt together compatible with all
   the above libraries.

Now maybe some of those layers get smushed together, libibcm and
libumad are both excessively small libraries :)

> > Two libraries are probably not needed, one library containing both
> > layers (with architectural purity), or putting the umad access layer
> > in libibverbs would be best. We have too many libraries.
 
> Ok, as I said one massive libib library is fine with me.  Are Roland and Sasha
> ready to accept this?

I think the stuff that would want to be added in libibverbs is pretty
minor, mostly some addressing helpers and additional constants that
are fairly static. There isn't really a long term churn there.

Next, I think strategies to get the libraries to the above kind of
layered state need to be devised. Ie for libumad I'd say crank the
SONAME and start again. It is small enough that is very easy, and the
current API really has nothing worth keeping.

Not sure what approach works for libibmad..

Also like I said, I have some stuff that is a different approach than
ib_types, that is much easier to use (bit fields, vs explicit bit
bashing) if it ports properly to Windows MS VC it might be worth
considering going that route instead.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
