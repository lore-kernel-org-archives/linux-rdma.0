From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwcm: Get rid of enum iw_cm_event_status
Date: Wed, 11 May 2011 09:06:14 +0300
Message-ID: <4DCA2756.3060900@mellanox.com>
References: <1305005199-4943-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305005199-4943-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> This also gets rid of the warning
>     drivers/infiniband/core/cma.c: In function 'cma_iw_handler':
>     drivers/infiniband/core/cma.c:1333:3: warning: case value '4294967185' not in enumerated type 'enum iw_cm_event_status'
>     drivers/infiniband/core/cma.c:1336:3: warning: case value '4294967186' not in enumerated type 'enum iw_cm_event_status'
>     drivers/infiniband/core/cma.c:1332:3: warning: case value '4294967192' not in enumerated type 'enum iw_cm_event_status'

Roland, so how did you manage to see that warning, is it your plane gcc 
(what version?) or through using some static checker? for example, I 
don't see it with the latest sparse.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
