From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IPoIB: fix faulty list maintenance in path and neigh
 list
Date: Thu, 17 Feb 2011 11:52:53 -0800
Message-ID: <4D5D7C95.5010408@linux.vnet.ibm.com>
References: <20110201161247.12671.10028.stgit@kop-dev-sles11-04.qlogic.org> <AANLkTin1pudSXZCGY31p2GnY6noWi2DS3y2+Gprj0+ug@mail.gmail.com> <4D5C70F6.3050604@linux.vnet.ibm.com> <AANLkTim-BnQ9tM68eGsCoOVYDRonmEOO6JN+EFT2zdff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim-BnQ9tM68eGsCoOVYDRonmEOO6JN+EFT2zdff-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/16/2011 05:15 PM, Roland Dreier wrote:
> On Wed, Feb 16, 2011 at 4:51 PM, Pradeep Satyanarayana
> <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>  wrote:
>> The list_move_tail() in ipoib_mcast_restart_task() is conditional. So it
>> feasible that mcast->list is not moved to the remove_list, but the
>> ipoib_neigh structure is freed. A subsequent call to ipoib_mcast_free() from
>> context of dev_close() tries to free the same ipoib_neigh() structure which
>> might cause the crash.
>
> I'm missing something.  ipoib_neigh_free() is only called in
> ipoib_mcast_free().  ipoib_mcast_free() is only called on entries in
> remove_list.  So if an mcast structure is not moved to the
> remove_list, I don't see how an ipoib_neigh struct on its list could
> be freed.

Yes, that is the crux of the issue. I had missed that ipoib_mcast_free() 
is only called on remove_list.

>
> We do all manipulation of the mcast list in ipoib_mcast_restart_task()
> and ipoib_mcast_dev_flush() with priv->lock held, so I don't see how
> we could free the same mcast struct twice, or free an ipoib_neigh
> struct without freeing its corresponding mcast struct.
>
> Indeed it's not clear to me why we need to take the lock in
> ipoib_mcast_free() or what it could be protecting against -- that
> seems like it must be wrong and unnecessary (and the locking predates
> git history).
>
> Sorry if I'm being slow but if this patch is fixing some test, it
> really seems that it must be doing that by making a race window
> smaller or something like that, rather than actually being the right
> fix for the underlying problem.

While we are discussing IPoIB issues, how about the two other issues 
that I illustrated previously. One was Ralph Campbell's patch for fixes 
to ipoib_cm_start_rx_drain() and my questions wrt ipoib_neigh_cleanup()?

Thanks
Pradeep
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
