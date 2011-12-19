From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] ib/core: Protect QP mcast list
Date: Mon, 19 Dec 2011 13:54:36 -0800
Message-ID: <CAL1RGDUpqz+26fKcHj=0NbNqU_8vYV6zOresyYzFZTasGwD_oA@mail.gmail.com>
References: <20111219070952.GA11530@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111219070952.GA11530@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 18, 2011 at 11:09 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Multicast attach/detach operations on a QP are carried under the
> readers'/writers' lock of the QP. Such protection is not sufficient since a
> reader's lock allows more than one reader to acquire the lock. However, list
> manipulation implies write operations on the list variable. Use a spinlock to
> provide protection.

Did you consider taking the QP's rwsem for writing across these operations
instead?  How did that approach compare?

Assuming there's some problem with that, would it make sense to put
the mcast_lock next to the mcast_list in struct ib_uqp_object, instead of
hiding it in struct ib_qp?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
