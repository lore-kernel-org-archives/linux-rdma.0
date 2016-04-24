From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Further thoughts on uAPI
Date: Sun, 24 Apr 2016 20:11:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB045101@ORSMSX109.amr.corp.intel.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <20160421172428.GA5102@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160421172428.GA5102-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Within the basic sketch I presented there are two basic ways to
> address this:
>   1) Allow the driver to override RDMA uAPI object call backs
>      directly.
>      A driver could replace the entire uAPI QP object with its
>      own code. The default implementation would be the existing scheme
>      that translates the uAPI to the kAPI.
>      The driver code could do whatever it wants and isn't required to
>      implement the 'struct ib_qp' to get there.
>      In this case the driver must still implement the common uAPI for
>      verbs QP objects.
>   2) Allow the driver to provide a 'driver specific QP' object which
>      does not follow the common uAPI. This is a new object that would
>      only be used by the driver specific library, and like the above
>      totally bypasses all of the standard kAPI design.
> 
> That said - there are clearly some important services that core code
> is providing, locking, idrs, hot-removal, auto-deletion, things like
> comp channels, etc. These are object agnostic and even if you have a
> driver specific object they still have to be cared for.
> 
> I'm guessing some hybrid is going to be best, eg simple objects like a
> verbs PD could be handled through common code calling the kAPI for all
> drivers and complex very driver-specific objects like MRs, AHs or QPs
> are better routed directly to the driver without using the kapi.

{snip}

> We already have to maintain it exactly as is (with write) for a long
> time, adding another copy that is ioctl based and has to live forever
> doesn't seem great :( Maybe the compromise is to use this scheme to
> carry the existing struct as the base attribute?

After fully over-analyzing things, these are my current thoughts.

I'm for merging all the rdma uABI interfaces.  This will allow us to share events, and allow closer association between objects.

We have 256 ioctl commands available.  A straightforward mapping would result in uverbs using 43, ucma 23, and ucm 18.  I'd deprecate ucm, but if it needs to be kept, it could probably drop to about 6 commands.  Uverbs could be re-structured into 10 objects -- each with create/query/modify/close routines -- plus about 6 fast path commands.

I propose splitting the ioctls into 8 command blocks, with 32 commands each.

Block 0: core objects
The uapi object create/query/modify/close routines (most of uverbs) fit here. 

Block 1: cm/mgmt
Block 2: driver fast path
Block 3: experimental?  No ABI compat guarantees
Block 4-7: reserved

A command block has a num_ops, followed by an array of calls.  Each device structure has an array of pointers to command blocks.  This allows a driver to override any call, without necessarily storing a huge function table.

For the base ioctl command, I would also add these two fields: op_ctrl and flags.  I'm envision that these fields can be used to determine the format of the input/output data.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
