From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/cm: Fix memory corruption in handling CM
 request
Date: Wed, 25 Oct 2017 14:39:26 -0400
Message-ID: <1508956766.3325.53.camel@redhat.com>
References: <20171019054030.13280-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019054030.13280-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-10-19 at 08:40 +0300, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In recent code, two path record entries are alwasy cleared while
> allocated could be either one or two path record entries.
> This leads to zero out of unallocated memory.
> 
> This fix initializes alternative path record only when alternative
> path
> is set.
> 
> While we are at it, path record allocation doesn't check for OPA
> alternative path, but rest of the code checks for OPA alternative
> path.
> Path record allocation code doesn't check for OPA alternative LID.
> This can further lead to memory corruption when only one path record
> is
> allocated, but there is actually alternative OPA path record present
> in CM
> request.
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.12+
> Fixes: 9fdca4da4d8c ("IB/SA: Split struct sa_path_rec based on IB and
> ROCE specific fields")
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
