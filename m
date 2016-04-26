From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 3/4] IB/core: Support new type of join-state
 for multicast
Date: Tue, 26 Apr 2016 20:57:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB045BD0@ORSMSX109.amr.corp.intel.com>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
 <1461070287-13469-4-git-send-email-erezsh@mellanox.com>
 <alpine.DEB.2.20.1604261514590.2663@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1604261514590.2663-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +* There are 4 types of join states:
> > +* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
> > +*/
> > +enum {
> > +	FULLMEMBER_JOIN,
> > +	NONMEMBER_JOIN,
> > +	SENDONLY_NONMEBER_JOIN,
> > +	SENDONLY_FULLMEMBER_JOIN,
> > +	NUM_JOIN_MEMBERSHIP_TYPES = 4

These seem better suited as flags -- fullmember (y/n), sendonly (y/n) 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
