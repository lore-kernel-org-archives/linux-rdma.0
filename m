From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: NULL pointer dereference in rdma_ucm
Date: Wed, 21 Jul 2010 10:51:17 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DA9EA@orsmsx501.amr.corp.intel.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<4C4544CC.3090405@voltaire.com>
	<AANLkTinOmOrg14OZGnj2qe1dwPaXQbN28-0kz2TINF6n@mail.gmail.com>
	<4C46F19A.3060203@Voltaire.com>
 <AANLkTilFcc34DV_o-D4jxkmqgh36iGsOQ8BLah-8HjF0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTilFcc34DV_o-D4jxkmqgh36iGsOQ8BLah-8HjF0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I do have the sysfs counters in
> /sys/class/infiniband_cm/<device>/<port_num>/cm_tx_msgs/.  Could you
> point me to a reference for what they all mean?

These are counting the number of CM messages sent for each type.  You would need to refer to the Infiniband specification to understand the CM protocol and messages.  In short, IB uses a 3 way handshake to connect:

REQ (request) ->
	<- REP (reply)
RTU (ready to use) ->

MRA (message received) can also appear to indicate that a message has been received, but its processing will be delayed.

> Now, I'm not sure how relevant it is, but under heavy load I also see
> a lot of these:
> kernel: ib_cm: calculated mra timeout 67584 > 8192, decreasing use
> timeout_ms

This is likely not an issue.  The CM has received an MRA, but is using a shorter timeout than what was specified in the MRA message.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
