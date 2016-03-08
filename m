From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 05/11] xprtrdma: Do not wait if ib_post_send() fails
Date: Tue, 8 Mar 2016 13:03:23 -0500
Message-ID: <8696EFBA-B7DB-42AC-AB57-C656070F4ED3@oracle.com>
References: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org> <20160304162801.13590.89343.stgit@oracle120-ib.cthon.org> <56DF1186.3030303@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56DF1186.3030303-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Mar 8, 2016, at 12:53 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> 
> 
> On 04/03/2016 18:28, Chuck Lever wrote:
>> If ib_post_send() in ro_unmap_sync() fails, the WRs have not been
>> posted, no completions will fire, and wait_for_completion() will
>> wait forever. Skip the wait in that case.
>> 
>> To ensure the MRs are invalid, disconnect.
> 
> How does that help to ensure that?

I should have said "To ensure the MRs are fenced,"

> The first wr that failed and on will leave the
> corresponding MRs invalid, and the others will be valid
> upon completion.

? This is in the invalidation code, not in the fastreg
code.

When this ib_post_send() fails, I've built a set of
chained LOCAL_INV WRs, but they never get posted. So
there is no WR failure here, the WRs are simply
never posted, and they won't complete or flush.

If the connection is no longer there, the MRs are
fenced from the target. Is there a better recovery in
this case?

I suppose I could reset these MRs instead (that is,
pass them to ib_dereg_mr).


> Disconnecting will move the QP to error state,
> but it's not guaranteed that the wrs that _were_ posted will not
> be executed.

Right, disconnecting is not attempting to knock
down running WRs.

> I'd say this is the opposite of ensuring...



--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
