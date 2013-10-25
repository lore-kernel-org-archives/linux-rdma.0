From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 10/10] IB/srp: Make queue size configurable
Date: Fri, 25 Oct 2013 18:13:33 -0400
Message-ID: <1382739213.17280.3.camel@frustration.ornl.gov>
References: <52569806.9080201@acm.org> <52569B6A.30301@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52569B6A.30301-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2013-10-10 at 14:19 +0200, Bart Van Assche wrote:
> @@ -2267,6 +2310,7 @@ static const match_table_t srp_opt_tokens = {
>         { SRP_OPT_SG_TABLESIZE,         "sg_tablesize=%u"       },
>         { SRP_OPT_COMP_VECTOR,          "comp_vector=%u"        },
>         { SRP_OPT_TL_RETRY_COUNT,       "tl_retry_count=%u"     },
> +       { SRP_OPT_CAN_QUEUE,            "can_queue=%d"          },
>         { SRP_OPT_ERR,                  NULL                    }

Minor question -- I thought you had ended up suggesting queue_size
instead of can_queue here?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
