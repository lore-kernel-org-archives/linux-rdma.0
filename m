From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Handling busy responses from the SA
Date: Fri, 4 Jun 2010 14:05:10 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DC96C@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This ensures that na=EFve IB applications cannot overwhelm the SA wit=
h
> queries, which could happen when a cluster is being rebooted, or when=
 a
> large HPC application is started.

I don't object to the concept of treating a busy response as a timeout,=
 but how does this help prevent overwhelming the SA?  It continues to r=
etry the queries, even if the SA says that it's too busy to respond wit=
hout adjusting the timeout specified by the user.  I would think that y=
ou'd at least want to adjust the timeout (double it or use some random =
backoff).

The general guideline that we've been using for adjusting timeouts has =
been to report the failures and let the caller make the a necessary adj=
ustments.  As far as I know, the only way for user space applications t=
o query the SA are through the librdmacm, which sets retries to 0, or t=
hrough the libibumad interface directly.  I would expect any applicatio=
n using the latter to be intelligent enough to handle a busy response.

Maybe we should re-think that guideline and allow users to simply indic=
ate that the MAD layer should use reasonable defaults.  This would enab=
le the ib_mad module to adjust the timeout values for all consumers bas=
ed on actual destination response times.  It could also back off retryi=
ng multiple requests that were initiated around the same time, instead =
only retrying the first request, while simply increasing the timeout va=
lues for the others.  This is more complex, but we should be able to st=
art with something fairly simple.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
