From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] Add creation flags for user space QPs
Date: Tue, 16 Sep 2014 09:04:07 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1409160903430.26070@gentwo.org>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410700802-27848-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 14 Sep 2014, Or Gerlitz wrote:

> This small series addresses a long time (2008..) pain point, namely
> the inability to specify creation flags for user-space QPs. We use
> the existing uverbs command and a reserved field there to specify the flags.


Ok that is the kernel portion. How do I test this? I would need updates to
libibverbs right?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
