From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/11] IB/rxe: Bug fixes
Date: Mon, 28 Aug 2017 19:32:35 -0400
Message-ID: <1503963155.52034.14.camel@redhat.com>
References: <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
         <1503951119-25573-1-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503951119-25573-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-08-28 at 16:11 -0400, Andrew Boyer wrote:
> This patch set addresses a few issues which we have found in RXE.
> The first patch fixes a serious issue that causes kernel panics
> during
> network congestion.
> 
> Changes for v2:
> * Update NETDEV_CHANGE patch so it builds; original was inadvertently
>   based on an internal branch
> 
> Changes for v1:
> * Address review comments and add review tags from Moni
> * Split destination cache patch into 4 smaller patches
> * Added CONFIG_IPV6 check to destination cache patch
> * Added new NETDEV_CHANGE patch
> 
> Andrew Boyer (11):
>   IB/rxe: Move refcounting earlier in rxe_send()
>   IB/rxe: Disable completion upcalls when a CQ is destroyed
>   IB/rxe: Remove dangling prototype
>   IB/rxe: Fix up the responder's find_resources() function
>   IB/rxe: Fix destination cache for IPv6
>   IB/rxe: Add dst_clone() in prepare_ipv6_hdr()
>   IB/rxe: Fix up rxe_qp_cleanup()
>   IB/rxe: Remove unneeded initialization in prepare6()
>   IB/rxe: Another fix for broken receive queue draining
>   IB/rxe: Avoid ICRC errors by copying into the skb first
>   IB/rxe: Handle NETDEV_CHANGE events

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
