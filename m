From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 06/15] IB/srpt: Simplify srpt_handle_tsk_mgmt()
Date: Tue, 26 Jan 2016 09:32:19 -0800
Message-ID: <56A7ADA3.5080507@sandisk.com>
References: <568BD0FC.70207@sandisk.com> <568BD1D2.1030609@sandisk.com>
 <F3529576D8E232409F431C309E29399328F6B06A@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F3529576D8E232409F431C309E29399328F6B06A-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/26/16 08:57, Estrin, Alex wrote:
> Is it possible to expedite this patch as it actually fixes a real bug in ib_srpt?
>
> If srp target receives ABORT TASK, it will crash the kernel while trying to respond.
> We were able to reproduce it under quite heavy load [ ... ]

Hello Alex,

Thank you for the feedback. Since the kernel 4.5 merge has been closed I 
will retest and resend the whole patch series. I would like to see all 
of these patches to be integrated in the upstream kernel instead of only 
this single patch. I will Cc stable and I will also add your Tested-by tag.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
