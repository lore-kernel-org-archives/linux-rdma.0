From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB/ipoib: fix dangling pointer reference to ipoib_neigh and
 ipoib_path -when will it go upstream?
Date: Tue, 13 Jul 2010 12:23:54 -0700
Message-ID: <1279049034.2296.219.camel@chromite.mv.qlogic.com>
References: <4C3AA0A2.3090406@linux.vnet.ibm.com>
	 <AANLkTilkXY0vDA4dtq9cMIO2shX-kw0ZlwadVjm4QMui@mail.gmail.com>
	 <4C3AEC65.1090304@linux.vnet.ibm.com>
	 <AANLkTil7Vbpg4n_TsR71F1mK5Sq6kzI0blgVjJ7_lebB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTil7Vbpg4n_TsR71F1mK5Sq6kzI0blgVjJ7_lebB-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-07-12 at 03:35 -0700, Bart Van Assche wrote:
> On Mon, Jul 12, 2010 at 12:20 PM, Pradeep Satyanarayana
> <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > Bart Van Assche wrote:
> >> On Mon, Jul 12, 2010 at 6:57 AM, Pradeep Satyanarayana
> >> <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> >>> I realize that the following patch:
> >>>
> >>> https://patchwork.kernel.org/patch/97243/
> >>>
> >>> is queued in your backlog of patches and unlikely that it will go into 2.6.35.
> >>> What are the chances that it will make it into 2.6.36? This patch has fixed a
> >>> a rarely seen crash and we would like it to go upstream ASAP.
> >>
> >> The following comment was made on that patch by Ralph Campbell (see
> >> also http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg03125.html):
> >>
> >> "Quite right. I should also use list_for_each_entry_safe(). I will fix this."
> >>
> >> This makes me wonder whether version three of this patch can go in unmodified ?
> >
> > There was a version 4 that followed. That was what I was referring to.
> 
> Thanks for the info -- I had missed version four of that patch. Now
> that I had a look at it, why does the comment above
> ipoib_cm_flush_path() say that it removes all entries while the loop
> inside that function is stopped after the first entry has been found
> and removed ? Why does that function use list_for_each_entry_safe()
> while only a single entry is removed ?
> 
> Bart.

There is only one matching entry on the list at any given time
so I guess list_for_each_entry_safe() isn't required.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
