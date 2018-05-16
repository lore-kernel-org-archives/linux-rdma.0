From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Wed, 16 May 2018 10:57:39 -0600
Message-ID: <20180516165739.GD25661@ziepe.ca>
References: <F9802EE9-4420-44EE-93DC-27CC799B427E@oracle.com>
 <3bee76df-49a6-cf3c-6df4-749a6309358e@dev.mellanox.co.il>
 <B3360947-5905-47BD-ABC4-6C4BB32F5DA6@oracle.com>
 <20180514210200.GN21531@ziepe.ca>
 <ab0e1318-8e1a-5822-5484-33e460095830@dev.mellanox.co.il>
 <E41BCEAA-0204-448D-8188-ACA03932B3AC@oracle.com>
 <20180515190424.GL5615@ziepe.ca>
 <3E15B62F-E705-43BD-8A72-9E74F784D40E@oracle.com>
 <20180516151201.GA25661@ziepe.ca>
 <695ae613-931a-50ba-2b83-9d172e0ac2bc@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <695ae613-931a-50ba-2b83-9d172e0ac2bc@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 16, 2018 at 12:42:37PM -0400, Hal Rosenstock wrote:

> >>> The only time you could need a new REJ code is if the GMP is using a
> >>> PKey different from the REQ - which is a pretty goofy thing to do
> >>> considering this VM case.
> >>
> >> Its goofy. In the CX-3 shared port model, the BTH.PKey is the
> >> default one and the REQ.PKey is the full one even if the sending
> >> VM’s port only is a limited member. This patch series fixes the last
> >> issue.
> > 
> > Again, this is wrong, the BTH.Pkey and REQ.Pkey should be the same -
> 
> I do not believe there is anything in the spec that requires this. I
> agree it's the simplest use model though.

The spec doesn't require it, but the design of the Linux CM certainly
does.

> > If BTH.Pkey != REQ.PKey then the requestor side has to obviously
> > select two PKeys, which is basically impossible.
> > 
> > The VM should not be part of the default partition, for instance.
> 
> I think that the VM is at least a limited member of the default partition.

Well, being a limited member still means the default pkey cannot be
used for CM GMPs.

I actually can't think of why you'd want to do this, better to put the
SM nodes in all the pkeys and reserve the default pkey completely for
the network management control plane.

Jason
