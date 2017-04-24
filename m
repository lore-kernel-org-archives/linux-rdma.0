From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/rxe: Offload CRC calculation when
 possible
Date: Mon, 24 Apr 2017 12:19:27 -0400
Message-ID: <1493050767.3041.40.camel@redhat.com>
References: <20170420175556.8573-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170420175556.8573-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-20 at 20:55 +0300, Leon Romanovsky wrote:
> From: yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Use CPU ability to perform CRC calculations, by
> replacing direct calls to crc32_le() with crypto_shash_updata().
> 
> The overall performance gain measured with ib_send_bw tool is 10% and
> it
> was tested on "Intel CPU ES-2660 v2 @ 2.20Ghz" CPU.
> 
> ib_send_bw -d rxe0  -x 1 -n 9000 -e  -s $((1024 * 1024 )) -l 100
> 
> -------------------------------------------------------------------
> --------------------------
> |             | bytes   | iterations | BW peak[MB/sec] | BW
> average[MB/sec] | MsgRate[Mpps] |
> -------------------------------------------------------------------
> --------------------------
> | crc32_le    | 1048576 | 9000       | inf             |
> 497.60             | 0.000498      |
> | CRC offload | 1048576 | 9000       | inf             |
> 546.70             | 0.000547      |
> -------------------------------------------------------------------
> --------------------------
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
