From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Wed, 21 Sep 2011 17:14:08 -0700
Message-ID: <20110921171408.4e4087c8.weiny2@llnl.gov>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
	<20110921151349.140d95f6.weiny2@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A8237316E6723E@ORSMSX101.amr.corp.intel.com>
	<20110921153254.06c77ebc.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110921153254.06c77ebc.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 21 Sep 2011 15:32:54 -0700
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> On Wed, 21 Sep 2011 15:23:45 -0700
> "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > > Does this mean "ibstatus" does not work on Windows?
> > 
> > We do not support any of the scripts on windows.  As far as I could tell, the scripts look like they just do post-processing of available output.
> >  
> 
> Good to know, thanks.
> 
> > > How are you proposing the addition to ibverbs?  It seems this would break ABI
> > > there.
> > 
> > On windows, libibumad uses libibverbs to obtain whatever data it needs.  I'm assuming that a non-MAD application will eventually be able to use ibverbs to determine the rate, without needing to parse data from some file.
> > 
> > > Does windows have sysfs like capabilities which would make the separate layer
> > > clean?
> > 
> > There's nothing like sysfs on windows.  If the data is available from ibverbs, windows could pull the data from there, even if the diags do not want to rely on ibverbs on the linux side.
> > 
> 
> To be clear I am not against using ibverbs on the linux side.  It sounds like that would be the best move going forward.
> 

Honestly, ibverbs supplies similar functionality in ibv_devinfo.  :-/

It seems both ibstat and ibstatus should be dropped and ibv_devinfo enhanced to supply, Rate, Physical state, Capability Mask, and the transport (on a per port basis)[*].  There might be some other functionality as well.  Roland, ibv_devinfo, is in the examples directory.  Is there any reason this should not be used as the "official" tool?  If not I think we should use the code from ibv_devinfo as a basis for ibstat.  But I hate to see 2 implementations so close.

Ira

[*] There are cards which support this.  However, ibverbs does not have a transport field for each port.  Example:

15:54:10 > ibv_devinfo -d mlx4_1 | grep trans
        transport:                      InfiniBand (0)

15:55:22 > ibstat mlx4_1 | grep Link
                Physical state: LinkUp
                Link layer: InfiniBand
                Link layer: Ethernet


Full output from ibstat:

15:55:32 > ibstat mlx4_1
CA 'mlx4_1'
        CA type: MT26428
        Number of ports: 2
        Firmware version: 2.9.1000
        Hardware version: b0
        Node GUID: 0x0002c9030008e7f0
        System image GUID: 0x0002c9030008e7f3
        Port 1:
                State: Initializing
                Physical state: LinkUp
                Rate: 10
                Base lid: 0
                LMC: 0
                SM lid: 0
                Capability mask: 0x02510868
                Port GUID: 0x0002c9030008e7f1
                Link layer: InfiniBand
        Port 2:
                State: Down
                Physical state: Disabled
                Rate: 10
                Base lid: 0
                LMC: 0
                SM lid: 0
                Capability mask: 0x00010000
                Port GUID: 0x0202c9fffe08e7f1
                Link layer: Ethernet


> Ira
> 
> > - Sean
> 
> 
> -- 
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org


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
