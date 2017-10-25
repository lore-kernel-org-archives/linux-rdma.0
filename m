From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] RDMA mlx5 driver updates
 rdma-next-2017-10-19
Date: Wed, 25 Oct 2017 14:24:47 -0400
Message-ID: <1508955887.3325.49.camel@redhat.com>
References: <20171019052556.8514-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019052556.8514-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-10-19 at 08:25 +0300, Leon Romanovsky wrote:
> This patch set adds two local to mlx5 features.
> 
> The first feature comes from Guy, who updated the mlx5 driver to
> support
> CQE compression for 128B-sized CQEs in addition to already supported
> 64B-sized CQEs: commit 1cbe6fc86ccf ("IB/mlx5: Add support for CQE
> compressing").
> 
> The second feature comes from Maor, this feature enables receive
> stateless
> offloading support for incoming tunneling traffic for raw ethernet
> QP.
> 
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> tags/rdma-next-2017-10-19-1
> 
>         Thanks

Thanks, series applied (with a fixup because I haven't taken the PCI
write pad patch series yet).

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
