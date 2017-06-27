From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: NFS/RDMA RoCE with mlx4_en
Date: Tue, 27 Jun 2017 12:57:24 +0300
Message-ID: <493629a1-3e36-15c8-8fe4-83a3d8e33e89@grimberg.me>
References: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Running various I/O stress workloads with iozone on an
> NFSv3 mount using RDMA on RoCEv1 (FRWR).
> 
> Jun 26 12:50:21 morisot kernel: mlx4_core 0000:01:00.0: command 0x49 timed out (go bit not cleared)

Looks like a FW issue to me...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
