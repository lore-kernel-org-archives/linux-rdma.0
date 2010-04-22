From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Thu, 22 Apr 2010 11:03:54 -0700
Message-ID: <adaljcfmkj9.fsf@roland-alpha.cisco.com>
References: <201002281102.21207.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201002281102.21207.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Jack Morgenstein's
	message of "Sun, 28 Feb 2010 11:02:21 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

So I'm looking at merging this, and I'm wondering about one thing.
Seems like it's just a mistake but I want to make sure I understand
properly:

 > @@ -1078,6 +1079,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 >  		goto err_put;
 >  	}
 >  
 > +	attr.create_flags  = 0;
 >  	attr.event_handler = ib_uverbs_qp_event_handler;

This looks redundant, because this function already sets create_flags to
0 a few lines later.  So I think this line is just a remnant from some
other patch.

But then ib_uverbs_create_xrc_rcv_qp() doesn't set create_flags before
the call to device->create_xrc_rcv_qp() -- which maybe is OK, since that
function is not going to look at create_flags right now, but for the
future we should probably set it to 0, right?

Also it's not 100% clear to me why the low-level driver needs a special
create_xrc_rcv_qp method, rather than having uverbs just call create_qp
with the right parameters.  But I haven't looked throught carefully to
see the differences between eg query_xrc_rcv_qp() vs query_qp() methods.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
