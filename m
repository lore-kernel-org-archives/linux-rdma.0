From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback query_transport()
Date: Fri, 24 Apr 2015 16:35:39 +0200
Message-ID: <553A54BB.4080902@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com> <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com> <553A5362.3040808@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <553A5362.3040808@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Talpey <tom@talpey.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Steve Wise <swise@opengridcomputing.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 04/24/2015 04:29 PM, Tom Talpey wrote:
> On 4/24/2015 8:23 AM, Michael Wang wrote:
[snip]
>> +static enum rdma_transport_type
>> +mlx5_ib_query_transport(struct ib_device *device, u8 port_num)
>> +{
>> +    return RDMA_TRANSPORT_IB;
>> +}
>> +
> 
> 
> Just noticed that mlx5 is not being coded as RoCE-capable like mlx4.
> The mlx5 driver is for the new ConnectX-4, which implements all three
> of IB, RoCE and RoCEv2, right? Are those last two not supported?

I'm not sure about the details of mlx5, but according to the current
implementation, it's transport is IB without a link-layer callback,
which means it doesn't support IBoE...

And there is no method to change the port link-layer type as mlx4 did.

Regards,
Michael Wang

> 
> 
