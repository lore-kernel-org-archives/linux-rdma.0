From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Fri, 26 Jun 2015 09:02:22 -0500
Message-ID: <558D5B6E.6090900@opengridcomputing.com>
References: <20150625212917.14869.66238.stgit@build.ogc.int> <1828884A29C6694DAF28B7E6B8A82373A8FF9ECA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FF9ECA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/25/2015 5:37 PM, Hefty, Sean wrote:
>> +enum rdma_mr_roles {
> I would drop naming the enum - it shouldn't be used, as the values are bit flags.

ok.

>> +	RDMA_MRR_RECV			= 1,
>> +	RDMA_MRR_SEND			= (1<<1),
>> +	RDMA_MRR_READ_SOURCE		= (1<<2),
>> +	RDMA_MRR_READ_SINK		= (1<<3),
>> +	RDMA_MRR_WRITE_SOURCE		= (1<<4),
>> +	RDMA_MRR_WRITE_SINK		= (1<<5),
>> +	RDMA_MRR_ATOMIC			= (1<<6),
>> +	RDMA_MRR_MW_BIND		= (1<<7),
>> +	RDMA_MRR_ZERO_BASED		= (1<<8),
> There's 'something' different about this role that cause me hesitation.  Maybe that it's dependent on other roles being set to be useful?  I'm not sure.
>
> Maybe we need both roles and registration flags, with this declared as a flag?
>
>> +	RDMA_MRR_ACCESS_ON_DEMAND	= (1<<9),
> This one is even more different, as it doesn't impact how the MR interacts with the interfaces, or change how the application uses the MR.  This is really a hint to the provider regarding the selection of different implementation flows.

How about roles and attributes?  ZERO_BASED and ACCESS_ON_DEMAND would 
be attributes and the rest roles.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
