From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v6 02/26] IB/Verbs: Implement raw management helpers
Date: Mon, 27 Apr 2015 09:41:43 +0200
Message-ID: <553DE837.6010800@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com> <1429878230-11749-3-git-send-email-yun.wang@profitbricks.com> <DB4PR05MB0863D872E5C4F95C4E01145FB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com> <20150424162914.GA9305@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150424162914.GA9305@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Liran Liss <liranl@mellanox.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 04/24/2015 06:29 PM, Jason Gunthorpe wrote:
> On Fri, Apr 24, 2015 at 03:15:54PM +0000, Liran Liss wrote:
>>> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> 
>>> +static inline int rdma_tech_iboe(struct ib_device *device, u8 port_num)
>>> +{
>>> +	return device->query_transport(device, port_num)
>>> +			== RDMA_TRANSPORT_IBOE;
>>
>> Remove RDMA_TRANSPORT_IBOE.
>> In the current code, the test should be: (IB transport && Ethernet link layer).
> 
> No, if this rmda_tech stuff is to reflect the specification the port
> implements, then RoCEE is a valid specification (IBA Annex A16), as it
> RoCEEv2 (A17).
> 
> This patch set is trying to drop then link layer concept entirely.

I think a new enum on protocol could help solve the conflict in here, we
can still get rid of the link layer meanwhile leave the legacy
transport type alone :-)

Regards,
Michael Wang

> 
> Jason
> 
