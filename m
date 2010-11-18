From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: dat_ep_disconnect() with ABRUPT
Date: Thu, 18 Nov 2010 11:51:13 -0800
Message-ID: <4CE583B1.1010007@linux.vnet.ibm.com>
References: <4CE5650C.1090706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE5650C.1090706-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/18/2010 9:40 AM, Pradeep Satyanarayana wrote:
> Hi Arlin,
> 
> We are seeing some issues with dat_ep_disconnect() with ABRUPT flag. In fact it appears that the ABRUPT flag seems
> to behave like the GRACEFUL flag. One difference between the DAT1.2 and DAT2.0 appears to be the following:
> 
> In dapls_ib_disconnect()
> 
> 
>         /* ABRUPT close, wait for callback and DISCONNECTED state */
>         if (close_flags == DAT_CLOSE_ABRUPT_FLAG) {
>                 dapl_os_lock(&ep_ptr->header.lock);
>                 while (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
>                         dapl_os_unlock(&ep_ptr->header.lock);
>                         dapl_os_sleep_usec(10000);
>                         dapl_os_lock(&ep_ptr->header.lock);
>                 }
>                 dapl_os_unlock(&ep_ptr->header.lock);
>         }
> 
> this loop exists in DAT2.0 and has been removed in DAT1.2. I am not sure why this is leading to different behaviors
> in DAT1.2 and DAT2.0.

I believe I understand this behavior. With the ABRUPT flag set it enters dapls_ib_disconnect() (incorrectly), with DAT_EP_STATE_DISCONNECT_PENDING
set. Hence it gets stuck in the while loop above and behaves no differently from the GRACEFUL case. One way would be to remove the
while loop above as in DAT1.2, or the other alternative (probably more correct?) is what is proposed below.

What are your thoughts?

Thanks
Pradeep
> 
> One thought is that both DAT1.2 and DAT2.0 have a missing check for ABRUPT flag in dapl_ep_disconnect().
> 
>     if ( ep_ptr->param.ep_state == DAT_EP_STATE_ACTIVE_CONNECTION_PENDING ||
>          ep_ptr->param.ep_state == DAT_EP_STATE_COMPLETION_PENDING )
>     {
>         /*
>          * Beginning or waiting on a connection: abort and reset the
>          * state
>          */
>         ep_ptr->param.ep_state  = DAT_EP_STATE_DISCONNECTED;
> 
>         dapl_os_unlock ( &ep_ptr->header.lock );
>         /* disconnect and make sure we get no callbacks */
>         (void) dapls_ib_disconnect (ep_ptr, DAT_CLOSE_ABRUPT_FLAG);
> 
>         /* clean up connection state */
>         dapl_sp_remove_ep (ep_ptr);
> 
>         evd_ptr = (DAPL_EVD *) ep_ptr->param.connect_evd_handle;
>         dapls_evd_post_connection_event (evd_ptr,
>                                         DAT_CONNECTION_EVENT_DISCONNECTED,
>                                         (DAT_HANDLE) ep_ptr,
>                                         0,
>                                         0);
>         dat_status = DAT_SUCCESS;
>         goto bail;
>     }
> 
> The if condition above should also have an additional check for disconnect_flags == ABRUPT. If the EP is in a
> CONNECTED state and the remote end crashes and this node calls dat_ep_disconnect() with ABRUPT, the if condition
> is not true and it is treated as though it was a GRACEFUL disconnect. If you agree with the assessment I can build
> a patch.
> 
> Thanks
> Pradeep
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
