From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: initiator depth and responder resources in a connect request.
Date: Mon, 14 Mar 2011 10:34:00 -0500
Message-ID: <4D7E3568.7010406@opengridcomputing.com>
References: <4D7E27E4.7060606@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCAC5612@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCAC5612-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/14/2011 10:28 AM, Hefty, Sean wrote:
>> Dumb question:  What exactly do the rdma_conn_param fields initiator_depth
>> and responder_resources mean in an incoming
>> connection request?  Does it mean the peer's values for these two
>> resources, or is responder_resources set to match the
>> peer's initiator_depth and initiator_depth set to match the peer's
>> responder_resources?  IE Are they swapped so the app
>> can turn around and use them in the rdma_accept()?
> The values are swapped.  See the man page for rdma_get_cm_event and let me know if it's not clear.

Thanks.  Yes.  That man page is clear.

I think the rdma_accept() page has a bug though:

----
        responder_resources
               The  maximum  number  of outstanding RDMA read and atomic opera-
               tions that the local side will  accept  from  the  remote  side.
               Applies  only  to  RDMA_PS_TCP.  This value must be less than or
               equal to the local RDMA device attribute max_qp_rd_atom and  the
               responder_resources value reported in the connect request event.
----

"and the responder_resources value" should be "and greater than or equal to the responder_resources value".


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
