From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 4 May 2015 12:36:57 -0600
Message-ID: <20150504183657.GA20586@obsidianresearch.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430720099-32512-2-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 04, 2015 at 02:14:55AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Add Core capability flags to each port attribute and read those into ib_device
> upon registration for each port.

+1 on adding it to read_port_table_lengths

But this whole thing is starting to get goofy, 3rd add gets the work
to fix it up I guess.

Pull pkey_tbl_len, gid_tbl_len and your new thing into a single struct
and allocate an array of them.

Actually, why not just allocate an array of ib_port_attrs and fill
that? Then you can use it for the mad size too.

Not in your patch, but why does read_port_table_lengths use a kmalloc
for what should be a stack allocation? Yuk.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
