From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v1 03/14] svcrdma: Eliminate RPCRDMA_SQ_DEPTH_MULT
Date: Wed, 22 Mar 2017 21:06:49 +0200
Message-ID: <68e3eda0-90f4-5bca-28be-b2cf494ed172@grimberg.me>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net>
 <20170316155250.4482.49638.stgit@klimt.1015granger.net>
 <46eb6195-a542-b35c-4902-a2bebb38feba@grimberg.me>
 <391F0D90-2A46-4B2F-BCF0-B3BE7D48A3EF@oracle.com>
 <ec82feb4-d6b9-7fb4-5b11-b8007e313845@grimberg.me>
 <C9D8A91C-DE08-4A41-A07D-1F4C42DD9B97@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C9D8A91C-DE08-4A41-A07D-1F4C42DD9B97-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Roughly speaking, I think there needs to be an rdma_rw API that
> assists the ULP with setting its CQ and SQ sizes, since rdma_rw
> hides the registration mode (one of which, at least, consumes
> more SQEs than the other).

Hiding the registration mode was the largely the motivation for
this... It buys us simplified implementation and inherently supports
both IB and iWARP (which was annoying and only existing in svc but
still suboptimal).

> I'd like to introduce one new function call that surfaces the
> factor used to compute how many additional SQEs that rdma_rw will
> need. The ULP will invoke it before allocating new Send CQs.

I see your point... We should probably get a sense on how to
size the completion queue. I think that this issue is solved with
the CQ pool API that Christoph sent a while ago but was never
pursued.

The basic idea is that the core would create a pool of long CQs
and then assigns queue-pairs depending on the sq+rq depth.
If we were to pick it up would you consider using it?

> I'll try to provide an RFC in the nfsd-rdma-rw-api topic branch.

Cool, lets see what you had in mind...
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
