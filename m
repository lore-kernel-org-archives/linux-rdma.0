From: David Dillow <dad-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Make queue size configurable
Date: Mon, 09 Sep 2013 23:01:20 -0400
Message-ID: <1378782080.3794.6.camel@feather.ornl.gov>
References: <521363EA.8080906@acm.org> <52136609.3090406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52136609.3090406-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2013-08-20 at 14:50 +0200, Bart Van Assche wrote:
> @@ -2227,6 +2270,7 @@ static const match_table_t srp_opt_tokens = {
>         { SRP_OPT_SG_TABLESIZE,         "sg_tablesize=%u"       },
>         { SRP_OPT_COMP_VECTOR,          "comp_vector=%u"        },
>         { SRP_OPT_TL_RETRY_COUNT,       "tl_retry_count=%u"     },
> +       { SRP_OPT_CAN_QUEUE,            "can_queue=%d"          },

I'm pretty much OK with the patch, but since we're stuck with it going
forward, I'd like to have a better externally visible name here --
queue_depth? max_queue? queue_size?

Otherwise,
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
