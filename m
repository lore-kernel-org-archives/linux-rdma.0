From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 04/22] IB/mlx4: SRIOV IB context objects and proxy/tunnel sqp support
Date: Fri, 21 Sep 2012 10:42:49 +0300
Message-ID: <201209211042.49517.jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <504F7068.6020606@redhat.com> <CAJZOPZ+-1EUpGozrG+XsyPmS0RL791zP0=7OT8JMsmhwgL7QPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+-1EUpGozrG+XsyPmS0RL791zP0=7OT8JMsmhwgL7QPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Friday 21 September 2012 02:15, Or Gerlitz wrote:
> On Tue, Sep 11, 2012 at 8:10 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> > > struct mlx4_ib_sriov{} is created by the master only.
> > > It is a container for the following:
> > > 1. All the info required by the PPF to multiplex and de-multiplex MADs
> > >    (including those from the PF). (struct mlx4_ib_demux_ctx demux)
> >
> > OK, so can we have at least a single reference to the various
> > abbreviations before using them exclusively?  I know PF and PPF may be
> > common, but it might be nice that they were used once in full form
> > before abbreviated in commit messages.
> 
> PF is physical function and PPF primary physical function
I'll do that during the review/resubmission process
> 
> >
> > > 2. All the info required to manage alias GUIDs (i.e., the GUID at
> > >    index 0 that each guest perceives.  In fact, this is not the
> > >    GUID which is actually at index 0, but is, in fact, the GUID
> > >    which is at index[<VF number>] in the physical table.
> >
> > OK, this has been one of the things that has made reviewing this
> > difficult.  I freely admit that I've steadfastly ignored SRIOV for as
> > long as I can, so maybe this is just me.  But, in the context of this
> > driver, how am I supposed to know which code paths will be on the host
> > and which on the guest?
> 
> For the mlx4 driver the approach taken was to para-virtualize mlx4_core
> such that both the PPF and VFs run the same driver but within that
> driver two flows are operative. In mlx4_core it should be pretty clear
> to see where are you now, in mlx4_ib sometimes less easy, I'll leave
> that to Jack
> to address with more details.
> 
The flows are indeed complex. The issue we have is that there is a single driver
for both "Native" (i.e., non-sriov) mode, for the SRIOV master (PF/PPF) and for SRIOV slaves (VFs).

We have macros to assist in routing these flows:

mlx4_is_mfunc() -- test for multifunc active (i.e, we are in an sriov master or an sriov slave).
mlx4_is_master() -- we are an sriov master.  False if we are an SRIOV slave, or if we are in Native mode.
mlx4_is_slave() -- we are an SRIOV slave.  False if we are an SRIOV master, or if we are in Native mode.

You will see 
    if (!mlx4_is_master)
	return;

  in various procedures, to indicate that what follows is code that only an SRIOV master should execute.

For example, look at procedure 
void mlx4_sync_pkey_table(struct mlx4_dev *dev, int slave, int port, int i, int val)
{
	struct mlx4_priv *priv = container_of(dev, struct mlx4_priv, dev);

	if (!mlx4_is_master(dev))
		return;

	priv->virt2phys_pkey[slave][port - 1][i] = val;
}

You will also see the tests in combination (e.g., if (!mlx4_is_master && !<some other condition>) do something)

Finally, you will see lots of places where the test is positive, around a block of code:

if (mlx4_is_master()) {
	do something;
}

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
