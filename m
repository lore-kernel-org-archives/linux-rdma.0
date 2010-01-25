From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problems using krping
Date: Sun, 24 Jan 2010 21:28:09 -0600
Message-ID: <4B5D0FC9.6060403@opengridcomputing.com>
References: <201001211807011710722@inspur.com>, <201001221533186875550@inspur.com>, <201001242242553436345@inspur.com> <201001251036131874884@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201001251036131874884-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>  
> >> Why data transferring happened before server waked up from waiting for 
> >> CONNECTED?
> >This can happen.  There is a race between getting the CONNECTED event 
> >and the first incoming data completion (like a recv completion).
> Could give me some tips to fix this? Since this sometimes will upset 
> normal state machine, which a stable program does not allow it appears.
> --

What normal state machine?  Its the nature of the beast.  Make your 
state machine handle it. :)



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
