From: Zach Brown <zach.brown-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: how to safely tear down a cm_id?
Date: Wed, 15 Sep 2010 12:29:54 -0700
Message-ID: <20100915192954.GA7566@takashi.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi gang,

We're chasing some bugs in RDS.  In trying to explore possible causes I found
that I don't really understand the sequence of events needed to safely tear
down a cm_id.

I'm worried that we have cm event callbacks being processed in the ib_cm thread
racing with our krds thread which is tearing down the cm_id.

If you get rid of unrelated rds-specific teardown and error checking, our cm_id
teardown (rds_ib_conn_shutdown()) simplifies down to:

		rdma_disconnect(cm_id);
		rdma_destroy_qp(cm_id);
                rdma_destroy_id(cm_id);

We blow through all of those without waiting for anything specifically CM
related.  We could wait for some send and receive work completions, sure, but
we might not if the universe aligns just right and everything is idle when we
tear things down.

Is it safe to blow through those calls while the ib_cm thread might be
processing a callback for the given cm_id?   Should we be serializing the two
specifically?

I think this code was initially written under the assumption that
rmda_disconnect() would only return once all CM callbacks completed.  I'm
worried that rdma_disconnect() doesn't work that way.

- z
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
