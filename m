From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/4] ConnectX-3 RSS Implementation
Date: Fri, 28 Jul 2017 14:30:01 -0400
Message-ID: <1501266601.2593.46.camel@redhat.com>
References: <20170704132427.25937-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170704132427.25937-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-07-04 at 16:24 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> This patch set adds to ConnectX-3 devices the ability to use RSS
> feature, which was initially implemented in mlx5-based devices [1].
> 
> The backport of RSS feature to ConnectX-3 hardware was a challenge
> task due to differences in architectures between mlx4 and mlx5 based
> devices.
> 
> It caused to a limited number of usage limitations, mentioned in the
> relevant
> commit messages where it applies.
> 
> This series supports all RSS related verbs.
> 
> Thanks.

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
