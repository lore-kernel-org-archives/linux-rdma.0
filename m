From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Thu, 17 Jul 2014 13:23:12 -0700
Message-ID: <53C830B0.4040901@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com> <008101cfa1f9$1b72c9f0$52585dd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <008101cfa1f9$1b72c9f0$52585dd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 07/17/2014 12:55 PM, Steve Wise wrote:
> 
> 
>> -----Original Message-----
>> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>> Sent: Thursday, July 17, 2014 2:50 PM
>> To: Steve Wise; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier'
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider module
>>
>>>> So the rdma cm is expected to increase the driver reference count
>>> (try_module_get) for
>>>> each new cm id, then deference count (module_put) when cm id is
>>> destroyed?
>>>>
>>>
>>> No, I think he's saying the rdma-cm posts a RDMA_CM_DEVICE_REMOVAL event
>>> to each
>>> application with rdmacm objects allocated, and each application is expected
>>> to destroy all
>>> the objects it has allocated before returning from the event handler.
>>
>> This is almost correct.  The applications do not have to destroy all the objects that it
> has
>> allocated before returning from their event handler.  E.g. an app can queue a work item
>> that does the destruction.  The rdmacm will block in its ib_client remove handler until
> all
>> relevant rdma_cm_id's have been destroyed.
>>
> 
> Thanks for the clarification.  

Thanks, checked the cma code, the reference count maintains there.

>>> And I think the ib_verbs core calls each ib_client's remove handler when an
>>> rdma provider
>>> unregisters with the core.
>>
>> yes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
