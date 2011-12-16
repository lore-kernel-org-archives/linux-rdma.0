From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Problems with link, opensm complains IB_SA_MAD_STATUS_REQ_INVALID
Date: Fri, 16 Dec 2011 10:43:37 -0500
Message-ID: <4EEB6729.8070600@dev.mellanox.co.il>
References: <4EEA8004.4060103@grepit.nl> <20111215160600.ebccb033.weiny2@llnl.gov> <4EEB07C3.90803@grepit.nl> <20111216091416.GA3448@calypso> <4EEB216D.2010407@grepit.nl> <4EEB39E8.5030601@dev.mellanox.co.il> <4EEB3FD3.3080409@grepit.nl> <4EEB4362.1050505@dev.mellanox.co.il> <4EEB65D0.8040802@grepit.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EEB65D0.8040802-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerben Roest <g.roest-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/16/2011 10:37 AM, Gerben Roest wrote:
> On 16-12-2011 14:10, Hal Rosenstock wrote:
> 
>>> They should be DDR cards. Does Rate=2 mean DDR?
>>
>> No; it means 1x SDR (lowest speed/width). 4x DDR would be rate 6 (20
>> Gbps). See IBA 1.2.1 vol 1 PathRecord SA attribute Rate component.
>>
>> By default, OpenSM sets the rate for the IPoIB broadcast groups when not
>> explicitly specified is rate 3 (10 Gbps) which is 4x SDR.
> 
> I have a similar twin node that does work correctly (has DDR IB) and it
> says at ibstat: "Rate: 20"
> whereas the two that are having problems say "Rate: 2".
> 
> Testing with openmpi osu_bw show:
> 
> Rate=2:	max bw: 245 MB/s
> Rate=20: max bw: 1970 MB/s

Yes, that's consistent.

Can you temporarily try the cable that is known to work (for rate 20)
between the ports that come up at rate 2 and see if they come up
properly (at rate 20) ?

-- Hal

> 
> greetings,
> 
> Gerben
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
