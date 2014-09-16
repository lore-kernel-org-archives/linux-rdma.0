From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] Add creation flags for user space QPs
Date: Tue, 16 Sep 2014 15:55:16 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1409161554590.10647@gentwo.org>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com> <alpine.DEB.2.11.1409160903430.26070@gentwo.org> <CAJ3xEMgnym=kLbzx2oa+o+ZwKvf+dOQ4JawyO4_-T8YFHtiRyw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgnym=kLbzx2oa+o+ZwKvf+dOQ4JawyO4_-T8YFHtiRyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 16 Sep 2014, Or Gerlitz wrote:

> To test it now, you need to patch your libibverbs to set the flag
> (say) when a UD QP is created, run your app which subscribes to a
> multicast group they also send over packets, and see that there are no
> loopbacks, wan't me to provide such libibverbs patch for you to test
> with?

Yes, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
