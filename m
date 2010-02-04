From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Thu, 04 Feb 2010 16:49:34 -0600
Message-ID: <4B6B4EFE.3010205@opengridcomputing.com>
References: <4B6B47D0.9030507@aoot.com> <DE586AB7003E4FC4B3850004A0B3CAF6@amr.corp.intel.com> <4B6B4C9B.8070804@opengridcomputing.com> <EEF75E01C32544C688989E66FECDC422@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EEF75E01C32544C688989E66FECDC422-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> But how can you determine _which_ rdma device should be used if and app
>> binds to 127.0.0.1?  I think this is busted...
>>     
>
> The code just picks the first rdma device available.  To me, this is preferable
> than simply disallowing the loopback device from working at all.  I personally
> use it all the time, so I don't have to figure out what the ip address is of the
> system that I'm trying to test on.
>   

Well then the rdma-cm needs to know which devices support hw loopback.  
Cuz on a T3-only system, no hwloop...

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
