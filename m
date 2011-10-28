From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: ip address print changes
Date: Fri, 28 Oct 2011 10:49:44 -0700
Message-ID: <CAL1RGDWnY5184vOfTUdaNWpfbsMmg6v6dk=fXFNHv5bEX4i+8g@mail.gmail.com>
References: <20111027161058.GA1092@FLATIF-MOBL4>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111027161058.GA1092@FLATIF-MOBL4>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 27, 2011 at 9:10 AM, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Fix printing of ip addresses to use %pI4.

Thanks, looks fine, I'll apply this.

But looking at this patch makes me wonder why nes ever stores IPv4
addresses in host order?  Couldn't a ton of swapping be eliminated
by just making eg cm_node->rem_addr etc. be in network order?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
