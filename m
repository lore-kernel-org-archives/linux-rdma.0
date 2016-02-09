From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 0/3] new ib_drain_qp() API
Date: Tue, 9 Feb 2016 15:20:47 -0600
Message-ID: <011d01d1637f$be2fdfe0$3a8f9fa0$@opengridcomputing.com>
References: <cover.1454969695.git.swise@chelsio.com> <010901d16375$1a023210$4e069630$@opengridcomputing.com> <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com> <56BA540B.4040405@sandisk.com> <08D51C34-0009-4784-BE80-7BCB85441606@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <08D51C34-0009-4784-BE80-7BCB85441606-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Hello Steve,
> >
> > How about creating three functions - one that drains the receive queue, one that drains the send queue and a third function that
drains
> both ? The latter function then can call the two former functions. And since only one of these three functions will have a user in
your patch
> series (the function that drains the RQ), how about only introducing only that function now and to wait with introducing the two
other
> functions until these have a user ?
> 
> I would like xprtrdma to use the function that drains both.
> Is that one of the functions that is being left out?
> 

That is Bart's proposal.  Perhaps we could add an xprtrdma patch to the series?  Then we'll have a user for flushing both.  Is the
change trivial?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
