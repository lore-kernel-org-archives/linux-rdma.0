From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 11:59:20 -0500
Message-ID: <4BACE7E8.3040803@opengridcomputing.com>
References: <4BACD985.1070906@opengridcomputing.com> <DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com> <4BACE28A.2080409@opengridcomputing.com> <603F8A3875DCE940BA37B49D0A6EA0AE84CFD851@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <603F8A3875DCE940BA37B49D0A6EA0AE84CFD851-uLM7Qlg6Mbekrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tung, Chien Tin wrote:
>> In other words, I think we want the ucma context to stay around until
>> the application destroys it (via explicit means or via exit).   But the
>> rdma_cm_id gets destroyed immediately upon receiving a DEVICE_REMOVE event.
>>     
>
> How do we "take care" of evil applications that won't go away?
>
>   

Since the low level rdma_cm_id _is_ destroyed, then the RDMA device can 
unload and go away.  The evil app then only is wasting the ucma 
contexts, file descriptors, etc.

Now, we could also consider something more abrupt like delivering a 
SIGABRT or SIGBUS to all processes that have objects allocated for the 
device that is going away.    But that is kind of drastic, and if done 
unconditionally, will kill applications that want to process the device 
removal and free the objects using that device, but still want to 
continue running on the available devices.   So I wouldn't recommend we 
deliver fatal signals...

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
