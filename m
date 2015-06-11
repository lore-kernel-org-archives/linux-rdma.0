From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't warn on no SA support in event handler
Date: Thu, 11 Jun 2015 09:48:27 +0200
Message-ID: <55793D4B.1010804@profitbricks.com>
References: <1433927612-20517-1-git-send-email-monis@mellanox.com> <55780D8C.1070600@profitbricks.com> <1828884A29C6694DAF28B7E6B8A82373A8FE66CA@ORSMSX109.amr.corp.intel.com> <2807E5FD2F6FDA4886F6618EAC48510E11099957@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E11099957-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 06/10/2015 06:15 PM, Weiny, Ira wrote:
>>>> Registering an event handler is done for a device. This device may
>>>> have one RoCE port (no SA cap) and one InfiniBand port (has SA cap).
>>>> Therefore, warning from the event handler about a specific port that
>>>> doesn't have SA cap is correct but pollutes the kernel log without a
>>>> need.
>>>
>>> Maybe we should think about register event handler per port :-P
>>
>> I agree, though I think that can be added separately from this change.
> 
> Also agreed.  We identified many places where we should split support to be per port while we did this work.  We need to start working up to that.  For the time being we should not break existing users (or in this case annoy them... ;-)

IMHO we can do some reform inside ib_dispatch_event(), where we already have
the port number related to the event, if we could have an event_handler_list
per port and classified the callback inside ib_register_event_handler(), then
we can call the handler on the right port meanwhile won't annoy the user ;-)

Regards,
Michael Wang

> 
> Ira
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
