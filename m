From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Re: Possible process deadlock in RMPP flow
Date: Tue, 20 Oct 2009 09:48:59 +0200
Message-ID: <20091020074859.GA27129@mtls03>
References: <20090923150454.GA26150@mtls03>
	<7A32EEE20DF5432CADB60B8F8B1E0093@amr.corp.intel.com>
	<20090923172532.GA32223@mtls03> <4ABB13F3.1060702@Voltaire.com>
	<20090924073601.GA28876@mtls03> <4AC848E9.6040909@voltaire.com>
	<4AC8BE74.3050200@mellanox.co.il>
	<BFC792E8570C48B8981C34F913243887@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BFC792E8570C48B8981C34F913243887-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 19, 2009 at 01:30:47PM -0700, Sean Hefty wrote:
> 
> I can't find anything off in the code for this.  It's odd, since
> unregister_mad_agent() does:
> 
>         flush_workqueue(port_priv->wq);
>         ib_cancel_rmpp_recvs(mad_agent_priv);
> 
> and ib_cancel_rmpp_recvs() does:
> 
>         spin_lock_irqsave(&agent->lock, flags);
>         list_for_each_entry(rmpp_recv, &agent->rmpp_list, list) {
>                 cancel_delayed_work(&rmpp_recv->timeout_work);
>                 cancel_delayed_work(&rmpp_recv->cleanup_work);
>         }
>         spin_unlock_irqrestore(&agent->lock, flags);
> 
>         flush_workqueue(agent->qp_info->port_priv->wq);
> 
> which basically just flushes the same work queue.
> 
> I haven't been able to reproduce the problem, but I'm running the latest kernel
> - not sure that matters in this case.  Does ibnetdiscover just hang forever at
> the end of the test when this occurs?  Is there any more information available?
> 

We are checking if the problem is a firmware bug, it looks like it.
Once we verify this I will send an update. 
