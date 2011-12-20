From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ib/core: Protect QP mcast list
Date: Tue, 20 Dec 2011 09:19:44 +0200
Message-ID: <CAL3tnx7u9_Yrqr0QZ=c2tKnJtyFe97XR2QKh0=DQuP77XYn9Kg@mail.gmail.com>
References: <20111219070952.GA11530@mtldesk30>
	<CAL1RGDUpqz+26fKcHj=0NbNqU_8vYV6zOresyYzFZTasGwD_oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUpqz+26fKcHj=0NbNqU_8vYV6zOresyYzFZTasGwD_oA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 19, 2011 at 11:54 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:
>
> Did you consider taking the QP's rwsem for writing across these opera=
tions
> instead? =A0How did that approach compare?
>
I considered this but that means that you serialize attach/detach
operations at ib core. Using a spinlock to protect the list allows
more concurrency. After all, we hit this bug since concurrency of such
operations occur in real life applications.

> Assuming there's some problem with that, would it make sense to put
> the mcast_lock next to the mcast_list in struct ib_uqp_object, instea=
d of
> hiding it in struct ib_qp?
>
Yes, it makes more sense to me.

If it is agreed to use a spinlock and put it next to mcast_list I will
prepare another patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
