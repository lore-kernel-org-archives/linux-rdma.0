From: Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Tue, 03 Aug 2010 13:09:39 -0400
Message-ID: <4C584D53.8050901@oracle.com>
References: <4C5331DC.9080109@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C5331DC.9080109-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Frank, Thank you for these patches.. !!

We are working on a user mode IPC based on XRC.. we will try these patches..

frank zago wrote:
> Hello,
>
> This allow rdma ucm to establish an XRC connection between two nodes. Most
> of the changes are related to modify_qp since the API is different
> whether the QP is on the send or receive side.
> To create an XRC receive QP, the cap.max_send_wr must be set to 0.
> Conversely, to create the send XRC QP, that attribute must be non-zero.
>
> Regards,
>   Frank
>
>
>
>   
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
