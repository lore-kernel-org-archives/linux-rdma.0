From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] libibverbs: Undo changes in memory range tree when madvise() fails
Date: Fri, 19 Mar 2010 11:15:19 -0700
Message-ID: <adaeijg5gaw.fsf@roland-alpha.cisco.com>
References: <4B666D56.4090708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B666D56.4090708-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Alex Vainman's message of "Mon, 01
	Feb 2010 07:57:42 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +static struct ibv_mem_node *prepare_to_roll_back(struct ibv_mem_node *node,
 > +						 uintptr_t start,
 > +						 uintptr_t *end,
 > +						 int *inc,
 > +						 int *advice)
 > +{
 > +	struct ibv_mem_node *tmp = NULL;
 > +
 > +	*inc *= -1;
 > +	*advice = *inc == 1 ? MADV_DONTFORK : MADV_DOFORK;
 > +	tmp = __mm_prev(node);
 > +	node = NULL;
 > +	if (tmp) {
 > +		*end = tmp->end;
 > +		if (start <= *end)
 > +			node = get_start_node(start, *end, *inc);
 > +	}
 > +	return node;
 > +}

I don't think this really makes sense as a separate function.

You could slightly rearrange the start of ibv_madvise_range:

static int ibv_madvise_range(void *base, size_t size, int advice)
{
	uintptr_t start, end;
	struct ibv_mem_node *node, *tmp;
	int inc;
+	int rolling_back = 0;
	int ret = 0;

	if (!size)
		return 0;

+	start = (uintptr_t) base & ~(page_size - 1);
+	end   = ((uintptr_t) (base + size + page_size - 1) &
+		 ~(page_size - 1)) - 1;

+	pthread_mutex_lock(&mm_mutex);

+again:
	inc = advice == MADV_DONTFORK ? 1 : -1;

	node = get_start_node(start, end, inc);
	if (!node) {
		ret = -1;
		goto out;
	}

and then for the rollback part, do:

+				if (rolling_back || !node)
+					goto out;
+
+				/* madvise failed, roll back previous changes */
+				rolling_back = 1;
+				advice = advice == MADV_DONTFORK ? MADV_DOFORK : MADV_DONTFORK;
+				tmp = __mm_prev(node);
+				if (!tmp)
+					goto out;
+				end = tmp->end;
+				goto again;

(All this untested/uncompiled etc).
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
