From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-next v1 00/11] Hardware tag matching support
Date: Tue, 22 Aug 2017 16:46:49 -0400
Message-ID: <1503434809.78641.14.camel@redhat.com>
References: <20170815085912.10181-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085912.10181-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-15 at 11:59 +0300, Leon Romanovsky wrote:
> This patch series adds to Mellanox ConnectX HCA driver support of
> tag matching. It introduces new hardware object eXtended shared
> Receive
> Queue (XRQ), which follows SRQ semantics with addition of extended
> receive buffers topologies and offloads.
> 
> This series adds tag matching topology and rendezvouz offload.
> 
> Changelog:
> v0->v1:
>  * Rebased version, no change
> RFC->v0:
>  * Followed after RFC posted on the ML and OFVWG discussions
>  * Implements agreed verbs interface
>  * Rebased on top of latest version
>  * Adding feature description under Documentaion/infiniband
>  * In struct ib_srq_init_attr moved CQ outside XRC inner struct.
>  * Added max size of the information passed after the RNDV header
>  * Added hca_sq_owner HW flag for RNDV QPs
> 
> Thanks
> 
> ----------------------------------------------------------------
> 
> Doug,
> 
> Please note that I merged our shared pull request from the mailing
> list before sending this series. Please let me know if something
> needs
> to be redone.

Hi Leon,

Does this patchset require the shared pull request?  If so, then that
presents a bit of a problem.  My for-next tree is based on -rc2 and
your shared tree is based on -rc4, so pulling your tree will do one of
Linus' dreaded forward merges along with the merge of the code.  I can
pull your stuff into a separate branch, but that will prevent things
that modify the core from being merged with things that have already
been taken into for-next.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
