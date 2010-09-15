From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: how to safely tear down a cm_id?
Date: Wed, 15 Sep 2010 14:28:51 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB6B2AC4@orsmsx501.amr.corp.intel.com>
References: <20100915192954.GA7566@takashi.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100915192954.GA7566-Mg0Rv1oTIzIdlZp+k6BvrWXnswh1EIUO@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zach.brown-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 		rdma_disconnect(cm_id);
> 		rdma_destroy_qp(cm_id);
>                 rdma_destroy_id(cm_id);
> 
> We blow through all of those without waiting for anything specifically CM
> related.  We could wait for some send and receive work completions, sure,
> but
> we might not if the universe aligns just right and everything is idle when
> we
> tear things down.
> 
> Is it safe to blow through those calls while the ib_cm thread might be
> processing a callback for the given cm_id?   Should we be serializing the
> two
> specifically?
> 
> I think this code was initially written under the assumption that
> rmda_disconnect() would only return once all CM callbacks completed.  I'm
> worried that rdma_disconnect() doesn't work that way.

rdma_destroy_id will block until all CM callbacks complete.  rdma_disconnect does not.  It merely issues or responds to a disconnect request.  If it issues a disconnect request, then a disconnect callback will eventually follow, possibly before rdma_disconnect returns.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
