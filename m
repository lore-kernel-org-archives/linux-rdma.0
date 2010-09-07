From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Multicast group pre-creation for TopSpin old stack
Date: Tue, 07 Sep 2010 10:19:48 -0700
Message-ID: <adafwxllbd7.fsf@cisco.com>
References: <4C835DDF.6000809@dev.mellanox.co.il> <20100906164327.GD11502@me>
	<AANLkTinG2XEhJkYYf-kZGYx7h8wJnBcywMa4AS-KaVh4@mail.gmail.com>
	<adazkvul8ay.fsf@cisco.com> <20100907165113.GH11502@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907165113.GH11502@me> (Sasha Khapyorsky's message of "Tue,
	7 Sep 2010 19:51:13 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > As far as I could understand this TS multicast group only impacts IPoIB
 > communication between two TS stack clients. If so then it is likely that
 > just using old Topspin switch will not activate this flow anyway. Right?

I think it would affect IPoIB-ethernet gateway at least.  And also
probably in-band management of switches.  But as I said I don't think it
matters too much.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
