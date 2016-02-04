From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx5] Add support for standard atomic operations
Date: Thu, 4 Feb 2016 18:01:47 +0200
Message-ID: <56B375EB.209@dev.mellanox.co.il>
References: <1454499186-7000-1-git-send-email-eranbe@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454499186-7000-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/3/2016 1:33 PM, Eran Ben Elisha wrote:
> Enable post send for atomic operation codes in case it is supported by
> the hardware.
>
> Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   src/mlx5.c  |  6 ++++++
>   src/mlx5.h  |  2 ++
>   src/qp.c    | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
>   src/verbs.c |  3 +++
>   4 files changed, 61 insertions(+), 5 deletions(-)
>

Applied.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
