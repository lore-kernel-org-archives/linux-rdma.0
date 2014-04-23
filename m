From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: IB/cma: Make timeout dependent on the subnet timeout
Date: Wed, 23 Apr 2014 08:30:21 -0400
Message-ID: <5357B25D.2000108@dev.mellanox.co.il>
References: <53566BB5.5030203@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F2F15@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373992F2F15-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/22/2014 2:41 PM, Hefty, Sean wrote:
>> +static u8 cma_get_ib_subnet_timeout(struct rdma_cm_id *id)
>> +{
>> +	struct ib_port_attr attr;
>> +	int ret;
>> +
>> +	ret = ib_query_port(id->device, id->port_num, &attr);
>> +	return ret == 0 ? attr.subnet_timeout : 18;
>> +}
> 
> Can we query the port once (or only on a change) and cache the result, rather than querying it for every request?

To be IBA spec compliant, SubnetTimeout could change so some new local
event would need to be added and handled to avoid the requerying.

In practice, however, that's not very likely AFAIK.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
