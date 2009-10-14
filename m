From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 2/4] SRP fail-over faster
Date: Wed, 14 Oct 2009 14:00:22 -0700
Message-ID: <4AD63BE6.3050303@mellanox.com>
References: <4AD3B443.7040107@mellanox.com> <ada63aham2r.fsf@cisco.com>	<4AD62D9D.1020900@mellanox.com> <adatyy190ti.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyy190ti.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > >  > -	wait_for_completion(&target->done);
>  > >
>  > > How do you avoid leaking connection on module unload etc?  Don't we have
>  > > to wait for the disconnect to finish somewhere?
>  > >
>  > >  - R.
>  > >   
>  > Are you talking about cm_id?
>  > I think that we wait because we want to reuse cq/qp associate with the
>  > connection.
>  > On module unload, we destroy cm_id, cq, qp altogether.
>
> OK, I think I understand this piece locally (although if you delete the
> wait_for_completion() it would probably make more sense to delete the
> init_completion() just before it as well).
>
> However is it really a correct to reuse a cm_id that is in state
> timewait to initiate a new connection?  That seems pretty fragile to me.
>   
Understood. However, we have to wait (1 << max(timeout - 8, 0)) ms; 
therefore, we need to disconnect without wait
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
