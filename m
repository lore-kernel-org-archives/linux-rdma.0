From: Steve Wise <swise-10udUCx4aRo@public.gmane.org>
Subject: Re: rdma provider module references
Date: Wed, 15 Dec 2010 12:53:40 -0600
Message-ID: <4D090EB4.70706@aoot.com>
References: <4D08E989.5020307@aoot.com> <adapqt3gdzb.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqt3gdzb.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/15/2010 11:09 AM, Roland Dreier wrote:
>   >  I notice that if I have a user rdma application running that has an
>   >  rdma connection using iw_cxgb3, then the iw_cxgb3 module reference
>   >  count is bumped and thus it cannot be unloaded.  However when I have
>   >  an NFSRDMA connection that utilizes iw_cxgb3, the module reference
>   >  count is not bumped, and iw_cxgb3 can erroneously be unloaded while
>   >  the NFSRDMA connection is still active, causing a crash.
>
> What is supposed to happen is that as the HW driver is unloading, it
> calls ib_unregister_device() first, and this calls each client's
> .remove() method to have it release everything related to that device.
>
> However I guess NFS/RDMA is behind the RDMA CM, which is supposed to
> handle device removal.  In that code it seems to end up in
> cma_process_remove(), which appears at first glance to do the right
> things to destroy all connections etc.
>
> The idea is that RDMA devices should be like net devices, ie you can
> remove them even if they're in use -- things should just clean up,
> rather than blocking the module removal.  The uverbs case is a bit of a
> hack because we don't have a way to handle revoking the mmap regions
> etc yet.
>

Thanks for the description of how it should work.

> What goes wrong with NFS/RDMA in this scheme?  It looks like it should work.
>

I'm still investigating exactly what happens.  I'll follow up once I know more.

Thanks!

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
