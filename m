From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V4 for-next 05/10] IB/core: Introduce Receive Work Queue indirection table
Date: Tue, 24 May 2016 09:02:37 -0500
Message-ID: <004c01d1b5c4$ed768500$c8638f00$@opengridcomputing.com>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com> <1464006056-19653-6-git-send-email-yishaih@mellanox.com> <01ba01d1b515$a18a6f80$e49f4e80$@opengridcomputing.com> <46a7de86-dffe-e44c-3768-10dfb70e8802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <46a7de86-dffe-e44c-3768-10dfb70e8802-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Hey Yishai,
> >
> > Why do you need usecnt on the individual tables allocated by the device?  I
see
> > them inc'd here and dec'd in destroy.  But I don't see them used anywhere
else?
> >
> > Steve.
> 
> Look at ib_destroy_wq for this reference count usage.
> 
> WQ and indirection table are IB objects that are managed by the IB layer
> for both update/cleanup. Specifically, a WQ can't be cleaned up if there
> is an indirection table that points to. From application point of view
> when it has an handle to an indirection table it assumes that all its
> underlying WQ(s) are valid so the IB layer should prevent any
> destruction of any WQ before releasing the indirection table, this is
> done by the ref count mechanism as done for other related IB objects.
> You can look also at ib_uverbs_cleanup_ucontext where upon process
> termination the order of cleanup is first destroying the indirection
> table(s) then going over all WQ(s) and destroy them.

I see.  Thanks for the clarification.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
