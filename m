From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/18] Enhance ib_ah_attr to specify types
Date: Wed, 12 Apr 2017 01:10:29 +0300
Message-ID: <CAJ3xEMibwEmP112g4n9O5a4KfDMtW5wa9=4sZJQm65huMgW9FQ@mail.gmail.com>
References: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 11, 2017 at 8:42 PM, Dasaratharaman Chandramouli
<dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> This patch addresses that drawback by defining three address handle
> types namely 'ib', 'eth' and 'opa'. While these these types share most
> of the original fields, the changes provide the infrastucture to
> extend and cleanup the fields based on their types.

So UR doing a massive renaming but the current series doesn't make any
real use in that, right? I think it would be much better to see the
actual new functionality before applying this renaming exercise

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
