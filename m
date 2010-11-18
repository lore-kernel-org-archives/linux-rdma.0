From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: mxl4 and rpcrdma: connection to 192.168.0.100:20049 on mlx4_0, memreg 5 slots 32 ird 16
Date: Wed, 17 Nov 2010 17:12:42 -0800
Message-ID: <ada62vvigdx.fsf@cisco.com>
References: <AANLkTi=d6d2vydtcK+ux22e-QR5xqrkenMoeM8AzHBVq@mail.gmail.com>
	<4CE41458.7020202@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE41458.7020202-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Wed, 17 Nov 2010 11:43:52 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Stephen Cousins <steve.cousins-e7X0jjDqjFGHXe+LvDLADg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > Nov 15 09:39:00 node4 kernel: rpcrdma: connection to
 > > 192.168.0.100:20049 on mlx4_0, memreg 5 slots 32 ird 16
 > >
 > > and then 5 minutes later:
 > >
 > > Nov 15 09:44:00 node4 kernel: rpcrdma: connection to
 > > 192.168.0.100:20049 closed (-103)
 > >
 > >    
 > 
 > I think NFSRDMA server will close the connection after 5 minutes of
 > inactivity...

Should the code be spamming the logs for normal events?  (Or is this
with an elevated log level)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
