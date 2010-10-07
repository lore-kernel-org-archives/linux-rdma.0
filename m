From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] dapl: add support for ibacm
Date: Thu, 7 Oct 2010 14:27:50 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011B174FD1@orsmsx506.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB4EA157@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB4EA157-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Applied, thanks!

>Allow DAPL out of band connection models to use ibacm to obtain
>path record data.  This will enable support for a wider range of
>topologies, where the SL is required from the SA to prevent
>deadlock.
>
>DAPL will obtain path record data using rdma_getaddrinfo, provided
>that IB ACM support is enabled.  On failure, dapl will fall back to
>using its default SL value.  The IB ACM can be configured to cache
>path information or always query the SA to ensure that the SL that is
>obtained is current.
>
>Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
