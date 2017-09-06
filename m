From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] mlx5: Add support for sending IPoIB packets
Date: Wed, 6 Sep 2017 19:49:03 +0300
Message-ID: <4151c1be-89f3-804f-8feb-5e2b0b3947bc@dev.mellanox.co.il>
References: <1504708729-15249-1-git-send-email-yishaih@mellanox.com>
 <1504708729-15249-4-git-send-email-yishaih@mellanox.com>
 <20170906160443.GC6262@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170906160443.GC6262-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/6/2017 7:04 PM, Jason Gunthorpe wrote:
> On Wed, Sep 06, 2017 at 05:38:49PM +0300, Yishai Hadas wrote:
>
>> +			if (unlikely(qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY)) {
>> +				err = mlx5_post_send_underlay(qp, wr, &seg, &size, &sg_copy_ptr);
>> +				if (unlikely(err)) {
>> +					*bad_wr = wr;
>> +					goto out;
>> +				}
>> +			}
>
> I don't know anything about your device, but this patch looks to me
> like it enables for any IBV_QP_CREATE_SOURCE_QPN user

Correct, the code is generic and can work not only with IPoIB packets.

  - and it seems
> to contain a lot of IPoIB specific commentary.
>
> It is wrong to assume that all IBV_QP_CREATE_SOURCE_QPN QP's are IPoIB.
>
> At a minimum some of the commentary needs revising..

The commentary was focused on IPoIB as this is the main use case that we 
come to solve.

I'll revise the commit log to better describe the general case and 
mention the IPoIB as a specific use case, will send V1 for that.

Thanks for comment on.
Yishai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
