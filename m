From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH V2 0/5] iSER support for iWARP
Date: Tue, 30 Jun 2015 09:34:07 -0500
Message-ID: <002401d0b341$d274cae0$775e60a0$@opengridcomputing.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <55926268.5060705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <55926268.5060705@dev.mellanox.co.il>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagig@dev.mellanox.co.il>, dledford@redhat.com
Cc: roid@mellanox.com, sagig@mellanox.com, linux-rdma@vger.kernel.org, jgunthorpe@obsidianresearch.com, infinipath@intel.com, eli@mellanox.com, ogerlitz@mellanox.com, sean.hefty@intel.com, 'target-devel' <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig@dev.mellanox.co.il]
> Sent: Tuesday, June 30, 2015 4:33 AM
> To: Steve Wise; dledford@redhat.com
> Cc: roid@mellanox.com; sagig@mellanox.com; linux-rdma@vger.kernel.org; jgunthorpe@obsidianresearch.com; infinipath@intel.com;
> eli@mellanox.com; ogerlitz@mellanox.com; sean.hefty@intel.com; target-devel
> Subject: Re: [PATCH V2 0/5] iSER support for iWARP
> 
> On 6/30/2015 12:36 AM, Steve Wise wrote:
> > The following series implements support for iWARP transports in the iSER
> > initiator and target.  This is based on Doug's k.o/for-4.2 branch.
> >
> > I've tested this on cxgb4 and mlx4 hardware.
> >
> > Changes since V1:
> >
> > Introduce and use transport-independent RDMA core services for allocating
> > DMA MRs and computing fast register access flags.
> >
> > Correctly set the device max_sge_rd capability in several rdma device
> > drivers.
> >
> > isert: use device capability max_sge_rd for the read sge depth.
> >
> > isert: change max_sge to max_write_sge in struct isert_conn.
> >
> 
> Steve,
> 
> iser-target related code is usually posted/reviewed on the target-devel
> mailing list and merged via target-pending tree.
> 
> Please CC target-devel in future patches that involve iser-target.
> 
> Thanks,
> Sagi.

Sorry, my bad. 
