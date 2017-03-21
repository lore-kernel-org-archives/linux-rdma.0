From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 03/14] svcrdma: Eliminate RPCRDMA_SQ_DEPTH_MULT
Date: Tue, 21 Mar 2017 14:44:45 -0400
Message-ID: <391F0D90-2A46-4B2F-BCF0-B3BE7D48A3EF@oracle.com>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net> <20170316155250.4482.49638.stgit@klimt.1015granger.net> <46eb6195-a542-b35c-4902-a2bebb38feba@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <46eb6195-a542-b35c-4902-a2bebb38feba-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Mar 21, 2017, at 1:58 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>> The Send Queue depth is temporarily reduced to 1 SQE per credit. The
>> new rdma_rw API does an internal computation, during QP creation, to
>> increase the depth of the Send Queue to handle RDMA Read and Write
>> operations.
>> 
>> This change has to come before the NFSD code paths are updated to
>> use the rdma_rw API. Without this patch, rdma_rw_init_qp() increases
>> the size of the SQ too much, resulting in memory allocation failures
>> during QP creation.
> 
> I agree this needs to happen, but turns out you don't have any
> guarantees of the maximum size of the sq depending on your max_sge
> parameter.

That's true. However, this is meant to be temporary while I'm
working out details of the rdma_rw API conversion. More work
in this area comes in the next series:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-rw-api


> I'd recommend having a fall-back shrinked size sq allocation
> impllemented like srpt does.

Agree it should be done. Would it be OK to wait until the dust
settles here, or do you think it's a hard requirement for
accepting this series?


> We don't have it in nvmet-rdma nor iser, but its a good thing to have...


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
