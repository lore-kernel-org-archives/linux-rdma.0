From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
 'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Mon, 14 Sep 2009 10:48:34 -0700
Message-ID: <20090914104834.1da077f6.weiny2@llnl.gov>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
	<20090910090213.6888b7d5.weiny2@llnl.gov>
	<829ded920909132320m7e33d79cx959fba7e6addb513@mail.gmail.com>
	<f0e08f230909140619o342758cdq79e00cc04071a33c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f230909140619o342758cdq79e00cc04071a33c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OFED mailing list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 14 Sep 2009 09:19:06 -0400
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Sep 14, 2009 at 2:20 AM, Keshetti Mahesh
> <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>wrote:
> 
> > I have a small question. If there are all 5 Gbps (maximum supported
> > speed) ports
> > except one with 10 Gbps in a subnet then what is the expected behavior
> > of OpenSM
> > while setting active link speed ?
> 
> 
> It depends on the peer port and the link between them.
> 
> 
> > Does OpenSM force the port with 10
> > Gbps to operate
> > at 5 Gbps or not ?
> >
> 
> SM (including OpenSM) sets PortInfo enabled components based on peer ports'
> supported components and link negotiation determines the active components.
> 
> So in the case where one port supports 10 Gbps speed and it's peer port only
> supports 5, the SM sets LinkSpeedEnabled components on the peer ports to 5
> Gbps (encoded as 3). In the case where the peer port supports 10 Gbps, it is
> set to 10 Gbps (encoded as 5 or 7 depending on what is supported). The link
> then negotiates to one of the enabled speeds and sets LinkSpeedActive
> accoridingly.

Hal is correct.

Just to be clear, the examples below are running in a cluster which I "forced" to SDR using OpenSM's "force_link_speed" option.  This just happened to be the easiest way for me to show you the output of a link which is running at sub-optimal speeds.

Ira

> 
> -- Hal
> 
> 
> 
> >
> > --
> > Keshetti Mahesh
> >
> > On Thu, Sep 10, 2009 at 9:32 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> >  > Also, iblinkinfo will report links which it finds capable of either
> > faster or wider operation.  iblinkinfo checks both ends of the link as Hal
> > mentions.  It reports this with output like.
> > >
> > > Switch 0x0005ad0000092106 Cisco Switch SFS7000D:
> > > ...
> > >           7    8[  ] ==( 4X 2.5 Gbps Active/  LinkUp)==>       8   12[  ]
> > "MT47396 Infiniscale-III Mellanox Technologies" ( Could be 5.0 Gbps)
> > > ...
> > >
> > > Also the portstatus console command in OpenSM will report links which are
> > running at "reduced speed or width".  Although this does not check the
> > remote port.
> > >
> > > OpenSM $ help portstatus
> > > portstatus [ca|switch|router]
> > > summarize port status
> > >   [ca|switch|router] -- limit the results to the node type specified
> > > OpenSM $ portstatus
> > > "ALL" port status:
> > >   115 port(s) scanned on 9 nodes in 26 us
> > >   85 down
> > >   30 active
> > >   32 at 4X
> > >   22 at 2.5 Gbps
> > >   8 at 5.0 Gbps
> > >   2 at 10.0 Gbps
> > >
> > > Possible issues:
> > >   2 disabled
> > >      0x0008f10400411b18 5 (ISR9024D Voltaire)
> > >      0x0005ad0000092106 13 (Cisco Switch SFS7000D)
> > >   6 with reduced speed
> > >      0x0008f10500200220 33 (Voltaire 4036 - 36 QDR ports switch)
> > >      0x0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch)
> > >      0x0005ad0000092106 21 (Cisco Switch SFS7000D)
> > >      0x0005ad0000092106 20 (Cisco Switch SFS7000D)
> > >      0x0005ad0000092106 9 (Cisco Switch SFS7000D)
> > >      0x0005ad0000092106 8 (Cisco Switch SFS7000D)
> > >
> > >
> > > Ira
> > >
> > > On Thu, 10 Sep 2009 09:23:35 -0400
> > > Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > >> On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh
> > >> <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>wrote:
> > >>
> > >> > Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
> > >> > 'ibcheckwidth/ibcheckportwidth' in functionality and implementation.
> > >> > Reports error/warning messages if the LinkSpeedActive is configured as
> > >> > 2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.
> > >> >
> > >>
> > >> ibportstate checks for more than this in terms of speed (and width)
> > >> anomalies.
> > >>
> > >> Would it be better for these scripts to use that tool now ?
> > Alternatively,
> > >> the additional speed/width anomaly checks could be implemented in these
> > >> scripts but it does involve checking the peer port so there's a little
> > more
> > >> to it.
> > >>
> > >> -- Hal
> > >>
> > >>
> > >> >
> > >> > Signed-off-by: Keshetti Mahesh < keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >> > ---
> > >> >  infiniband-diags/scripts/ibcheckportspeed.in |  146
> > >> > ++++++++++++++++++++++++++
> > >> >  infiniband-diags/scripts/ibcheckportwidth.in |    2 +-
> > >> >  infiniband-diags/scripts/ibcheckspeed.in     |  135
> > >> > ++++++++++++++++++++++++
> > >> >  3 files changed, 282 insertions(+), 1 deletions(-)
> > >> >  create mode 100644 infiniband-diags/scripts/ibcheckportspeed.in
> > >> >  create mode 100644 infiniband-diags/scripts/ibcheckspeed.in
> > >> >
> > >> <snip...>
> > >>
> > >
> > >
> > > --
> > > Ira Weiny
> > > Math Programmer/Computer Scientist
> > > Lawrence Livermore National Lab
> > > 925-423-8008
> > > weiny2-i2BcT+NCU+M@public.gmane.org
> > >
> >
> 


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
