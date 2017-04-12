From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 18/18] IB/core: Define 'opa' rdma_ah_attr type
Date: Tue, 11 Apr 2017 22:31:58 -0700
Message-ID: <8676f0b2-15f4-a30f-4f0c-15176ef80d0c@intel.com>
References: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1491932545-60894-19-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1119CE@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1119CE-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/11/2017 5:14 PM, Hefty, Sean wrote:
>> +struct opa_ah_attr {
>> +	struct ib_global_route	grh;
>> +	u32			dlid;
>> +	u8			sl;
>> +	u8			src_path_bits;
>> +	u8			static_rate;
>> +	u8			ah_flags;
>> +	u8			port_num;
>
> ah_flags and port_num are in rdma_ah_attr:

Will fix.

>
>> +};
>> +
>>  struct rdma_ah_attr {
>>  	u8	port_num;
>>  	u8	ah_flags;
>> @@ -867,6 +878,7 @@ struct rdma_ah_attr {
>>  	union {
>>  		struct ib_ah_attr ib;
>>  		struct eth_ah_attr eth;
>> +		struct opa_ah_attr opa;
>>  	};
>>  };
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
