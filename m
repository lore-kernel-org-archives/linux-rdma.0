From: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Subject: Rare Duplicate Completions
Date: Fri, 4 Apr 2014 13:00:42 -0400
Message-ID: <CAPb9-SF6OS3xabKMJdT2Fe32=O1nOhS5y3Ng3ySQG3KOHvcV=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I am working on building a distributed Infiniband application, testing
using Mellanox Connect-X HCAs. In very rare cases, perhaps once in a
few million operations, I appear to be receiving duplicate completions
or incorrect completions. For instance, I'll send out an RDMA request
and receive a completion for a Verb message response I had just
handled, or send a Verb message request and receive a duplicate Verb
message completion.. Needless to say, this is introducing instability
in my application. Does anyone have experience with a bug like this,
or am I encountering some arcane issue in how I'm manipulating the
HCA? I'd be more than happy to furnish relevant sections of code to
help nail down the issue.

Thanks in advance,
Christopher
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
