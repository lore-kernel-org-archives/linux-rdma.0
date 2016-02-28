From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Sun, 28 Feb 2016 12:43:03 -0800
Message-ID: <1456692183.19657.151.camel@haakon3.risingtidesystems.com>
References: <56C0A6C3.3010903@redhat.com>
	 <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
	 <1456647963.19657.135.camel@haakon3.risingtidesystems.com>
	 <56D31CC9.7000609@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D31CC9.7000609-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2016-02-28 at 08:14 -0800, Bart Van Assche wrote:
> On 02/28/16 00:26, Nicholas A. Bellinger wrote:
> > Please confirm when you started triggering this regression during target
> > service restart.
> 
> Hi Nic,
> 
> Are you aware that Doug was not the first person to report this crash? I 
> had already reported this crash myself seven weeks ago. Together with 
> the report of this crash I had also sent a root cause analysis to you 
> and a fix.

As we've discussed, your analysis was incorrect.

http://thread.gmane.org/gmane.linux.scsi.target.devel/10905/focus=10891

Adding a second, new kref to se_session just for srpt is completely
wrong, and now that I've thrown out the legacy srpt_lookup_acl() junk in
v4.5-rc1, srpt can finally come out of the stone age wrt to se_node_acl
shutdown.

>  In the patch description I explained clearly that this crash 
> is caused by a bug in the LIO core and should be fixed in the LIO core. 
> See also Bart Van Assche, [PATCH 07/21] target: Fix a use-after-free in 
> core_tpg_del_initiator_node_acl(), target-devel mailing list, January 5, 
> 2016 
> (http://thread.gmane.org/gmane.linux.scsi.target.devel/10905/focus=10891).
> 

Anyways, I'll sit down this week and figure out what's going on with
Doug's active I/O shutdown regression.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
