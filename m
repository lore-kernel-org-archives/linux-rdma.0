From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Mon, 29 Feb 2016 07:05:04 +0100
Message-ID: <20160229060504.GA6024@lst.de>
References: <56C0A6C3.3010903@redhat.com> <1456630639.19657.47.camel@haakon3.risingtidesystems.com> <1456647963.19657.135.camel@haakon3.risingtidesystems.com> <56D31CC9.7000609@sandisk.com> <1456692183.19657.151.camel@haakon3.risingtidesystems.com> <56D392D4.2000105@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D392D4.2000105-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 28, 2016 at 04:37:40PM -0800, Bart Van Assche wrote:
> On 02/28/16 12:43, Nicholas A. Bellinger wrote:
> > Anyways, I'll sit down this week and figure out what's going on with
> > Doug's active I/O shutdown regression.
> 
> The crash occurs in the core_tpg_del_initiator_node_acl() function
> and a call to that function has been added recently in
> target_fabric_nacl_base_release(). I think it was added through the
> following patch:

That patch just moved the call from the .fabric_drop_nodeacl instances
(in the SRPT case srpt_drop_nodeacl) to the caller in
target_fabric_nacl_base_release.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
