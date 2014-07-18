From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Fri, 18 Jul 2014 08:47:37 -0700
Message-ID: <53C94199.4050601@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com>  <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com> <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A@oracle.com> <008c01cfa201$f1eecda0$d5cc68e0$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE1482F@CMEXMB1.ad.emulex.com> <002401cfa28c$11feb4e0$35fc1ea0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <002401cfa28c$11feb4e0$35fc1ea0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Devesh Sharma' <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 07/18/2014 06:27 AM, Steve Wise wrote:
>>>> We can't really deal with a CM_DEVICE_REMOVE event while there are
>>>> active NFS mounts.
>>>>
>>>> System shutdown ordering should guarantee (one would hope) that NFS
>>>> mount points are unmounted before the RDMA/IB core infrastructure is
>>>> torn down. Ordering shouldn't matter as long all NFS activity has
>>>> ceased before the CM tries to remove the device.
>>>>
>>>> So if something is hanging up the CM, there's something xprtrdma is
>>>> not cleaning up properly.
>>>>
>>>
>>>
>>> Devesh, how are you reproducing this?  Are you just rmmod'ing the ocrdma
>>> module while there are active mounts?
>>
>> Yes, I am issuing rmmod while there is an active mount. In my case rmmod ocrdma remains
>> blocked forever.
Where is it blocked?

>> Off-the-course of this discussion: Is there a reasoning behind not using
>> ib_register_client()/ib_unregister_client() framework?
> 
> I think the idea is that you don't need to use it if you are transport-independent and use
> the rdmacm...
> 
> 
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
