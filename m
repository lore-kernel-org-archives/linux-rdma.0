From: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 0/3] New RAW_PACKET QP type
Date: Mon, 08 Nov 2010 08:38:56 +0200
Message-ID: <1289198336.12829.28.camel@alst60.voltaire.com>
References: <4CD171F0.8020506@voltaire.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8308783@orsmsx501.amr.corp.intel.com>
	 <4CD41D5D.9030103@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD41D5D.9030103-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2010-11-05 at 10:06 -0500, Steve Wise wrote:
> On 11/03/2010 09:58 AM, Hefty, Sean wrote:
> >> The following patches add a new QP type named RAW_PACKET.
> >>
> >> This type of QP is used in Ethernet environment and intended for
> >> creation of a whole packet, including L2 headers,
> >>      
> > RAW_FRAME seems like a better name to me.
> >
> >    
> 
> Not that it matters much, but doesn't "FRAME" and "PACKET" mean the same 
> thing?
> 
> 
As I understand, Ethernet frame contains preamble and delimiter in
addition to the packet data and we construct only packet. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
