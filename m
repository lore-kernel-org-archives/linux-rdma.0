From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 4 May 2015 19:16:23 -0400
Message-ID: <20150504231622.GE10115@phlsvsds.ph.intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com> <1430720099-32512-2-git-send-email-ira.weiny@intel.com> <20150504183657.GA20586@obsidianresearch.com> <20150504223234.GB10115@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150504223234.GB10115-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Pull pkey_tbl_len, gid_tbl_len and your new thing into a single struct
> > and allocate an array of them.
> > 
> > Actually, why not just allocate an array of ib_port_attrs and fill
> > that? Then you can use it for the mad size too.
> 
> That was debated before and I was hoping to leave that for another day.
> 
> It does make some sense to roll it in here.

I remember more details now...

This came up in my original OPA patch series when Sean objected to me calling
the port attributes "cached_port_attr".

There are a number of values in the ib_port_attr structure which are not fixed
(state, active_mtu, lid, sm_lid, etc...)

Putting another copy of this data in the device will be confusing to know which
of these one can count on for the correct data.

I did not write the table length code so I am assuming that data is immutable.
As is the max MAD size, and these new capability bits.  But storing the entire
ib_port_attr structure is probably going to mislead someone.

Do we still think this is a good idea?  I think putting in a single struct with
the proper immutable data is the proper way to go.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
