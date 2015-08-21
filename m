From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v9 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 21 Aug 2015 17:12:03 -0600
Message-ID: <20150821231203.GB16951@obsidianresearch.com>
References: <1439556729-27876-1-git-send-email-kaike.wan@intel.com>
 <1439556729-27876-5-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439556729-27876-5-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 14, 2015 at 08:52:09AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

> +static LIST_HEAD(ib_nl_request_list);
> +static DEFINE_SPINLOCK(ib_nl_request_lock);
> +static atomic_t ib_nl_sa_request_seq;
> +static struct workqueue_struct *ib_nl_wq;
> +static struct delayed_work ib_nl_timed_work;
> +static const struct nla_policy ib_nl_policy[LS_NLA_TYPE_MAX] = {
> +	[LS_NLA_TYPE_PATH_RECORD]	= {.type = NLA_BINARY,
> +		.len = sizeof(struct ib_path_rec_data)},
> +	[LS_NLA_TYPE_TIMEOUT]		= {.type = NLA_U32},
> +	[LS_NLA_TYPE_SERVICE_ID]	= {.type = NLA_U64},
> +	[LS_NLA_TYPE_DGID]		= {.type = NLA_BINARY,
> +		.len = sizeof(struct rdma_nla_ls_gid)},
> +	[LS_NLA_TYPE_SGID]		= {.type = NLA_BINARY,
> +		.len = sizeof(struct rdma_nla_ls_gid)},
> +	[LS_NLA_TYPE_TCLASS]		= {.type = NLA_U8},
> +	[LS_NLA_TYPE_PKEY]		= {.type = NLA_U16},
> +	[LS_NLA_TYPE_QOS_CLASS]		= {.type = NLA_U16},
> +};

I'm not sure a single policy is the right way to use this API. The
majority of cases seem to use a policy per message type. However, I
can't think of a downside.

I'd like to test this again here next week, but I think this is OK
now.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
