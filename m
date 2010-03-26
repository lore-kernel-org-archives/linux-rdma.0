From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 13:05:28 -0500
Message-ID: <4BACF768.7040009@opengridcomputing.com>
References: <4BACD985.1070906@opengridcomputing.com> <DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com> <4BACE28A.2080409@opengridcomputing.com> <603F8A3875DCE940BA37B49D0A6EA0AE84CFD851@azsmsx501.amr.corp.intel.com> <4BACE7E8.3040803@opengridcomputing.com> <603F8A3875DCE940BA37B49D0A6EA0AE84CFD8DD@azsmsx501.amr.corp.intel.com> <4BACF5B8.7090304@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BACF5B8.7090304-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve Wise wrote:
>
>> But to Roland's point, how will we ummap resources?
>> If an application won't respond to device removal event and clean up 
>> properly,
>> perhaps it is "okay" to let it crash.  Alternatively, what about a
>> RDMA_CM_EVENT_DEVICE_REMOVAL_PENDING and RDMA_CM_EVENT_DEVICE_REMOVED 
>> scheme.
>> Post the first event to allow good applications to clean up.  The 
>> second event
>> to notify apps that the device is "gone".  After the second event, we 
>> can then
>> get violent and shoot to kill?
>>   
>
> You probably don't need the two events as you can detect when the apps 
> free up these resources anyway.   So your proposal boils down to:  
> post the DEVICE_REMOVAL/ DEVICE_FATAL events, and wait some amount of 
> time.  After said timeout, you fire a SIGBUS at each process still 
> owning resources for the device in question.
>
> Roland, is that terrible in your opinion?
>
>

Actually, we don't need to deliver the signal at all.   Just continue 
with the device removal after the timeout. The mapped resources would 
get unmapped, I guess, and then accessing them would cause a fault in 
the process. 

So we try and wait for well behaved apps, but we don't hang the device 
removal forever...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
