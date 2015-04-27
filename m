From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback query_transport()
Date: Mon, 27 Apr 2015 09:39:05 +0200
Message-ID: <553DE799.5050608@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com> <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com> <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Liran Liss <liranl@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 04/24/2015 05:12 PM, Liran Liss wrote:
>> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>>
> [snip]
>> a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
>> 65994a1..d54f91e 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -75,10 +75,13 @@ enum rdma_node_type {  };
>>
>>  enum rdma_transport_type {
>> +	/* legacy for users */
>>  	RDMA_TRANSPORT_IB,
>>  	RDMA_TRANSPORT_IWARP,
>>  	RDMA_TRANSPORT_USNIC,
>> -	RDMA_TRANSPORT_USNIC_UDP
>> +	RDMA_TRANSPORT_USNIC_UDP,
>> +	/* new transport */
>> +	RDMA_TRANSPORT_IBOE,
> 
> Remove RDMA_TRANSPORT_IBOE - it is not a transport.
> ROCE uses IBTA transport.
> 
> If any code should test for ROCE should invoke a specific helper, e.g., rdma_protocol_iboe().
> This is  what you currently call "rdma_tech_iboe" is patch 02/26.
> 
> I think that pretty much everybody agrees that rdma_protocol_*() is a better name than rdma_tech_*(), right?
> So, let's change this.

Sure, sounds reasonable now, about the IBOE, we still need it to
separate the port support IB/ETH without the check on link-layer,
So what about a new enum on protocol type?

Like:

enum rdma_protocol {
	RDMA_PROTOCOL_IB,
	RDMA_PROTOCOL_IBOE,
	RDMA_PROTOCOL_IWARP,
	RDMA_PROTOCOL_USNIC_UDP
};

So we could use query_protocol() to ask device provide the protocol
type, and there will be no mixing with the legacy transport type
anymore :-)

Regards,
Michael Wang

> 
> The semantics are: "check that a link supports a certain wire protocol, or a set of wire protocols", where 'certain'
> refers to the specific helper...
> 
> 
