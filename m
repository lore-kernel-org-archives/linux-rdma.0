From: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ghost cq event in handler
Date: Thu, 20 Oct 2011 14:26:38 +0100
Message-ID: <CAEWUdFXZ3nCK9BBGdCS=iu_V89t4bQ0Y1Bwf4QozLAoR3sVxZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am developing in kernel features that use the RDMA or exchanging data.

I am currently testing the RDMA communication engine i coded and i am
experiencing a strange behaviour.

Setup :
kernel : linux 3.0
RDMA : soft Iwarp ( for dev / debug purpose)

Testing setup :
Establish communication between 2 machine A and B

A send a request (IB_POST_SEND / IB_SEND_SIGNALLED)  to B with a
message containing a variable status  set 1
B receive the message , process it and reply back with an and
(IB_WR_SEND + IBSEND_SIGNALED)  . The RDMA write , write a page, the
send , just to notify the reception of the page the message of
notification contain a variable status set to 2.

Note the IB_POST_SEND are only performed if the status change has been
confirmed. so i cannot try to send a message that doesn't contain a
status of 1 or 2 .

I have a flow control that prevent me from overflowing the CQ.
Also i protect my IB_POST_SEND by spinlock with irqsave/restore


Now here is the strange behaviour:

When i send 100 msg, 1000 msg , No problem .

When i start moving toward 100 000 msg and more i start seeing some
strange message in my "CQ send handler ".
I start to get notification of message send , however when i check the
status of the message , it is 0 ;

Note so far this doesn't create any disturbance and the exchange of
the 100k+ message finish ok.

However sometimes , it looks like the system is repeatedly trying to
send the message and  then the value of the status variable change and
is suddenly pushed over to B. Which naturally receive it and discarded
it because of the non valid status value.

It would be ok if it didn't also drop the message it was supposed to
send in the first place at the same time.

So from time to time i  get a random message being dropped ( only when
i push a high number of message as fast as possible).


My question is : did any of you experience similar issue, if yes , how
did you solve it?

Regards
Benoit

--
" The production of too many useful things results in too many useless people"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
