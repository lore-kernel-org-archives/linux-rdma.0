From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/mlx5: Fix iteration overrun in GSI qps
Date: Mon, 4 Jul 2016 09:27:17 +0300
Message-ID: <ff11736c-adf6-b901-454e-ee232837da69@mellanox.com>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
 <1467548899-21923-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467548899-21923-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/3/2016 3:28 PM, Leon Romanovsky wrote:
> From: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Number of outstanding_pi may overflow and as a result may indicate that
> there are no elements in the queue. The effect of doing this is that the
> MAD layer will get stuck waiting for completions. The MAD layer will
> think that the QP is full - because it didn't receive these completions.
> 
> This fix changes it so the outstanding_pi number is increased
> with 32-bit wraparound and is not limited to max_send_wr so
> that the difference between outstanding_pi and outstanding_ci will
> really indicate the number of outstanding completions.
> 
> Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Fixes: ea6dc2036224 ('IB/mlx5: Reorder GSI completions')
> Signed-off-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks for this fix,

Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
