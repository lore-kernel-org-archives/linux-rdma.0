From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] iser-target: Handle errors from isert_put_datain and
 isert_get_dataout
Date: Fri, 06 Mar 2015 23:19:07 -0800
Message-ID: <1425712747.22358.18.camel@haakon3.risingtidesystems.com>
References: <462EF229174FDB4D92ACE4656EA561005DD2BD41@CMEXMB1.ad.emulex.com>
	 <54FA5F8B.1030003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54FA5F8B.1030003-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Chris Moore <Chris.Moore-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel (target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2015-03-07 at 04:16 +0200, Sagi Grimberg wrote:
> On 3/6/2015 7:56 PM, Chris Moore wrote:
> > isert_put_datain() always returns 1 and isert_get_dataout() always returns 0, even if
> > ib_post_send() fails.   They should return an error in this case so the caller can handle it.
> > Also, in the case of an ib_post_send() failure, user isert_err instead of isert_warn.
> >
> > With these changes, these two functions handle errors from ib_post_send() in the
> > same way as other functions within ib_isert.c
> >
> 
> Hi Chris,
> 
> This is indeed needed, but I'm afraid this is not complete given the
> rc is completely ignored by the callers (see 
> lio_queue_data_in/lio_write_pending).
> 

So lio_write_pending() is propagating up the return back to
transport_generic_new_cmd().  When the return is -EAGAIN or -ENOMEM,
it triggers transport_handle_queue_full() to retry ->write_pending()
from se_device->qf_work_queue context.

It's lio_queue_data_in() + lio_queue_status() that aren't propagating up
failures to trigger queue_full in target_complete_ok_work().  Looking at
this code again for traditional iscsi-target, I don't see a reason why
iscsit_add_cmd_to_response_queue() failure should not be triggering
queue_full logic to kick in.. 

On the iser-target side, is it OK for isert_put_datain() +
isert_put_response() to be re-invoked from transport_complete_qf()
context after ib_post_send() failure..?

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
