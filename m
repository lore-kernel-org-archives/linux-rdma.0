From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH RFC] Documentation/infiniband: Add docs for rdma-helpers
Date: Fri, 15 May 2015 10:31:33 +0200
Message-ID: <5555AEE5.9060503@profitbricks.com>
References: <1431523472-10888-1-git-send-email-yun.wang@profitbricks.com> <1431529914.2377.22.camel@redhat.com> <1828884A29C6694DAF28B7E6B8A82373A8FDA105@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDA105@ORSMSX109.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>, Doug Ledford <dledford@redhat.com>
Cc: Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, "Weiny, Ira" <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: linux-rdma@vger.kernel.org



On 05/13/2015 06:42 PM, Hefty, Sean wrote:
>>> +  rdma_cap_ib_cm
>>> +  ---------------
>>> +    Communication Manager (CM) will handle the connections between
>>        ^Connection Manager (CM) service, used to ease the process of
> 
> In IB terms, this is communication manager.  It also handles transport level address resolution for UD QPs.

I could find both 'connection' and 'communication' in different docs,
while 'connection' is more related to verbs, 'communication' is more
close to specification.

IMHO 'connection' make more sense, after all, all the transport between
adaptors could named as communication, while connection management is exactly
what CM did in kernel.

Doug, what's your opinion?

> 
>>> +  rdma_cap_eth_ah
>>> +  ---------------
>>> +    Infiniband address handler format is special in ethernet fabric,
>> use
>>> +    the helper to verify whether the port is using ethernet format or
>> not.
>>
>> This helper is true when the address of the specific connection is of
>> the Ethernet (RoCE) variety.
> 
> This is used for connectionless communication.

Could you please give more details on this?

Regards,
Michael Wang

> 
