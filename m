From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 02/11] IB/hfi1: Check return value of strchr
 before using it
Date: Wed, 3 Jan 2018 10:42:24 -0500
Message-ID: <4555c08f-a568-48ea-e183-2d49ebd36c7c@intel.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035621.2126.23093.stgit@scvm10.sc.intel.com>
 <20171220082555.GN2942@mtr-leonro.local>
 <f5849e2b-c8cd-b93b-f32f-f423bff9ae31@intel.com>
 <20180103152721.GT10145@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103152721.GT10145-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/3/2018 10:27 AM, Leon Romanovsky wrote:
> On Wed, Jan 03, 2018 at 10:05:56AM -0500, Dennis Dalessandro wrote:
>> On 12/20/2017 3:25 AM, Leon Romanovsky wrote:
>>> On Mon, Dec 18, 2017 at 07:56:23PM -0800, Dennis Dalessandro wrote:
>>>> The call to strchr in our counter initialization does not check the return
>>>> value before attempting to use the pointer. In theory this should not
>>>> happen given the way the code is structured but do the smart thing and
>>>> check the value anyway to harden the code.
>>>
>>> The smartest way is to get rid of the whole "\n"<->"\0" logic and
>>> copy/paste mlx5 implementation which does the same thing but statically
>>> and much safer than here.
>>>
>>> Thanks
>>>
>>
>> Not sure I'd agree. Is there something unsafe about the code here? The hole
>> is plugged. Changing the entire implementation for a copy/paste job doesn't
>> seem like a good thing to me.
> 
> The names are static and can't be changed. IMHO, the whole
> implementation is overkill.

Now that I do agree with. It is certainly an area that needs improved upon.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
