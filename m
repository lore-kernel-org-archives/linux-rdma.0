From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 6/7] mlx5: Add direct verbs man pages
Date: Mon, 13 Feb 2017 23:52:33 +0200
Message-ID: <156c0448-5e9b-9879-1d6b-06cbaec3ce6b@dev.mellanox.co.il>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-7-git-send-email-yishaih@mellanox.com>
 <20170213165445.GC25430@obsidianresearch.com>
 <20170213181338.GB6989@mtr-leonro.local>
 <20170213184551.GB12224@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170213184551.GB12224-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/13/2017 8:45 PM, Jason Gunthorpe wrote:
> On Mon, Feb 13, 2017 at 08:13:38PM +0200, Leon Romanovsky wrote:
>> On Mon, Feb 13, 2017 at 09:54:45AM -0700, Jason Gunthorpe wrote:
>>> On Sun, Feb 12, 2017 at 04:16:51PM +0200, Yishai Hadas wrote:
>>>
>>>> +.\" -*- nroff -*-
>>>> +.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
>>>
>>> Please use the MIT variant for all new files
>>>
>>>> +.fi
>>>> +.SH "RETURN VALUE"
>>>> +0 on success.
>>>
>>> 'or the value of errno on failure (which indicates the failure reason)'
>>>
>>> and in other places.
>>>
>>>> +.BI "int mlx5dv_query_device(struct ibv_context *ctx_in,
>>>> +.BI "                        struct mlx5dv_context *attrs_out);
>>>
>>> This isn't going to work with comp_mask, at a minimum you need to add
>>> a size_t attrs_len argument.
>>>
>>> I recommend against adding new complex queries like this - they don't
>>> work well from an ABI perspective and not being performance critical
>>> do not require this comp_max madness
>>>
>>> Eg just use:
>>>
>>> int mlx5dv_query_cq_format(struct ibv_context *ctx_in)
>>
>> This will end with bazillion small exported functions and I don't think
>> that it is clean way to provide API. Especially for function which
>> should query_device.
>
> There is nothing really wrong with that, and it is better than
> fighting with that horrid comp_mask stuff, especially when the first
> attempt is done wrong :|
>
> You could also use a getsockopt style of multiplexer.
>
> Overall 'query_device' was a design mistake from an ABI perspective,
> do not copy it.
>
> In any case, it cannot stay the way it is in this series.

There is nothing wrong with current usage of comp_mask, it just follows 
the usage of ibv_query_rt_values_ex where it's used as both in/out.(see 
below from its man page)
We can update the man pages to say it explicitly so that it will be 
fully clear.

That way looks quite more simple than managing an input size which may 
still require a comp_mask as an output to mark which values were set in 
case few fields can have a valid value of 0 but might be ignored as of 
legacy driver.


 From man page:
----------------------
int ibv_query_rt_values_ex(struct ibv_context *context,
                                   struct ibv_values_ex *values);

DESCRIPTION
ibv_query_rt_values_ex() returns certain real time values of a device 
context.  The argument attr is a pointer to an ibv_device_attr_ex 
struct, as defined in <infiniband/verbs.h>.

struct ibv_values_ex {
uint32_t      comp_mask;    /* Compatibility mask that defines the 
query/queried fields [in/out] */
  struct timespec      raw_clock;    /* HW raw clock */
};

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
