From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: ibstat does not recognize iWARP RNIC adapters
Date: Thu, 26 Apr 2012 10:40:28 -0400
Message-ID: <4F995E5C.1090705@dev.mellanox.co.il>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com> <1828884A29C6694DAF28B7E6B8A82373469D85A8@ORSMSX101.amr.corp.intel.com> <4F995001.7050306@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A82373469D860B@ORSMSX101.amr.corp.intel.com> <4F99586F.5040106@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F99586F.5040106-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/26/2012 10:15 AM, Steve Wise wrote:
> On 04/26/2012 09:12 AM, Hefty, Sean wrote:
>>> Users seem to expect ibstat to show all rdma devices...
>> They why not change ibstat to use ibverbs or have it gather its data
>> directly?
> 
> Could do.
> 
> What is the difference between ibstat and ibv_devinfo anyway? 

What they present to the user is similar. How they obtain their data is
different and useful to debugging issues IMO.

-- Hal

> Seems like they are redundant.
> 
>>   What other functionality does umad provide for RNICs?
> 
> As far as I know, none.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
