From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Is multicast only available with UD Transport mode?
Date: Sat, 13 Nov 2010 09:35:05 +0100
Message-ID: <AANLkTi=Pdk5nZXq+Yed=fbxXLwkSJGere=26-3YNmd_Y@mail.gmail.com>
References: <20101112101223.44mbsbnygwcw0008@peddycoart.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101112101223.44mbsbnygwcw0008-6c4oY0qWgKW61VtY7fu8aA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 12, 2010 at 6:12 PM, <ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org> wrote:
> Is multicast only available with UD Transport mode?

In the past several reliable multicast protocols have been developed
on top of unreliable multicast for IPv4. See e.g.

S. Pingali, D. Towsley and J. Kurose, A comparison of sender-initiated
and receiver-initiated reliable multicast protocols, SIGMETRICS '94
Proceedings, 1994.

Note: I'm not sure how much work it would take to convert one of the
existing reliable multicast protocols to IB.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
