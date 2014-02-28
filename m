From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC] dapltest: Add final send/recv "sync" for transaction	tests.
Date: Fri, 28 Feb 2014 14:25:40 -0600
Message-ID: <00b501cf34c3$3f50a2f0$bdf1e8d0$@opengridcomputing.com>
References: <20140228171428.30473.82786.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140228171428.30473.82786.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Arlin,

This fix isn't quite correct:  If one side finishes its transaction IO, then posts the final sync SEND, but the peer hasn't finished with its transaction IO, then the peer could post a READ request, for example, and then wait for the READ completion.  However the READ response would get sent behind the local side's final sync SEND and wouldn't be placed because the peer's final sync RECV hasn't been posted yet.  Sigh.  I'll need to think more on this, but I'd like feedback if anybody has opinions/questions/comments...

Steve.

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Friday, February 28, 2014 11:14 AM
> To: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH RFC] dapltest: Add final send/recv "sync" for transaction
> tests.
> 
> The transaction tests need both sides to send a sync message after running
> the test.  This ensures that all remote operations are complete before
> dapltest deregeisters memory and disconnects the endpoints.
> 
> Without this logic, we see async errors on iwarp devices because a read
> or write arrives after the rmr has been destroyed.  I believe this is
> more likely to happen with iWARP than IB because iWARP completions only
> indicate the local buffer can be reused.  It doesn't imply that the
> message has even arrived at the peer, let alone been placed in memory.
> 
> I've tested this on cxgb4 only so far.
> 
> Similar logic is probably needed for the performance tests as well.
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
> 
>  test/dapltest/test/dapl_transaction_stats.c |   10 ++
>  test/dapltest/test/dapl_transaction_test.c  |  139
> +++++++++++++++++++++++++++
>  2 files changed, 149 insertions(+), 0 deletions(-)
> 
> diff --git a/test/dapltest/test/dapl_transaction_stats.c
> b/test/dapltest/test/dapl_transaction_stats.c
> index f9d6377..6422ee3 100644
> --- a/test/dapltest/test/dapl_transaction_stats.c
> +++ b/test/dapltest/test/dapl_transaction_stats.c
> @@ -59,6 +59,16 @@
> DT_transaction_stats_set_ready(DT_Tdep_Print_Head * phead,
>  	DT_Mdep_Unlock(&transaction_stats->lock);
>  }
> 
> +void
> +DT_transaction_stats_reset_wait_count(DT_Tdep_Print_Head * phead,
> +			       Transaction_Stats_t * transaction_stats,
> +			       unsigned int num)
> +{
> +	DT_Mdep_Lock(&transaction_stats->lock);
> +	transaction_stats->wait_count = num;
> +	DT_Mdep_Unlock(&transaction_stats->lock);
> +}
> +
>  bool
>  DT_transaction_stats_wait_for_all(DT_Tdep_Print_Head * phead,
>  				  Transaction_Stats_t * transaction_stats)
> diff --git a/test/dapltest/test/dapl_transaction_test.c
> b/test/dapltest/test/dapl_transaction_test.c
> index 779ea86..b94a2cc 100644
> --- a/test/dapltest/test/dapl_transaction_test.c
> +++ b/test/dapltest/test/dapl_transaction_test.c
> @@ -1799,6 +1799,145 @@ DT_Transaction_Run(DT_Tdep_Print_Head *
> phead, Transaction_Test_t * test_ptr)
>  		}		/* end loop for each op */
>  	}			/* end loop for iteration */
> 
> +	/*
> +	 * Final sync up to ensure all previous remote operations have
> +	 * finished.
> +	 *
> +	 * Without a final sync exchange, we see async errors on iwarp
> +	 * devices because a read or write arrives after the rmr has
> +	 * been destroyed.  I believe this is more likely to happen with
> +	 * iWARP than IB because iWARP completions only indicate the
> +	 * local buffer can be reused.  It doesn't imply that the
> +	 * message has even arrived at the peer, let alone been placed in
> memory.
> +	 */
> +	if (test_ptr->is_server) {
> +		/*
> +		 * Server
> +		 */
> +		DT_Tdep_PT_Debug(1,
> +				 (phead,
> +				  "Test[" F64x "]: Send Final Sync to
> Client\n",
> +				  test_ptr->base_port));
> +		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
> +			if (!DT_post_recv_buffer(phead,
> +						 test_ptr-
> >ep_context[i].ep_handle,
> +						 test_ptr-
> >ep_context[i].bp,
> +						 SYNC_RECV_BUFFER_ID,
> SYNC_BUFF_SIZE)) {
> +				goto bail;
> +			}
> +			if (!DT_post_send_buffer(phead,
> +						 test_ptr->ep_context[i].
> +						 ep_handle,
> +						 test_ptr-
> >ep_context[i].bp,
> +						 SYNC_SEND_BUFFER_ID,
> +						 SYNC_BUFF_SIZE)) {
> +				DT_Tdep_PT_Debug(1,
> +						 (phead,
> +						  "Test[" F64x
> +						  "]: Server final sync send
> error\n",
> +						  test_ptr->base_port));
> +				goto bail;
> +			}
> +		}
> +		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
> +			DAT_DTO_COMPLETION_EVENT_DATA dto_stat;
> +
> +			if (!DT_dto_event_wait(phead,
> +					       test_ptr->ep_context[i].
> +					       reqt_evd_hdl, &dto_stat)) {
> +				DT_Tdep_PT_Debug(1,
> +						 (phead,
> +						  "Test[" F64x
> +						  "]: Server final sync send
> error\n",
> +						  test_ptr->base_port));
> +
> +				goto bail;
> +			}
> +		}
> +
> +		DT_Tdep_PT_Debug(1,
> +				 (phead,
> +				  "Test[" F64x "]: Wait for Final Sync
> Message\n",
> +				  test_ptr->base_port));
> +		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
> +			DAT_DTO_COMPLETION_EVENT_DATA dto_stat;
> +
> +			if (!DT_dto_event_wait(phead,
> +					       test_ptr->ep_context[i].
> +					       recv_evd_hdl, &dto_stat)) {
> +				DT_Tdep_PT_Debug(1,
> +						 (phead,
> +						  "Test[" F64x
> +						  "]: Server final sync recv
> error\n",
> +						  test_ptr->base_port));
> +				goto bail;
> +			}
> +		}
> +	} else {
> +
> +		/*
> +		 * Client
> +		 */
> +		DT_Tdep_PT_Debug(1,
> +				 (phead,
> +				  "Test[" F64x "]: Wait for Final Sync
> Message\n",
> +				  test_ptr->base_port));
> +		DT_transaction_stats_reset_wait_count(phead,
> +					       &test_ptr->pt_ptr->
> +					       Client_Stats,
> +					       test_ptr->cmd-
> >eps_per_thread);
> +		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
> +			DAT_DTO_COMPLETION_EVENT_DATA dto_stat;
> +
> +			if (!DT_post_recv_buffer(phead,
> +						 test_ptr-
> >ep_context[i].ep_handle,
> +						 test_ptr-
> >ep_context[i].bp,
> +						 SYNC_RECV_BUFFER_ID,
> SYNC_BUFF_SIZE)) {
> +				goto bail;
> +			}
> +			if (!DT_dto_event_wait(phead,
> +					       test_ptr->ep_context[i].
> +					       recv_evd_hdl, &dto_stat)) {
> +				DT_Tdep_PT_Debug(1,
> +						 (phead,
> +						  "Test[" F64x
> +						  "]: Client final sync recv
> error\n",
> +						  test_ptr->base_port));
> +				goto bail;
> +			}
> +			DT_transaction_stats_set_ready(phead,
> +						       &test_ptr->pt_ptr->
> +						       Client_Stats);
> +		}
> +		DT_Tdep_PT_Debug(1,
> +				 (phead, "Test[" F64x "]: Send Final Sync
> Msg\n",
> +				  test_ptr->base_port));
> +		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
> +			if (!DT_post_send_buffer(phead,
> +						 test_ptr->ep_context[i].
> +						 ep_handle,
> +						 test_ptr-
> >ep_context[i].bp,
> +						 SYNC_SEND_BUFFER_ID,
> +						 SYNC_BUFF_SIZE)) {
> +				DT_Tdep_PT_Debug(1,
> +						 (phead,
> +						  "Test[" F64x
> +						  "]: Client sync send
> error\n",
> +						  test_ptr->base_port));
> +				goto bail;
> +			}
> +		}
> +		for (i = 0; i < test_ptr->cmd->eps_per_thread; i++) {
> +			DAT_DTO_COMPLETION_EVENT_DATA dto_stat;
> +
> +			if (!DT_dto_event_wait(phead,
> +					       test_ptr->ep_context[i].
> +					       reqt_evd_hdl, &dto_stat)) {
> +				goto bail;
> +			}
> +		}
> +	}
> +
>  	/* end time and print stats */
>  	test_ptr->stats.end_time = DT_Mdep_GetTime();
>  	if (!test_ptr->pt_ptr->local_is_server) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
