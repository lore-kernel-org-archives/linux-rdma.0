From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] IB/mlx5: Implement Fast Indirect Memory Registration
 Feature
Date: Mon, 13 Oct 2014 15:57:49 +0300
Message-ID: <543BCC4D.3030907@mellanox.com>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <1412693281-6161-3-git-send-email-sagig@mellanox.com> <543AD8DE.5060404@mellanox.com> <543B8E09.6090606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <543B8E09.6090606-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bvanassche-HInyCGIudOg@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 10/13/2014 11:32 AM, Sagi Grimberg wrote:
> mask = MLX5_MKEY_MASK_LEN        |
> +        MLX5_MKEY_MASK_PAGE_SIZE    |
> +        MLX5_MKEY_MASK_START_ADDR    |
> +        MLX5_MKEY_MASK_EN_RINVAL    |
> +        MLX5_MKEY_MASK_KEY        |
> +        MLX5_MKEY_MASK_LR        |
> +        MLX5_MKEY_MASK_LW        |
> +        MLX5_MKEY_MASK_RR        |
> +        MLX5_MKEY_MASK_RW        |
> +        MLX5_MKEY_MASK_A        |
> +        MLX5_MKEY_MASK_FREE; 
@ least let's not repeat this mask = MLX5_MKEY_MASK_YYY | [...] exactly 
twice, BTW I think Eli is OOO this week and I'm not sure we want to stop 
this train just as of this small suggestion I made here



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
