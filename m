From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IPoIB: synchronize timer deletion with
	completion handler
Date: Thu, 10 Dec 2009 13:37:02 +0200
Message-ID: <20091210113701.GA18037@mtls03>
References: <20091207172210.GA8441@mtls03>
	<adapr6npya2.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adapr6npya2.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2009 at 02:39:49PM -0800, Roland Dreier wrote:
> 
>  > When calling del_timer_sync on priv->poll_timer, it is necessary to prevent
>  > farther arming of the timer which can be done by a completion handler. Though
>  > it is harmless since the timer will eventually stop being rearmed, it is better
>  > practice to avoid calling the timer function after it is deleted. This patch
>  > handles this by using a new flag that is checked before arming the timer.
> 
> have you seen this in practice?  If it can happen then it's not
> harmless, since the module could be unloaded with the timer pending.
> However I don't see how it could happen, since we only seem to delete
> the timer after we know that no more completions are coming (except for
> the case where we decide that the hardware is wedged but it really only
> takes a *long* time to respond at exactly the wrong time, and we somehow
> get a completion between the del_timer_sync and the modify QP to reset
> state -- which is so unlikely it seems not worth adding this extra
> complexity for -- maybe we could add the del_timer_sync to after we
> delete the CQ or something if you're really worried)

No, I haven't actually seen this happening but I think it could.
Consider this scenario:

1. ipoib_send() calls ib_req_notify_cq()
2. ipoib_ib_dev_stop() gets called
3. All pending WR complete; interrupt is generated but not yet
serviced.
4. ipoib_ib_dev_stop() calls del_timer_sync() and passes it.
5. Completion handler is finally serviced - it schedules
ipoib_ib_tx_timer_func()
6. IPoIB unloads and we're in trouble.

Not so likely to happen indeed. Your suggestion to defer deleting the
timer until after the CQ is destroyed will also solve this.
