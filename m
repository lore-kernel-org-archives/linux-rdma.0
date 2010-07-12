From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: IB/ipoib: fix dangling pointer reference to ipoib_neigh and
	ipoib_path -when will it go upstream?
Date: Mon, 12 Jul 2010 12:07:20 +0200
Message-ID: <AANLkTilkXY0vDA4dtq9cMIO2shX-kw0ZlwadVjm4QMui@mail.gmail.com>
References: <4C3AA0A2.3090406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3AA0A2.3090406-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 12, 2010 at 6:57 AM, Pradeep Satyanarayana
<pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> I realize that the following patch:
>
> https://patchwork.kernel.org/patch/97243/
>
> is queued in your backlog of patches and unlikely that it will go into 2.6.35.
> What are the chances that it will make it into 2.6.36? This patch has fixed a
> a rarely seen crash and we would like it to go upstream ASAP.

The following comment was made on that patch by Ralph Campbell (see
also http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg03125.html):

"Quite right. I should also use list_for_each_entry_safe(). I will fix this."

This makes me wonder whether version three of this patch can go in unmodified ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
