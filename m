From: Levente Kurusa <levex-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv4]Checks for Null value in function *get_skub
Date: Mon, 16 Jun 2014 17:33:06 +0200
Message-ID: <539F0E32.50100@linux.com>
References: <1402932328-3732-1-git-send-email-xerofoify@gmail.com> <539F0DAF.1020802@opengridcomputing.com>
Reply-To: Levente Kurusa <levex-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <539F0DAF.1020802-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/16/2014 05:30 PM, Steve Wise wrote:
> On 6/16/2014 10:25 AM, Nicholas Krause wrote:
>> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
>> index f9477e2..2d56983 100644
>> --- a/drivers/infiniband/hw/cxgb4/cm.c
>> +++ b/drivers/infiniband/hw/cxgb4/cm.c
>> @@ -340,15 +340,13 @@ static int status2errno(int status)
>>    */
>>   static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>>   {
>>   if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>>                  skb_trim(skb, 0);
>>                  skb_get(skb);
>>                  skb_reset_transport_header(skb);
>>       } else {
>> +        if (skb)
>> +            kfree_skb (skb);
>>           skb = alloc_skb(len, gfp);
>>       }
>>       t4_set_arp_err_handler(skb, NULL, NULL);
>
> Can you change the comment?  This patch is now fixing a potential skb leak.
> Also, kfree_sb() will ignore NULL ptrs, so we could just always call it.
 > But I'd add a comment like /* NULL is ignored */.

AFAIK, checkpatch.pl will show you a message if it detects this:

if (x)
     kfree(x);

so I guess it is not really needed.

Thanks,
     Levente Kurusa.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
