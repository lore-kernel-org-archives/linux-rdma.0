From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Tue, 14 Apr 2015 10:08:26 +0200
Message-ID: <552CCAFA.8030107@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB5AC.6050101@profitbricks.com> <20150413192701.GA19112@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150413192701.GA19112-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/13/2015 09:27 PM, Jason Gunthorpe wrote:
> On Mon, Apr 13, 2015 at 02:25:16PM +0200, Michael Wang wrote:
>>  	dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
>>  	if (!dev_list)
>> @@ -1673,13 +1671,19 @@ static void ipoib_add_one(struct ib_device *device)
>>  	}
>>  
>>  	for (p = s; p <= e; ++p) {
>> -		if (rdma_port_get_link_layer(device, p) != IB_LINK_LAYER_INFINIBAND)
>> +		if (!rdma_tech_ib(device, p))
>>  			continue;
>>  		dev = ipoib_add_port("ib%d", device, p);
>>  		if (!IS_ERR(dev)) {
>>  			priv = netdev_priv(dev);
>>  			list_add_tail(&priv->list, dev_list);
>>  		}
>> +		count++;
>> +	}
>> +
>> +	if (!count) {
>> +		kfree(dev_list);
>> +		return;
>>  	}
> 
> This doesn't quite look right, it should be 'goto error1'
> 
> But then I read 'goto error1' and it doesn't look like it can handle
> cm_dev->port being NULL, so more fixing is needed.

Nice catch ;-) I guess the 'count++' should be inside 'if (!IS_ERR(dev))' after
link the node.

Regards,
Michael Wang

> 
> Ditto for cm_remove_one
> 
> Should audit all uses of cm_dev->port[] to make sure they can all
> handle NULL.
> 
> Jason
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
