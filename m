From: Mohammed Rafi K C <muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA connection establishment flow.
Date: Thu, 25 Sep 2014 00:09:46 +0530
Message-ID: <1411583986.5583.3.camel@rafi>
References: <1411552728.6278.3.camel@rafi>
	 <1828884A29C6694DAF28B7E6B8A8237399DE3037@ORSMSX109.amr.corp.intel.com>
Reply-To: muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DE3037-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2014-09-24 at 15:32 +0000, Hefty, Sean wrote:
> > My question is Who will get RDMA_CM_EVENT_ESTABLISHED notification first,
> > Server or client ? Is there any order to keep it strictly .
> 
> There is no guarantee which side will receive the event first.
> 
> The only restriction is that the side which initiates the first data transfer must wait until it sees the event before sending.

That was really helpful, thanks very much for your reply.
Rafi KC

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
