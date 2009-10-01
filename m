From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib_types.h moving [was: Re: [ofa-general] [RFC] 3/5: IB ACM:
 libibacm]
Date: Wed, 30 Sep 2009 18:31:26 -0700
Message-ID: <20090930183126.0011af7c.weiny2@llnl.gov>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com>
	<FCF6CB1AB515463BAB014EB7BB084FDA@amr.corp.intel.com>
	<20090917101804.12e9e5ce.weiny2@llnl.gov>
	<FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com>
	<20090917132050.041b077d.weiny2@llnl.gov>
	<20090925130908.GD26931@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090925130908.GD26931@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 25 Sep 2009 16:09:08 +0300
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 13:20 Thu 17 Sep     , Ira Weiny wrote:
> > 
> > Sasha, would you be willing to accept such a patch?  First move ib_types.h to umad and then move the long inline functions into the lib and separate out the remaining header.
> > 
> > Or would you prefer a new library?  I think there is enough code there but I leave it up to you.
> 
> Basically cleaning ib_types.h issue (which was raised repeatedly in the
> past too) and making some order here with libibmad duplications would be
> a nice thing.
> 
> However I still not understand clearly yet how things should be
> organized properly (assumig all histories, ibutils dependencies, etc.).
> And sure we can try to find an optimal model, so let's discuss:
> 
> libibumad is an option. However today this library only provides a
> layer to user_mad kernel API and actually is transparent to MAD's
> structure. Maybe complicating this with adding ib_types.h and some MAD
> fields access helpers is not a big deal, but sort of disadvantage
> anyway.

I think I agree.  I have been looking over the headers and functionality of
the librarys and libibumad is really just an interface to the kernel.  It is
just a data passing library.  libibmad is the library which can marshal
packets (mad packets anyway).  Much of the functionality of ib_types.h is used
in (de|en)codeing packets (mad and others).  For example, there is
functionality for other things such as ib_gid_is_multicast which is used for
non-mad packets.  Where does this functionality go?  I think I agree with Sean
that this header should be broken up but I fear there might be a number of
items left homeless...  :-/

> 
> To place this stuff in separate library/package is another possibility,
> but perspective of adding new package doesn't make me happy.

I think we need to look at libibverbs as well...

from ib_types.h

#define IB_PATH_RECORD_RATE_2_5_GBS		2
#define IB_PATH_RECORD_RATE_5_GBS		5
...
#define IB_MTU_LEN_256							1
#define IB_MTU_LEN_512							2
...
#define IB_LINK_DOWN      1
#define IB_LINK_INIT	  2


>From verbs.h

	IBV_RATE_2_5_GBPS = 2,
	IBV_RATE_5_GBPS   = 5,
...
	IBV_MTU_256  = 1,
	IBV_MTU_512  = 2,
...
	IBV_PORT_DOWN		= 1,
	IBV_PORT_INIT		= 2,


Furthermore, we have 3 functions to decode node type (and their associated
#def/enums).

libibmad:
mad_dump_node_type

ib_types.h:
ib_get_node_type_str

libibverbs:
ibv_node_type_str

I will admit mad_dump_node_type is somewhat special...  But still, why all
this reinvention?

> 
> In theory ib_types.h would be also merged with libibmad. However for
> me the current libibmad seems to be too much heavy for not using it for
> stuff other than infiniband-diags.

I am not quite sure what you mean here.  Do you mean libibmad is already too
complicated ("too much heavy")?  And/Or that libibmad is not appropriate for
users other than infiniband-diags?

> 
> Another options?
> 
> Now I likely would agree with Ira that moving ib_types.h to libibumad
> is a least painful option. Do we have a better ideas?

So far I can only think of 2 "correct" options.

   1) Make ib_types.h into a new library and have libibverbs, libibmad,
      opensm, and MPI's use the constants and helper functions there.  This of
      course would force some dependencies.

   2) split up and spread ib_types.h around to appropriate places.  This will
      likely include libibmad and libibverbs (others?) I don't think libibumad
      is appropriate really.  At first, I suggested this mainly out of
      convenience because WinOF uses it.  However, I don't think it is
      architecturally correct.  libibumad looks to have a sound interface and
      should not be messed with.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
