From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx4 direct verbs
Date: Sun, 2 Jul 2017 13:31:00 +0300
Message-ID: <d69c655c-145c-5856-1335-c0d2384a6ef8@dev.mellanox.co.il>
References: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498736828-17875-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/29/2017 2:47 PM, Yishai Hadas wrote:
> This patchset from Maor adds direct access to mlx4 devices, it follows same
> solution from both API and packaging perspectives as was already accepted for
> mlx5.
>
> The libibverbs API is an abstract API. It is agnostic to any underlying
> provider specific implementation. While this abstraction has the advantage of
> user applications portability it has a performance penalty. For some
> applications optimizing performance is more important than portability.
>
> The mlx4 direct verbs API introduced in this patchset is intended for such
> applications. It exposes mlx4 specific low level data path
> (send/receive/completion) operations, allowing the application to bypass the
> libibverbs data path API.
>
> The proposed interface consists from one hardware specific header with relevant
> inline functions and conversion logic from ibverbs structures to mlx4 related
> structures.
>
> New header is going to be installed in below path location:
> /usr/inlcude/infiniband/mlx4dv.h
>
> The direct include of mlx4dv.h together with linkage to mlx4 library will
> allow usage of this new interface.
>
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/155
>
> Yishai
>

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
