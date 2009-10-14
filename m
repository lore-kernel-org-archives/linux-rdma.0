From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 2/4] SRP fail-over faster
Date: Wed, 14 Oct 2009 13:29:13 -0700
Message-ID: <adatyy190ti.fsf@cisco.com>
References: <4AD3B443.7040107@mellanox.com> <ada63aham2r.fsf@cisco.com>
	<4AD62D9D.1020900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD62D9D.1020900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (Vu Pham's message of "Wed, 14
	Oct 2009 12:59:25 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > >  > -	wait_for_completion(&target->done);
 > >
 > > How do you avoid leaking connection on module unload etc?  Don't we have
 > > to wait for the disconnect to finish somewhere?
 > >
 > >  - R.
 > >   
 > Are you talking about cm_id?
 > I think that we wait because we want to reuse cq/qp associate with the
 > connection.
 > On module unload, we destroy cm_id, cq, qp altogether.

OK, I think I understand this piece locally (although if you delete the
wait_for_completion() it would probably make more sense to delete the
init_completion() just before it as well).

However is it really a correct to reuse a cm_id that is in state
timewait to initiate a new connection?  That seems pretty fragile to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
