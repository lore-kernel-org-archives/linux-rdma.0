From: Nick Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3]Checks for Null value in function *get_skub
Date: Mon, 16 Jun 2014 11:14:45 -0400
Message-ID: <CAPDOMVg8hthn2beTjHx94RRJeRHGGP1wyT0Y2KfscUtZGFfiCA@mail.gmail.com>
References: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>
	<539F096F.8020502@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <539F096F.8020502-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Levente Kurusa <levex-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>From what I know yes so I would close the bug at the the link in
my previous email and just void my patch.
Cheers Nick

On Mon, Jun 16, 2014 at 11:12 AM, Levente Kurusa <levex-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On 06/16/2014 05:08 PM, Nicholas Krause wrote:
>>
>> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/cm.c
>> b/drivers/infiniband/hw/cxgb4/cm.c
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
>>         } else {
>> +               if (skb)
>> +                       kfree (skb);
>>                 skb = alloc_skb(len, gfp);
>>         }
>>         t4_set_arp_err_handler(skb, NULL, NULL);
>>
>
> Isn't kfree(NULL) legal?
>
> (i.e. the if statement is useless)
>
> Thanks,
>     Levente Kurusa
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
