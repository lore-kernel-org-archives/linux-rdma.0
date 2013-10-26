From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 10/10] IB/srp: Make queue size configurable
Date: Sat, 26 Oct 2013 08:13:42 +0200
Message-ID: <526B5D96.4000302@acm.org>
References: <52569806.9080201@acm.org> <52569B6A.30301@acm.org> <1382739213.17280.3.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382739213.17280.3.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/26/13 00:13, David Dillow wrote:
> On Thu, 2013-10-10 at 14:19 +0200, Bart Van Assche wrote:
>> @@ -2267,6 +2310,7 @@ static const match_table_t srp_opt_tokens = {
>>          { SRP_OPT_SG_TABLESIZE,         "sg_tablesize=%u"       },
>>          { SRP_OPT_COMP_VECTOR,          "comp_vector=%u"        },
>>          { SRP_OPT_TL_RETRY_COUNT,       "tl_retry_count=%u"     },
>> +       { SRP_OPT_CAN_QUEUE,            "can_queue=%d"          },
>>          { SRP_OPT_ERR,                  NULL                    }
>
> Minor question -- I thought you had ended up suggesting queue_size
> instead of can_queue here?

Sorry, forgot to change that. Will post an update.

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
