From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Tue, 7 Mar 2017 17:01:21 -0600
Message-ID: <20170307230121.GA52428@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170301172920.GA11340@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301175521.GB14791@obsidianresearch.com>
 <20170301221420.GA18548@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301230506.GB2820@obsidianresearch.com>
 <20170303214514.GA12996@ssaleem-MOBL4.amr.corp.intel.com>
 <20170303222244.GA678@obsidianresearch.com>
 <20170306191631.GB34252@ssaleem-MOBL4.amr.corp.intel.com>
 <20170306194052.GB31672@obsidianresearch.com>
 <20170307224622.GA45028@ssaleem-MOBL4.amr.corp.intel.com>
 <20170307225027.GA20858@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170307225027.GA20858-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 07, 2017 at 03:50:27PM -0700, Jason Gunthorpe wrote:
> On Tue, Mar 07, 2017 at 04:46:22PM -0600, Shiraz Saleem wrote:
> 
> > Is __this__ C11 barrier a compiler barrier as well?
> 
> Yes, of course.
> 
> > #1 is preferred using atomic_thread_fence(memory_order_seq_cst) for all 
> > archs. 
> 
> Okay..
> 
> I will send a patch to fix this then?
> 

One more question - C11 atomics are only supported on latest GCC 4.9? User
would need to move newer compilers. Yes? 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
