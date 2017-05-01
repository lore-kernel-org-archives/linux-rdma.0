From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] IB/mlx4: Code cleanup in cm.c
Date: Mon, 01 May 2017 16:55:56 -0400
Message-ID: <1493672156.3041.187.camel@redhat.com>
References: <20170428110654.13176-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428110654.13176-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hakon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-04-28 at 13:06 +0200, Hakon Bugge wrote:
> This patchset contains two non-functional patches that cleans up two
> issues.
> 
> Hakon Bugge (2):
>   IB/mlx4: Change flush logic so it adheres to the variable name
>   IB/mlx4: Fix incorrect order of formal and actual parameters
> 
>  drivers/infiniband/hw/mlx4/cm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

I made the commit messages a bit clearer, but otherwise, series
applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
