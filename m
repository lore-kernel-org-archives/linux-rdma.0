From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] Add creation flags for user space QPs
Date: Tue, 16 Sep 2014 23:07:52 +0300
Message-ID: <CAJ3xEMgnym=kLbzx2oa+o+ZwKvf+dOQ4JawyO4_-T8YFHtiRyw@mail.gmail.com>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>
	<alpine.DEB.2.11.1409160903430.26070@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1409160903430.26070-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 16, 2014 at 5:04 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:

> Ok that is the kernel portion. How do I test this? I would need updates to
> libibverbs right?

yep, it's very common that such development goes bottom up, with the
kernel part (which is the top pain  point here) posted 1st. Once this
is accepted we'll be working on the user space part.

To test it now, you need to patch your libibverbs to set the flag
(say) when a UD QP is created, run your app which subscribes to a
multicast group they also send over packets, and see that there are no
loopbacks, wan't me to provide such libibverbs patch for you to test
with?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
