From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/ucma: Copy iWARP route information.
Date: Tue, 11 May 2010 15:38:38 -0500
Message-ID: <4BE9C04E.4040907@opengridcomputing.com>
References: <20100510154656.22415.47740.stgit@build.ogc.int> <1C56604F650B44A8B00B3CA55D00B95D@amr.corp.intel.com> <B28805226A0F4AD7B53BD430925D3D20@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B28805226A0F4AD7B53BD430925D3D20-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>>> +static void ucma_copy_iw_route(struct rdma_ucm_query_route_resp *resp,
>>> +			       struct rdma_route *route)
>>> +{
>>> +	struct rdma_dev_addr *dev_addr;
>>> +
>>> +	dev_addr = &route->addr.dev_addr;
>>> +	rdma_addr_get_dgid(dev_addr, (union ib_gid *) &resp->ib_route[0].dgid);
>>> +	rdma_addr_get_sgid(dev_addr, (union ib_gid *) &resp->ib_route[0].sgid);
>>>       
>> essentially breaking the query_route call into query_addr, query_path, and
>> query_gid.
>>     
>
> I'm unsure where exactly this change would fit into the newer query model.  Are
> these values available after rdma_resolve_addr completes? 


Yes.


>  Are the sgid and dgid
> the same type of values (e.g. L2 addresses)?  


Yes.


> If the device does ARP internally,
> is the dgid value still set?
>
>   


No.  But only Amso does this, and its old and crusty...


> My current implementation for 'query_gid' returns GIDs using an AF_IB address
> structure.  I'm trying to figure out what structure we should be using to return
> the iwarp values -- some other sockaddr, an iw_path_record, other? 
>
>   


I'll have to ponder this.   In the past, we've been using the gid.raw 
areas to hold these mac addresses...

> Here are links to the proposed changes:
>
> http://www.openfabrics.org/git/?p=~shefty/rdma-dev.git;a=commitdiff;h=b87cccdb27
> a7e75c0f9e03a9d37593ceab4d4ede
>
> http://www.openfabrics.org/git/?p=~shefty/rdma-dev.git;a=commitdiff;h=1830722bb5
> e84451e3b458719cea8c746a2fb6d4
>
> http://www.openfabrics.org/git/?p=~shefty/rdma-dev.git;a=commitdiff;h=0257cc9298
> aa70c4bfc1a8c393f970375a897825
>
> - Sean
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
