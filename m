From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs V4 0/5] Add support for UD QPs under RoCE IP
 addressing
Date: Tue, 20 May 2014 09:58:57 +0300
Message-ID: <537AFD31.3000401@mellanox.com>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400405929-14313-1-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 18/05/2014 12:38, Or Gerlitz wrote:
[...]
> changes from V3 -- addressed feedback from Jason:
>    - replaced the char* that used to hold the MAC address provided to
>      the provider library (e.g libmlx4) with sockaddr_storage and use ARPHRD
>      for the af_family (similar to the practice used in the kernel)
>
>    - Dropped mask1 from ibv_query_port_ex and put all fields in comp_mask
>    - Added a man page for ibv_query_port_ex
>    - Made the code c99 friendly by dropping the anonymous union and struct
>    - Splitted the patches to patch that adds the interface and patch that uses it
>    - Removed the usage of drv_ and lib_ schemas
>    - Removed the VERBS_CONTEXT_XXXXXXX

Hi Jason,  so Matan has addressed you comments from V3, could you please 
take a look and ack? we find tiny little bug in patch #1 but want to get 
your feedback before re-spinning  V5.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
