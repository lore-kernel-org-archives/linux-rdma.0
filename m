From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] IB/ipoib: Leave stale send-only multicast groups
Date: Wed, 26 Jan 2011 09:55:11 -0600 (CST)
Message-ID: <alpine.DEB.2.00.1101260954420.23080@router.home>
References: <4D34239D.9030004@Voltaire.COM> <alpine.DEB.2.00.1101181406490.18059@router.home> <AANLkTiku+dkiqsv1AKUr_wCVhxWFhay0HEuSZtt7uZWr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTiku+dkiqsv1AKUr_wCVhxWFhay0HEuSZtt7uZWr-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

And here is my answer that also was not cced.


> Please take a look at this. It demonstrates what I claim.

Trouble is that iperf is a performance measurement tool and I am not sure
what is going on behind the scenes in regard to MC subscriptions etc. Also
I do not see when you terminate what task.

I can demonstrate using mcast that the groups go away (see below). AFAICT
behavior that you suggest would be troublesome for some of the apps we run
here.


> linux:~ # cat /proc/net/dev_mcast |grep ib0
>
> 29   ib0             1     0     00ffffffff12401bffff00000000000003070707 <---
                      ^^^ there is a reference remaining that is why the
group sticks around.

Here is the output of /sys/kernel/debug/ipoib/ib0.8030_mcg a few minutes
after an mcast test completed:

GID: ff12:401b:8030:0:0:0:0:1
  created: 4370767176
  queuelen:         0
  complete:       yes
  send_only:       no

GID: ff12:401b:8030:0:0:0:ffff:ffff
  created: 4370767176
  queuelen:         0
  complete:       yes
  send_only:       no


Running mcast -b ib0.8030 on another host
and running ./mcast -n 1 -b ib0.8030 on this host yields:

Receiver: Listening to control channel 239.0.192.1
Receiver: Subscribing to 0 MC addresses 239.0.192-254.2-254 offset 0
origin 10.2.30.180
Sender: Sending 10 msgs/ch/sec on 1 channels. Probe interval=0.001-1 sec.

While the program is running we do:

clameter@rd-gateway-deb64:/sys/kernel/debug/ipoib$ cat ib0.8030_mcg
GID: ff12:401b:8030:0:0:0:0:1
  created: 4370767176
  queuelen:         0
  complete:       yes
  send_only:       no

GID: ff12:401b:8030:0:0:0:f00:c001
  created: 4371010379
  queuelen:         0
  complete:       yes
  send_only:       no

GID: ff12:401b:8030:0:0:0:f00:c002
  created: 4371010589
  queuelen:         0
  complete:       yes
  send_only:      yes

GID: ff12:401b:8030:0:0:0:ffff:ffff
  created: 4370767176
  queuelen:         0
  complete:       yes
  send_only:       no


Terminating mcast yields:

clameter@rd-gateway-deb64:/sys/kernel/debug/ipoib$ cat ib0.8030_mcg
GID: ff12:401b:8030:0:0:0:0:1
  created: 4370767176
  queuelen:         0
  complete:       yes
  send_only:       no

GID: ff12:401b:8030:0:0:0:0:2
  created: 4371020715
  queuelen:         0
  complete:       yes
  send_only:      yes

GID: ff12:401b:8030:0:0:0:f00:c002
  created: 4371010589
  queuelen:         0
  complete:       yes
  send_only:      yes

GID: ff12:401b:8030:0:0:0:ffff:ffff
  created: 4370767176
  queuelen:         0
  complete:       yes
  send_only:       no

Wait a few minutes and then c002 will also vanish and you will have the
state above.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
