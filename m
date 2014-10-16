From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] RDMA/core: Fixes for port mapper client registration
Date: Thu, 16 Oct 2014 22:19:00 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB0D97D2CF@fmsmsx104.amr.corp.intel.com>
References: <20141016161954.GA23268@TENIKOLO-MOBL2>
 <005101cfe979$edec8890$c9c599b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005101cfe979$edec8890$c9c599b0$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Steve,

>>Doesn't this feature require provider support?  It seems like this patch really doesn't do anything yet.
It is a fix for the client registration logic. When the user space port mapper is restarted, the IWPM_PREV_REG_CLIENTs send their mapping information to the port mapper, afterwards they are allowed to send remove mapping requests and they should be. 

If you look at the remove mapping request logic, you see that only registered clients are allowed to make a remove mapping request. 
In other words, without this fix there are just registered and non-registered clients. IWPM_PREV_REG_CLIENTs are handled like non-registered clients, so their remove mapping requests aren't allowed to go the port mapper, when the rdma application closes the connections in use.

No provider support is necessary.

Thanks,
Tatyana

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
Sent: Thursday, October 16, 2014 2:47 PM
To: Nikolova, Tatyana E; 'Roland Dreier'
Cc: Lacombe, John S; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH 1/1] RDMA/core: Fixes for port mapper client registration



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Tatyana 
> Nikolova
> Sent: Thursday, October 16, 2014 11:20 AM
> To: Roland Dreier
> Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; 
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH 1/1] RDMA/core: Fixes for port mapper client 
> registration
> 
> IWPM_REG_CLIENT and IWPM_PREV_REG_CLIENT are added:
> 
> IWPM_REG_CLIENT is a client, registered with the user space port 
> mapper daemon, available at the time of the client register pid 
> request.
> IWPM_PREV_REG_CLIENT is a client, which has been IWPM_REG_CLIENT 
> before the user space port mapper daemon is stopped.
> After restarting the port mapper, IWPM_PREV_REG_CLIENTs provide their 
> mapping info to the port mapper daemon and they are allowed to send 
> remove mapping requests aftewards.
> 


Hey Tatyana,

Nit:  "aftewards" is misspelled.

Doesn't this feature require provider support?  It seems like this patch really doesn't do anything yet.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
