From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: ibstat does not recognize iWARP RNIC adapters
Date: Thu, 26 Apr 2012 10:36:02 -0500
Message-ID: <4F996B62.2030707@opengridcomputing.com>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com> <1828884A29C6694DAF28B7E6B8A82373469D85A8@ORSMSX101.amr.corp.intel.com> <4F995001.7050306@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A82373469D860B@ORSMSX101.amr.corp.intel.com> <4F99586F.5040106@opengridcomputing.com> <4F995E5C.1090705@dev.mellanox.co.il> <4F996A71.6090309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F996A71.6090309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 04/26/2012 10:32 AM, Hal Rosenstock wrote:
> On 4/26/2012 10:40 AM, Hal Rosenstock wrote:
>> On 4/26/2012 10:15 AM, Steve Wise wrote:
>>> On 04/26/2012 09:12 AM, Hefty, Sean wrote:
>>>>> Users seem to expect ibstat to show all rdma devices...
>>>> They why not change ibstat to use ibverbs or have it gather its data
>>>> directly?
>>> Could do.
>>>
>>> What is the difference between ibstat and ibv_devinfo anyway?
>> What they present to the user is similar. How they obtain their data is
>> different and useful to debugging issues IMO.
> One other point:
>
> Currently, for an IB management only node (at least in Linux), there is
> no requirement for libibverbs.
>
> -- Hal
>

Hal/Sean, I defer to you on whether you think we should add this change to ibstat.  If you all recommend against it, 
we'll advise customers to use ibv_devinfo, which is included with libibverbs and is required for iwarp user apps.  But 
it seems a minimal change to add, and previously it did include iwarp devices.

steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
