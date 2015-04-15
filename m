From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Wed, 15 Apr 2015 09:58:18 +0200
Message-ID: <552E1A1A.4090704@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB5AC.6050101@profitbricks.com> <20150413192701.GA19112@obsidianresearch.com> <20150413194602.GA21467@phlsvsds.ph.intel.com> <20150413200138.GC19112@obsidianresearch.com> <20150414141806.GA7354@phlsvsds.ph.intel.com> <20150414172514.GB7682@obsidianresearch.com> <20150414174311.GA28111@phlsvsds.ph.intel.com> <20150414175904.GB13896@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FC127C@ORSMSX109.amr.corp.intel.com> <20150414182137.GD7682@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150414182137.GD7682@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Hefty, Sean" <sean.hefty@intel.com>
Cc: "Weiny, Ira" <ira.weiny@intel.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/14/2015 08:21 PM, Jason Gunthorpe wrote:
> On Tue, Apr 14, 2015 at 06:02:47PM +0000, Hefty, Sean wrote:
>>> Yes, that is the only reasonable thing that could happen.
>>>
>>> init failure should only be possible under exceptional cases (OOM).
>>>
>>> The only system response is to call ib_umad_add_one again - so of
>>> course the first call had to completely clean up everything it did.
>>
>> A reasonable follow up change would be to replace the add device
>> callbacks with add port callbacks.
> 
> Yes, combined with a port argument to ib_set_client_data /
> ib_get_client_data it would be a nice simplifying clean up.
> 
> It would be nice to have sane error handling too :( In an ideal world
> the add call back should return an error and the thing that triggered
> it should unwind back to module load failure.

We can give client->add() callback a return value and make ib_register_device()
return -ENOMEM when it failed, just wondering why we don't do this at first, any
special reason?

Regards,
Michael Wang

> 
> Jason
> 
