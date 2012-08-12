From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] net/mlx4_core: enable 8TB of memory registration
Date: Sun, 12 Aug 2012 13:42:11 +0300
Message-ID: <50278883.5000306@mellanox.com>
References: <1344342878-32650-1-git-send-email-yishaih@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344342878-32650-1-git-send-email-yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/08/2012 15:34, yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org wrote:
> From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> This patch solves below issue:
> Fix the mlx4 core limitation of log num mtt higher than 28.
> - There were some int overflows which were fixed to enable using 31.
>
> - When we auto scaling number of MTTs with the size of the system memory
>    we can map 8TB instead of 1TB.

Yishai,

I see that the relation to the ICM size limit was wrong assertion, and 
anyway, lets fix the submission
such that this patch comes **before** the other patch you sent, so it 
fixes the sign/int etc issues, and later the other patch adds the 
vmalloc thing.

Or.

Also checkpatch spotted here some tiny issue to be fixed.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
