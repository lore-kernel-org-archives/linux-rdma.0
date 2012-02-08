From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possibly serious bug in ib_mad: processing packets from ibping
 can consume 100% of CPU and may leave user processes locked in umad_recv
Date: Thu, 9 Feb 2012 00:48:57 +0200
Message-ID: <CAJZOPZK+fyQSOF3od3OyR8Hj8=WxF+dgkqXzMfTTr9AT=T5zpA@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD8E9A@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD8E9A-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 9, 2012 at 12:41 AM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:

> This behavior has been demonstrated on 1.5.4 and 1.5.4.1, and on RHEL6.0, 6.1 and 5.7

tried kernel.org? this list deals with kernels from that fabric.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
