From: Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] bug 1918 - openmpi broken due to rdma-cm changes
Date: Sun, 07 Feb 2010 23:44:49 +0200
Message-ID: <4B6F3451.2070304@mellanox.co.il>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>	<4B6C498F.3060708@opengridcomputing.com> <F6DF49B759AD49EEB44BECD99FE26DCF@amr.corp.intel.com>
Reply-To: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F6DF49B759AD49EEB44BECD99FE26DCF-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/5/2010 6:52 PM, Sean Hefty wrote:
>
>> BTW:  Was this change an artifact of rebasing ofed-1.5.1 on a new kernel
>> version?
>>      
> apparently
>
>    
Sorry to jump late on this thread
OFED 1.5.1 was not rebased on a new kernel - its still based on 2.6.30.
But many time we take patches that were accepted by the kernel to OFED.
These patches where pushed to OFED by David Wilder from IBM, since 
loopback support of CMA was important for them.
Therefore I add David to the thread too.

Steve/Jeff - how come no one tested iWARP with the new kernel patches 
when Sean submitted them?

Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
