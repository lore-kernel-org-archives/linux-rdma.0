From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] Support optional performance counters, including
 congestion control performance counters.
Date: Thu, 21 Jul 2011 17:20:33 -0700
Message-ID: <20110721172033.f581b762.weiny2@llnl.gov>
References: <1311113629.6898.139.camel@auk59.llnl.gov>
	<4E26DBEF.1030205@dev.mellanox.co.il>
	<1311183503.6898.153.camel@auk59.llnl.gov>
	<4E271FE9.7080508@dev.mellanox.co.il>
	<1311206683.6898.184.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311206683.6898.184.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Jul 2011 17:04:43 -0700
Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

> Hey everyone,
> 
> Here's a new patch series for the optional performance counters.  It
> fixes up the issues brought up by Hal.  I also include a new patch that
> fixes up the incorrect BITSOFFS for other fields in libibmad.

Thanks all 3 applied.

> 
> Al
> 
> On Wed, 2011-07-20 at 11:35 -0700, Hal Rosenstock wrote:
> > Hi again Al,
> > 
> > On 7/20/2011 1:38 PM, Albert Chu wrote:
> > > Hey Hal,
> > > 
> > > Thanks for the nit-catches.  As for
> > > 
> > >> +     {32, 2, "PortVLXmitFlowCtlUpdateErrors0", mad_dump_uint},
> > >>> +     {34, 2, "PortVLXmitFlowCtlUpdateErrors1", mad_dump_uint},
> > >>> +     {36, 2, "PortVLXmitFlowCtlUpdateErrors2", mad_dump_uint},
> > >>> +     {38, 2, "PortVLXmitFlowCtlUpdateErrors3", mad_dump_uint},
> > >>> +     {40, 2, "PortVLXmitFlowCtlUpdateErrors4", mad_dump_uint},
> > >>> +     {42, 2, "PortVLXmitFlowCtlUpdateErrors5", mad_dump_uint},
> > >>> +     {44, 2, "PortVLXmitFlowCtlUpdateErrors6", mad_dump_uint},
> > >>> +     {46, 2, "PortVLXmitFlowCtlUpdateErrors7", mad_dump_uint},
> > >>> +     {48, 2, "PortVLXmitFlowCtlUpdateErrors8", mad_dump_uint},
> > >>> +     {50, 2, "PortVLXmitFlowCtlUpdateErrors9", mad_dump_uint},
> > >>> +     {52, 2, "PortVLXmitFlowCtlUpdateErrors10", mad_dump_uint},
> > >>> +     {54, 2, "PortVLXmitFlowCtlUpdateErrors11", mad_dump_uint},
> > >>> +     {56, 2, "PortVLXmitFlowCtlUpdateErrors12", mad_dump_uint},
> > >>> +     {58, 2, "PortVLXmitFlowCtlUpdateErrors13", mad_dump_uint},
> > >>> +     {60, 2, "PortVLXmitFlowCtlUpdateErrors14", mad_dump_uint},
> > >>> +     {62, 2, "PortVLXmitFlowCtlUpdateErrors15", mad_dump_uint},
> > >>
> > >> Don't these need to be BITSOFFS(nn, 2)  ?
> > > 
> > > Perhaps there's a subtlety I'm missing.  If these require BITSOFFS, then
> > > wouldn't the 16 bit fields require them too?  There are many places
> > > amongst the performance counters that BITSOFFS isn't used w/ 16 bit
> > > fields.
> > 
> > Yes; it looks like any field less than 32 bits should use BITSOFFS so I
> > think that there are some existing things to fix in fields.c (the 16 bit
> > fields that are not using the macro).
> > 
> > -- Hal
> > 
> > > Al
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory
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
