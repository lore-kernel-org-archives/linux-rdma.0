From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V2 04/22] IB/mlx4: SRIOV IB context objects and
 proxy/tunnel sqp support
Date: Fri, 21 Sep 2012 02:15:20 +0300
Message-ID: <CAJZOPZ+-1EUpGozrG+XsyPmS0RL791zP0=7OT8JMsmhwgL7QPQ@mail.gmail.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
	<1343983258-6268-5-git-send-email-jackm@dev.mellanox.co.il>
	<504F7068.6020606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504F7068.6020606-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 11, 2012 at 8:10 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> > struct mlx4_ib_sriov{} is created by the master only.
> > It is a container for the following:
> > 1. All the info required by the PPF to multiplex and de-multiplex MADs
> >    (including those from the PF). (struct mlx4_ib_demux_ctx demux)
>
> OK, so can we have at least a single reference to the various
> abbreviations before using them exclusively?  I know PF and PPF may be
> common, but it might be nice that they were used once in full form
> before abbreviated in commit messages.

PF is physical function and PPF primary physical function

>
> > 2. All the info required to manage alias GUIDs (i.e., the GUID at
> >    index 0 that each guest perceives.  In fact, this is not the
> >    GUID which is actually at index 0, but is, in fact, the GUID
> >    which is at index[<VF number>] in the physical table.
>
> OK, this has been one of the things that has made reviewing this
> difficult.  I freely admit that I've steadfastly ignored SRIOV for as
> long as I can, so maybe this is just me.  But, in the context of this
> driver, how am I supposed to know which code paths will be on the host
> and which on the guest?

For the mlx4 driver the approach taken was to para-virtualize mlx4_core
such that both the PPF and VFs run the same driver but within that
driver two flows are operative. In mlx4_core it should be pretty clear
to see where are you now, in mlx4_ib sometimes less easy, I'll leave
that to Jack
to address with more details.

> Also, I note that you do math every time you want to know if you are on
> a parent device or a virtual device.  Do you really want to do math all
> the time, or would it be better to save off your status on device init
> and just refer to that when you would do math in this patch?

this is addressed in down stream patch #21 of this series

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
