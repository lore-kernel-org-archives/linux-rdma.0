From: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Subject: How to start tinkering help...
Date: Fri, 16 Oct 2009 13:09:02 -0500
Message-ID: <AF9DB53B-1E31-45F7-83AD-6277DCF53F7F@routingdynamics.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Folks,

I have hit a point of frustration trying to work with RHEL5.4 and the  
kernel parts of OFED and am looking for help to get a foothold to  
explore from.  First off, the install process works great. What I am  
missing is a starting point to getting a real view into the source so  
that I can tinker with bits...

Here is where I am at/tried as background:
1) I am on a fairly stock RHEL5.4 (2.6.18-164.2.1-el5-xin-x86_64)  
based box.
2) I have been able to install OFED-1.5-rc1 from downloads, so I know  
I have enough in place to compile modules against the kernel.
3) I have tried pulling the 1.5 kernel project (url = git://git.openfabrics.org/ofed_1_5/linux-2.6.git 
).  (make oldconfig ; make clean; make yields an error: make[3]: ***  
No rule to make target `drivers/net/mlx4/en_ethtool.o', needed by  
`drivers/net/mlx4/mlx4_core.o'.  Stop.) I will be going any see if I  
am just missing a config option after I send this email, but currently  
this is a dead-end.
4) Tried pulling the source rpm for above kernel. It created an, um,  
interesting pile in the source area. I have not tried to decode how to  
turn that into a functioning kernel yet.

Soooo,

Is there anyway to get to the point were I have a snapshot of the  
where the install script is at when it finishes building the kernel  
modules but before it rolls it up and actually installs it?
AND/OR
How do you get to "my-kernel" + back-port based patches? (I would  
prefer to stay as close to the kernel I am running right now as  
possible)
AND/OR
If I _can't_ stay close to this kernel, how would I get the  
linux-2.6.git working?

And I apologize for such a low-grade question, but this is likely one  
of those things that once you know how to do, you never think of it  
again. Unless you are just starting out , in which case you get to  
feel like an idiot and scrabble around for two days trying random  
stuff ;)

Thank you,
--stuart

--
Stuart Stanley
M: 952-457-3790
stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org
--
"Life is something set to music. I can hear it when I'm sad. There's a  
chord in every muscle: every kiss you've ever had" - Heather Nova in  
Not only human

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
