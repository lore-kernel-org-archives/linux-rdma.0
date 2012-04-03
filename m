From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Tue, 3 Apr 2012 14:37:05 -0700
Message-ID: <20120403143705.8fdfc254.weiny2@llnl.gov>
References: <4F795880.4070306@acm.org>
	<4F798069.4030305@mellanox.com>
	<4F798A9B.7060805@acm.org>
	<4F798B9A.6090309@mellanox.com>
	<4F799222.3050306@acm.org>
	<4F79A0C5.2030805@mellanox.com>
	<4F79A359.2020204@mellanox.com>
	<4F79A8C4.5000604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F79A8C4.5000604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 02 Apr 2012 09:25:24 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 4/2/2012 9:02 AM, Or Gerlitz wrote:
> > On 4/2/2012 3:51 PM, Or Gerlitz wrote:
> >> can you add these prints and send me the output after attempting to
> >> cat the rate file?
> > 
> > okay, on a system which has IB on port 1 and Ethernet on port 2, using
> > this patch
> > I get these prints:
> >> ib_link_query_port active_speed 4
> >> rate_show ret 0 for ib_query_port dev mlx4_0 port 1 link 1
> >> eth_link_query_port active_speed 4
> >> rate_show ret 0 for ib_query_port dev mlx4_0 port 2 link 2
> > 
> > but if forcing port 2 link layer to be IB as well, which means we will
> > land in ib_link_query_port for an Ethernet port, I get the below
> > 
> >> echo ib >  /sys/bus/pci/devices/0000:07:00.0/mlx4_port2
> >> ib_link_query_port active_speed 4
> >> rate_show ret 0 for ib_query_port dev mlx4_0 port 1 link 1
> >> ib_link_query_port active_speed 7
> >> rate_show ret 0 for ib_query_port dev mlx4_0 port 2 link 1
> > 
> > So when doing the MAD_IFC port info query command on Ethernet port, the
> > firmware returns the
> > value of seven which isn't among the IB speeds and we are remained with
> > rate=-1 in rate_show
> > of drivers/infiniband/core/sysfs.c
> 
> libibumad (and infiniband-diags) are not yet RoCE ready AFAIK. Fixing
> that at least for libibumad is minor. Ira can comment on infiniband-diags.

I agree they are not "RoCE ready".  But the main reason is I am unclear what "RoCE ready" means.  My first thought is that "InfiniBand" Diags should not function on an Ethernet link.  However, we seem to be merging much of the functionality and it does not seem to hurt in most cases.

If some of the diags do retain functionality on an Ethernet link then perhaps some name changes are in order in addition to testing.  For example "ibstat" should probably be "rdmastat" or something.  (This change was made to the perftest package a long time ago.)

I guess my question to the hardware vendors is:

What MAD's, __if__ any, do you see Ethernet supporting in the future?  Do you see MADs being used in some Open Flow spec to be able to program switches?  What about Performance Management?

I don't want to get all draconian and remove these devices, since having more information (ie from ibstat) is good.  But other than that tool what else should the diags support?

Ira

> 
> > It should be pretty simple to come with patch to that situation, but I
> > want to better understand
> > what happens on your system, waiting for the output...
> 
> I think there are 3 main issues here:
> 1. EINVAL can be returned from rate_show and hence "Invalid argument"
> rate string should be handled in libibumad. I think this was Bart's
> original point.
> 2. Why is rate_show returning EINVAL ? I think that's what you're trying
> to isolate with the additional printks you sent Bart for sysfs.c.
> 3. link_layer ethernet should also be handled which is the issue you raised.
> 
> -- Hal
> 
> > Or.
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 


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
