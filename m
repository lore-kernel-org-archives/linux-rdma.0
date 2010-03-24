From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ibstat stuck in state initialized after reboot
Date: Wed, 24 Mar 2010 11:25:25 -0700
Message-ID: <20100324112525.fc4a8eb9.weiny2@llnl.gov>
References: <E25E098F-AFCA-4FEA-BE46-5AF59C408293@mines.edu>
	<20100324093805.4c7c1034.weiny2@llnl.gov>
	<4256D4F9-36CC-4C21-A459-B69B363F29C9@mines.edu>
	<6203933669E90E4AB42B5BC4EDE38D350C9B6386B6@orsmsx510.amr.corp.intel.com>
	<230744DB-D7A7-4A1C-973E-E0D7097554DE@mines.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <230744DB-D7A7-4A1C-973E-E0D7097554DE-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Robbert <mrobbert-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org>
Cc: "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 24 Mar 2010 11:34:02 -0600
Michael Robbert <mrobbert-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org> wrote:

> Interesting note! The 7024 is our large switch where all the hosts are
> connected, but I was told that we were sold the 7000D because the 7024
> didn't have a subnet manager. Unfortunately the 7000D has a different CLI
> and that command is not available and I don't have the password for our 7024
> so I can't log onto it. 
>
> On another note I just noticed the uptime on the 7000D is just over 1 day so
> that must have been the start of the problem, but I have no idea why it
> rebooted nor why it didn't come up working. I'm pretty sure we tested a
> reboot of the device during acceptance testing.
> 
> Oh, I just got your second note:
> ==================================
> BTW, I highly recommend running the opensm on a server instead of using the
> sm on the switch.  We found running the sm on the switch was much less
> reliable.  I also recommend using a server dedicated to opensm only.
> ==================================

I will second this.  OpenSM has come a long way since the time Cisco was
selling IB switches.  If I understand your situation you don't even need the
7000D you could just remove it and run OpenSM on a "management" node.  If you
can afford it adding a node for OpenSM would be nice but I am not sure you
_need_ it.

OpenSM is now managing many of the largest IB networks out there, on a 288
node system it will have no problems at all "out of the box".

:D

Ira
 
> I will take that into consideration, but we bought this as a "turn-key"
> solution from Dell. They designed it and we had no experience with IB so we
> trusted their knowledge. 

<snip>
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
