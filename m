From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 05/11] libbnxtre: Allow apps to poll for
 flushed completions
Date: Sun, 29 Jan 2017 16:11:03 -0700
Message-ID: <20170129231103.GE24051@obsidianresearch.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-6-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-6-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 28, 2017 at 05:13:36PM -0500, Devesh Sharma wrote:
> +#ifndef __BNXT_RE_LIST_H__
> +#define __BNXT_RE_LIST_H__
> +
> +struct bnxt_re_list_node {
> +	uint8_t valid;
> +	struct bnxt_re_list_node *next, *prev;
> +};
> +
> +struct bnxt_re_list_head {
> +	struct bnxt_re_list_node node;
> +	pthread_mutex_t lock;
> +};
> +
> +#define DBLY_LIST_HEAD_INIT(name) {{true, &name.node, &name.node},\
> +				    PTHREAD_MUTEX_INITIALIZER}
> +
> +#define DBLY_LIST_HEAD(name) \
> +	struct bnxt_re_list_head name = DBLY_LIST_HEAD_INIT(name) \
> +
> +#define INIT_DBLY_LIST_NODE(ptr) do {	\
> +	(ptr)->next = (ptr); (ptr)->prev = (ptr); (ptr)->valid = false;	\
> +} while (0)
> +
> +#define INIT_DBLY_LIST_HEAD(ptr) INIT_DBLY_LIST_NODE(ptr.node)
> +
> +static inline void __list_add_node(struct bnxt_re_list_node *new,
> +				   struct bnxt_re_list_node *prev,
> +				   struct bnxt_re_list_node *next)
> +{
> +	next->prev = new;
> +	new->next = next;
> +	new->prev = prev;
> +	prev->next = new;
> +}

Nope on this entire file, use ccan/list.h

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
