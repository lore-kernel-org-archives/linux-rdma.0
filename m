From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ibstat does not recognize iWARP RNIC adapters
Date: Thu, 26 Apr 2012 18:40:22 -0700
Message-ID: <20120426184022.27e0140d.weiny2@llnl.gov>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com>
	<4F9943D9.2060705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9943D9.2060705-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 26 Apr 2012 08:47:21 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 4/25/2012 8:38 PM, Troy Leedberg wrote:
> > I noticed that doing ibstat, none of the iWARP RNIC adapters were showing up.  
> 
> Once upon a time, this used to work:
> 
> commit c864f5d6f1886510f69d1756843c1754fd3a42b4
> Author: Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Date:   Fri May 19 12:40:35 2006 +0000
> 
>     r7350: Change to libibmad and diags/ibstat.c to support iWARP RNIC node type
>     
>     Signed-off-by: Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> 
> but appears to have been broken for some time now by:
> 
> commit 4474288a0eeccced81782c3aac2133aa538a2234
> Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Date:   Wed Jul 23 04:32:41 2008 +0300
> 
>     libibumad: check that node type has IB type
>     
>     When resolving CA device name (name is not provided) check that it has
>     IB type.
>     
>     Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> 
> which is what your patch addresses.
> 
> I couldn't find any discussion on the linux-rdma list relative to that change but may have missed the motivation. The OpenSM vendor layer checks for IB node type. Not sure or not if there are any other IB diagnostic tools which would have similar problems for iWARP.

Hal, do you believe Troy's change will break OpenSM?

I don't believe it will affect the diags any more than the mlx4 ethernet ports.  I believe we fixed the issue of "Ethernet" link layers on ports appearing in umad.  That said, Troy, have you tried any of the other diags on the iWARP cards?[*]

Whether ibstat (and by extension the infiniband-diags) should include ethernet cards or not, is another question.  If mlx4 ethernet cards appear I think it seems reasonable (from a users perspective) that iWARP cards should appear.  I realize there is a difference here in that mlx4 cards are "RoCCE" and iWARP are not.  But what does it mean to support MAD operations on RDMA over Ethernet?  The RoCCE spec only disallows QP0 but is the plan going forward to allow all QP1 operations?  One tool which seemed reasonable to have support for was perfquery.  The current version will fail because it required SMP support.  I fixed that in a local tree and it still fails a ClassPortInfo query.  I suspected it was due to the DLID being 0 but I traced it in the kernel a bit and found that ib_umad_write 
 fails in __get_agent.  So although the agents were registered there seems to be a deeper bug here.

Finally, this was all tested on the local port.  Will other MAD's be supported for remote ports?

I have already mentioned I think ibstat, ibstatus, and ibv_devinfo are all redundant.  If we are to serve our user base I believe there needs to be some consolidation.  In previous threads I advocated removing ibstat and ibstatus in favour of ibv_devinfo.  The issue of RDMA over Ethernet was one of my reasons for doing so.[**]

That said, Hal does make a decent point that ibstat is useful in reporting the devices which libibumad can access.  Perhaps the tool should be something like umad_devinfo and be moved to the libibumad library package?

Ira


[*] I don't have an iWARP card to test on.

[**] There is the caveat that some additional functionality may be required in ibv_devinfo.

> 
> BTW, what does CapabilityMask 0x009f0000 mean ?
> 
> -- Hal
> 
> > I have attached a patch to address the issue (libibumad.patch).
> > 
> > SYS_NODE_TYPE for iWARP RNIC is 4 and is_ib_type only checked to 3.
> > 
> > 
> > Before patch is applied:
> > 
> > [root@t4-2 SOURCES]# ibstat
> > [root@t4-2 SOURCES]#
> > 
> > 
> > After patch is applied:
> > 
> > [root@t4-2 libibumad-1.3.7]# ibstat
> > iWARP RNIC 'cxgb4_0'
> >         iWARP RNIC type: cxgb4
> >         Number of ports: 2
> >         Firmware version: 1.4.23.0
> >         Hardware version: 2
> >         Node GUID: 0x000743101d000000
> >         System image GUID: 0x000743101d000000
> >         Port 1:
> >                 State: Active
> >                 Physical state: No state change
> >                 Rate: 20
> >                 Base lid: 0
> >                 LMC: 0
> >                 SM lid: 0
> >                 Capability mask: 0x009f0000
> >                 Port GUID: 0x0000000000000000
> >                 Link layer: Ethernet
> >         Port 2:
> >                 State: Down
> >                 Physical state: No state change
> >                 Rate: 20
> >                 Base lid: 0
> >                 LMC: 0
> >                 SM lid: 0
> >                 Capability mask: 0x009f0000
> >                 Port GUID: 0x0000000000000000
> >                 Link layer: Ethernet
> > [root@t4-2 libibumad-1.3.7]#
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
