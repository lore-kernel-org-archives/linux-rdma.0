From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IPoIB: fix faulty list maintenance in path and neigh
 list
Date: Wed, 16 Feb 2011 16:51:02 -0800
Message-ID: <4D5C70F6.3050604@linux.vnet.ibm.com>
References: <20110201161247.12671.10028.stgit@kop-dev-sles11-04.qlogic.org> <AANLkTin1pudSXZCGY31p2GnY6noWi2DS3y2+Gprj0+ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin1pudSXZCGY31p2GnY6noWi2DS3y2+Gprj0+ug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/15/2011 10:24 AM, Roland Dreier wrote:
> I'm not sure I understand what this patch is trying to do.
>
>> Added list_del to ipoib_mcast_free() and path_free() to remove the neigh from
>> the path's neigh_list link list before freeing the memory it consumes.
>> This makes the code consistent with ipoib_cm_handle_tx_wc() and other locations where the list_del() preceeds the call to ipoib_neigh_free().
>
> It looks like this is not needed -- in both cases, the code walks a
> list of neigh
> structs and frees them, and then frees the list itself a few lines
> later.  So what
> does it fix to delete the neigh structs from the list?

Consider the following two threads:

.ipoib_mcast_free+0x48/0x308 [ib_ipoib]
.ipoib_mcast_restart_task+0x3d0/0x560 [ib_ipoib]
.worker_thread+0x1b4/0x330
.kthread+0xc4/0xd0
.kernel_thread+0x54/0x70



.ipoib_mcast_free+0x48/0x308 [ib_ipoib]
.ipoib_mcast_dev_flush+0x188/0x1f8 [ib_ipoib]
.ipoib_ib_dev_down+0x94/0x160 [ib_ipoib]
.ipoib_stop+0x78/0x178 [ib_ipoib]
.dev_close+0xdc/0x148

The list_move_tail() in ipoib_mcast_restart_task() is conditional. So it
feasible that mcast->list is not moved to the remove_list, but the 
ipoib_neigh structure is freed. A subsequent call to ipoib_mcast_free() 
from context of dev_close() tries to free the same ipoib_neigh() 
structure which might cause the crash.

>
>> Similarly, at list_del() now preceeds path_free() to remove the path from
>> ipoib_dev_priv's path_list.
>
> Similarly in ipoib_flush_paths() the code is walking a local remove_list that
> is on the stack and will be thrown away when the function returns -- why does
> it matter if we remove the paths from that list before freeing them?
>
>> Additionally, the fields neigh->ah and neigh->list were not being initialized
>> upon allocation.  The patch insures that these two remaining fields are
>> initialized correctly.
>
> Again, I don't see how this fixes anything; neigh->list does not need to be
> initialized, since it is only used to add the neigh struct to other
> lists (AFAICT).
> And also AFAICT, every place that allocates a neigh always initializes neigh->ah
> on every code path.  It might be cleaner to set neigh->ah to NULL but I don't
> see how this could fix something.
>
> Pradeep seems to believe that this patch fixes some crashes but I would like
> to understand the real cause before blindly applying this patch.
> Which part(s) are
> the real fix, and what is the race or other bug it fixes?

I hope I have addressed the questions regarding the need for a 
list_del() in ipoib_mcast_free(). I presume a similar logic applies to
ipoib_flush_paths().

Thanks
Pradeep
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
