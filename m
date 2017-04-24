From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2] IB/mlx5: Support congestion related
 counters
Date: Mon, 24 Apr 2017 12:26:54 -0400
Message-ID: <1493051214.3041.45.camel@redhat.com>
References: <20170416042929.18294-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170416042929.18294-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-04-16 at 07:29 +0300, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch adds support to query the congestion related hardware
> counters
> through new command and links them with other hw counters being
> available
> in hw_counters sysfs location.
> 
> In order to reuse existing infrastructure it renames related
> q_counter
> data structures to more generic counters to reflect q_counters and
> congestion counters and maybe some other counters in the future.
> 
> New hardware counters:
>  * rp_cnp_handled - CNP packets handled by the reaction point
>  * rp_cnp_ignored - CNP packets ignored by the reaction point
>  * np_cnp_sent    - CNP packets sent by notification point to respond
> to
>                      CE marked RoCE packets
>  * np_ecn_marked_roce_packets - CE marked RoCE packets received by
>                                 notification point
> 
> It also avoids returning ENOSYS which is specific for invalid
> system call and produces the following checkpatch.pl warning.
> 
> WARNING: ENOSYS means 'invalid syscall nr' and nothing else
> +               return -ENOSYS;
> 
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
