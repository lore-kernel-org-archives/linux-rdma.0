From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: RDMA CM and IBV_WC_WR_FLUSH_ERR
Date: Thu, 31 Mar 2011 13:36:01 -0700
Message-ID: <AANLkTikp6_-7OGUZLNewU9enb+UKqi6ki=__-R1VFs5X@mail.gmail.com>
References: <1301592898.5661.10.camel@deela.quest-ce.net> <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC8B505B@orsmsx501.amr.corp.intel.com>
 <1301603412.2766.4.camel@dworkin.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301603412.2766.4.camel-vNW8ozRvgWupuGC+iAP0z+TW4wlIGRCZ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 31, 2011 at 1:30 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> If not using RDMA CM, would switching QP to RTR then RTS state, reset
> the error status on the QP ?
> If yes, does it require the same re-configuration on the other peer ?

After any error, your QP is in the error state.  You can look at the state
diagram in the IB spec to see the transitions you need to follow to get
back to the RTS state.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
