From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: initiator depth and responder resources in a connect request.
Date: Mon, 14 Mar 2011 16:35:33 -0500
Message-ID: <4D7E8A25.8010701@opengridcomputing.com>
References: <4D7E27E4.7060606@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCAC5612@orsmsx501.amr.corp.intel.com> <4D7E3568.7010406@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39DF3@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39DF3-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/14/2011 04:33 PM, Hefty, Sean wrote:
>> "and the responder_resources value" should be "and greater than or equal to
>> the responder_resources value".
> thanks - I added the following change to the man page:
>
> -max_qp_rd_atom and the responder_resources value reported in the connect
> -request event.
> +max_qp_rd_atom, but preferably greater than or equal to the responder_resources
> +value reported in the connect request event.
>

For iwarp, its a fatal connection termination if the responder resources (aka IRD) is overflowed by the peer.  Is it not 
fatal for an IB connection?




> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
