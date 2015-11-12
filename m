From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] staging/rdma/hfi1: Reduce number of parameters passed to send handlers
Date: Thu, 12 Nov 2015 08:25:39 -0500
Message-ID: <20151112132538.GA23251@phlsvsds.ph.intel.com>
References: <1447220077-8325-1-git-send-email-ira.weiny@intel.com> <20151111062535.GG4023@leon.nu> <20151111133907.GA21044@phlsvsds.ph.intel.com> <CAJ3xEMiaKkPX0gjTYqvdSjiHqiXSxGuPL=t8yfkwpamGa0+e3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiaKkPX0gjTYqvdSjiHqiXSxGuPL=t8yfkwpamGa0+e3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2015 at 08:04:01AM +0200, Or Gerlitz wrote:
>On Wed, Nov 11, 2015 at 3:39 PM, Dennis Dalessandro
><dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Nov 11, 2015 at 08:25:35AM +0200, Leon Romanovsky wrote:
>>> On Wed, Nov 11, 2015 at 12:34:37AM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>>>> From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> +int snoop_send_dma_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
>
>>>> -       pr_alert("Snooping/Capture of  Send DMA Packets Is Not
>>>> Supported!\n");
>>>> +       pr_alert("Snooping/Capture of Send DMA Packets Is Not Supported!\n");
>
>Dennis, can we have less camelcase sort of speak in this upstream driver?
>this is linux here not windowZ.

I plan to just remove this function.

See: http://www.spinics.net/lists/linux-rdma/msg30244.html

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
