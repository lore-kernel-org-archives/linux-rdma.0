From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-4.2 0/1] RDMA/core: Fixes for port mapper client
 registration
Date: Mon, 6 Jul 2015 20:59:42 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB0DAFE093@fmsmsx104.amr.corp.intel.com>
References: <20150702174609.GA11108@TENIKOLO-MOBL2>
 <003301d0b810$10b02070$32106150$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003301d0b810$10b02070$32106150$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Steve,

>> how can I reproduce the original bug/issue and then test this fix on iw_cxgb4?

Have iwpmd running and start an rdma application. 
Leave the rdma application running and restart the iwpmd. 
When you stop the application, if you have the debug enabled, you will see that the remove mapping request from the client driver to the port mapper service isn't going through, (without the fix, it isn't allowed, because the client is treated as unregistered).

Tatyana

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
Sent: Monday, July 06, 2015 12:21 PM
To: Nikolova, Tatyana E; 'Doug Ledford'
Cc: Lacombe, John S; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH for-4.2 0/1] RDMA/core: Fixes for port mapper client registration



> -----Original Message-----
> From: Tatyana Nikolova [mailto:Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, July 02, 2015 12:46 PM
> To: Doug Ledford
> Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; 
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH for-4.2 0/1] RDMA/core: Fixes for port mapper client 
> registration
> 
> This patch has been reworked, but is very similar to the previously 
> submitted (10/16/2014) patch, which was forgotten:
> 
> [PATCH 1/1] RDMA/core: Fixes for port mapper client registration 
> https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg21512.htm
> l
> 
> This patch is addressing the same issue as the previous one - the 
> clients which have provided their mapping info to the user space 
> service after it is restarted, are treated as unregistered and are not 
> allowed to make remove mapping requests.
> 
> If the user space port mapper service is restarted, it notifies the 
> port mapper clients and they provide the mapping information they have 
> in use. At this time with the fix the registration type of the client 
> is set to IWPM_REG_INCOMPL and the client is allowed to make remove 
> mapping requests to the user space service.
> 
> There are some improvements in the current patch:
> 1) Adding functions to set/check registration type
> 2) New clients (calling iwpm_init()) have their registration set to 
> IWPM_REG_UNDEF
> 3) If the port mapper user space service is not available, then the client
>    registration stays IWPM_REG_UNDEF and the registration type won't be
>    checked until the service becomes available (obviously no mappings are
>    possible, if the user space service isn't running).
> 
> For these changes to take effect no provider changes are necessary.
> The patch contains fixes for the current registration logic.
> 

Hey Tatyana, how can I reproduce the original bug/issue and then test this fix on iw_cxgb4? 





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
