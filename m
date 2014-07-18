From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Fri, 18 Jul 2014 11:27:17 -0400
Message-ID: <D9783B2E-8D18-442E-9BFE-0863F9DD6B96@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com> <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE1686F@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD3FE1686F-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 18, 2014, at 2:19 AM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> wrote:

>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
>> Sent: Friday, July 18, 2014 1:39 AM
>> To: 'Hefty, Sean'; 'Shirley Ma'; Devesh Sharma; 'Roland Dreier'
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider
>> module
>> 
>> 
>> 
>>> -----Original Message-----
>>> From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
>>> Sent: Thursday, July 17, 2014 2:56 PM
>>> To: 'Hefty, Sean'; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier'
>>> Cc: 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'; 'chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org'
>>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider
>>> module
>>> 
>>> 
>>> 
>>>> -----Original Message-----
>>>> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>>>> Sent: Thursday, July 17, 2014 2:50 PM
>>>> To: Steve Wise; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier'
>>>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
>>>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma
>>>> provider module
>>>> 
>>>>>> So the rdma cm is expected to increase the driver reference
>>>>>> count
>>>>> (try_module_get) for
>>>>>> each new cm id, then deference count (module_put) when cm id is
>>>>> destroyed?
>>>>>> 
>>>>> 
>>>>> No, I think he's saying the rdma-cm posts a
>> RDMA_CM_DEVICE_REMOVAL
>>>>> event to each application with rdmacm objects allocated, and each
>>>>> application is expected to destroy all the objects it has
>>>>> allocated before returning from the event handler.
>>>> 
>>>> This is almost correct.  The applications do not have to destroy all
>>>> the objects that
>> it has
>>>> allocated before returning from their event handler.  E.g. an app
>>>> can queue a work
>> item
>>>> that does the destruction.  The rdmacm will block in its ib_client
>>>> remove handler
>> until all
>>>> relevant rdma_cm_id's have been destroyed.
>>>> 
>>> 
>>> Thanks for the clarification.
>>> 
>> 
>> And looking at xprtrdma, it does handle the DEVICE_REMOVAL event in
>> rpcrdma_conn_upcall().
>> It sets ep->rep_connected to -ENODEV, wakes everybody up, and calls
>> rpcrdma_conn_func() for that endpoint, which schedules
>> rep_connect_worker...  and I gave up following the code path at this point...
>> :)
>> 
>> For this to all work correctly, it would need to destroy all the QPs, MRs, CQs,
>> etc for that device _before_ destroying the rdma cm ids.  Otherwise the
>> provider module could be unloaded too soon...
> 
> Okay, Should I try to handle device removal in this proposed fashion and post the v1.

Hi Devesh,

To make it work, xprtrdma is going to have to allow the device to be
removed and added back while there are active NFS mounts and pending RPCs.
AFAICT the code is not structured to do that today.

Probably the place to start is to see how much work is needed to leverage
the existing logic to watch for ENODEV and do the right things to suspend
RPC activity until another device is inserted. It would have to work like
a network partition that causes a transport reconnect.

However, replacing everything, including all MRs and the PD, will require
significant code churn and additional (undesirable) serialization around
the use of QPs and cm_ids. Thus I would like to understand how much of a
priority this is.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
