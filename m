From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v1 03/14] svcrdma: Eliminate RPCRDMA_SQ_DEPTH_MULT
Date: Wed, 22 Mar 2017 15:09:19 +0200
Message-ID: <ec82feb4-d6b9-7fb4-5b11-b8007e313845@grimberg.me>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net>
 <20170316155250.4482.49638.stgit@klimt.1015granger.net>
 <46eb6195-a542-b35c-4902-a2bebb38feba@grimberg.me>
 <391F0D90-2A46-4B2F-BCF0-B3BE7D48A3EF@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <391F0D90-2A46-4B2F-BCF0-B3BE7D48A3EF-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> I agree this needs to happen, but turns out you don't have any
>> guarantees of the maximum size of the sq depending on your max_sge
>> parameter.
>
> That's true. However, this is meant to be temporary while I'm
> working out details of the rdma_rw API conversion. More work
> in this area comes in the next series:
>
> http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-rw-api

Thanks for the pointer...

>> I'd recommend having a fall-back shrinked size sq allocation
>> impllemented like srpt does.
>
> Agree it should be done. Would it be OK to wait until the dust
> settles here, or do you think it's a hard requirement for
> accepting this series?

It isn't and can definitely be added incrementally...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
