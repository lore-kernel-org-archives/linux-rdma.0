From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Modify default value of log_rdmarc_per_qp to
 be consistent with HW capability
Date: Tue, 9 Dec 2014 19:45:26 +0200
Message-ID: <CAJ3xEMgKXBJx5_jJMhfZtkNZXxqg0ia+devT+gAULPDty8-KBg@mail.gmail.com>
References: <1418060758-22411-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418060758-22411-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 8, 2014 at 7:45 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> This value is used to calculate max_qp_dest_rdma.
> Default value of 4 brings us to 16 while HW supports 128 (max_requester_per_qp).
> Although this value can be changed by module param it is best that default be optimized.

Do you have any performance data to support this change?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
