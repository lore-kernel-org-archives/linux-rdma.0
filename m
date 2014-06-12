From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nfs-rdma performance
Date: Thu, 12 Jun 2014 13:14:37 -0700
Message-ID: <CABgxfbFvrCUzkyEyuSsVMaWK=y2A0GLKYuK-b49TxfpTox_aWg@mail.gmail.com>
References: <CADvaNzXHOafuzav9RwB2SHXma7EUCxMQX6sNEL6r5-a_e37pLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADvaNzXHOafuzav9RwB2SHXma7EUCxMQX6sNEL6r5-a_e37pLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 12, 2014 at 12:54 PM, Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Awesome work on nfs-rdma in the later kernels!  I had been having
> panic problems for awhile and now things appear to be quite reliable.
>
> Now that things are more reliable, I would like to help work on speed
> issues.  On this same hardware with SMB Direct and the standard
> storage review 8k 70/30 test, I get combined read & write performance
> of around 2.5GB/sec.  With nfs-rdma it is pushing about 850MB/sec.
> This is simply an unacceptable difference.
>
> I'm using the standard settings -- connected mode, 65520 byte MTU,
> nfs-server-side "async", lots of nfsd's, and nfsver=3 with large
> buffers.  Does anyone have any tuning suggestions and/or places to
> start looking for bottlenecks?
>

There is a tunable called "xprt_rdma_slot_table_entries" .. Increasing
that seemed to help a lot for me last year. Be aware that this tunable
is enclosed inside  "#ifdef RPC_DEBUG" so you might need to tweak the
source and rebuild the kmod.


-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
