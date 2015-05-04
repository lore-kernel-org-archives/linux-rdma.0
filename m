From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 4 May 2015 18:32:35 -0400
Message-ID: <20150504223234.GB10115@phlsvsds.ph.intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com> <1430720099-32512-2-git-send-email-ira.weiny@intel.com> <20150504183657.GA20586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150504183657.GA20586-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 04, 2015 at 12:36:57PM -0600, Jason Gunthorpe wrote:
> On Mon, May 04, 2015 at 02:14:55AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Add Core capability flags to each port attribute and read those into ib_device
> > upon registration for each port.
> 
> +1 on adding it to read_port_table_lengths
> 
> But this whole thing is starting to get goofy,
>

<quote>
> 3rd add gets the work
> to fix it up I guess.
</quote>

I don't understand this comment?

> 
> Pull pkey_tbl_len, gid_tbl_len and your new thing into a single struct
> and allocate an array of them.
> 
> Actually, why not just allocate an array of ib_port_attrs and fill
> that? Then you can use it for the mad size too.

That was debated before and I was hoping to leave that for another day.

It does make some sense to roll it in here.

> 
> Not in your patch, but why does read_port_table_lengths use a kmalloc
> for what should be a stack allocation? Yuk.

I don't know.  I almost submitted a separate patch for that.  I will clean it
up when I combine the functions.

I also don't like the way the arrays in read_port_table_lengths are handled.
This requires a start_port call when comparing bits.  It is easier to just make
the array 1 based with index 0 valid only for switches.

This is part of the reason there is a separate function and array.

Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
