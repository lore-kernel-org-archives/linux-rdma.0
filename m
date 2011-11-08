From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] opensm: Add the precreation of multicast groups
Date: Tue, 8 Nov 2011 18:24:22 +0200
Message-ID: <20111108162422.GC2313@calypso.mtl.com>
References: <20111103153241.0d7c8ebb.weiny2@llnl.gov>
 <4EB4274A.8010006@dev.mellanox.co.il>
 <20111104122600.9dfe7fe5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111104122600.9dfe7fe5.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 12:26 Fri 04 Nov     , Ira Weiny wrote:
> On Fri, 4 Nov 2011 10:56:26 -0700
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> > Ira,
> > 
> > Looks good to me; just one nit in the commit message:
> > 
> > On 11/3/2011 6:32 PM, Ira Weiny wrote:
> > > P_Key is taken from Partition Definition.  Q_Key, TClass, rate, FlowRate and
> > > mtu can be specified
> > 
> > FlowRate -> FlowLabel
> > 
> 
> New patch with correct commit message:
> ======================================
> 
> Allow for the pre-creation of these groups on a partition by partition basis.
> 
> P_Key is taken from Partition Definition.  Q_Key, TClass, rate, FlowLabel and
> mtu can be specified.
> 
> For IP groups, rate and mtu are verified to match the broadcast groups
> parameters.  The P_Key bits in the mgid itself is verified to match the P_Key
> in the Partition Definition.  If the P_Key bits in the mgid are 0x0000 then the
> P_Key is taken from the Partition Definition.
> 
> The syntax extends the existing syntax by allowing MC groups to be specified
> one per line, intermixed with the port specifications.
> 
> Changes from V1:
> 
> 	Incorporate Hal's comments:
> 		Add FlowLabel
> 		copy documentation from man page to doc/partition-config.txt
> 		code format cleanup
> 		Remove "ERR:" from messages
> 
> 	Move group flag parsing to common function for broadcast and generic
> 	groups.  Update documentation for the support of the other flags in the
> 	broadcast group.
> 	Error message clean up
> 	Update commit message
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
