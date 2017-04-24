From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/mlx5: Add inner spec and IPv6
 validation in user's flow attribute list
Date: Mon, 24 Apr 2017 12:21:28 -0400
Message-ID: <1493050888.3041.41.camel@redhat.com>
References: <20170403101103.5141-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403101103.5141-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-04-03 at 13:11 +0300, Leon Romanovsky wrote:
> From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This change fixes an incomplete validation of the user's
> flow attributes list.
> 
> Previous implementation validated only matching of IPv4 Ethertype
> to IPv4 spec of outer headers (in case both Ethernet with specified
> Ethertype and IP specs were present) and lacked the validation of:
> 1. Matching of IPv6 Ethertype in Ethernet spec (if such exists) to an
>    IPv6 protocol spec (if such exists).
> 2. Validation of Ethertype to IP protocol matching on inner headers
> specs.
> Which could cause some combinations of unmatching Ethernet and IP
> protocols to pass validation and apply on the device.
> 
> The fix adds validation of IPv6 Ethertype and IP spec as well as
> performing the scan on both outer and inner attributes.
> 
> Fixes: 038d2ef87572 ("Add flow steering support")
> Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Series applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
