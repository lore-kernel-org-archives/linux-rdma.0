From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Add inline-receive support
Date: Tue, 12 Sep 2017 11:23:46 +0300
Message-ID: <2638e6ca-b0bb-ebbc-c289-bbeb422d39a8@dev.mellanox.co.il>
References: <1505036749-12297-1-git-send-email-yishaih@mellanox.com>
 <20170911163847.GF32117@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911163847.GF32117-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/11/2017 7:38 PM, Jason Gunthorpe wrote:
> On Sun, Sep 10, 2017 at 12:45:49PM +0300, Yishai Hadas wrote:
>> +.\" -*- nroff -*-
>> +.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
>> +.\"
>> +.TH MLX4DV_QUERY_DEVICE 3 2017-06-27 1.0.0
>> +.SH "NAME"
>> +mlx4dv_query_device \- Query device capabilities specific to mlx4
>> +.SH "SYNOPSIS"
>> +.nf
>> +.B #include <infiniband/mlx4dv.h>
>> +.sp
>> +.BI "int mlx4dv_query_device(struct ibv_context *ctx_in,
>> +.BI "                        struct mlx4dv_context *attrs_out);
>> +.fi
>> +.SH "DESCRIPTION"
>> +.B mlx4dv_query_device()
>> +Query HW device-specific information which is important for data-path, but isn't provided by
>> +\fBibv_query_device\fR(3).
>
> Please adjust the man page grammer, something like:
>
> Query mlx4 specific device information that is usable via the direct
> verbs interface.
>
> This function returns a version and compatibility mask. The version
> represents the format of the internal hardware structures that
> mlx4dv.h exposes. Future additions of new fields to the existing
> structures are handled by the comp_mask field.
>
>  * Compatibility mask (comp_mask) is an in/out field.
>

Man page was updated in the PR as suggested above.
Merged.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
