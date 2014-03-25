From: Egor Medvedev <methodx-w/L3Ro8pDhisTnJN9+BGXg@public.gmane.org>
Subject: Re: ib_srpt error
Date: Tue, 25 Mar 2014 12:22:56 +0400
Message-ID: <CAK4NFoHiSyFkS1DSgyQh=cdpbs+PHz_XTB0eUOzNVXaAasPd0A@mail.gmail.com>
References: <CAK4NFoEhJPx6YBpa7OMV_jo2YmAcV1LcquQiC4-2+LPCSz4cQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK4NFoEhJPx6YBpa7OMV_jo2YmAcV1LcquQiC4-2+LPCSz4cQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Also, I forgot to mention, that restarting multipath on compute node
solves this problem, and makes connection possible.
But I want to figure out why connection breaks on my target node.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
