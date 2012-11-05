From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB: fix task hanging on error recovery
Date: Mon, 5 Nov 2012 09:51:24 -0800
Message-ID: <CAL1RGDWQnyHighw4vV67ReapEyTJHr4xuKfdRzqJhJP9d5AQVg@mail.gmail.com>
References: <1350683896-3928-1-git-send-email-klebers@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350683896-3928-1-git-send-email-klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thadeu Lima de Souza Cascardo <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 19, 2012 at 2:58 PM, Kleber Sacilotto de Souza
<klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>  void rdma_addr_unregister_client(struct rdma_addr_client *client)
>  {
>         put_client(client);
> -       wait_for_completion(&client->comp);
> +       wait_for_completion_timeout(&client->comp, 5*HZ);
>  }
>  EXPORT_SYMBOL(rdma_addr_unregister_client);

This type of change looks pretty risky to me.  Aren't we just letting
things continue with a potential use-after-free hanging around?

Where does 5 seconds as a timeout come from?  Can we be confident that
nothing will complete client->comp after 5 seconds?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
