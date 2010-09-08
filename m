From: Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Errors from ibchecknet
Date: Wed, 8 Sep 2010 13:51:45 -0400
Message-ID: <AANLkTikadVD0MBxVyGk65=DQRif9W5QaFdebHbb+xwA9@mail.gmail.com>
References: <AANLkTi=EuVGxLyjMFMw=YZm38CPvCTbcxt104R-B_o_i@mail.gmail.com>
	<AANLkTikoYH+1tBzHX29uUnFGepFhfXdOkRHSX3OLW9g6@mail.gmail.com>
	<AANLkTikQ3jeNwtbR6zqpSvt7=YWatRhWfr60Q5of_FJR@mail.gmail.com>
	<20100902090330.093d8ba6.weiny2@llnl.gov>
	<AANLkTin=p2Mt223QS1oXfy6vi1RBNiF4HaQQcScfg5FP@mail.gmail.com>
	<20100902131614.440c3111.weiny2@llnl.gov>
	<AANLkTi=zJWVk3KCiiQpuQd+Etuxc3JVTg48EeMQ_xV9C@mail.gmail.com>
	<20100907190756.c7710d9a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907190756.c7710d9a.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We found what the problem is...

There is an onboard mthca DDR interface and a mlx4 QDR add-in card.
When the system comes up, it finds the onboard HCA first and was
making that IB0. The ifconfig output shows that interface ib0 is up
even though the actual IB state is down/polling. We disabled the mthca
driver from loading and now the mlx4 port 1 interface becomes ib0 as
we wanted.

I'm not sure what the best way to handle this configuration would be
(assuming we actually needed to use all 3 ports / 2 HCAs).  We could
specify the HWADDR in the ifcfg-ib[0,1,2] files, assuming that it
works with the 20-byte IB addresses. Or, I seem to remember adding
alias lines in /etc/modprobe.conf years ago to sort out a similar
situation with ethernet ports. Do you guys have other/better
suggestions?

What is the purpose of the "alias ib0 ib_ipoib" line in
etc/modprobe.conf? Is it required by something in OFED? Are you
supposed to have one for any additional interfaces (ib1, ib2)? Since
the OFED install did not create entries for the other interfaces, I'm
guessing it is not strictly required?

-Chuck
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
