From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc] xprtrdma: Don't require LOCAL_DMA_LKEY support
 for fasterg
Date: Tue, 6 Oct 2015 19:27:48 +0300
Message-ID: <5613F684.3020904@dev.mellanox.co.il>
References: <1444124889-8957-1-git-send-email-sagig@mellanox.com>
 <56C57483-17AA-47FF-8743-E1522BD8C351@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C57483-17AA-47FF-8743-E1522BD8C351-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/6/2015 6:05 PM, Chuck Lever wrote:
> Hi Sagi-
>
>
>> On Oct 6, 2015, at 5:48 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> There is no need to require LOCAL_DMA_LKEY support in order to
>> use fast registration as the PD allocation makes sure that there
>> is a local_dma_lkey.
>
> In other words, all devices now have a local DMA lkey, so the
> check is unnecessary.

Right.

>
>
>> This caused a NULL pointer dereference in mlx5 which removed
>> the support for LOCAL_DMA_LKEY.
>
> Where was the bad dereference? in mlx5, or in xprtrdma?

xprtrdma, ia->ri_ops wasn't assigned correctly.

Now that I look at it, one error path in rpcrdma_ia_open misses
an rc assignment. That needs to be fixed too, should it be in the same
patch?

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 7efd9ef..81e8d31 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -554,6 +554,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct 
sockaddr *addr, int memreg)
                 if (!ia->ri_device->alloc_fmr) {
                         dprintk("RPC:       %s: MTHCAFMR registration "
                                 "not supported by HCA\n", __func__);
+                       rc = -EINVAL;
                         goto out3;
                 }
         }
--

the incorrect requirement + missing rc caused the NULL deref of
ia->ri_ops.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
