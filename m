From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 05 Feb 2010 10:45:08 -0600
Message-ID: <4B6C4B14.9000202@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com> <4B6C4460.3050908@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6C4460.3050908-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I agree that we should probably not allow 127.0.0.1 binds in 
> ofed-1.5.1 at all because it regresses OpenMPI.  Even with IB systems, 
> if the bind to 127.0.0.1 succeeds, then OpenMPI assumes 127.0.0.1 is 
> bound to that rdma interface and advertises this address to its peer 
> as an address to-which that peer can rdma connect!  This will break IB 
> clusters too, not just T3/iWARP cluster.   While I think OpenMPI needs 
> to skip 127.0.0.1 in its logic, I think we should probably defer 
> allowing 127.0.0.1 binds until ofed-1.6.
>
> But Jeff, note that if someone uses the upstream kernel and OpenMPI, 
> its busted...
>
> So I recommend:
>
> 1) Don't allow 127.0.0.1 binds in ofed-1.5.1
>
> 2) Fix OpenMPI ASAP to never advertise 127.0.0.1 as a valid rdma-cm 
> connect address (get it in ofed-1.5.2 or ofed-1.6).

Also, there is a good argument for never allowing 127.0.0.1 for rdma 
anyway.  It implies a _software_ loopback.  It should NEVER be bound to 
a real NIC interface and thus rdma binds shouldn't be allowed to it 
since there is no software rdma loopback support...

Unless someone implements software rdma loobpack...  ;)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
