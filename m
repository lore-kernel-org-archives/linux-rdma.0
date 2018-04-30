From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/core: Make ib_mad_client_id atomic
Date: Mon, 30 Apr 2018 17:01:08 -0600
Message-ID: <20180430230108.GE26909@ziepe.ca>
References: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
 <1524196555.11756.30.camel@redhat.com>
 <20180420153451.GF30433@ziepe.ca>
 <50E3FE4A-2C6E-4493-92E1-383C349FAE3A@oracle.com>
 <20180423221618.0000795d@dev.mellanox.co.il>
 <20180430144930.GB26895@ziepe.ca>
 <1525108249.11756.93.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1525108249.11756.93.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: jackm <jackm@dev.mellanox.co.il>, =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, Don Hiatt <don.hiatt@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 30, 2018 at 01:10:49PM -0400, Doug Ledford wrote:
> On Mon, 2018-04-30 at 08:49 -0600, Jason Gunthorpe wrote:
> > On Mon, Apr 23, 2018 at 10:16:18PM +0300, jackm wrote:
> > 
> > > > > TIDs need to be globally unique on the entire machine.  
> > > Jason, that is not exactly correct.
> > 
> > The expecation for /dev/umad users is that they all receive locally
> > unique TID prefixes. The kernel may be OK to keep things port-specific
> > but it is slightly breaking the API we are presenting to userspace to
> > allow them to alias..
> > 
> > Jason
> 
> Would people be happier with this commit message then:
> 
> IB/core: Make ib_mad_client_id atomic
>   
> Currently, the kernel protects access to the agent ID allocator on a per
> port basis using a spinlock, so it is impossible for two apps/threads on
> the same port to get the same TID, but it is entirely possible for two
> threads on different ports to end up with the same TID.  
> 
> As this can be confusing (regardless of it being legal according to the
> IB Spec 1.3, C13-18.1.1, in section 13.4.6.4 - TransactionID usage),
> and as the rdma-core user space API for /dev/umad devices implies unique
> TIDs even across ports, make the TID an atomic type so that no two
> allocations, regardless of port number, will be the same.
> 
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> Reviewed-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> Signed-off-by: Doug Ledford <dledford@redhat.com>

fine for me

Jason
