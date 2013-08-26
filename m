From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Mon, 26 Aug 2013 12:01:08 -0700
Message-ID: <CAL1RGDX=ppDWfzVmcFyKOSqYJ-JecPpmdxj+unzL4gWBEKS1vg@mail.gmail.com>
References: <1376477911-13828-1-git-send-email-ogerlitz@mellanox.com> <1376477911-13828-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376477911-13828-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 14, 2013 at 3:58 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> +       if (cmd.flow_attr.num_of_specs) {
> +               kern_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
> +               if (!kern_flow_attr)
> +                       return -ENOMEM;
> +
> +               memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
> +               kern_attr_size = cmd.flow_attr.size - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr_ex);
> +               if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
> +                                  kern_attr_size)) {
> +                       err = -EFAULT;
> +                       goto err_free_attr;
> +               }
> +       } else {

This looks risky... it's basically taking size fields passed in from
userspace and trusting them enough to pass directly to kmalloc.  In
fact kern_attr_size is a plain int and I don't see even enogh checking
to make sure it's positive (nothing I see enforces that
cmd.flow_attr.size > sizeof(cmd) + sizeof(struct
ib_uverbs_cmd_hdr_ex)).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
