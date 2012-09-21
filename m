From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libmlx4 1/8] Add raw packet QP support
Date: Fri, 21 Sep 2012 10:16:27 +0300
Message-ID: <CAJZOPZJeLZ+d6romA8Qe63XKyuCtsMEkrjtoOs4+1s+NY-_d_A@mail.gmail.com>
References: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
	<1348173067-12116-2-git-send-email-ogerlitz@mellanox.com>
	<4AF12E8016D2BF46BCDFCE8FAA77A3580315252C@fmsmsx109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF12E8016D2BF46BCDFCE8FAA77A3580315252C-96pTJSsuoYQd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 21, 2012 at 3:51 AM, Luick, Dean <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> @@ -286,6 +286,10 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct
>> ibv_send_wr *wr,
>>                       size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
>>                       break;
>>
>> +             case IBV_QPT_RAW_PACKET:
>> +                     /* For raw eth, the MLX4_WQE_CTRL_SOLICIT flag is used
>> +                      * to indicate that no icrc should be calculated */
>> +                     ctrl->srcrb_flags |= htonl(MLX4_WQE_CTRL_SOLICIT);
>>               default:
>>                       break;
>>               }
>
> Add a break for the new case?  While the above code works as expected, it is inconsistent from what it was before, and could lead to problems if the default case starts doing something.

fair-enough, will fix
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
