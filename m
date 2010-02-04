From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Thu, 04 Feb 2010 16:39:23 -0600
Message-ID: <4B6B4C9B.8070804@opengridcomputing.com>
References: <4B6B47D0.9030507@aoot.com> <DE586AB7003E4FC4B3850004A0B3CAF6@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DE586AB7003E4FC4B3850004A0B3CAF6-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> OpenMPI uses rdma_bind_addr() to figure out which ip addresses are valid
>> for which IB devices.   This logic is now broken.  Regardless of whether
>> OpenMPI should use another method for determining which IP address
>> belong to which interfaces, we should probably rethink whether we're
>> breaking rdma-cm semantics in a bad way on a point release.
>>     
>
> The changes to the rdma_cm have been merged upstream.  These were fixes
> specifically to enable using the loopback address with RDMA devices.
>
> At first thought, we can extend enum ib_device_cap_flags to indicate if a device
> supports loopback capabilities or not.  The rdma_cm could then skip over such
> devices when dealing with a loopback address. 
>
> - Sean
>   

But how can you determine _which_ rdma device should be used if and app 
binds to 127.0.0.1?  I think this is busted...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
