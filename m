From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] infiniband:core:Add needed error path in
 cm_init_av_by_path
Date: Mon, 7 Dec 2015 09:48:31 +0100
Message-ID: <566547DF.9040509@profitbricks.com>
References: <1449252173-12131-1-git-send-email-xerofoify@gmail.com>
 <HE1PR05MB13551694F8428E5A53CB3993C1090@HE1PR05MB1355.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB13551694F8428E5A53CB3993C1090-eBadYZ65MZ+lkJP6d7MyxNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 12/07/2015 08:57 AM, Haggai Eran wrote:
> On Friday, December 4, 2015 8:02 PM, Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>> Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Haggai Eran; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; Matan Barak; yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org; ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; Doron Tsur; Erez Shitrit; david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [PATCH] infiniband:core:Add needed error path in cm_init_av_by_path
>>
>> This adds a needed error path in the function, cm_init_av_by_path
>> after the call to ib_init_ah_from_path in order to avoid incorrectly
>> accessing the path pointer of structure type ib_sa_path_rec if this
>> function call fails to complete its intended work successfully by
>> returning a error code.
>>
>> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> The subject doesn't seem to match the convention but apart from that,
> 
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> I wonder if this should go to stable. If I understand correctly, this will fail only when the SGID isn't found in the GID table, but such connections would fail later on when creating a QP, right?

Me too think this need a reconsider, to me the current logical don't
really care the missing gid in cache when initializing AV, I'm not
sure if it's necessary to fail all the following path for such cache
missing...

Regards,
Michael Wang

> 
> Haggai
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
