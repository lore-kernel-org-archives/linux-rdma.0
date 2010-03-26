From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 10:29:07 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE84CFD8DD@azsmsx501.amr.corp.intel.com>
References: <4BACD985.1070906@opengridcomputing.com>
 <DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com>
 <4BACE28A.2080409@opengridcomputing.com>
 <603F8A3875DCE940BA37B49D0A6EA0AE84CFD851@azsmsx501.amr.corp.intel.com>
 <4BACE7E8.3040803@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BACE7E8.3040803-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Tung, Chien Tin wrote:
>>> In other words, I think we want the ucma context to stay around until
>>> the application destroys it (via explicit means or via exit).   But the
>>> rdma_cm_id gets destroyed immediately upon receiving a DEVICE_REMOVE event.
>>>
>>
>> How do we "take care" of evil applications that won't go away?
>>
>>
>
>Since the low level rdma_cm_id _is_ destroyed, then the RDMA device can
>unload and go away.  The evil app then only is wasting the ucma
>contexts, file descriptors, etc.

Yup, let someone else hold the bag...

>Now, we could also consider something more abrupt like delivering a
>SIGABRT or SIGBUS to all processes that have objects allocated for the
>device that is going away.    But that is kind of drastic, and if done
>unconditionally, will kill applications that want to process the device
>removal and free the objects using that device, but still want to
>continue running on the available devices.   So I wouldn't recommend we
>deliver fatal signals...


I'm against violence as well.  But to Roland's point, how will we ummap resources?
If an application won't respond to device removal event and clean up properly,
perhaps it is "okay" to let it crash.  Alternatively, what about a
RDMA_CM_EVENT_DEVICE_REMOVAL_PENDING and RDMA_CM_EVENT_DEVICE_REMOVED scheme.
Post the first event to allow good applications to clean up.  The second event
to notify apps that the device is "gone".  After the second event, we can then
get violent and shoot to kill?

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
