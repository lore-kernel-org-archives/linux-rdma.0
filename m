From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] libibverbs: Add support for usNIC nodes and
 transports
Date: Wed, 22 Jan 2014 16:57:49 +0000
Message-ID: <97D33F82-21BA-4885-A909-7DCDBFCACD36@cisco.com>
References: <1390360721-14894-1-git-send-email-umalhi@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D1516D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D1516D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <1137E0437CC0804A852C7B0F9A5299F0-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,
	The underlaying requirement is to have two different transports for usNIC.  However, in verbs, there is a one to one relationship between node type and transport.  Hence, there are two nodes also.

Upinder

On Jan 21, 2014, at 8:04 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
>> index 4b1ab57..ff9a1aa 100644
>> --- a/include/infiniband/verbs.h
>> +++ b/include/infiniband/verbs.h
>> @@ -68,13 +68,17 @@ enum ibv_node_type {
>> 	IBV_NODE_CA 		= 1,
>> 	IBV_NODE_SWITCH,
>> 	IBV_NODE_ROUTER,
>> -	IBV_NODE_RNIC
>> +	IBV_NODE_RNIC,
>> +	IBV_NODE_USNIC,
>> +	IBV_NODE_USNIC_UDP,
> 
> Are these really different nodes or just different transports for the same NIC?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
