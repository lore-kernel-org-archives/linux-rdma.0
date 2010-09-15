From: Zach Brown <zach.brown-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to safely tear down a cm_id?
Date: Wed, 15 Sep 2010 14:41:16 -0700
Message-ID: <20100915214116.GA9408@takashi.us.oracle.com>
References: <20100915192954.GA7566@takashi.us.oracle.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB6B2AC4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB6B2AC4-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> rdma_destroy_id will block until all CM callbacks complete.  rdma_disconnect
> does not.  It merely issues or responds to a disconnect request.  If it issues
> a disconnect request, then a disconnect callback will eventually follow,
> possibly before rdma_disconnect returns.  

Thanks, that's just the sort of detail I was looking for.  Now to audit some
code.

- z
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
