From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband:core:Add needed error path in
 cm_init_av_by_path
Date: Mon, 7 Dec 2015 07:57:33 +0000
Message-ID: <HE1PR05MB13551694F8428E5A53CB3993C1090@HE1PR05MB1355.eurprd05.prod.outlook.com>
References: <1449252173-12131-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449252173-12131-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Friday, December 4, 2015 8:02 PM, Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Haggai Eran; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; Matan Barak; yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org; ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; Doron Tsur; Erez Shitrit; david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] infiniband:core:Add needed error path in cm_init_av_by_path
> 
> This adds a needed error path in the function, cm_init_av_by_path
> after the call to ib_init_ah_from_path in order to avoid incorrectly
> accessing the path pointer of structure type ib_sa_path_rec if this
> function call fails to complete its intended work successfully by
> returning a error code.
> 
> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The subject doesn't seem to match the convention but apart from that,

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I wonder if this should go to stable. If I understand correctly, this will fail only when the SGID isn't found in the GID table, but such connections would fail later on when creating a QP, right?

Haggai--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
