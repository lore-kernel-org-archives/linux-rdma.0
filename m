From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Undo changes in memory range tree when madvise() fails
Date: Fri, 15 Jan 2010 10:54:50 -0800
Message-ID: <adad41bi4g5.fsf@roland-alpha.cisco.com>
References: <4B12A679.3000800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B12A679.3000800-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Alex Vainman's message of "Sun, 29
	Nov 2009 18:51:05 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This looks pretty good overall -- thanks for taking this on, I've been
meaning to fix this for a long time, but never got around to it.

However, I'm having a bit of a hard time following the cleanups vs. real
changes in this patch -- could you break it up into (at least) two
steps?  ie one patch that just factors code out into merge_ranges()
etc. and then a second patch that makes the fixes for handling madvise
failures?  I think that would make the second patch much easier to
understand.  And if you can split the second patch further, that might
make it even easier to review.

Also some specific comments:

 > +static struct ibv_mem_node *merge_ranges(struct ibv_mem_node *node,
 > +					 struct ibv_mem_node *prev)
 > +{
 > +	struct ibv_mem_node *new_node = NULL;
 > +
 > +	prev->end = node->end;
 > +	prev->refcnt = node->refcnt;
 > +	__mm_remove(node);
 > +	new_node = prev;
 > +
 > +	return new_node;
 > +}

why do you have the new_node variable at all?  why can't this just be
written as:

+static struct ibv_mem_node *merge_ranges(struct ibv_mem_node *node,
+					 struct ibv_mem_node *prev)
+{
+	prev->end = node->end;
+	prev->refcnt = node->refcnt;
+	__mm_remove(node);
+	return prev;
+}

 > +	else{

should be a space after the "else" -- please make sure all the
trivial formatting is OK.

 > +	/*
 > +	 * This condition can be true only if we merged node which begins at start
 > +	 * and ends at node->end with previous node which begins at node->start
 > +	 * and ends at start - 1
 > +	 */

these and a few other comments make pretty long lines for no really good
reason -- please try to end comments before, say, column 75.

 > +						 uintptr_t *p_end,
 > +						 int *p_inc,
 > +						 int *p_advice)

I prefer not to use hungarian notation for variable names.

 > +						node = prepare_to_roll_back(node, start, &end, &inc, &advice);

I'm OK with lines over 80 characters, but 110 is a bit too
much... please try to split the function up a bit so this isn't indented
by 6 tabs.  (This over-long line is a symptom of the fact that things
are too deeply nested here)

 > @@ -568,3 +665,5 @@ int ibv_dofork_range(void *base, size_t size)
 >  		return 0;
 >  	}
 >  }
 > +
 > +

extra chunk, just get rid of this change.

Thanks,
  Roland

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
