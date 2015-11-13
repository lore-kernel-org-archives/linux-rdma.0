From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mad: In validate_mad, validate CM method and attribute
Date: Fri, 13 Nov 2015 14:12:24 -0500
Message-ID: <56463618.4060104@dev.mellanox.co.il>
References: <56447CA2.1070802@dev.mellanox.co.il>
 <20151112181339.GA16488@phlsvsds.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A9BACD7D@ORSMSX110.amr.corp.intel.com>
 <20151112221300.GA12250@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151112221300.GA12250-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IOn 11/12/2015 5:13 PM, Jason Gunthorpe wrote:
> On Thu, Nov 12, 2015 at 08:30:55PM +0000, Hefty, Sean wrote:
>>>> +		/* CM attributes other than ClassPortInfo only use Send method
>>> */
>>>> +		if (mad_hdr->mgmt_class == IB_MGMT_CLASS_CM) {
>>>> +			if (mad_hdr->attr_id != IB_MGMT_CLASSPORTINFO_ATTR_ID) {
>>>> +				if (mad_hdr->method != IB_MGMT_METHOD_SEND)
>>>> +					goto out;
>>>> +			} else if (mad_hdr->method != IB_MGMT_METHOD_GET_RESP)
>>>> +				goto out;
>>>> +		}
>>>
>>> Doesn't this invalidate a CM Get(ClassPortInfo) mad?
>>
>> I believe this does.

My bad. That wasn't my intention.

>> I think you could remove the else if clause
>> and let the received MAD get passed to the CM.  It would be dropped
>> there as unsupported.  The net result is likely the same.

I'm dropping else clause for CM CPI validation in next version of this
patch.

> IIRC responding to Get(CPI) is mandatory?

Yes it's mandatory to support CPI (and get method of CPI) on a class.
However, it's not currently done in CM.

-- Hal

> Jason
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
