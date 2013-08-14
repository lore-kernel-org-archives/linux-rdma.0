From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 2/4] IB/core: Infra-structure to support verbs
 extensions through uverbs
Date: Wed, 14 Aug 2013 12:06:31 +0300
Message-ID: <520B4897.2010608@mellanox.com>
References: <1375873322-19384-1-git-send-email-ogerlitz@mellanox.com> <1375873322-19384-3-git-send-email-ogerlitz@mellanox.com> <CAL1RGDXJtrc849M6_XNZT5xO1+ybKtLWGq6yg6LhoSsKpsmkYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXJtrc849M6_XNZT5xO1+ybKtLWGq6yg6LhoSsKpsmkYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13/08/2013 22:18, Roland Dreier wrote:
>> >+struct ib_uverbs_cmd_hdr_ex {
>> >+       __u32 command;
>> >+       __u16 in_words;
>> >+       __u16 out_words;
>> >+       __u16 provider_in_words;
>> >+       __u16 provider_out_words;
>> >+       __u32 cmd_hdr_reserved;
>> >+};
>> >+
> If I understand the vague explanations and the analogy to the
> presentation about userspace, then cmd_hdr_reserved is supposed to be
> used as a mask field.  Should a kernel that doesn't understand any
> mask components make sure that this reserved field is 0, and return an
> error if it isn't?  I don't see any code to do that, and it seems to
> risk new userspace silently getting wrong answers on an old kernel.
>
> Is there any reason not to name it as a mask field from the start?


NO.

The last field in the extended uverbs command header isn't for extending 
the command for which this instance serves as the header. Each new 
command which is defined in the extensions framework carries a comp_mask 
as the first field its specificstructure, for example


+struct ib_uverbs_create_flow  {
+	__u32 comp_mask;
+	__u64 response;
+	__u32 qp_handle;
+	struct ib_kern_flow_attr flow_attr;
+};

+struct ib_uverbs_destroy_flow  {
+	__u32 comp_mask;
+	__u32 flow_handle;
+};
+


As for new/modified user space working on old/unmodified kernel driver, 
the kernel will simply return -EINVAL based on inspecting the command 
field. This field is the first one in both the non-extended (old) and 
the extended (new) header.


> static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>                              size_t count, loff_t *pos)
> {
>         struct ib_uverbs_file *file = filp->private_data;
>         struct ib_uverbs_cmd_hdr hdr;
>
>         if (count < sizeof hdr)
>                 return -EINVAL;
>
>         if (copy_from_user(&hdr, buf, sizeof hdr))
>                 return -EFAULT;
>
>         if (hdr.in_words * 4 != count)
>                 return -EINVAL;
>
>         if (hdr.command >= ARRAY_SIZE(uverbs_cmd_table) ||
>             !uverbs_cmd_table[hdr.command]) <-- old kernels will 
> return error here
>                 return -EINVAL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
