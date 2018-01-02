From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Linux kernel v4.15-rc4 and rdma_rxe
Date: Tue, 2 Jan 2018 19:44:51 +0200
Message-ID: <CAG9sBKOtxoG-HLU5A=WEZqUuADzje74_AjZgtG21Ueeb2YCAEQ@mail.gmail.com>
References: <1513732236.2535.25.camel@wdc.com> <CAG9sBKP=i9ukbkj7x11oW=yLAz8u2RYHTMbf_Z1h3=nQ3pjfLw@mail.gmail.com>
 <1513983674.2579.27.camel@wdc.com> <CAG9sBKOOvvwG6yaQfWG=c04-LQ-Yvw8QbD-jzTm-zJYOFJeEVQ@mail.gmail.com>
 <dd87887d-8641-c8fc-48f1-234e7cf67cb1@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dd87887d-8641-c8fc-48f1-234e7cf67cb1-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> Hello Moni,
>
> The ib_srpt driver uses zero-length writes to trigger the completion handler
> if either an RTU event is received or an RDMA channel is being closed. In
> the log I saw the message "queued zerolength write" appear but not
> "srpt_zerolength_write_done: wc->status = ..." when the hang was observed.
> That made me wonder whether the rxe driver perhaps suppresses completions
> for zero-length writes if the queue pair state is changed into IB_QPS_ERR? I
> think it is required by the IB spec to queue an error completion for pending
> work requests upon the transition to IB_QPS_ERR.
>

Hi Bart
This is a great input for the debugger (whoever that be). From a brief
look at the code I see that error QP is checked when during the
validation of  RDMA_WRITE request. In this case a completion is
generated and the size of the buffer to write remains irrelevant.
However, to verify that I wasn't wrong you can add some printk() in
the path that starts with rxe_responder(). When flow reaches
check_resource() and when QP is in ERROR state the function returns
RESPST_COMPLETE. The next step in the state machine would be to call
the do_complete() function.

thanks

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
