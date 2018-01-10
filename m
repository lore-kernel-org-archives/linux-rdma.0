From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Wed, 10 Jan 2018 15:43:08 -0700
Message-ID: <CALEgSQu0nRU2pTDcf3Ke0x-cjgZtvAAMbqbEuN=W5YnOmX+W8A@mail.gmail.com>
References: <5a5016c0.4c0a620a.ed2b3.60da@mx.google.com> <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
 <1515528956.3919.3.camel@redhat.com> <1515529869.3919.4.camel@redhat.com>
 <1515531079.2721.26.camel@wdc.com> <1515531652.26021.1.camel@redhat.com>
 <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
 <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
 <20180110191758.GL4518@ziepe.ca> <1515612733.2745.27.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515612733.2745.27.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 12:32 PM, Bart Van Assche
<Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:
> On Wed, 2018-01-10 at 12:17 -0700, Jason Gunthorpe wrote:
>> But that has nothing directly to do with the lifetime of, say, struct
>> srp_request which contains ib_wc->wr_cqe?
>>
>> eg freeing struct srp_request before the wrid has passed through the
>> CQ poll would produce these sorts of symptoms...
>
> Hello Jason,
>
> The SRP initiator driver RDMA channel shutdown sequence is as follows:
> * srp_remove_target() calls srp_free_ch_ib(). That last function calls
>   srp_destroy_qp() which in turn calls ib_drain_qp(). ib_drain_qp() waits until
>   all CQEs have been dequeued by changing the QP state into IB_QPS_ERR and by
>   waiting until the completion for a newly posted request has been received.
> * srp_remove_target() calls srp_free_req_data(). That last function
>   calls kfree(ch->req_ring), that is the data structure that contains the
>   SRP request structures.

Thanks Bart, informative..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
