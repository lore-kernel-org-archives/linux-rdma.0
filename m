From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: CMA handler status code
Date: Tue, 27 Jul 2010 09:40:30 +0300
Message-ID: <4C4E7F5E.6070306@Voltaire.com>
References: <AANLkTik2eOWELUAwjL+tfjMb28L3OjWB57iMyvDpOWDm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik2eOWELUAwjL+tfjMb28L3OjWB57iMyvDpOWDm-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eldad Zinger <eldadz-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eldad Zinger wrote:
> event.status = ib_event->param.sidr_rep_rcvd.status
> event.status = ib_event->param.rej_rcvd.reason
> event.status should be 0 for success, or negative value of generic error code.
> In that code, the error code is positive and do not comply with generic error code.

Basically, I believe that the status equals reject reason for rdma-cm reject event
is known to the kernel developers that deal with the rdma-cm. Personally, I'm fine
with it, we could document that, but currently there's no rdma-cm document under 
Documentation/infiniband which could have this.

For user space, I would add a comment in the man pages

> In order to make the status field available for other modules (like
> SDP), that field should be format-consistent.

With SDP being out of tree for about four-six years (and counting), somehow
hard to take into account claims related to it.

Ot.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
