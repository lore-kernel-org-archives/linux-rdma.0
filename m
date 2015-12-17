From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH RESEND] infiniband:core:Add needed error path in
 cm_init_av_by_path
Date: Thu, 17 Dec 2015 09:43:43 +0100
Message-ID: <567275BF.1010208@profitbricks.com>
References: <1450194724-7107-1-git-send-email-xerofoify@gmail.com>
 <5670420A.7040202@profitbricks.com>
 <20151215173022.GB25965@obsidianresearch.com>
 <56713C5F.5020507@profitbricks.com>
 <20151216181644.GF32594@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151216181644.GF32594-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/16/2015 07:16 PM, Jason Gunthorpe wrote:
> On Wed, Dec 16, 2015 at 11:26:39AM +0100, Michael Wang wrote:
[snip]
>>
>> I've rechecked the ib_init_ah_from_path() again, and found it
>> still set IB_AH_GRH when the GID cache missing, but with:
> 
> How do you mean?
> 
>                 ah_attr->ah_flags = IB_AH_GRH;
>                 ah_attr->grh.dgid = rec->dgid;
> 
>                 ret = ib_find_cached_gid(device, &rec->sgid, ndev, &port_num,
>                                          &gid_index);
>                 if (ret) {
>                         if (ndev)
>                                 dev_put(ndev);
>                         return ret;
>                 }
> 
> If find_cached_gid fails then ib_init_ah_from_path also fails.
> 
> Is there a case where ib_find_cached_gid can succeed but not return
> good data?

Just for the GRH header, ib_find_cached_gid() will failed but the flag
and dgid will be correct, and others are all 0 including hop limit, but
may be just coincidence...

As long as hop_limit > 1 means the pkg do have to pass through a router
to other subnet, the fix make sense :-)

Regards,
Michael Wang

> 
> I agree it would read nicer if the ah_flags and gr.dgid was moved
> after the ib_find_cached_gid
> 
>> BTW, cma_sidr_rep_handler() also call ib_init_ah_from_path() with out
>> a check on return.
> 
> That sounds like a problem.
> 
> Jason
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
