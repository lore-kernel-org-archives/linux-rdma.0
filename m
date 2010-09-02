From: Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Errors from ibchecknet
Date: Thu, 2 Sep 2010 14:16:41 -0400
Message-ID: <AANLkTim_trDik7m5k0KwqAerhpeuU2gADNZSBSkuRxf-@mail.gmail.com>
References: <AANLkTi=EuVGxLyjMFMw=YZm38CPvCTbcxt104R-B_o_i@mail.gmail.com>
	<AANLkTikoYH+1tBzHX29uUnFGepFhfXdOkRHSX3OLW9g6@mail.gmail.com>
	<AANLkTikQ3jeNwtbR6zqpSvt7=YWatRhWfr60Q5of_FJR@mail.gmail.com>
	<20100902090330.093d8ba6.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100902090330.093d8ba6.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

BTW, I am able to communicate between nodes via 'ibping'.  That is the
only test program I found that will work without needing a host IP.



On Thu, Sep 2, 2010 at 12:03 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Thu, 2 Sep 2010 06:56:50 -0700
> Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> We swapped in a different switch and see the same errors. The opensm
>> logfile does not show any errors:
>
> Could you run "ibstat" on the node with OpenSM running?
>
> And "iblinkinfo" on the same node?
>
> Send that output.
>
> Ira
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
