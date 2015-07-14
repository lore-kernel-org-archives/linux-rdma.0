From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH V5 5/5] RDMA/isert: Limit read depth based on the device max_sge_rd capability
Date: Tue, 14 Jul 2015 14:11:58 -0500
Message-ID: <00e001d0be68$f50005c0$df001140$@opengridcomputing.com>
References: <20150705174353.10042.39648.stgit@build2.ogc.int> <20150705174505.10042.28442.stgit@build2.ogc.int> <20150714082721.GA30072@infradead.org> <001201d0be43$1a240980$4e6c1c80$@opengridcomputing.com> <20150714154200.GE11026@infradead.org> <007001d0be4c$9f640ab0$de2c2010$@opengridcomputing.com> <57000A57-6E11-4949-81D4-C8735A10C671@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <57000A57-6E11-4949-81D4-C8735A10C671@oracle.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Chuck Lever' <chuck.lever@oracle.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'Doug Ledford' <dledford@redhat.com>, infinipath@intel.com, 'Sagi Grimberg' <sagig@mellanox.com>, 'Or Gerlitz' <ogerlitz@mellanox.com>, roid@mellanox.com, 'linux-rdma' <linux-rdma@vger.kernel.org>, 'Eli Cohen' <eli@mellanox.com>, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Chuck Lever
> Sent: Tuesday, July 14, 2015 1:47 PM
> To: Steve Wise
> Cc: Christoph Hellwig; Doug Ledford; infinipath@intel.com; Sagi Grimberg; Or Gerlitz; roid@mellanox.com; linux-rdma; Eli Cohen;
target-
> devel@vger.kernel.org
> Subject: Re: [PATCH V5 5/5] RDMA/isert: Limit read depth based on the device max_sge_rd capability
> 
> 
> On Jul 14, 2015, at 11:49 AM, Steve Wise <swise@opengridcomputing.com> wrote:
> 
> >
> >
> >> -----Original Message-----
> >> From: 'Christoph Hellwig' [mailto:hch@infradead.org]
> >> Sent: Tuesday, July 14, 2015 10:42 AM
> >> To: Steve Wise
> >> Cc: 'Christoph Hellwig'; Chuck Lever; dledford@redhat.com; infinipath@intel.com; sagig@mellanox.com; ogerlitz@mellanox.com;
> >> roid@mellanox.com; linux-rdma@vger.kernel.org; eli@mellanox.com; target-devel@vger.kernel.org
> >> Subject: Re: [PATCH V5 5/5] RDMA/isert: Limit read depth based on the device max_sge_rd capability
> >>
> >> On Tue, Jul 14, 2015 at 09:41:00AM -0500, Steve Wise wrote:
> >>>> Btw, any hance to make the NFS client use these values as well instead
> >>>> of the current rdma_read_max_sge() hack?
> >>>
> >>> Chuck, can you add this to your cleanup list?
> >>
> >> It would be useful to add this to your series so we can get rid of
> >> it for the next merge window instead of introducing a depenency that
> >> would defer it to the next merge window.
> >
> > Ok, I will do this.
> 
> Steve, can you review v2 of the nfs-rdma-for-4.3 series I posted
> yesterday? Specifically:
> 
>   http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=commit;h=6abafb636e03fbb7f93a26796223833581a70190
> 
> Which changes the way xprtrdma uses max_sge.
> 

Sure, but xprtrdma doesn't issue reads, so max_sge_rd isn't needed.  The change Christoph wants is actually in svcrdma.  I will
change the server to use max_sge_rd instead of rdma_cap_read_multi_sge().
