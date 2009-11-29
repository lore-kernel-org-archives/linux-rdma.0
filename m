From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Reliable IB connections (RC) and event ordering
Date: Sun, 29 Nov 2009 11:45:37 +0100
Message-ID: <e2e108260911290245mb9d603wf46ac7925824a9c4@mail.gmail.com>
References: <e2e108260911290243h623d45bar77127e9610c8203e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260911290243h623d45bar77127e9610c8203e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

While working on the SRP target implementation I noticed the following
(the SRP protocol requires that an SRP initiator sets up an RC
connection to the SRP target during login):
* Sometimes (about 25% of SRP logins) the completion queue callback
function reports data arrival to the SRP target before the RTU event
has been delivered.
* Sometimes the completion queue callback function reports data
arrival after the DREQ message has been sent.
* According to the IBTA, message order is preserved over RC
connections and the system that sent the RTU message may only start
sending data after the RTU message has been sent (section 12.2).

Is this known behavior ? Is this the intended behavior of the Linux
InfiniBand stack ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
