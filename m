From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCHv4]Checks for Null value in function *get_skub
Date: Mon, 16 Jun 2014 11:37:50 -0500
Message-ID: <539F1D5E.30505@opengridcomputing.com>
References: <1402932328-3732-1-git-send-email-xerofoify@gmail.com>	<539F0DAF.1020802@opengridcomputing.com> <CAPDOMVjd9J=Kz4d88==UsbfjH13mhGzzmbc2NnxSOfqJs_aGpQ@mail.gmail.com> <539F112F.7030303@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <539F112F.7030303-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Levente Kurusa <levex-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Nick Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/16/2014 10:45 AM, Levente Kurusa wrote:
> On 06/16/2014 05:37 PM, Nick Krause wrote:
>> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/cxgb4/
>> cm.c | 8 +++-----
>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/cm.c 
>> b/drivers/infiniband/hw/cxgb4/cm.c
>> index f9477e2..2d56983 100644
>> --- a/drivers/infiniband/hw/cxgb4/cm.c
>> +++ b/drivers/infiniband/hw/cxgb4/cm.c
>> @@ -340,15 +340,13 @@ static int status2errno(int status)
>>    */
>>   static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t 
>> gfp)
>>   {
>>   if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>>                  skb_trim(skb, 0);
>>                  skb_get(skb);
>>                  skb_reset_transport_header(skb);
>>          } else {
>> +               if (skb)
>> /* NULL is ignored */.
>> +                       kfree_skb (skb);
>>                  skb = alloc_skb(len, gfp);
>>          }
>>          t4_set_arp_err_handler(skb, NULL, NULL);
>
> This patch is severely whitespace damaged. Can you fix your MUA
> or try to use git-send-email?
>
> The changelog as well is of low quality. Maybe something like this:
>
> infiniband: cxgb4: fix memory skb memory leak
>
> ... would be better.
>
> Also, this fails the build, due to the extra dot character after
> the comment. :-(
>

Agreed.  Start over with this patch,  do what we asked, and make sure it 
passes checkpatch...


> Thanks,
>     Levente Kurusa.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
