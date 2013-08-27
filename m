From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V5 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Tue, 27 Aug 2013 15:37:17 +0300
Message-ID: <521C9D7D.5010304@mellanox.com>
References: <1376477911-13828-1-git-send-email-ogerlitz@mellanox.com> <1376477911-13828-4-git-send-email-ogerlitz@mellanox.com> <CAL1RGDX=ppDWfzVmcFyKOSqYJ-JecPpmdxj+unzL4gWBEKS1vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDX=ppDWfzVmcFyKOSqYJ-JecPpmdxj+unzL4gWBEKS1vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 26/8/2013 10:01 PM, Roland Dreier wrote:
> On Wed, Aug 14, 2013 at 3:58 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> +       if (cmd.flow_attr.num_of_specs) {
>> +               kern_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
>> +               if (!kern_flow_attr)
>> +                       return -ENOMEM;
>> +
>> +               memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
>> +               kern_attr_size = cmd.flow_attr.size - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr_ex);
>> +               if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
>> +                                  kern_attr_size)) {
>> +                       err = -EFAULT;
>> +                       goto err_free_attr;
>> +               }
>> +       } else {
>
> This looks risky... it's basically taking size fields passed in from
> userspace and trusting them enough to pass directly to kmalloc.  In
> fact kern_attr_size is a plain int and I don't see even enogh checking
> to make sure it's positive (nothing I see enforces that
> cmd.flow_attr.size > sizeof(cmd) + sizeof(struct
> ib_uverbs_cmd_hdr_ex)).
>
>   - R.
>

You are correct. We'll fix it in V6.

     - Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
