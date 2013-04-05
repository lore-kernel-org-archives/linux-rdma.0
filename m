From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC/PATCH v2] IPoIB: Leave space in skb linear buffer for IP headers
Date: Fri, 5 Apr 2013 13:44:40 -0700
Message-ID: <CAL1RGDWrNpExCzMSORfF74pp4EN_gi==O9nEspU-gwx_z6dNCg@mail.gmail.com>
References: <1365109940-22916-1-git-send-email-roland@kernel.org> <CD84E1B9.5721%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD84E1B9.5721%markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 5, 2013 at 11:42 AM, Markus Stockhausen
<markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> wrote:
> this patch is better than the first one. No more lockups of the server.
> Nevertheless I'm sorry to tell you that we are not finished yet. After
> running some promising netperf/netserver tests I switched over to NFS.
> The machine behaves like working with an active handbrake. Throughput
> varies and sometimes communication is totally stopped. dmesg shows some
> very ugly output.

Thanks.  I guess I'll have to set up a testbed and debug this myself.
I'll try to work on that this weekend.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
