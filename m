From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Mon, 26 Aug 2013 11:58:05 -0700
Message-ID: <CAL1RGDWSLCRr0ZYis1aj9xUR7B99zYV+4L-72BTeqV0d=z_NfQ@mail.gmail.com>
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
> +struct ib_uverbs_create_flow  {
> +       __u32 comp_mask;
> +       __u64 response;
> +       __u32 qp_handle;
> +       struct ib_kern_flow_attr flow_attr;
> +};
> +
> +struct ib_uverbs_create_flow_resp {
> +       __u32 comp_mask;
> +       __u32 flow_handle;
> +};
> +
> +struct ib_uverbs_destroy_flow  {
> +       __u32 comp_mask;
> +       __u32 flow_handle;
> +};

I don't see any other place where any of these comp_mask fields are
referenced in the patch.  Am I misunderstanding the new uverbs command
scheme, or does the code need to make sure these are 0 so that it's
not silently ignoring some future extension fields?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
