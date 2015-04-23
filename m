From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Thu, 23 Apr 2015 11:36:03 +0200
Message-ID: <5538BD03.6010403@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com> <1429714792.45956.110.camel@redhat.com> <20150422171051.GE1494@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422171051.GE1494@phlsvsds.ph.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ira.weiny" <ira.weiny@intel.com>, Doug Ledford <dledford@redhat.com>
Cc: Liran Liss <liranl@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: linux-rdma@vger.kernel.org



On 04/22/2015 07:10 PM, ira.weiny wrote:
> On Wed, Apr 22, 2015 at 10:59:52AM -0400, Doug Ledford wrote:
>> On Tue, 2015-04-21 at 23:36 +0000, Liran Liss wrote:
> 
> [snip]
> 
>>>
>>> 2)The name rdma_tech_* is lame.
>>> rdma_transport_*(), adhering to the above (*) remark, is much better.
>>> For example, both IB and ROCE *do* use the same transport. 
>>
>> I especially want to second this.  I haven't really been happy with the
>> rdma_tech_* names at all.
>>
> 
> I am sure Michael is open to alternative names.  I know I am.  The problem is
> that we can't figure out what "IBoE" is.  It is not a transport, even though
> query_transport is now returning it as one.  :-P

Exactly :-P

> 
> I think the idea behind the "tech" name was that it is a technology "family".
> I can't think of a better name.

IMHO a single patch to change the name and collecting all the
discussion in that thread would be better.

The discussion in this thread already starting to be scattered, like discussion
on bitmask would be better in a thread dedicated on that purpose, otherwise
we have to collect all these scattered discussions again when the bitmask series
come out...

Regards,
Michael Wang


> 
> Ira
> 
