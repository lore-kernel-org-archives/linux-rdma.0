From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 4/4] ibacm: support no delay options
Date: Wed, 8 Dec 2010 14:05:58 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011EA0FA37@orsmsx506.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1ECAE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1ECAE-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Allow a user to specify that address and/or route resolution
>protocols should be suppressed, and that only locally cached
>data should be returned.
>
>This helps support rdma_getaddrinfo options RAI_NUMERICHOST
>and RAI_NOROUTE.  If data for a request is available, it is
>immediately returned.  Otherwise, the client request is
>failed, but the lookup is still initiated.  This avoids
>blocking a client for an extended period of time while
>resolution completes, but allows future calls to find cached
>data.

Do you have a librdmacm patch coming soon with the new ai_flags?







--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
