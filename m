From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: perfmgr, only set orig_lid when we have a valid
 port.  Otherwise leave it as 0
Date: Mon, 18 Apr 2011 10:05:15 -0700
Message-ID: <20110418100515.ab36353c.weiny2@llnl.gov>
References: <20110415151736.809c550b.weiny2@llnl.gov>
	<4DAB0565.8020505@dev.mellanox.co.il>
	<53790366-BE39-4A3D-8144-EA1DE3F0197A@llnl.gov>
	<4DAC31D0.3050004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DAC31D0.3050004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 18 Apr 2011 05:42:56 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 4/17/2011 9:26 PM, Weiny, Ira K. wrote:
> > On Apr 17, 2011, at 8:21 AM, Hal Rosenstock wrote:
> > 
> >> On 4/15/2011 6:17 PM, Ira Weiny wrote:
> >>>

[snip]

> >>
> >> There are several other calls to get_base_lid. Is it also an issue there
> >> too or is port always valid there ? If it's not always valid for those
> >> cases, why not just move this check into get_base_lid ?
> > 
> > I believe this is a special case because we are looping through the ports of a CA node and not all of it's ports are valid on this fabric.  Most of the other places where get_base_lid is called I believe the port is known to be good, therefore there is an assertion in there just to protect us.
> > 
> > I think the better way to "fix" this would probably be to change the perfmgr to track ports rather than nodes.[*]
> 
> Why would tracking ports be better than tracking nodes ? Just to
> eliminate this issue ?
> 
> > Unfortunately this will take a significant amount of coding effort.  I think the best thing to do is just check if the physical port is valid as I did above.
> > 
> > As to Alex's comment I think the port should be marked invalid as well.  (I should have CC'ed the list on my response to him.)  I will resend the patch with that change.
> > 
> > Ira
> > 
> > [*] At the time I coded the perfmgr it seemed to make more sense to track nodes rather than ports.  
> > In hindsight this might have been a mistake but for this small place I don't see a reason to re-architect it all yet.
> 
> I'm not following what you're thinking here other than this small issue.
> Is there something more behind this ?

I agree that it would not be worth the effort to fix this minor issue.  My thoughts were: we are tracking values which are provided by ports not nodes.  (They are PortCounters after all.)  So in some ways it makes sense to keep track of all the ports in the system.

However, I did think about it more after my email and tracking ports may have other disadvantages.  One example I could think of was that the perfmgr keeps it's own list of monitored nodes.  This list would be much larger if we were tracking ports.  So finding the "monitored port" would be slower when processing response mads.  Would that be a big deal?  Perhaps not.  I would have to do some performance tests.

In the end I just wanted to acknowledge that there might be another way.

:-D

Ira

> 
> -- Hal
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
