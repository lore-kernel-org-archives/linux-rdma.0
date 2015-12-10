From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Thu, 10 Dec 2015 10:10:21 -0600
Message-ID: <004f01d13365$45535e20$cffa1a60$@opengridcomputing.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com> <566753E3.9060301@redhat.com> <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com> <20151208225940.GB27609@obsidianresearch.com> <20151208230244.GA10701@infradead.org> <20151209005203.GD16976@phlsvsds.ph.intel.com> <20151209184235.GB4522@infradead.org> <20151210014556.GA32059@phlsvsds.ph.intel.com> <56693758.90808@dev.mellanox.co.il> <93E3DE8A-0589-436D-A9A1-7EAC66B12739@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <93E3DE8A-0589-436D-A9A1-7EAC66B12739-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "'ira.weiny'" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Or Gerlitz' <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
> Sent: Thursday, December 10, 2015 10:08 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: ira.weiny; Christoph Hellwig; Jason Gunthorpe; Or Gerlitz; Steve Wise; Or Gerlitz; Sagi Grimberg; Doug Ledford
> Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
> 
> 
> > On Dec 10, 2015, at 3:27 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> >
> >
> >
> >> Doug this is going to conflict with the rdmavt work.  So if you take this could
> >> you respond on the list.
> >
> > It will also conflict with the iser remote invalidate series.
> >
> > Doug it would help if you share your plans so people can rebase
> > accordingly.
> 
> I would be remiss not to mention that it probably also
> conflicts with the NFS server bi-directional RPC/RDMA
> series.
> 
> Invasive IB core changes like this clean up are especially
> burdensome for me because NFS/RDMA changes do not normally
> go through Doug's tree, so it takes extra co-ordination.
> 
> Here is a modest proposal. An obvious way to split the
> device attr cleanup might go like this:
> 
> a. first patch: add new fields to ib_device
> b. then one patch for each provider to populate these fields
> c. then one patch for each kernel ULP to use the new fields
> d. then one patch for each provider to remove ->query_attr
> e. last patch: remove ib_device_attr from the IB core
> 
> That way each provider and ULP maintainer can review and
> ack the portion of the changes that he or she is responsible
> for, and it should help make it much easier to merge with
> conflicting changes.
> 
> Splitting it across more than one kernel release would be
> helpful too, IMO. a. and b. can go into 4.5, c. into 4.6,
> and d. and e. can go in any time after that.
> 
> This adds more "process" but given the long chain of core
> changes now in plan, we should acknowledge how disruptive
> they will be, and come up with ways to make it possible to
> get other work done while the core maintenance work
> progresses.
> 
> 

The approach sounds reasonable to me.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
