From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/47] IB/cm: Suppress gcc 7 fall-through complaints
Date: Tue, 10 Oct 2017 15:49:22 -0400
Message-ID: <09736345-fb33-5cde-b571-862454334faf@intel.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-3-bart.vanassche@wdc.com>
 <849d304a-fa89-0d6a-6edb-cf34780e41a8@intel.com>
 <20171010193127.GK2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010193127.GK2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/2017 3:31 PM, Leon Romanovsky wrote:
> On Tue, Oct 10, 2017 at 03:27:11PM -0400, Dennis Dalessandro wrote:
>> On 10/6/2017 5:32 PM, Bart Van Assche wrote:
>>> Avoid that gcc 7 reports the following warning when building with W=1:
>>>
>>> warning: this statement may fall through [-Wimplicit-fallthrough=]
>>>
>>> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
>>> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> ---
>>>    drivers/infiniband/core/cm.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>>> index d80911d4abb7..5927ee4e57ca 100644
>>> --- a/drivers/infiniband/core/cm.c
>>> +++ b/drivers/infiniband/core/cm.c
>>> @@ -2808,6 +2808,7 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
>>>    			msg_response = CM_MSG_RESPONSE_OTHER;
>>>    			break;
>>>    		}
>>> +		/* fall through */
>>>    	default:
>>>    		ret = -EINVAL;
>>>    		goto error1;
>>>
>>
>> So adding the comment is enough to make gcc shut up? Or are you just
>> annotating the code so it's obvious it was intentional?
> 
> GCC is looking for the specific comment.
> ---
> -Wimplicit-fallthrough warns when a switch case falls through.
> This warning has five different levels. The compiler is able to parse a wide range of fallthrough comments,
> depending on the level. It also handles control-flow statements, such as ifs.
> It's possible to suppress the warning by either adding a fallthrough comment,
> or by using a null statement: __attribute__ ((fallthrough)); (C, C++),
> or [[fallthrough]]; (C++17), or [[gnu::fallthrough]]; (C++11/C++14).
> ---
> https://gcc.gnu.org/gcc-7/changes.html
> 
> Thanks

Ah, makes sense now, thanks Leon.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
