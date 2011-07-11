From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: make loopback console compile on by default.
Date: Mon, 11 Jul 2011 10:23:54 -0700
Message-ID: <5033C751-5B39-4F08-AB35-C595F17F6B6B@llnl.gov>
References: <20110706155435.ada5fbb6.weiny2@llnl.gov> <20110710091410.GB8520@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110710091410.GB8520-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 10, 2011, at 2:14 AM, Alex Netes wrote:

> Hi Ira,
> 
> On 15:54 Wed 06 Jul     , Ira Weiny wrote:
>> 
>> The console is very useful for debugging and should be available in opensm.conf
>> as an option.
>> 
>> Generic socket is still an option which is off for security reasons.
>> 
>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>> ---
> 
> I was digging a little in a history and one concern that was issued while socket
> support was introduced is that it requires libwrap devel package, so any one
> who lacks this package, opensm compilation will fail.

My intention was to disable console_looback if libwrap was not available.  But as I look at the configure.in I think there may be a bug in that logic.

I don't have a system without libwrap readily available so give me some time to fix this.

Ira

> 
> -- Alex

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
