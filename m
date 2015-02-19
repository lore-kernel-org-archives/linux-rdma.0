From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RE-RESEND V2 for-next 5/5] IB/core: Fix deadlock on uverbs
 modify_qp error flow
Date: Thu, 19 Feb 2015 10:31:45 +0200
Message-ID: <54E59F71.6050300@mellanox.com>
References: <1423137232-24587-1-git-send-email-ogerlitz@mellanox.com>
 <1423137232-24587-6-git-send-email-ogerlitz@mellanox.com>
 <54E41D3E.6020809@mellanox.com>
 <CAG4TOxOhnc_ihooLyKJ09P90RMM4MbcWS5McwNOMV4gQ+Ls4Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxOhnc_ihooLyKJ09P90RMM4MbcWS5McwNOMV4gQ+Ls4Qg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 2/18/2015 8:07 AM, Roland Dreier wrote:
> On Tue, Feb 17, 2015 at 9:03 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Roland, can you please pick this one too, it's a bug fix and no comments
>> were raised against it.
>> I just failed to remove the Gerrit Issue: XXX line,  so if you can do that,
>> will be great
>
> OK.

I noted that these commits which are targeted to 3.20 are @ your master 
branch but not on for-next, just
dropping you a note to make sure they are not left behind.


IB/core: Add on demand paging caps to ib_uverbs_ex_query_device
IB/core: Add support for extended query device caps
IB/core: Fix deadlock on uverbs modify_qp error flow
IB/core: Properly handle registration of on-demand paging MRs after dereg
IB/mlx4: Bug fixes in mlx4_ib_resize_cq
IB/mlx4: Fix memory leak in __mlx4_ib_modify_qp
IB/mlx4: In mlx4_ib_demux_cm, print out GUID in host-endian order
IB/mlx5: Enable the ODP capability query verb
IB/mlx5: Update the dev in reg_create

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
