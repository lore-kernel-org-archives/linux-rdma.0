From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v1 03/14] svcrdma: Eliminate RPCRDMA_SQ_DEPTH_MULT
Date: Tue, 21 Mar 2017 19:58:22 +0200
Message-ID: <46eb6195-a542-b35c-4902-a2bebb38feba@grimberg.me>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net>
 <20170316155250.4482.49638.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170316155250.4482.49638.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> The Send Queue depth is temporarily reduced to 1 SQE per credit. The
> new rdma_rw API does an internal computation, during QP creation, to
> increase the depth of the Send Queue to handle RDMA Read and Write
> operations.
>
> This change has to come before the NFSD code paths are updated to
> use the rdma_rw API. Without this patch, rdma_rw_init_qp() increases
> the size of the SQ too much, resulting in memory allocation failures
> during QP creation.

I agree this needs to happen, but turns out you don't have any
guarantees of the maximum size of the sq depending on your max_sge
parameter. I'd recommend having a fall-back shrinked size sq allocation
impllemented like srpt does.

We don't have it in nvmet-rdma nor iser, but its a good thing to have...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
