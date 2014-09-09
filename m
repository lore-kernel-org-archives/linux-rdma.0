From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/8] IPoIB: Use dedicated workqueues per interface
Date: Tue, 09 Sep 2014 03:09:38 -0400
Message-ID: <540EA7B2.2050805@redhat.com>
References: <cover.1407885724.git.dledford@redhat.com> <f7af9c251d722675a549e4a673f46c0f31dfa266.1407885724.git.dledford@redhat.com> <54080B6B.8050707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54080B6B.8050707-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/04/2014 02:49 AM, Erez Shitrit wrote:
> Hi Doug,
>
> The idea that "big" ipoib workqueue is only for the IB_EVENT_XXX looks
> good to me.
>
> one comment here: I don't see where the driver flushes it at all.
> IMHO, when the driver goes down you should cancel all pending tasks over
> that global wq prior the call for the destroy_workqueue.

I understand your thought, but I disagree with your conclusion.  If we 
ever get to the portion of the driver down sequence where we are 
removing the big flush work queue and there are still items on that work 
queue, then we have already failed and we are going to crash because 
there are outstanding flushes for a deleted device.  The real issue here 
is that we need to make sure it's not possible to delete a device that 
has outstanding flushes, and not possible to flush a device in the 
process of being deleted (Wendy, don't get mad at me, but the rtnl lock 
jumps out as appropriate for this purpose).

> The current logic calls the destroy_workqueue after the remove_one, i
> think you should cancel the pending works after the
> ib_unregister_event_handler call in the ipoib_remove_one function,

The ib_remove_one is device specific while the big flush work queue is 
not.  As such, that can cancel work for devices other than the device 
being removed with no clear means of getting it back.

> otherwise if there are pending tasks in that queue they will schedule
> after the dev/priv are gone.

I agree that there is a problem here.  I think what needs to happen is 
that now that we have a work queue per device, and all flushes come in 
to us via a work queue that does not belong to the device, it is now 
possible to handle flushes synchronously.  This would allow us to lock 
around the flush itself and prevent removal until after the flush is 
complete without getting into the hairy rat hole that is trying to flush 
the flush workqueue that might result in either flushing or canceling 
the very device we are working on.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
