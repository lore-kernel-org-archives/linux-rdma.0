From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Mon, 14 May 2018 15:04:08 -0600
Message-ID: <20180514210408.GO21531@ziepe.ca>
References: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
 <20180509093020.24503-3-Haakon.Bugge@oracle.com>
 <ab1f16cd-aa60-0c43-841c-aed301fd2a7e@dev.mellanox.co.il>
 <F9802EE9-4420-44EE-93DC-27CC799B427E@oracle.com>
 <3bee76df-49a6-cf3c-6df4-749a6309358e@dev.mellanox.co.il>
 <B3360947-5905-47BD-ABC4-6C4BB32F5DA6@oracle.com>
 <325ba4af-b52e-4f70-9d89-38dafe10ba99@dev.mellanox.co.il>
 <23B160D2-6631-42A6-8A4D-644E90E8A704@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23B160D2-6631-42A6-8A4D-644E90E8A704@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Hal Rosenstock <hal@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 11, 2018 at 12:55:00PM +0200, Håkon Bugge wrote:
> > I'll check upstream OpenSM when I get a chance to see if same problem
> > exists. Oracle OpenSM forked from upstream long time ago and not sure
> > how similar the path record code is. There were various impacts for the
> > shared port virtualization (for CX-3) in terms of adding the ability to
> > allow both pkeys.
> 
> I just had a chat with Line H. here in Oracle. She confirms that Oracle’s SM and the upstream one act similar in this matter.
> 
> Further, using shared port virtualization, OpenSM will adhere to the
> physical ports only, and doesn’t even know the PKey assignments to
> the VFs assigned the VMs.

Yes, but that isn't the point. If the VM receives a PR with a pkey
that is not found in the VM's table then it should not even send a CM
REQ in the first place.

Jason
