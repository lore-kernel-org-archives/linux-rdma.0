From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Date: Fri, 14 Jun 2019 12:09:21 +1000
Message-ID: <20190614020921.GM14363@dread.disaster.area>
References: <20190606104203.GF7433@quack2.suse.cz>
 <20190606220329.GA11698@iweiny-DESK2.sc.intel.com>
 <20190607110426.GB12765@quack2.suse.cz>
 <20190607182534.GC14559@iweiny-DESK2.sc.intel.com>
 <20190608001036.GF14308@dread.disaster.area>
 <20190612123751.GD32656@bombadil.infradead.org>
 <20190613002555.GH14363@dread.disaster.area>
 <20190613152755.GI32656@bombadil.infradead.org>
 <20190613211321.GC32404@iweiny-DESK2.sc.intel.com>
 <20190613234530.GK22901@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190613234530.GK22901-uk2M96/98Pc@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 13, 2019 at 08:45:30PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 13, 2019 at 02:13:21PM -0700, Ira Weiny wrote:
> > On Thu, Jun 13, 2019 at 08:27:55AM -0700, Matthew Wilcox wrote:
> > > On Thu, Jun 13, 2019 at 10:25:55AM +1000, Dave Chinner wrote:
> > > > e.g. Process A has an exclusive layout lease on file F. It does an
> > > > IO to file F. The filesystem IO path checks that Process A owns the
> > > > lease on the file and so skips straight through layout breaking
> > > > because it owns the lease and is allowed to modify the layout. It
> > > > then takes the inode metadata locks to allocate new space and write
> > > > new data.
> > > > 
> > > > Process B now tries to write to file F. The FS checks whether
> > > > Process B owns a layout lease on file F. It doesn't, so then it
> > > > tries to break the layout lease so the IO can proceed. The layout
> > > > breaking code sees that process A has an exclusive layout lease
> > > > granted, and so returns -ETXTBSY to process B - it is not allowed to
> > > > break the lease and so the IO fails with -ETXTBSY.
> > > 
> > > This description doesn't match the behaviour that RDMA wants either.
> > > Even if Process A has a lease on the file, an IO from Process A which
> > > results in blocks being freed from the file is going to result in the
> > > RDMA device being able to write to blocks which are now freed (and
> > > potentially reallocated to another file).
> > 
> > I don't understand why this would not work for RDMA?  As long as the layout
> > does not change the page pins can remain in place.
> 
> Because process A had a layout lease (and presumably a MR) and the
> layout was still modified in way that invalidates the RDMA MR.

The lease holder is allowed to modify the mapping it has a lease
over. That's necessary so lease holders can write data into
unallocated space in the file. The lease is there to prevent third
parties from modifying the layout without the lease holder being
informed and taking appropriate action to allow that 3rd party
modification to occur.

If the lease holder modifies the mapping in a way that causes it's
own internal state to screw up, then that's a bug in the lease
holder application.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
