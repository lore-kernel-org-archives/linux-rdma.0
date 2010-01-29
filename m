From: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: RE: Setting ACK timeout for QP's created using RDMA_CM.
Date: Fri, 29 Jan 2010 11:50:47 -0500 (EST)
Message-ID: <Pine.GSO.4.40.1001291150240.4760-100000@kappa.cse.ohio-state.edu>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF12D589ABB6@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF12D589ABB6-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

Thanks a lot for the quick and detailed response... :).

Hari.

On Fri, 29 Jan 2010, Hefty, Sean wrote:

> >uint8_t timeout; /* Local ack timeout for primary path (valid only for RC
> >QPs)*/
> >
> >I believe that this is the period of time (in seconds) that the IB HCA
> >will wait for the ACK for a packet it sent out before re-transmitting? I
> >was looking as to whether this field can be modified when creating a QP
> >using RDMA_CM.
>
> This field is set based on the packet lifetime carried in the path record.  If you're using opensm, there's probably a configuration option that can adjust this (subnet timeout, maybe?).  The time given for the QP attribute is in 'IB time': 4.096 x 2 ^ timeout micro-seconds.
>
> - Sean
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
