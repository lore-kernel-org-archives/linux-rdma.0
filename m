From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 4 May 2015 17:52:05 -0600
Message-ID: <20150504235204.GA24346@obsidianresearch.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <20150504183657.GA20586@obsidianresearch.com>
 <20150504223234.GB10115@phlsvsds.ph.intel.com>
 <20150504231622.GE10115@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150504231622.GE10115-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 04, 2015 at 07:16:23PM -0400, ira.weiny wrote:
> > > Pull pkey_tbl_len, gid_tbl_len and your new thing into a single struct
> > > and allocate an array of them.
> > > 
> > > Actually, why not just allocate an array of ib_port_attrs and fill
> > > that? Then you can use it for the mad size too.
> > 
> > That was debated before and I was hoping to leave that for another day.
> > 
> > It does make some sense to roll it in here.
> 
> I remember more details now...
> 
> This came up in my original OPA patch series when Sean objected to me calling
> the port attributes "cached_port_attr".

Yeah, not a great name for storing immutable values. port_properties
or something.

> There are a number of values in the ib_port_attr structure which are not fixed
> (state, active_mtu, lid, sm_lid, etc...)

Yes, there are alot of those.. 

So, a new struct is better, and this has just gotten so messy.

- Update ib_alloc_device to accept a num_ports argument and
  create the port-port array at that point
- Have the drivers fill in their per port values before calling
  ib_register. Delete read_port_table_lengths
- Get ib_dealloc_device to free the list instead of unregister,
  feels like keeping that memory around for the duration of the kref
  is smarter..
- Drop gid_tbl_len and pkey_tbl_len for the new scheme
- Mark all the old immutable attrs in ib_port_attrs as deprecated and
  if any are easy to remove then do so..
- Don't add the caps or the max mad size immutables to port_attrs

> <quote>
> > 3rd add gets the work
> > to fix it up I guess.
> </quote>
> I don't understand this comment?

gid_tbl_len, pkey_tbl_len were the first two to use a 'shortcut' here,
your caps and/or max mad size are the third to take the 'shortcut'.

Rule of threes: The third person to extend the same badly designed
widget gets to fix it properly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
