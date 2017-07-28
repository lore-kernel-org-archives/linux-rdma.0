From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] (IB, net)/mlx4: Add resource utilization
 support
Date: Fri, 28 Jul 2017 14:27:53 -0400
Message-ID: <1501266473.2593.45.camel@redhat.com>
References: <20170621062936.7894-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170621062936.7894-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-06-21 at 09:29 +0300, Leon Romanovsky wrote:
> From: Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Adding visibility of resource usage of QPs, CQs and counters used by
> virtual functions. This feature will be used to give the PF
> administrator
> more data while debugging VF status. Usage info was added to
> ALLOC_RES
> command, to notify the PF if the resource which is being reserved or
> allocated for the VF will be used by kernel driver or by user verbs.
> 
> Updated reservation and allocation functions of QP, CQ and counter
> with
> additional usage parameter.
> 
> Signed-off-by: Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
