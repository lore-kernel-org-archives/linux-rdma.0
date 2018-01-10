From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] Verbs requirement for GRH when working in GID based addressing
Date: Wed, 10 Jan 2018 23:59:18 +0200
Message-ID: <CAJ3xEMgtcv0dgyY59i4+t9tOt8QOfGD9onPcc=QdZBe2ZmKA9w@mail.gmail.com>
References: <CAFgAxU_p4OR7qUe+HjK_rYP+LxUUOxYs+Qp6g4_e64WvOXMWDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFgAxU_p4OR7qUe+HjK_rYP+LxUUOxYs+Qp6g4_e64WvOXMWDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 9:28 PM, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> RDMA applications require an indication they are operating in an
> environment which is based on GID addressing, such as SR-IOV IB
> Virtualization. In this mode, all sent traffic must include a GRH.

Hi Alex,

Isn't this the case for RoCE since it's day one? how does it work there? maybe
a hop limit > 1 is used and the kernel rdma stack tweaks it over RoCE ports?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
