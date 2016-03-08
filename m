From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 05/11] xprtrdma: Do not wait if ib_post_send() fails
Date: Tue, 8 Mar 2016 19:53:10 +0200
Message-ID: <56DF1186.3030303@dev.mellanox.co.il>
References: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org>
 <20160304162801.13590.89343.stgit@oracle120-ib.cthon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160304162801.13590.89343.stgit-HOT7RYQ5zl57mBIHr/i2/HG1qET/BF4J@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 04/03/2016 18:28, Chuck Lever wrote:
> If ib_post_send() in ro_unmap_sync() fails, the WRs have not been
> posted, no completions will fire, and wait_for_completion() will
> wait forever. Skip the wait in that case.
>
> To ensure the MRs are invalid, disconnect.

How does that help to ensure that?

The first wr that failed and on will leave the
corresponding MRs invalid, and the others will be valid
upon completion. disconnecting will move the QP to error state,
but it's not guaranteed that the wrs that _were_ posted will not
be executed. I'd say this is the opposite of ensuring...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
