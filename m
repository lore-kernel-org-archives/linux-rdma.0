From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-core/srp_daemon PATCH] Correct method field for PathRecord
 request
Date: Wed, 12 Apr 2017 21:29:23 +0800
Message-ID: <20170412132923.GB16375@dhcp-13-42.nay.redhat.com>
References: <1491924533-2548-1-git-send-email-honli@redhat.com>
 <20170411154944.GA19917@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170411154944.GA19917-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 11, 2017 at 09:49:44AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 11, 2017 at 11:28:53PM +0800, Honggang LI wrote:
> > From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > According to InfiniBand Architecture Release 1.2.1, Table 208
> > Example PathRecord Request MAD Header Fields, MADHeader:Method
> > should setup to 0x12 (SubnAdmGetTable()).
> 
> That is just an example, Table 192 shows that Get and GetTable are
> both valid query types.

I don't understand this as "Table 192 PortInfoRecord" seems nothing to
do with PathRecord request.

> 
> I however expect that the SM will fail when using GetTable if the
> query returns more than one result, could that be what is happening?
> When you convert it to GET_TABLE does it return more than one result?

strace output shows srptools always received MAD packet in 320 bytes. So
the embedded subnet manager only returns one result.

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
