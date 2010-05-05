From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Wed, 5 May 2010 09:45:05 +0300
Message-ID: <201005050945.05729.jackm@dev.mellanox.co.il>
References: <201002281102.21207.jackm@dev.mellanox.co.il> <adavdbaxcs1.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavdbaxcs1.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, diego-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thursday 29 April 2010 22:46, Roland Dreier wrote:
>  > Note that for users who do not wish to utilize the reg/unreg verbs,
>  > a destroy_xrc_rcv_qp verb is also provided.  Thus, usage is:
>  > Either: create/destroy_xrc_rcv_qp
>  > Or: create/reg/unreg_xrc_rcv_qp (the unreg is used in place of destroy) 
> 
> I don't really understand the semantics here.  What is supposed to
> happen if I do create/reg/destroy?> What happens if one process does 
> destroy while another process is still registered?
Maybe we can simply assert that the unreg IS the destroy method of the
IB_SPEC, and get rid of the destroy method.

The xrc target qp section of the spec was not written with QP persistence
(after the creating process exited) in mind.  That requirement surfaced
at the last minute as a result of testing by the MPI community during the
implementation phase (as far as I know).  Unfortunately, this created
a semantic problem.

For applications in which the creating process persists until all other
processes which use the XRC RCV QP have finished with it, no reg/unreg is
needed -- and the API that makes the most sense is create/destroy.

For apps which DO need persistence, we also need a reg/unreg for reference
counting.  In that situation, destroy_xrc_rcv_qp does not make sense as
a pure destroy -- it functions as unreg_xrc_rcv_qp, since it must function
within the reference counting context (unreg also destroys the QP in the
low-level driver when there are no more references to it). In fact, in this
case the semantics of destroy is identical to the semantics of unreg.

I do not see a clean way out of this mess other than to eliminate the
destroy_xrc_rcv_qp method and claim that the unreg is in fact the destroy
method of the SPEC.

> To make everything 
> even more confusing, mlx4 defines unreg_rxc_rcv_qp to be equivalent to
> destroy_xrc_rcv_qp.

I simply noticed that if reg is not used, then the unreg would in fact destroy
the QP.  I therefore saw no reason to implement the destroy method separately.

> I'm not even clear why the low-level driver has two 
> entry points for these two methods -- shouldn't the uverbs core be
> handling the counting/listing of xrc rcv qps and just ask the low-level
> driver to destroy the QP when it's really done with it?
The uverbs layer DOES handle the counting/listing (see, for example, list_add_tail at the
end of ib_uverbs_create_xrc_rcv_qp.

However, I had an additional problem -- to distribute async events received
for the xrc_rcv QP to all registered processes (so that each could unregister
and allow the QP to be destroyed -- the ref count going to zero).

In my original implementation, the low-level driver was responsible for generating
the events for all the processes.  To move this mechanism to the core would require
a fairly extensive re-write.  I would need to introduce ib_core methods for create,
reg, unreg, and destroy, since the uverbs layer operates per user process and does
not track across multiple processes.  I was concerned that modifications of this
magnitude would introduce instability in XRC, and would require a significant QA cycle

Finally, I do not believe that it is such a bad thing to have low-level driver
procedures for reg/unreg here.  If a given low-level driver has implementation
details that it wishes to record, it should have the opportunity to do so.

> 
> (By the way, should we use the name "target QP" instead of "rcv QP" to
> match the actual IB spec?)
I would rather not, since the xrc_rcv QP function names have been in use for 2 years already.

>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
