From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: dumping queue state
Date: Wed, 20 Dec 2017 10:59:25 -0600
Message-ID: <010901d379b3$e4417bc0$acc47340$@opengridcomputing.com>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com> <1513786487.2603.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513786487.2603.4.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Hello Steve,
> 
> I'm not sure what the best solution is for RDMA queues. But if you want you can
> have a look at block/blk-mq-debugfs.c. That code has been added recently and
> has
> been very valuable for debugging block layer / SCSI queue lockups.

Thanks Bart.  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
