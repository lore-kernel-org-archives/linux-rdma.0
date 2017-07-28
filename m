From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Add raw ethernet local loopback
Date: Fri, 28 Jul 2017 14:15:23 -0400
Message-ID: <1501265723.2593.33.camel@redhat.com>
References: <20170530064255.3745-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530064255.3745-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-05-30 at 09:42 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> The following patch set from Huy adds ability to disable/enable
> raw ethernet loopbacks based on actual number of user contexts.
> 
> The one or less user space context simply says that no actual
> consumer
> of this packets and they don't need to be forwarded to the vport.
> 
> After this patch set, the raw ethernet unicast and multicast
> local loopbacks are disabled by default and packets are forwarded
> to the next routing level (eswitch, or multihost switch, or out to
> the
> wire depending on the configuration).
> 
> Available in the "topic/local_lb" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
