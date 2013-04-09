From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC/PATCH v3] IPoIB: Leave space in skb linear buffer for IP headers
Date: Tue, 9 Apr 2013 09:39:59 -0700
Message-ID: <CAG4TOxOLCPi3+bSSNuoB=Ubk7T-H=xuoieXTGpu=FWYudNLsDA@mail.gmail.com>
References: <1365457381-10184-1-git-send-email-roland@kernel.org> <4AF12E8016D2BF46BCDFCE8FAA77A358042F382C@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF12E8016D2BF46BCDFCE8FAA77A358042F382C-AtyAts71sc9Qxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 9, 2013 at 6:13 AM, Luick, Dean <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Can you go through the "else" of the first if (page is NULL), then enter the second if? If so, isn't the page lost?

Thanks, good catch.  I'll fix that up.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
