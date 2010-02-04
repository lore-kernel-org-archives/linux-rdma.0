From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Thu, 04 Feb 2010 17:04:23 -0600
Message-ID: <4B6B5277.80307@opengridcomputing.com>
References: <4B6B47D0.9030507@aoot.com> <DE586AB7003E4FC4B3850004A0B3CAF6@amr.corp.intel.com> <4B6B4C9B.8070804@opengridcomputing.com> <EEF75E01C32544C688989E66FECDC422@amr.corp.intel.com> <4B6B4EFE.3010205@opengridcomputing.com> <DB361897EE7C40C5AB494AAC2D8625AC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB361897EE7C40C5AB494AAC2D8625AC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> Well then the rdma-cm needs to know which devices support hw loopback.
>> Cuz on a T3-only system, no hwloop...
>>     
>
> The problem sounds like it's more than just whether 127.0.0.1 is usable.  That
> check may fix openmpi, but it sounds more like the app needs to know whether the
> device can actually support loopback, regardless of what addresses are used.  Is
> this correct?
>
> What would openmpi do if there were two addresses assigned to the T3 device?
>   

It would use them and might even create two connections.

> Does openmpi simply bypass RDMA for all connections on the local machine?
>
>   

OpenMPI can be run to use hw loopback if its available.  For T3 
clusters, OMPI is run in a mode to use shared memory for intra-node 
communications.


> Basically, I'm not sure that this is *just* an rdma_cm issue.  Although it
> definitely appears that some sort of change needs to be made to the rdma_cm.
>
>   

I think the OpenMPI rdmacm code needs to skip 127.0.0.1, in this 
particular case.  Prior to ofed-1.5.1, however, the bind would fail and 
thus OpenMPI would not advertise 127.0.0.1 to its peer.  I will work to 
get that change done.

But lets also add a device attribute so the rdmacm can know if a device 
supports loopback.   Clearly, if the rdma-cm allows binds to T3, 
loopback connections will fail at connect time.

Hey Roland, are you ok with a device attribute to indicate hw-loopback 
support?


Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
